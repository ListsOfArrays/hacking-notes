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
    
1. The hint in /home/elfuuser/IOTteethBraces.md is:
    ```
    # ElfU Research Labs - Smart Braces
    ### A Lightweight Linux Device for Teeth Braces
    ### Imagined and Created by ElfU Student Kent TinselTooth
    This device is embedded into one's teeth braces for easy management and monitoring of dental statu
    s. It uses FTP and HTTP for management and monitoring purposes but also has SSH for remote access.
    Please refer to the management documentation for this purpose.
    ## Proper Firewall configuration:
    The firewall used for this system is `iptables`. The following is an example of how to set a default policy with using `iptables`:

    sudo iptables -P FORWARD DROP

    The following is an example of allowing traffic from a specific IP and to a specific port:

    sudo iptables -A INPUT -p tcp --dport 25 -s 172.18.5.4 -j ACCEPT

    A proper configuration for the Smart Braces should be exactly:
    1. Set the default policies to DROP for the INPUT, FORWARD, and OUTPUT chains.
    2. Create a rule to ACCEPT all connections that are ESTABLISHED,RELATED on the INPUT and the OUTPU
    T chains.
    3. Create a rule to ACCEPT only remote source IP address 172.19.0.225 to access the local SSH serv
    er (on port 22).
    4. Create a rule to ACCEPT any source IP to the local TCP services on ports 21 and 80.
    5. Create a rule to ACCEPT all OUTPUT traffic with a destination TCP port of 80.
    6. Create a rule applied to the INPUT chain to ACCEPT all traffic from the lo interface.
    ```
1. For 1. we can do as follows:
    ```bash
    sudo iptables -P INPUT DROP
    sudo iptables -P FORWARD DROP
    sudo iptables -P OUTPUT DROP
    ```
    and now when we run sudo iptables -L we see all policies are default DROP.
1. For 2 we look up the [man page for iptables](https://linux.die.net/man/8/iptables) and find we can do:
    ```bash
    sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
    sudo iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
    ```
    *We have now timed out our session, our poor little elf can't stand the cable, so we'll have to copy-paste the overall bash script at the end.*

    Continuing, we find for 3:
    ```bash
    sudo iptables -A INPUT -p tcp --dport 22 -s 172.19.0.225 -j ACCEPT
    ```
    and for 4:
    ```bash
    sudo iptables -A INPUT -p tcp --dport 21 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
    ```
    ... 5:
    ```bash
    sudo iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT
    ```
    ... 6:
    ```bash
    sudo iptables -A INPUT -i lo -j ACCEPT
    ```
1. This gives us an overall rule of:
    ```bash
    sudo iptables -P INPUT DROP
    sudo iptables -P FORWARD DROP
    sudo iptables -P OUTPUT DROP

    sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
    sudo iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

    sudo iptables -A INPUT -p tcp --dport 22 -s 172.19.0.225 -j ACCEPT

    sudo iptables -A INPUT -p tcp --dport 21 -j ACCEPT
    sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT

    sudo iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT

    sudo iptables -A INPUT -i lo -j ACCEPT
    ```
1. This gives us a badge, and a hint to look for a crate in the Student Union, it has an interesting set of locks, and rhymes, specifically the page source for the crate, and a hint to use Chrome Dev Tools specifically. And then Firefox, then Safari, the Edge, then... curl? Then LYNX? And hints if we complete the Holiday Hack Trial on HARD.
1. I gotta look up [curl dev tools](https://curl.haxx.se/docs/manpage.html) and [lynx dev tools](https://xkcd.com/325/) XKCD-rolled. :D WELL I deserved that one :P