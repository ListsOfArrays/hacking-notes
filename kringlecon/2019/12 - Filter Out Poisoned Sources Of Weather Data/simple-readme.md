# 12) Filter Out Poisoned Sources of Weather Data
## Prompt
Use the data supplied in the Zeek JSON logs to identify the IP addresses of attackers poisoning Santa's flight mapping software. Block the 100 offending sources of information to guide Santa's sleigh through the attack. Submit the Route ID ("RID") success value that you're given. For hints on achieving this objective, please visit the Sleigh Shop and talk with Wunorse Openslae.
## Secondary Prompt
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

## Incidental Tooth Fairy Rant
I’m the Tooth Fairy, the mastermind behind the plot to destroy the holiday season.
I hate how Santa is so beloved, but only works one day per year!
He has all of the resources of the North Pole and the elves to help him too.
I run a solo operation, toiling year-round collecting deciduous bicuspids and more from children.
But I get nowhere near the gratitude that Santa gets. He needs to share his holiday resources with the rest of us!
But, although you found me, you haven’t foiled my plot!
Santa’s sleigh will NOT be able to find its way.
I will get my revenge and respect!
I want my own holiday, National Tooth Fairy Day, to be the most popular holiday on the calendar!!!

## Solve Process
1. ... \<idiotic steps here\>
1. ...
1. Bingo, we found "https://srf.elfu.org/README.md" which tells the default username credentials (this was hinted at in the 10th challenge):
    ```md
    # Sled-O-Matic - Sleigh Route Finder Web API

    ### Installation

    ` ` `
    sudo apt install python3-pip
    sudo python3 -m pip install -r requirements.txt
    ` ` `

    #### Running:

    `python3 ./srfweb.py`

    #### Logging in:

    You can login using the default admin pass:

    `admin 924158F9522B3744F5FCD4D10FAC4356`

    However, it's recommended to change this in the sqlite db to something custom.
    ```
