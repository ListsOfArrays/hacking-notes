# 4) Windows Log Analysis: Determine Attacker Technique
## Prompt
Using [these normalized Sysmon logs](https://downloads.elfu.org/sysmon-data.json.zip), identify the tool the attacker used to retrieve domain password hashes from the lsass.exe process. For hints on achieving this objective, please visit Hermey Hall and talk with SugarPlum Mary.

# Solve Process

1. So for this one we search for "lsass" and find that it has started a "cmd.exe" process. That seems weird.
1. From this point, because we've read the idiotic version, we decide to NOT scroll up in the file, and save ourselves a couple hours. Also, we skip going to Hermey Hall to talk to SugarPlum Mary for a hint, as that's not useful :D
1. Instead, we are absolute geniuses and immediately spot this:
    ```json
    {
        "command_line": "ntdsutil.exe  \"ac i ntds\" ifm \"create full c:\\hive\" q q",
        "event_type": "process",
        "logon_id": 999,
        "parent_process_name": "cmd.exe",
        "parent_process_path": "C:\\Windows\\System32\\cmd.exe",
        "pid": 3556,
        "ppid": 3440,
        "process_name": "ntdsutil.exe",
        "process_path": "C:\\Windows\\System32\\ntdsutil.exe",
        "subtype": "create",
        "timestamp": 132186398470300000,
        "unique_pid": "{7431d376-dee7-5dd3-0000-0010f0c44f00}",
        "unique_ppid": "{7431d376-dedb-5dd3-0000-001027be4f00}",
        "user": "NT AUTHORITY\\SYSTEM",
        "user_domain": "NT AUTHORITY",
        "user_name": "SYSTEM"
    }
    ```
    This is ntdsutil.exe creating a copy of the registry hive... which contains the LSASS creds....
    
    And the answer is ntdsutil.exe...
1. Tada! that was totally easy and did not take us a day to solve. :D

### *PS: Warning, downloading the 04 idiotic version may cause your AV to trigger: there's malicious powershell embedded in it, but it should be safe so long as you don't copy the powershell into a console. 🤣*