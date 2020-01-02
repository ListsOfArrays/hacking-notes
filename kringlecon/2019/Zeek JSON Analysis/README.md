# Zeek JSON Analysis
## Prompt
Wunorse Openslae here, just looking at some Zeek logs.
I'm pretty sure one of these connections is a malicious C2 channel...
Do you think you could take a look?
I hear a lot of C2 channels have very long connection times.
Please use jq to find the longest connection in this data set.
We have to kick out any and all grinchy activity!
## Solve Process
1. Logging onto the terminal, we get the message:
    ```
    Some JSON files can get quite busy.
    There's lots to see and do.
    Does C&C lurk in our data?
    JQ's the tool for you!

    -Wunorse Openslae

    Identify the destination IP address with the longest connection duration
    using the supplied Zeek logfile. Run runtoanswer to submit your answer.
    ```
    The selected command: cat conn.log | jq -s -c 'sort_by(.duration) | .[]' > sorted.txt
    Then using "tail -100 sorted.txt" we find the longest duration, 1019365.337758, with IP 13.107.21.200.
    ```
    Thank you for your analysis, you are spot-on.
    I would have been working on that until the early dawn.
    Now that you know the features of jq,
    You'll be able to answer other challenges too.

    -Wunorse Openslae

    Congratulations!
    ```
    Wunorse Openslae now gives us the hint:
    ```
    That's got to be the one - thanks!
    Hey, you know what? We've got a crisis here.
    You see, Santa's flight route is planned by a complex set of machine learning algorithms which use available weather data.
    All the weather stations are reporting severe weather to Santa's Sleigh. I think someone might be forging intentionally false weather data!
    I'm so flummoxed I can't even remember how to login!
    Hmm... Maybe the Zeek http.log could help us.
    I worry about LFI, XSS, and SQLi in the Zeek log - oh my!
    And I'd be shocked if there weren't some shell stuff in there too.
    I'll bet if you pick through, you can find some naughty data from naughty hosts and block it in the firewall.
    If you find a log entry that definitely looks bad, try pivoting off other unusual attributes in that entry to find more bad IPs.
    The sleigh's machine learning device (SRF) needs most of the malicious IPs blocked in order to calculate a good route.
    Try not to block many legitimate weather station IPs as that could also cause route calculation failure.
    Remember, when looking at JSON data, jq is the tool for you!
    ```