1. Instead of using jq, I decided to use PowerShell. That may have been a good or bad choice, but it made certain queries easier (particularly queries using ' in them). Some example commands used to start looking at bad data:
    ```powershell
    $json_file = Get-Content .\http.log | ConvertFrom-Json

    $json_file | Select-Object uri | ConvertTo-Csv | Sort | Get-Unique | Select-String -Pattern "<"
    $json_file | Select-Object uri | ConvertTo-Csv | Sort | Get-Unique | Select-String -Pattern "\.\."
    $json_file | Select-Object uri | ConvertTo-Csv | Sort | Get-Unique | Select-String -Pattern "'"
    $json_file | Select-Object user_agent | ConvertTo-Csv | Sort | Get-Unique | Select-String -Pattern "'"
    $json_file | Select-Object user_agent | ConvertTo-Csv | Sort | Get-Unique | Select-String -Pattern "{|}"
    $json_file | Select-Object user_agent | ConvertTo-Csv | Sort | Get-Unique | Select-String -Pattern '>'
    $json_file | Select-Object host | ConvertTo-Csv | Sort | Get-Unique | Select-String -Pattern '>'

    # combined options
    $json_file | Select-Object host,uri,user_agent | ConvertTo-Csv | Sort | Get-Unique | Select-String -Pattern "'"
    $json_file | Select-Object host,uri,user_agent | ConvertTo-Csv | Sort | Get-Unique | Select-String -Pattern '{|}'
    $json_file | Select-Object host,uri,user_agent | ConvertTo-Csv | Sort | Get-Unique | Select-String -Pattern '>'
    $json_file | Select-Object host,uri,user_agent | ConvertTo-Csv | Sort | Get-Unique | Select-String -Pattern '(\.[/\\])|(\.\.)'
    ```
    The ConvertTo-CSV helped the sorting for some reason :D

    I think this is the majority of the data, let's go and find the IPs associated with these bad requests, and also map to the bad user agents.
    ... fast forward 1 week
1. I created the powershell script. The resulting Regex looked like this:
    ```powershell
    "(')|(>)|(<)|(\.\.)|( or )|" + '(")|(%)|(\./\|)|(\(\))|\||(/etc)|(\$)|(;:)'
    ```
    The overall script:
    ```powershell
    $json_file = gc .\http.log | ConvertFrom-Json
    $superRegex = "(')|(>)|(<)|(\.\.)|( or )|" + '(")|(%)|(\./\|)|(\(\))|\||(/etc)|(\$)|(;:)'
    $knownBadRequests = $json_file | Where-Object {$_.host -Match "$superRegex" -or $_.uri -Match "$superRegex" -or $_.user_agent -Match "$superRegex" -or $_.username -Match "$superRegex"}
    ([System.Collections.Generic.HashSet[string]] $useragent_set = $knownBadRequests.user_agent)
    ([System.Collections.Generic.HashSet[string]] $ip_set = $knownBadRequests."id.orig_h")
    $otherBadRequests = $json_file | Where-Object {$_.user_agent -in $useragent_set -or $_."id.orig_h" -in $ip_set}

    # taking a hint from https://pollev.github.io/Kringlecon-2-Turtle-Doves/#filter-out-poisoned-sources-of-weather-data, we find that the most common UAs have to be filtered out.
    $good_user_agents = $otherBadRequests.user_agent | group | sort -Property Count -Descending | select -First 4 | select Name 
    for ($i = 0; $i -lt $good_user_agents.Count; $i++) { $good_user_agents[$i] = [string] $good_user_agents[$i].Name }
    $otherBadRequests | where {$_.user_agent -ne $good_user_agents[0] -and $_.user_agent -ne $good_user_agents[1] -and $_.user_agent -ne $good_user_agents[2] -and $_.user_agent -ne $good_user_agents[3]} | select "id.orig_h" | measure
    $otherBadRequests | where {$_.user_agent -ne $good_user_agents[0] -and $_.user_agent -ne $good_user_agents[1] -and $_.user_agent -ne $good_user_agents[2] -and $_.user_agent -ne $good_user_agents[3]} | select "id.orig_h"
    ```
    Then we take the IPs, place commas after each one using multi-select, and get a success! RID:0807198508261964.
    Alas, I was unable to solve this over the course of the challenge, I did not think to group the UAs and filter by that.
    Also, there were only 97 IPs instead of 100 as the challenge described. But special thanks to https://pollev.github.io/Kringlecon-2-Turtle-Doves/#filter-out-poisoned-sources-of-weather-data for posting a writeup so I could finally solve this; the hint to filter the most common UAs was all that was needed.j
1. Placing the RID in opens the door to the bell tower. We see that the Tooth fairy is now in a prison outfit, and tells us:
    ```
    You foiled my dastardly plan! I’m ruined!
    And I would have gotten away with it too, if it weren't for you meddling kids!    
    ```
    Meanwhile, Krampus tells us:
    ```
    Congratulations on a job well done!
    Oh, by the way, I won the Frido Sleigh contest.
    I got 31.8% of the prizes, though I'll have to figure that out.
    ```
    And Santa tells us:
    ```
    You did it! Thank you! You uncovered the sinister plot to destroy the holiday season!

    Through your diligent efforts, we’ve brought the Tooth Fairy to justice and saved the holidays!

    Ho Ho Ho!

    The more I laugh, the more I fill with glee.

    And the more the glee,

    The more I'm a merrier me!

    Merry Christmas and Happy Holidays.
    ```
    A fitting end to the challenge.
1. Unfortunately when I had to "phone a friend" and look at the Pollev walkthrough, I saw the letter mentioned, and had that part spoiled (to be honest I'd have probably missed it).

    Letter text:
    ```
    Thankfully, I didn’t have to
    implement my plan by myself!
    Jack Frost promised to use his
    wintry magic to help me subvert
    Santa’s horrible reign of holiday
    merriment NOW and FOREVER!
    ```
    Which as the walkthrough pointed out, probably means we'll be seeing a certain fellow nipping at our noses next year as the villain of Kringle Con. :D

    Merry Christmas & Happy New Year!

    ListsOfArrays -> "lolz"

# Last note:
I do want to thank all the people who made Kringlecon so great!
Thanks and hope to play again next year, great job!
Here were the credits that the game ended with:

# Credits

## SANS Holiday Hack Challenge 2019
## KringleCon 2: Turtle Doves
## Direction

Ed Skoudis

## Technical Lead

Joshua Wright

## Narrative / Story

Ed Skoudis

## World Builder Lead

Evan Booth

## Programming

Evan Booth

Ron Bowes

Chris Davis

Chris Elgee

Matt Toussain

Joshua Wright

## System Builds & Administration

Tom Hessman

Daniel Pendolino

## Artwork

Evan Booth

Chris Davis

Chris Elgee

Kimberly Elliott

Brian Hostetler

Annie Royal

Ed Skoudis

## Challenge Development

Jim Apger

Evan Booth

Ron Bowes

James Brodsky

Gary Burgett

Andy Cooper

Chris Davis

Chris Elgee

Tim Frazier

Dave Herrald

Ryan Kovar

Marcus Laferrera

Brett Leaver

Lily Lee

Devian Ollam

Daniel Pendolino

John Stoner

Matt Toussain

David Veuve

Robert Wagner

Joshua Wright

## Soundtrack

Dual Core

Ninjula

Josh Skoudis

## Website Design

Tom Hessman

## Conference Scheduler and Speaker Wrangler

Chris Fleener

## Testing and Feedback

Ron Bowes

Chris Elgee

Tom Hessman

Brian Hostetler

Ryan Huffer

Daniel Pendolino

Lynn Schifano

Ed Skoudis

Joshua Wright

## KringleCon Speakers

Ed Skoudis - Host

John Strand - Keynote

Mark Baggett

Ron Bowes

James Brodsky

Lesley Carhart

Ian Coldwater

Chris Davis

Chris Elgee

John Hammond

Dave Kennedy

Katie Knowles

Heather Mahalik

Deviant Ollam

Sn0w
## Marketing
Chris Fleener
## Sponsored Hosting Services
Google
## Special Thanks
The SANS Institute
© Copyright SANS Institute, 2019. All Rights Reserved.
