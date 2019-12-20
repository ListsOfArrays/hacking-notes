# Smart Braces
## Prompt
Kent Tinseltooth is having voices in his head, from his un-firewalled-off-smart braces. Make a firewall in iptables to block the bad traffic, while still letting needed traffic through.

### prompt secondary text on login

<span style="color:yellow;font-weight:bold;font-family:monospace">Inner Voice: Kent. Kent. Wake up, Kent.</span>

<span style="color:yellow;font-weight:bold;font-family:monospace">Inner Voice: I'm talking to you, Kent.</span>

<span style="color:red;font-weight:bold;font-family:monospace">Kent TinselTooth: Who said that? I must be going insane.</span>

<span style="color:red;font-weight:bold;font-family:monospace">Kent TinselTooth: Am I?</span>

<span style="color:yellow;font-weight:bold;font-family:monospace">Inner Voice: That remains to be seen, Kent. But we are having a conversation.</span>

<span style="color:yellow;font-weight:bold;font-family:monospace">Inner Voice: This is Santa, Kent, and you've been a very naughty boy.</span>

<span style="color:red;font-weight:bold;font-family:monospace">Kent TinselTooth: Alright! Who is this?! Holly? Minty? Alabaster?</span>

<span style="color:yellow;font-weight:bold;font-family:monospace">Inner Voice: I am known by many names. I am the boss of the North Pole. Turn to me and be hired after graduation.</span></span>

<span style="color:red;font-weight:bold;font-family:monospace">Kent TinselTooth: Oh, sure.</span>

<span style="color:yellow;font-weight:bold;font-family:monospace">Inner Voice: Cut the candy, Kent, you've built an automated, machine-learning, sleigh device.</span>

<span style="color:red;font-weight:bold;font-family:monospace">Kent TinselTooth: How did you know that?</span>

<span style="color:yellow;font-weight:bold;font-family:monospace">Inner Voice: I'm Santa - I know everything.</span>

<span style="color:red;font-weight:bold;font-family:monospace">Kent TinselTooth: Oh. Kringle. *sigh*</span>

<span style="color:yellow;font-weight:bold;font-family:monospace">Inner Voice: That's right, Kent. Where is the sleigh device now?</span>

<span style="color:red;font-weight:bold;font-family:monospace">Kent TinselTooth: I can't tell you.</span>

<span style="color:yellow;font-weight:bold;font-family:monospace">Inner Voice: How would you like to intern for the rest of time?</span>

<span style="color:red;font-weight:bold;font-family:monospace">Kent TinselTooth: Please no, they're testing it at srf.elfu.org using default creds, but I don't know more. It's classified.</span>

<span style="color:yellow;font-weight:bold;font-family:monospace">Inner Voice: Very good Kent, that's all I needed to know.</span>

<span style="color:red;font-weight:bold;font-family:monospace">Kent TinselTooth: I thought you knew everything?</span>

<span style="color:yellow;font-weight:bold;font-family:monospace">Inner Voice: Nevermind that. I want you to think about what you've researched and studied. From now on, stop playing with your teeth, and floss more.</span>

<span style="color:yellow;font-weight:bold;font-family:monospace">*Inner Voice Goes Silent*</span>


<span style="color:red;font-weight:bold;font-family:monospace">Kent TinselTooth: Oh no, I sure hope that voice was Santa's.</span>

<span style="color:red;font-weight:bold;font-family:monospace">Kent TinselTooth: I suspect someone may have hacked into my IOT teeth braces.</span>

<span style="color:red;font-weight:bold;font-family:monospace">Kent TinselTooth: I must have forgotten to configure the firewall...</span>

<span style="color:red;font-weight:bold;font-family:monospace">Kent TinselTooth: Please review /home/elfuuser/IOTteethBraces.md and help me configure the firewall.</span>

<span style="color:red;font-weight:bold;font-family:monospace">Kent TinselTooth: Please hurry; having this ribbon cable on my teeth is uncomfortable.</span>

# Solve Process

1. First we checkout the website given "https://srf.elfu.org/". Common defaults are admin:password, devtest:devtest, admin:admin, username:password... none of these work...
1. Now we try some simple SQL injection:
    ```sql
    admin' OR 1=1;-- -:password
    admin:admin' OR 1=1;-- -
    ```
    Neither of these work. This suggests that we should come back to this challenge later. It could still be SQL injection or credential stuffing, but for now let's proceed on the normal challenge to see if we get a hint from Kent TinselTooth.
    
    ... (challenge last attempted 12/19/2019 22:41)