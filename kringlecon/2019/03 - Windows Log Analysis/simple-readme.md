# Windows Log Analysis: Evaluate Attack Outcome
## Prompt
We're seeing attacks against the Elf U domain! Using the event log data, identify the user account that the attacker compromised using a password spray attack. Bushy Evergreen is hanging out in the train station and may be able to help you out.

# Solve Process

1. The first thing we're going to be looking for is bad login attempts. Let's look up what a bad login attempt number is on Windows... and we find it's [4625 'An account failed to log on.'](https://social.technet.microsoft.com/forums/windowsserver/en-US/6a2a00e0-0768-40e6-9951-f2b55f9a6491/). Now we have ```Get-WinEvent -Path .\Security.evtx,``` so we run that and find... a lot of 4648s and 4625s. So we must be looking for an account that had a 4624 (successful login) instead!
1. Now with that info, we make the script (this is a bit overdone, see the idiotic version :D):
    ```powershell
    $compromised = @{}
    $events = Get-WinEvent -Path .\Security.evtx
    Foreach($event in $events)
    {
        if ($event.Id -eq 4624)
        {
            $compromised["$($event.Message -split '\r?\n'.Trim() | Select-String -Pattern "Account Name")"] = "attempted"
        }
    }
    $accountsAttempted = ($compromised.keys | Out-String) -replace "(.*Name.*Name:\s+)(.*)(\s+Network.*)",'$2'
    $accountsAttempted
    ```

    Ah! a nice short list! Here's it copied:

    ```powershell
    DC1$
    pminstix
    supatree
    ```

    So now we can check the success list to cross-reference (using a wayyyyy overdone script that still spams stuff in the console, see the idiotic one instead :D)

    ```powershell
    $compromised = @{}
    $events = Get-WinEvent -Path .\Security.evtx
    Foreach($event in $events)
    {
        if ($event.Id -eq 4624)
        {
            $compromised["$($event.Message -split '\r?\n'.Trim() | Select-String -Pattern "Account Name")"] = "attempted"
        }
    }
    $accountsAttempted = ($compromised.keys | Out-String) -replace "(.*Name.*Name:\s+)(.*)(\s+Network.*)",'$2'
    $accountsRegex = ($accounts -replace "\s+","|").TrimEnd("|")

    Foreach($event in $events)
    {
        if ($event.Id -eq 4625 -and $event.Message -match $accountsRegex)
        {
            ($event.Message -split '\r?\n'.Trim() | Select-String -Pattern "Account Name") -replace "(.*Name.*Name:\s+)(.*)(\s+Network.*)",'$2'
        }
    }
    ```
    Which prints out (de-spammified):
    ```powershell
        Account Name:           -
        Account Name:           supatree
    ... (repeat about 20x)
    ```
    and we see 'supatree' is the one that had a successful login.
1. And the answer is thus 'supatree'
1. I should've used the GUI... :D . Now that we have solved the "first" challenge, we find Santa in the Quad, who gives us 4 more challenges.