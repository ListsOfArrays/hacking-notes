# 6) Splunk
## Prompt 1
Access https://splunk.elfu.org/ as elf with password elfsocks. What was the message for Kent that the adversary embedded in this attack? The SOC folks at that link will help you along! For hints on achieving this objective, please visit the Laboratory in Hermey Hall and talk with Prof. Banas.

## Prompt 2
The Search for Holiday Cheer Challenge
1. Your goal is to answer the Challenge Question. You will include the answer to this question in your HHC write-up!
1. You do not need to answer the training questions. You may simply search through the Elf U SOC data to find the answer to the final question on your own.
1. If you need some guidance, answer the training questions! Each one will help you get closer to the answering the Challenge Question.
1. Characters in the SOC Secure Chat are there to help you. If you see a blinking red dot  next to a character, click on them and read the chat history to learn what they have to teach you! And don't forget to scroll up in the chat history!
1. To search the SOC data, just click the Search link in the navigation bar in the upper left hand corner of the page.
1. This challenge is best enjoyed on a laptop or desktop computer with screen width of 1600 pixels or more.
1. WARNING This is a defensive challenge. Do not attack this system, web application, or back-end APIs. Thank you!

# Solve Process
1. I don't know Splunk, so let's learn by following the training questions.
1. Question 1: What is the short host name of Professor Banas' computer?
    1. For the first question, one of the chat logs mentions that a system has beaconing (on the #ELFU SOC sub-chat), and that system's name is 'sweetums'. Alice mentions that's Professor Banas' system... bingo!
1. Question 2: 	What is the name of the sensitive file that was likely accessed and copied by the attacker? Please provide the fully qualified location of the file. (Example: C:\temp\report.pdf)
    1. Returning to Alice Bluebird, we see that we have 18 new messages.
    1. Following the hint to search for the professor's name, we find an unusual email from a student to the professor: please decrypt this zip file and hit enable content on Word, implying that the professor was phished by one of his students. Also, reading the professor's reply suggests that the script created a copy of another student's file even to the exact error. The word document launched a powershell script that ran (with some additional formatting to fix the mess):

    1. We're geniuses so we skip investigating the actual PS macro executed as in the idiotic walkthrough & decide to type in the following: "C:\Users\cbanas\"
    
    1. aha!
    C:\Users\cbanas\Documents\Naughty_and_Nice_2019_draft.txt
    Looks sensitive to me!
    and that's the answer.

    1. Then Alice disses us and tells us we could've just searched "index=main santa" instead. :D

1. For the Fully Qualified Domain Name, let's look for "144.202.46.214" and DNS.
    We can do this by looking at "144.202.46.214" and DestinationHostname:
    144.202.46.214.vultr.com

    The suggested way was "sourcetype=XmlWinEventLog:Microsoft-Windows-Sysmon/Operational powershell EventCode=3"


1. For this we already know! It's the docm file :D
    19th Century Holiday Cheer Assignment.docm

    Alice suggested a lot of useful stuff, but we hit it all at step 1 haha.


1. Let's look for "Carl.Banas@faculty.elfu.org"
    Turning on the syntax highlighter on one of the emails, let's look for results.workers.iocextract.email
    ```splunk
    Carl.Banas@faculty.elfu.org | fields "results{}.workers.iocextract.email{}"
    ```
    Bah close enough. Select all on the page, copy in to VS Code, and run the regex \S*@\S* to extract all emails on the page. Then sort and reduce & remove the machine ones for the following list:
    ```
    bradly.buttercups@eifu.org
    brownie.snowtrifle@students.elfu.org
    bushy.evergren@students.elfu.org
    carol.greenballs@students.elfu.org
    cherry.brandyfluff@students.elfu.org
    clove.fruitsparkles@students.elfu.org
    cupcake.silverlog@students.elfu.org
    holly.evergreen@students.elfu.org
    merry.fairybubbles@students.elfu.org
    minty.candycane@students.elfu.org
    partridge.sugartree@students.elfu.org
    pepper.minstix@students.elfu.org
    plum.sparklepie@students.elfu.org
    robin.wintercrystals@students.elfu.org
    shinny.upatree@students.elfu.org
    sixpence.snowcane@students.elfu.org
    sparkle.redberry@students.elfu.org
    sugerplum.mary@students.elfu.org
    turtledove.fairytree@students.elfu.org
    wunorse.openslae@students.elfu.org
    yule.toffeetoes@students.elfu.org
    ```
    Which is 21 different emails.
1. For the password the email said "123456789"
1. For the email it was Bradly.Buttercups@eIfu.org

1. And for the final challenge, we download the files associated with that attack... and cat them.
Because we're geniuses (unlike the idiotic walkthrough) and we know that the challenge won't contain a docm, we skip the investigation of the docm & go straight for the core. The core.xml specifically :P
    And in the core.xml file it says:
    ```xml
    <cp:coreProperties xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dcmitype="http://purl.org/dc/dcmitype/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    <dc:title>Holiday Cheer Assignment</dc:title>
    <dc:subject>19th Century Cheer</dc:subject>
    <dc:creator>Bradly Buttercups</dc:creator>
    <cp:keywords></cp:keywords>
    <dc:description>Kent you are so unfair. And we were going to make you the king of the Winter Carnival.</dc:description>
    <cp:lastModifiedBy>Tim Edwards</cp:lastModifiedBy>
    <cp:revision>4</cp:revision>
    <dcterms:created xsi:type="dcterms:W3CDTF">2019-11-19T14:54:00Z</dcterms:created>
    <dcterms:modified xsi:type="dcterms:W3CDTF">2019-11-19T17:50:00Z</dcterms:modified>
    <cp:category></cp:category>
    </cp:coreProperties>
    ```
    Which gives us the message "Kent you are so unfair. And we were going to make you the king of the Winter Carnival."
    Which is our answer.