# Mongo Pilfer
## Prompt
Hey! It's me, Holly Evergreen! My teacher has been locked out of the quiz database and can't remember the right solution.
Without access to the answer, none of our quizzes will get graded.
Can we help get back in to find that solution?
I tried lsof -i, but that tool doesn't seem to be installed.
I think there's a tool like ps that'll help too. What are the flags I need?
Either way, you'll need to know a teensy bit of Mongo once you're in.
Pretty please find us the solution to the quiz!
## Solve Process
1. Holly Evergreen wants us to find the quiz database solution.
1. We try running "mongo" but it tells us it's not running.
1. Running "sudo -l" shows us that the mongo user starts on port 12121 instead of the default port.
1. Using that "mongo --port=12121" lets us in the database.
1. Running "show dbs" gives us:
    ```
    admin  0.000GB
    elfu   0.000GB
    local  0.000GB
    test   0.000GB
    ```
1. Running "use elfu" and then "show collections" shows us:
    ```
    bait
    chum
    line
    metadata
    solution
    system.js
    tackle
    tincan
    ```
1. db.solution.find() gives us:
    ```json
    {
        "_id" : "You did good! Just run the command between the stars: ** db.loadServerScripts();displaySolution(); **"
    }
    ```
1. Which when we run it solves the challenge & gives us nice ASCII art :D
    ```
          .
       __/ __
            /
       /.'*'. 
        .o.'.
       .'.'o'.
      *'.*.'.*.
     .'.*.'.'.o.
    .*.'.o.'.*.'.
       [_____]
        ___/

    Congratulations!!
    ```
1. And our hint is:
    ```
    Woohoo! Fantabulous! I'll be the coolest elf in class.
    On a completely unrelated note, digital rights management can bring a hacking elf down.
    That ElfScrow one can really be a hassle.
    It's a good thing Ron Bowes is giving a talk on reverse engineering!
    That guy knows how to rip a thing apart. It's like he breathes opcodes!
    ```
1. ... which probably means we're on the right track.