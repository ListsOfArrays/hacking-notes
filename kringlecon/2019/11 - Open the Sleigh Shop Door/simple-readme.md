# 11) Open the Sleigh Shop Door
## Prompt
Visit Shinny Upatree in the Student Union and help solve their problem. What is written on the paper you retrieve for Shinny?
For hints on achieving this objective, please visit the Student Union and talk with Kent Tinseltooth.
## Secondary Prompt
Psst - hey!
I'm Shinny Upatree, and I know what's going on!
Yeah, that's right - guarding the sleigh shop has made me privvy to some serious, high-level intel.
In fact, I know WHO is causing all the trouble.
Cindy? Oh no no, not that who. And stop guessing - you'll never figure it out.
The only way you could would be if you could break into my crate, here.
You see, I've written the villain's name down on a piece of paper and hidden it away securely!
## Solve Process
1. From solver: As we later find out, the key values randomize on each refresh of the page.
1. 
    ```
    I locked the crate with the villain's name inside. Can you get it out?
    You don't need a clever riddle to open the console and scroll a little.
    ```
    For this one we scroll up in the F12 console window in Chrome. There we find our first key: CW7ASVT9 
1. 
    ```
    Some codes are hard to spy, perhaps they'll show up on pulp with dye?
    ```
    Meantime we open the network panel and find a picture on the network tab, with value "ZSV1URNZ"
    Look at the hint & find:
    ```
    Most paper is made out of pulp.
    How can you view this page on paper?
    Emulate `print` media, print this page, or view a print preview.
    ```
    Which shows us the next key, DTQZHH1R
1. 
    ```
    This code is still unknown; it was fetched but never shown.
    ```
    That's the code we saw already, ZSV1URNZ.
1.
    ```
    Where might we keep the things we forage? Yes, of course: Local barrels!
    ```
    For this one I we get a hint
    ```
    Google: "[your browser name] view local storage"
    ```
    With some futzing around we find local storage under the application tab in Chrome w/out using Google :D, and find our next key, "PUSA8608"
1. Meanwhile on the network tab, we open the html page sent, and find "AWR9YO1J" which will probably be useful.
    Scrolling down & skipping last challenge temporarily, we find the challenge
    ```
    Did you notice the code in the title? It may very well prove vital.
    ```
    for which AWR9YO1J was the answer.
1. 
    ```
    In order for this hologram to be effective, it may be necessary to increase your perspective.
    ```
    Asking for a hint, we see that we're supposed to _increase_ the perspective key, which reveals our final key for this step: "TBE6ZTU8"
1.
    ```
    The font you're seeing is pretty slick, but this lock's code was my first pick.
    ```
    For this one we checkout the HTML source again and find that the font style is ```<style>.instructions { font-family: 'XDMIAPNL', 'Beth Ellen', cursive; }</style>```
    That's our code! XDMIAPNL
1.
    ```
    In the event that the .eggs go bad, you must figure out who will be sad.
    ```
    Hint:
    ```
    Google: "[your browser name] view event handlers"
    ```
    We see that Bing (yep) tells us that Event Listeners can be found on the Inspect Element pane.
    For ours it says ()=>window['VERONICA']='sad'
    which is our next key.
1.
    ```
    This next code will be unredacted, but only when all the chakras are :active.
    ```
    Let's look at the hint first.
    ```
    `:active` is a css pseudo class that is applied on elements in an active state.
    Google: "[your browser name] force psudo classes"
    ```
    After some googling, it appears as though the only way to trigger it is to click with the mouse. We just click each word in sequence, which reveals our code, "3QK3QZTK".
1.
    ```
    Oh, no! This lock's out of commission! Pop off the cover and locate what's missing.
    ```
    So looking at the network tab, we see a lot of pictures involving this lock.
    I get stuck again, so I get another couple hints:
    ```
    Use the DOM tree viewer to examine this lock. you can search for items in the DOM using this view.
    You can click and drag elements to reposition them in the DOM tree.
    If an action doesn't produce the desired effect, check the console for error output.
    Be sure to examine that printed circuit board.
    ```
    We don't delete the div tag like in "idiotic readme" and instead move the div tag of the lock around :D
    Zooming in on the picture of the PCB to see if there's something we can see in the trace, and we find that there is, our key!
    "KD29XJ37"
    Refreshing the page and hitting the switch button gives us the error:
    ```
    Error: Missing macaroni!
    ```
    Moving that component let's us place a piece of macaroni on the lock.
    Putting the cover back on tells us:
    ```
    Error: Missing cotton swab!
    ```
    Now:
    ```
    Error: Missing gnome!
    ```
    And placing that, we see "The villian is The Tooth Fairy"
    Checking the console, we find:
    ```
    Well done! Here's the password:
    The Tooth Fairy
    You opened the chest in 695.731 seconds
    Well done! Do you have what it takes to Crack the Crate in under three minutes?
    Feel free to use this handy image to share your score!
    ```
    background-image: url("./images/scores/cc2bd188-9563-4570-9e50-1742965146fa.jpg");
1. Talking to Shinny Upatree after solving, we see the following message:
    ```
    Wha - what?? You got into my crate?!
    Well that's embarrassing...
    But you know what? Hmm... If you're good enough to crack MY security...
    Do you think you could bring this all to a grand conclusion?
    Please go into the sleigh shop and see if you can finish this off!
    Stop the Tooth Fairy from ruining Santa's sleigh route!
    ```