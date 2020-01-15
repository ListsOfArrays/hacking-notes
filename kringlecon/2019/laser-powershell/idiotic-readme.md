# Elf University Student Research Terminal - Christmas Cheer Laser Project 
## Prompt
🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲
🗲                                                                                🗲
🗲 Elf University Student Research Terminal - Christmas Cheer Laser Project       🗲
🗲 ------------------------------------------------------------------------------ 🗲
🗲 The research department at Elf University is currently working on a top-secret 🗲
🗲 Laser which shoots laser beams of Christmas cheer at a range of hundreds of    🗲
🗲 miles. The student research team was successfully able to tweak the laser to   🗲
🗲 JUST the right settings to achieve 5 Mega-Jollies per liter of laser output.   🗲
🗲 Unfortunately, someone broke into the research terminal, changed the laser     🗲
🗲 settings through the Web API and left a note behind at /home/callingcard.txt.  🗲
🗲 Read the calling card and follow the clues to find the correct laser Settings. 🗲
🗲 Apply these correct settings to the laser using it's Web API to achieve laser  🗲
🗲 output of 5 Mega-Jollies per liter.                                            🗲
🗲                                                                                🗲
🗲 Use (Invoke-WebRequest -Uri http://localhost:1225/).RawContent for more info.  🗲
🗲                                                                                🗲
🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲🗲 

# Solve Process

1. This one was fun, particularly because it used Powershell on Linux, which is still pretty new.
    Let's look at the note first, and then figure out a solve first.
    ```powershell
    Get-Content /home/callingcard.txt
    ```
    --->
    ```txt
    What's become of your dear laser?
    Fa la la la la, la la la la
    Seems you can't now seem to raise her!
    Fa la la la la, la la la la
    Could commands hold riddles in hist'ry?
    Fa la la la la, la la la la
    Nay! You'll ever suffer myst'ry!
    Fa la la la la, la la la la
    ```
1. That gave us a hint to find the history of the terminal... which in powershell is:
    ```powershell
    history # powershell has a lot of aliases!
    # Get-History is aliased to history, feel free
    # to use the aliases since they make your scripts prettier
    ```
    --->
    ```powershell
    Id CommandLine
    -- -----------
    1   Get-Help -Name Get-Process 
    2   Get-Help -Name Get-* 
    3   Set-ExecutionPolicy Unrestricted 
    4   Get-Service | ConvertTo-HTML -Property Name, Status > C:\services.htm 
    5   Get-Service | Export-CSV c:\service.csv 
    6   Get-Service | Select-Object Name, Status | Export-CSV c:\service.csv 
    7   (Invoke-WebRequest http://127.0.0.1:1225/api/angle?val=65.5).RawContent
    8   Get-EventLog -Log "Application" 
    9   I have many name=value variables that I share to applications system wide. At a command I w…
    10  Get-Content /home/callingcard.txt
    ```
    Powershell is object-oriented, which is difficult to use at first, but becomes power-ful (hahah, pun intended) the more you get used to it. This spat an object out with an array called "CommandLine". We can use "select" to "-ExpandProperty" CommandLine and get a bit more text from the above. It looks like we have our first flag, the angle value was 65.5 . We'll run that command later.
1. In this case we have a hint to look at the environment variables, which can be done with:
    ```powershell
    gci env:*
    ```
    --->
    ```powershell
    Name                           Value
    ----                           -----
    PSModulePath                   /home/elf/.local/share/powershell/Modules:/usr/local/share/powers…
    username                       elf
    USER                           elf
    MAIL                           /var/mail/elf
    SHELL                          /home/elf/elf
    USERNAME                       elf
    _                              /bin/su
    PSModuleAnalysisCachePath      /var/cache/microsoft/powershell/PSModuleAnalysisCache/ModuleAnaly…
    SHLVL                          1
    userdomain                     laserterminal
    TERM                           xterm
    LC_ALL                         en_US.UTF-8
    PATH                           /opt/microsoft/powershell/6:/usr/local/sbin:/usr/local/bin:/usr/s…
    USERDOMAIN                     laserterminal
    LOGNAME                        elf
    HOSTNAME                       14a6d467677c
    HOME                           /home/elf
    riddle                         Squeezed and compressed I am hidden away. Expand me from my priso…
    PWD                            /home/elf
    RESOURCE_ID                    7b49d8aa-b007-4e8e-978d-471ee9e8610d
    LANG                           en_US.UTF-8
    DOTNET_SYSTEM_GLOBALIZATION_I… false
    ```
1. Let's expand riddle, that looks useful:
    ```powershell
    gci env:riddle | select -ExpandProperty Value
    ```
    --->
    ```txt
    Squeezed and compressed I am hidden away. Expand me from my prison and I will show you the way. Recurse through all /etc and Sort on my LastWriteTime to reveal im the newest of all.
    ```
1. That's a biiiiig hint :D
    It should be pretty easy to do that in Powershell, as again all the object attributes (like date modified) propagate when you do a search. Using bash would also be easy, but way different. Let's use gci again, but add the -Recurse flag. :D
    ```powershell
    gci /etc/ -Recurse -File | Sort -Property LastWriteTime | select -First 1
    ```
    --->
    ```powershell
    gci : Access to the path '/etc/ssl/private' is denied.
    At line:1 char:1
    + gci /etc/ -Recurse -File | Sort -Property LastWriteTime | select -Fir ...
    + ~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : PermissionDenied: (/etc/ssl/private:String) [Get-ChildItem], UnauthorizedAccessException
    + FullyQualifiedErrorId : DirUnauthorizedAccessError,Microsoft.PowerShell.Commands.GetChildItemCommand
    


        Directory: /etc/dpkg/origins

    Mode                LastWriteTime         Length Name
    ----                -------------         ------ ----
    --r---            2/2/09 11:06 PM             82 debian
    ```
    That's probably wrong, so let's skip errors!
    ```powershell
    gci /etc/ -Recurse -File -ErrorAction Ignore | Sort -Property LastWriteTime | select -First 1
    ```
    --->
    ```txt
        Directory: /etc/dpkg/origins

    Mode                LastWriteTime         Length Name
    ----                -------------         ------ ----
    --r---            2/2/09 11:06 PM             82 debian
    ```
    whatddya know! ah wait, we need the Last item, since we sorted the wrong way :D
    ```powershell
    gci /etc/ -Recurse -File -ErrorAction Ignore | Sort -Property LastWriteTime | select -Last 1 
    ```
    --->
    ```txt
        Directory: /etc/apt

    Mode                LastWriteTime         Length Name
    ----                -------------         ------ ----
    --r---          12/21/19  5:12 PM        5662902 archive
    ```
    And that looks more useful.
    ```powershell
    Expand-Archive -Path /etc/apt/archive -DestinationPath ~/unzipped
    gci -Recurse -File /home/elf/unzipped
    ```
    --->
    ```powershell
            Directory: /home/elf/unzipped/refraction
    Mode                LastWriteTime         Length Name
    ----                -------------         ------ ----
    ------           11/7/19 11:57 AM            134 riddle
    ------           11/5/19  2:26 PM        5724384 runme.elf
    ```
1. Let's figure out how to run "runme.elf".
    Let's run Get-Content on i...
    
    OHHH THAT WAS A MISTAKE. *10 minutes later*

    Ok, now that we have our terminal back we indeed know that it's an elf file, and we have to run it somehow. :D

    ... a lot of Bing searching (we're using powershell after all :D) later... Let's try to run it as an expression, but I think we'll have to change the ACL on it to add execute. Nope not valid... Trying Start-Process gives permission denied...
1. Let's skip for now and wrap back later.

    ```powershell
    # gci -Recurse ./depths/ | where {$(Get-FileHash -Algorithm MD5 -Path $_.FullName).Hash -eq "25520151A320B5B0D21561F92C8F6224"}
    # first attempt was disaster, returned directories that Get-FileHash complained about :D
    gci -File -Recurse ./depths/ | where {$(Get-FileHash -Algorithm MD5 -Path $_.FullName).Hash -eq "25520151A320B5B0D21561F92C8F6224"}
    ```
    --->
    ```powershell
            Directory: /home/elf/depths/produce

    Mode                LastWriteTime         Length Name
    ----                -------------         ------ ----
    --r---          11/18/19  7:53 PM            224 thhy5hll.txt
    ```
    Let's get that file!
    ```powershell
    gc /home/elf/depths/produce/thhy5hll.txt
    ```
    --->
    ```txt
    temperature?val=-33.5

    I am one of many thousand similar txt's contained within the deepest of /home/elf/depths. Finding me will give you the most strength but doing so will require Piping all the FullName's to Sort Length.
    ```
1. That's easy. Let's do another where :D
    ```powershell
    # another disaster :D
    # gci -File -Recurse ./depths/ | select -ExpandProperty FullName | sort
    # that sorts on name! But now we have strings, so let's sort on that property :D
    gci -File -Recurse ./depths/ | select -ExpandProperty FullName |  sort -Property Length | select -Last 1
    ```
    --->
    ```powershell
    /home/elf/depths/larger/cloud/behavior/beauty/enemy/produce/age/chair/unknown/escape/vote/long/writer/behind/ahead/thin/occasionally/explore/tape/wherever/practical/therefore/cool/plate/ice/play/truth/potatoes/beauty/fourth/careful/dawn/adult/either/burn/end/accurate/rubbed/cake/main/she/threw/eager/trip/to/soon/think/fall/is/greatest/become/accident/labor/sail/dropped/fox/0jhj5xz6.txt
    ```
    much better! Let's get the file contents.
    --->
    ```txt
    Get process information to include Username identification. Stop Process to show me you''re skilled and in this order they must be killed:

    bushy
    alabaster
    minty
    holly

    Do this for me and then you /shall/see .
    ```
    ```powershell
    Get-Process -IncludeUserName
    ```
    --->
    ```txt
    
     WS(M)   CPU(s)      Id UserName                       ProcessName
     -----   ------      -- --------                       -----------
     29.00     1.34       6 root                           CheerLaserServi
    129.09    46.81      31 elf                            elf
      3.53     0.03       1 root                           init
      0.75     0.00      24 bushy                          sleep
      0.71     0.00      25 alabaster                      sleep
      0.72     0.00      27 minty                          sleep
      0.80     0.00      29 holly                          sleep
      3.29     0.00      30 root                           su
    ```
    ```powershell
    Stop-Process 24; Stop-Process 25; Stop-Process 27; Stop-Process 29
    gc /shall/see
    ```
    --->
    ```txt
    Get the .xml children of /etc - an event log to be found. Group all .Id''s and the last thing will be in the Properties of the lonely unique event Id.
    ```
    ```powershell
    gci /etc/ -Recurse -ErrorAction Ignore -Filter *.xml
    ```
    --->
    ```txt
        Directory: /etc/systemd/system/timers.target.wants

    Mode                LastWriteTime         Length Name
    ----                -------------         ------ ----
    --r---          11/18/19  7:53 PM       10006962 EventLog.xml
    ```
1. Now we have a Windows event log... on Linux? Ok, this is going to be fun :D.
    Let's try parsing on ```"      <I32 N="Id">5</I32>"```
    ```powershell
    # first mistake was
    gc /etc/systemd/system/timers.target.wants/EventLog.xml | Select-String -Pattern "      <I32 N="Id">5</I32>"
    # 1 MILLLLLIION errors :D
    # had to close terminal :D
    [xml]$xmlfile = gc /etc/systemd/system/timers.target.wants/EventLog.xml
    # now we have our stuff stored in an easy-to-index format
    # peek at the xml file and find the overall format, but to save time here's me skipping ahead:
    $xmlFile.Objs.Obj.Props.I32
    # which prints out a bunch of different Ids...
    # more iterations later
    $xmlFile.Objs.Obj.Props.I32 | where {$_.N -eq "Id"} | select -ExpandProperty '#text' | group-object
    ```
    which prints out a count of all unique Ids on the system:
    ```powershell
    Count Name                      Group
    ----- ----                      -----
    1       1                         {1}
    39      2                         {2, 2, 2, 2…}
    179     3                         {3, 3, 3, 3…}
    2       4                         {4, 4}
    905     5                         {5, 5, 5, 5…}
    98      6                         {6, 6, 6, 6…}
    ```
    we can select that xml object now!
    ```powershell
    $xmlFile.Objs.Obj | where {$_.Props.I32.N -eq "Id" -and $($_.Props.I32 | select -ExpandProperty '#text') -eq '1'} 
    #...
    $node = $xmlFile.Objs.Obj | where {$_.Props.I32.N -eq "Id" -and $($_.Props.I32 | select -ExpandProperty '#text') -eq '1'}
    #...
    $node.OuterXml
    #...
    ```
    Using [this script](https://devblogs.microsoft.com/powershell/format-xml/) from Microsoft...
    ```powershell
    Format-XML $node.OuterXml 
    ```
    -->
    ```xml
    <Obj RefId="1800" xmlns="http://schemas.microsoft.com/powershell/2004/04">
    <TN RefId="1800">
        <T>System.Diagnostics.Eventing.Reader.EventLogRecord</T>
        <T>System.Diagnostics.Eventing.Reader.EventRecord</T>
        <T>System.Object</T>
    </TN>
    <ToString>System.Diagnostics.Eventing.Reader.EventLogRecord</ToString>
    <Props>
        <I32 N="Id">1</I32>
        <By N="Version">5</By>
        <Nil N="Qualifiers" />
        <By N="Level">4</By>
        <I32 N="Task">1</I32>
        <I16 N="Opcode">0</I16>
        <I64 N="Keywords">-9223372036854775808</I64>
        <I64 N="RecordId">2422</I64>
        <S N="ProviderName">Microsoft-Windows-Sysmon</S>
        <G N="ProviderId">5770385f-c22a-43e0-bf4c-06f5698ffbd9</G>
        <S N="LogName">Microsoft-Windows-Sysmon/Operational</S>
        <I32 N="ProcessId">1960</I32>
        <I32 N="ThreadId">6640</I32>
        <S N="MachineName">elfuresearch</S>
        <Obj N="UserId" RefId="1801">
        <TN RefId="1801">
            <T>System.Security.Principal.SecurityIdentifier</T>
            <T>System.Security.Principal.IdentityReference</T>
            <T>System.Object</T>
        </TN>
        <ToString>S-1-5-18</ToString>
        <Props>
            <I32 N="BinaryLength">12</I32>
            <Nil N="AccountDomainSid" />
            <S N="Value">S-1-5-18</S>
        </Props>
        </Obj>
        <DT N="TimeCreated">2019-11-07T09:59:56.5265735-08:00</DT>
        <Nil N="ActivityId" />
        <Nil N="RelatedActivityId" />
        <S N="ContainerLog">microsoft-windows-sysmon/operational</S>
        <Obj N="MatchedQueryIds" RefId="1802">
        <TN RefId="1802">
            <T>System.UInt32[]</T>
            <T>System.Array</T>
            <T>System.Object</T>
        </TN>
        <LST />
        </Obj>
        <Obj N="Bookmark" RefId="1803">
        <TN RefId="1803">
            <T>System.Diagnostics.Eventing.Reader.EventBookmark</T>
            <T>System.Object</T>
        </TN>
        <ToString>System.Diagnostics.Eventing.Reader.EventBookmark</ToString>
        </Obj>
        <S N="LevelDisplayName">Information</S>
        <S N="OpcodeDisplayName">Info</S>
        <S N="TaskDisplayName">Process Create (rule: ProcessCreate)</S>
        <Obj N="KeywordsDisplayNames" RefId="1804">
        <TN RefId="1804">
            <T>System.Collections.ObjectModel.ReadOnlyCollection`1[[System.String, mscorlib, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089]]</T>
            <T>System.Object</T>
        </TN>
        <LST />
        </Obj>
        <Obj N="Properties" RefId="1805">
        <TN RefId="1805">
            <T>System.Collections.Generic.List`1[[System.Diagnostics.Eventing.Reader.EventProperty, System.Core, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089]]</T>
            <T>System.Object</T>
        </TN>
        <LST>
            <Obj RefId="1806">
            <TN RefId="1806">
                <T>System.Diagnostics.Eventing.Reader.EventProperty</T>
                <T>System.Object</T>
            </TN>
            <ToString>System.Diagnostics.Eventing.Reader.EventProperty</ToString>
            <Props>
                <S N="Value">
                </S>
            </Props>
            </Obj>
            <Obj RefId="1807">
            <TNRef RefId="1806" />
            <ToString>System.Diagnostics.Eventing.Reader.EventProperty</ToString>
            <Props>
                <S N="Value">2019-11-07 17:59:56.525</S>
            </Props>
            </Obj>
            <Obj RefId="1808">
            <TNRef RefId="1806" />
            <ToString>System.Diagnostics.Eventing.Reader.EventProperty</ToString>
            <Props>
                <G N="Value">ba5c6bbb-5b9c-5dc4-0000-00107660a900</G>
            </Props>
            </Obj>
            <Obj RefId="1809">
            <TNRef RefId="1806" />
            <ToString>System.Diagnostics.Eventing.Reader.EventProperty</ToString>
            <Props>
                <U32 N="Value">3664</U32>
            </Props>
            </Obj>
            <Obj RefId="18010">
            <TNRef RefId="1806" />
            <ToString>System.Diagnostics.Eventing.Reader.EventProperty</ToString>
            <Props>
                <S N="Value">C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe</S>
            </Props>
            </Obj>
            <Obj RefId="18011">
            <TNRef RefId="1806" />
            <ToString>System.Diagnostics.Eventing.Reader.EventProperty</ToString>
            <Props>
                <S N="Value">10.0.14393.206 (rs1_release.160915-0644)</S>
            </Props>
            </Obj>
            <Obj RefId="18012">
            <TNRef RefId="1806" />
            <ToString>System.Diagnostics.Eventing.Reader.EventProperty</ToString>
            <Props>
                <S N="Value">Windows PowerShell</S>
            </Props>
            </Obj>
            <Obj RefId="18013">
            <TNRef RefId="1806" />
            <ToString>System.Diagnostics.Eventing.Reader.EventProperty</ToString>
            <Props>
                <S N="Value">Microsoft® Windows® Operating System</S>
            </Props>
            </Obj>
            <Obj RefId="18014">
            <TNRef RefId="1806" />
            <ToString>System.Diagnostics.Eventing.Reader.EventProperty</ToString>
            <Props>
                <S N="Value">Microsoft Corporation</S>
            </Props>
            </Obj>
            <Obj RefId="18015">
            <TNRef RefId="1806" />
            <ToString>System.Diagnostics.Eventing.Reader.EventProperty</ToString>
            <Props>
                <S N="Value">PowerShell.EXE</S>
            </Props>
            </Obj>
            <Obj RefId="18016">
            <TNRef RefId="1806" />
            <ToString>System.Diagnostics.Eventing.Reader.EventProperty</ToString>
            <Props>
                <S N="Value">C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -c "`$correct_gases_postbody = @{`n    O=6`n    H=7`n    He=3`n    N=4`n    Ne=22`n    Ar=11`n    Xe=10`n    F=20`n    Kr=8`n    Rn=9`n}`n"</S>
            </Props>
            </Obj>
            <Obj RefId="18017">
            <TNRef RefId="1806" />
            <ToString>System.Diagnostics.Eventing.Reader.EventProperty</ToString>
            <Props>
                <S N="Value">C:\</S>
            </Props>
            </Obj>
            <Obj RefId="18018">
            <TNRef RefId="1806" />
            <ToString>System.Diagnostics.Eventing.Reader.EventProperty</ToString>
            <Props>
                <S N="Value">ELFURESEARCH\allservices</S>
            </Props>
            </Obj>
            <Obj RefId="18019">
            <TNRef RefId="1806" />
            <ToString>System.Diagnostics.Eventing.Reader.EventProperty</ToString>
            <Props>
                <G N="Value">ba5c6bbb-5b9c-5dc4-0000-0020f55ca900</G>
            </Props>
            </Obj>
            <Obj RefId="18020">
            <TNRef RefId="1806" />
            <ToString>System.Diagnostics.Eventing.Reader.EventProperty</ToString>
            <Props>
                <U64 N="Value">11099381</U64>
            </Props>
            </Obj>
            <Obj RefId="18021">
            <TNRef RefId="1806" />
            <ToString>System.Diagnostics.Eventing.Reader.EventProperty</ToString>
            <Props>
                <U32 N="Value">0</U32>
            </Props>
            </Obj>
            <Obj RefId="18022">
            <TNRef RefId="1806" />
            <ToString>System.Diagnostics.Eventing.Reader.EventProperty</ToString>
            <Props>
                <S N="Value">High</S>
            </Props>
            </Obj>
            <Obj RefId="18023">
            <TNRef RefId="1806" />
            <ToString>System.Diagnostics.Eventing.Reader.EventProperty</ToString>
            <Props>
                <S N="Value">MD5=097CE5761C89434367598B34FE32893B</S>
            </Props>
            </Obj>
            <Obj RefId="18024">
            <TNRef RefId="1806" />
            <ToString>System.Diagnostics.Eventing.Reader.EventProperty</ToString>
            <Props>
                <G N="Value">ba5c6bbb-4c79-5dc4-0000-001029350100</G>
            </Props>
            </Obj>
            <Obj RefId="18025">
            <TNRef RefId="1806" />
            <ToString>System.Diagnostics.Eventing.Reader.EventProperty</ToString>
            <Props>
                <U32 N="Value">1008</U32>
            </Props>
            </Obj>
            <Obj RefId="18026">
            <TNRef RefId="1806" />
            <ToString>System.Diagnostics.Eventing.Reader.EventProperty</ToString>
            <Props>
                <S N="Value">C:\Windows\System32\svchost.exe</S>
            </Props>
            </Obj>
            <Obj RefId="18027">
            <TNRef RefId="1806" />
            <ToString>System.Diagnostics.Eventing.Reader.EventProperty</ToString>
            <Props>
                <S N="Value">C:\Windows\system32\svchost.exe -k netsvcs</S>
            </Props>
            </Obj>
        </LST>
        </Obj>
    </Props>
    <MS>
        <S N="Message">Process Create:_x000D__x000A_RuleName: _x000D__x000A_UtcTime: 2019-11-07 17:59:56.525_x000D__x000A_ProcessGuid: {BA5C6BBB-5B9C-5DC4-0000-00107660A900}_x000D__x000A_ProcessId: 3664_x000D__x000A_Image: C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe_x000D__x000A_FileVersion: 10.0.14393.206 (rs1_release.160915-0644)_x000D__x000A_Description: Windows PowerShell_x000D__x000A_Product: Microsoft® Windows® Operating System_x000D__x000A_Company: Microsoft Corporation_x000D__x000A_OriginalFileName: PowerShell.EXE_x000D__x000A_CommandLine: C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -c "`$correct_gases_postbody = @{`n    O=6`n    H=7`n    He=3`n    N=4`n    Ne=22`n    Ar=11`n    Xe=10`n    F=20`n    Kr=8`n    Rn=9`n}`n"_x000D__x000A_CurrentDirectory: C:\_x000D__x000A_User: ELFURESEARCH\allservices_x000D__x000A_LogonGuid: {BA5C6BBB-5B9C-5DC4-0000-0020F55CA900}_x000D__x000A_LogonId: 0xA95CF5_x000D__x000A_TerminalSessionId: 0_x000D__x000A_IntegrityLevel: High_x000D__x000A_Hashes: MD5=097CE5761C89434367598B34FE32893B_x000D__x000A_ParentProcessGuid: {BA5C6BBB-4C79-5DC4-0000-001029350100}_x000D__x000A_ParentProcessId: 1008_x000D__x000A_ParentImage: C:\Windows\System32\svchost.exe_x000D__x000A_ParentCommandLine: C:\Windows\system32\svchost.exe -k netsvcs</S>
    </MS>
    </Obj>
    ```
    and we see the result as the process creation string!
    ```powershell
    C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -c "`$correct_gases_postbody = @{`n    O=6`n    H=7`n    He=3`n    N=4`n    Ne=22`n    Ar=11`n    Xe=10`n    F=20`n    Kr=8`n    Rn=9`n}`n
    ```
    formatted:
    ```powershell
    $correct_gases_postbody = @{
        O=6
        H=7
        He=3
        N=4
        Ne=22
        Ar=11
        Xe=10
        F=20
        Kr=8
        Rn=9
    }
    ```
1. Let's run that webscript to see what else we need.
    ```html
    HTTP/1.0 200 OK                                                                                   
    Server: Werkzeug/0.16.0                                                                           
    Server: Python/3.6.9                                                                              
    Date: Sat, 21 Dec 2019 19:10:33 GMT                                                               
    Content-Type: text/html; charset=utf-8
    Content-Length: 860

    <html>
    <body>
    <pre>
    ----------------------------------------------------
    Christmas Cheer Laser Project Web API
    ----------------------------------------------------
    Turn the laser on/off:
    GET http://localhost:1225/api/on
    GET http://localhost:1225/api/off

    Check the current Mega-Jollies of laser output
    GET http://localhost:1225/api/output

    Change the lense refraction value (1.0 - 2.0):
    GET http://localhost:1225/api/refraction?val=1.0

    Change laser temperature in degrees Celsius:
    GET http://localhost:1225/api/temperature?val=-10

    Change the mirror angle value (0 - 359):
    GET http://localhost:1225/api/angle?val=45.1

    Change gaseous elements mixture:
    POST http://localhost:1225/api/gas
    POST BODY EXAMPLE (gas mixture percentages):
    O=5&H=5&He=5&N=5&Ne=20&Ar=10&Xe=10&F=20&Kr=10&Rn=10
    ----------------------------------------------------
    </pre>
    </body>
    </html>
    ```
1. Well we have the following so far:
    ```powershell
    temperature?val=-33.5
    (Invoke-WebRequest http://127.0.0.1:1225/api/angle?val=65.5).RawContent
    $correct_gases_postbody = @{
        O=6
        H=7
        He=3
        N=4
        Ne=22
        Ar=11
        Xe=10
        F=20
        Kr=8
        Rn=9
    }
    ```
    but what is the refraction? Let's return to the runme.elf, and try to see if there's a way we can run that binary.

    ...
    ...
    ...

    And once again the obvious escaped us. Chmod is accessible. 🤦🏽‍♂️
    ```bash
    chmod +x ./runme.elf
    ./runme.elf
    ```
    ```txt
    refraction?val=1.867
    ```
    Woot our last value! Let's activate the laser then!
1. Final set of commands:
    ```powershell
    Invoke-WebRequest -Uri http://localhost:1225/api/refraction?val=1.867
    Invoke-WebRequest -Uri http://localhost:1225/api/temperature?val=-33.5
    (Invoke-WebRequest http://127.0.0.1:1225/api/angle?val=65.5).RawContent
    $correct_gases_postbody = @{
        O=6
        H=7
        He=3
        N=4
        Ne=22
        Ar=11
        Xe=10
        F=20
        Kr=8
        Rn=9
    }
    Invoke-WebRequest -Uri http://localhost:1225/api/gas -Method POST -Body $correct_gases_postbody

    # and now...

    Invoke-WebRequest -Uri http://localhost:1225/api/on

    
    # that didn't do anything other than say it's powered on let's check the power levels vegeta

    (Invoke-WebRequest -Uri http://localhost:1225/api/output).Content
    ```
1. And we solved the challenge. We get a hint to use RITA to solve challenge 5.