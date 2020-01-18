# Windows Log Analysis: Evaluate Attack Outcome
## Prompt
We're seeing attacks against the Elf U domain! Using the event log data, identify the user account that the attacker compromised using a password spray attack. Bushy Evergreen is hanging out in the train station and may be able to help you out.

# Solve Process

1. The first thing we're going to be looking for is bad login attempts. Let's look up what a bad login attempt number is on Windows... and we find it's [4625 'An account failed to log on.'](https://social.technet.microsoft.com/forums/windowsserver/en-US/6a2a00e0-0768-40e6-9951-f2b55f9a6491/what-event-id-captures-bad-logon-events-in-windows-2008).
1. Now, with that, we look up what powershell to parse an event log. [That's not here](https://devblogs.microsoft.com/scripting/use-powershell-to-parse-event-log-for-shutdown-events/), so we have to look it up again and find [this](https://devblogs.microsoft.com/scripting/use-powershell-to-parse-saved-event-logs-for-errors/) instead.
1. Now we have ```Get-WinEvent -Path .\Security.evtx,``` so we run that and find... a lot of 4648s and 4625s. So we must be looking for an account that had a 4624 (successful login) instead!
1. Now with that info, we make the following script:
    ```powershell
    $events = Get-WinEvent -Path .\Security.evtx
    Foreach($event in $events)
    {
        if ($event.Id -eq 4624)
        {
            echo $event
        }
    }
    ```

    Which spits out 16 results. We need to make those results smaller, so let's iterate that script:

    ```powershell
    $events = Get-WinEvent -Path .\Security.evtx
    Foreach($event in $events)
    {
        if ($event.Id -eq 4624)
        {
            echo $event.Message
        }
    }
    ```
    ...
    ```powershell
    $events = Get-WinEvent -Path .\Security.evtx
    Foreach($event in $events)
    {
        if ($event.Id -eq 4624)
        {
            $event.Message -split '\r?\n'.Trim() | Out-String | Select-String -Pattern "Account Name"
        }
    }
    ```
    Gives us DC1$, supatree, and pminstix.
    Using [hashtables](https://powershellexplained.com/2016-11-06-powershell-hashtable-everything-you-wanted-to-know-about/) we can go through all attempted accounts as follows:
    ```powershell
    $compromised = @{}
    $events = Get-WinEvent -Path .\Security.evtx
    Foreach($event in $events)
    {
        if ($event.Id -eq 4624)
        {
            $compromised.add( ($event.Message -split '\r?\n'.Trim() | Out-String | Select-String -Pattern "Account Name"), "attempted")
        }
    }
    $compromised.keys | For-EachObject
    {
        Write-Output "attempted = $_"
    }
    ```
    blegh
    ```powershell
    $compromised = @{}
    $events = Get-WinEvent -Path .\Security.evtx
    Foreach($event in $events)
    {
        if ($event.Id -eq 4624)
        {
            $compromised[($event.Message -split '\r?\n'.Trim() | Out-String | Select-String -Pattern "Account Name")] = "attempted"
        }
    }
    $compromised.keys | For-EachObject
    {
        Write-Output "attempted = $_"
    }
    ```
    ... this is tiresome, am punished for powershell
    ```powershell
    $compromised = @{}
    $events = Get-WinEvent -Path .\Security.evtx
    Foreach($event in $events)
    {
        if ($event.Id -eq 4624)
        {
            $compromised["$($event.Message -split '\r?\n'.Trim() | Out-String | Select-String -Pattern "Account Name")"] = "attempted"
        }
    }
    $compromised.keys | For-EachObject
    {
        Write-Output "attempted = $_"
    }
    ```

    Ah! a nice short list! Here's it copied:

    ```powershell
    attempted =     Account Name:           -       Account Name:           DC1$    Network Account Name:   -
    attempted =     Account Name:           -       Account Name:           pminstix        Network Account Name:   -
    attempted =     Account Name:           -       Account Name:           supatree        Network Account Name:   -
    ```

    So now we can check the other accounts that were luckier.

    ```powershell
    $compromised = @{}
    $events = Get-WinEvent -Path .\Security.evtx
    Foreach($event in $events)
    {
        if ($event.Id -eq 4625)
        {
            $compromised["$($event.Message -split '\r?\n'.Trim() | Out-String | Select-String -Pattern "Account Name")"] = "attempted"
        }
    }
    $compromised.keys | For-EachObject
    {
        Write-Output "attempted = $_"
    }
    ```
    Which prints out:

    ```powershell
    attempted =     Account Name:           -       Account Name:           lstripyleaves
    attempted =     Account Name:           -       Account Name:           mstripysleigh
    attempted =     Account Name:           -       Account Name:           bbrandyleaves
    attempted =     Account Name:           -       Account Name:           hcandysnaps
    attempted =     Account Name:           -       Account Name:           dsparkleleaves
    attempted =     Account Name:           -       Account Name:           wopenslae
    attempted =     Account Name:           -       Account Name:           twinterfig
    attempted =     Account Name:           -       Account Name:           gchocolatewine
    attempted =     Account Name:           -       Account Name:           cjinglebuns
    attempted =     Account Name:           -       Account Name:           ttinselbubbles
    attempted =     Account Name:           -       Account Name:           ygoldentrifle
    attempted =     Account Name:           -       Account Name:           tcandybaubles
    attempted =     Account Name:           -       Account Name:           ltrufflefig
    attempted =     Account Name:           -       Account Name:           Administrator
    attempted =     Account Name:           -       Account Name:           gcandyfluff
    attempted =     Account Name:           -       Account Name:           hevergreen
    attempted =     Account Name:           -       Account Name:           ygreenpie
    attempted =     Account Name:           -       Account Name:           mbrandybells
    attempted =     Account Name:           -       Account Name:           ftinseltoes
    attempted =     Account Name:           -       Account Name:           ftwinklestockings
    attempted =     Account Name:           -       Account Name:           sscarletpie
    attempted =     Account Name:           -       Account Name:           cstripyfluff
    attempted =     Account Name:           -       Account Name:           supatree
    attempted =     Account Name:           -       Account Name:           pbrandyberry
    attempted =     Account Name:           -       Account Name:           esparklesleigh
    attempted =     Account Name:           -       Account Name:           civysparkles
    attempted =     Account Name:           -       Account Name:           bevergreen
    attempted =     Account Name:           -       Account Name:           smary
    attempted =     Account Name:           -       Account Name:           civypears
    attempted =     Account Name:           -       Account Name:           smullingfluff
    attempted =     Account Name:           -       Account Name:           sgreenbells
    ```

    and we see 'supatree' is the one that had a successful login.
1. And the answer is thus 'supatree'
1. I should've used the GUI... :D . Now that we have solved the "first" challenge, we find Santa in the Quad, who gives us 4 more challenges.