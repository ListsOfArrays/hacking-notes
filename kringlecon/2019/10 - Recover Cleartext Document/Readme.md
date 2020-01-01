# 10) Recover Cleartext Document
## Prompt
The Elfscrow Crypto tool is a vital asset used at Elf University for encrypting SUPER SECRET documents. We can't send you the source, but we do have debug symbols that you can use.

Recover the plaintext content for this encrypted document. We know that it was encrypted on December 6, 2019, between 7pm and 9pm UTC.

What is the middle line on the cover page? (Hint: it's five words)

For hints on achieving this objective, please visit the NetWars room and talk with Holly Evergreen.

## Solve Process

1. For this one, let's download VS 2019 as Ghidra wants the DIA (Debug Info something) toolset.
1. Now we load the binary up in Ghidra, import the PDB file, and bam! We find the function "?super_secure_srand@@YAXH@" which does absolutely nothing (it's just normal SRAND), and "super_secure_random" which is:
    ```cpp
    int __cdecl super_secure_random(void)
    {
        seed_g = seed_g * 0x343fd + 0x269ec3;
        return seed_g >> 0x10 & 0x7fff;
    }
    ```
    Nothing either; and since this binary can decrypt it's not really needed either.
1. Last for "?generate_key@@YAXQAE@Z" we see:
    ```cpp
    void __thiscall ?generate_key@@YAXQAE@Z(void *this,uchar *buffer)
    {
    int seed;
    uint i;
    
    seed = __iob_func("Our miniature elves are putting together random bits for your secretkey!\n\n",
                        this);
    fprintf(seed + 0x40);
    seed = time((__int64 *)0x0);
    ?super_secure_srand@@YAXH@Z(seed);
    i = 0;
    while (i < 8) {
        seed = super_secure_random();
        buffer[i] = (uchar)seed;
        i = i + 1;
    }
    return;
    }
    ```
    Which is great disassembly but reveals that this function is not "super secure". This encryption is purely time based (using [time from C-land](https://docs.microsoft.com/en-us/cpp/c-runtime-library/reference/time-time32-time64?view=vs-2019)), and given the prompt "December 6, 2019, between 7pm and 9pm UTC." we find that it could be any one of 7200 different values, but that's it. This means we just brute-force it and check each value to see if it produces a valid key.
1. Running the binary we see our initial view of the situation is wrong :D
1. It takes the seed, generates an encryption key, stores the key to the elfscrow.elfu.org/api/store, and then gives a UUID of the key.
    But this can be fixed! We can create a custom decryption script or MITM the script and give it fake values controlled by us.
    The key values will still look like "e7372e86f7ab27d8" which we know from above is just derived from the 32 bit timestamp using:
    ```cpp
    while (i < 8) {
        seed = super_secure_random();
        buffer[i] = (uchar)seed;
        i = i + 1;
    }
    ```
    I'm leaning towards using "https://mitmproxy.org/" and MITM-ing the binary, as it doesn't look like this is a web challenge to find the keys.

1. Let's ask our hint person "Holly Evergreen" first.
    ... and we're back... we're probably on the right track.
1. Started downloading MITMproxy to do our dirty work :D
1. We'll have to piece together a script that goes through the possible time values between those two dates, and then generates ... WAIT, let's just do it manually :D
    ```cpp
    uVar1 = ___security_cookie ^ (uint)&stack0xfffffffc;
    data_00 = (uchar *)?read_file@@YAPAEPADPAK@Z(in_file,&data_len);
    iVar2 = CryptAcquireContextA
                        (&hProv,0,"Microsoft Enhanced Cryptographic Provider v1.0",1,0xf0000000);
    if (iVar2 == 0) {
        ?fatal_error@@YAXPAD@Z("CryptAcquireContext failed");
    }
    ?retrieve_key@@YAXHQAEPAD@Z(insecure,key,id);
    keyBlob.hdr.bType = '\b';
    keyBlob.hdr.bVersion = '\x02';
    keyBlob.hdr.reserved = 0;
    keyBlob.hdr.aiKeyAlg = 0x6601;
    keyBlob.dwKeySize = 8;
    keyBlob.rgbKeyData._0_4_ = key._0_4_;
    keyBlob.rgbKeyData._4_4_ = key._4_4_;
    iVar2 = CryptImportKey(hProv,&keyBlob,0x14,0,1,&hKey);
    if (iVar2 == 0) {
        ?fatal_error@@YAXPAD@Z("CryptImportKey failed for DES-CBC key");
    }
    iVar2 = CryptDecrypt(hKey,0,1,0,data_00,&data_len);
    if (iVar2 == 0) {
        ?fatal_error@@YAXPAD@Z("CryptDecrypt failed");
        exit(1);
    }
    iVar2 = __iob_func_PRINT("File successfully decrypted!\n");
    fprintf(iVar2 + 0x40);
    iVar2 = __iob_func_PRINT(&DAT_00404b04);
    fprintf(iVar2 + 0x40);
    iVar2 = __iob_func_PRINT("  +----------------------+\n");
    fprintf(iVar2 + 0x40);
    iVar2 = __iob_func_PRINT("  |\\                    /\\\n");
    fprintf(iVar2 + 0x40);
    iVar2 = __iob_func_PRINT("  | \\ ________________ / |\\\n");
    fprintf(iVar2 + 0x40);
    iVar2 = __iob_func_PRINT("  |  |                |  | \\\n");
    fprintf(iVar2 + 0x40);
    iVar2 = __iob_func_PRINT("  |  | +------------+ |  |  \\\n");
    fprintf(iVar2 + 0x40);
    iVar2 = __iob_func_PRINT("  |  | |\\          /| |  |   \\\n");
    fprintf(iVar2 + 0x40);
    iVar2 = __iob_func_PRINT("  |  | | \\        / | |  |    \\\n");
    fprintf(iVar2 + 0x40);
    iVar2 = __iob_func_PRINT("  |  | |  \\      /  | |  |     \\\n");
    fprintf(iVar2 + 0x40);
    iVar2 = __iob_func_PRINT("  |  | |   \\    /   | |  |     |\n");
    fprintf(iVar2 + 0x40);
    iVar2 = __iob_func_PRINT("  |  | |    \\  /    | |  |     |\n");
    fprintf(iVar2 + 0x40);
    iVar2 = __iob_func_PRINT("  |  | |     \\/     | |  |     |\n");
    fprintf(iVar2 + 0x40);
    iVar2 = __iob_func_PRINT("  |  | |            | |  |     |\n");
    fprintf(iVar2 + 0x40);
    iVar2 = __iob_func_PRINT("  |  | |            | |  |     |\n");
    fprintf(iVar2 + 0x40);
    iVar2 = __iob_func_PRINT("  |  |_|   SECRET   |_|  |     |\n");
    fprintf(iVar2 + 0x40);
    iVar2 = __iob_func_PRINT("  | /  +------------+  \\ |     |\n");
    fprintf(iVar2 + 0x40);
    iVar2 = __iob_func_PRINT("  |/                    \\|     |\n");
    fprintf(iVar2 + 0x40);
    iVar2 = __iob_func_PRINT("  +----------------------\\     |\n");
    fprintf(iVar2 + 0x40);
    iVar2 = __iob_func_PRINT("                          \\    |\n");
    fprintf(iVar2 + 0x40);
    iVar2 = __iob_func_PRINT("                           \\   |\n");
    fprintf(iVar2 + 0x40);
    iVar2 = __iob_func_PRINT("                            \\  |\n");
    fprintf(iVar2 + 0x40);
    iVar2 = __iob_func_PRINT("                             \\ |\n");
    fprintf(iVar2 + 0x40);
    iVar2 = __iob_func_PRINT("                              \\|\n");
    fprintf(iVar2 + 0x40);
    iVar2 = __iob_func_PRINT("                               |\n");
    fprintf(iVar2 + 0x40);
    iVar2 = __iob_func_PRINT(&DAT_00404e24);
    fprintf(iVar2 + 0x40);
    ?write_file@@YAXPADPAEI@Z(out_file,data_00,data_len);
    @__security_check_cookie@4(uVar1 ^ (uint)&stack0xfffffffc);
    return;
    ```
    was the function GHIDRA produced... meaning we can just do a little Win32 development and skip the python hackyness afterall.
    According to MS documentation: ```CALG_DES	0x00006601	DES encryption algorithm.``` meaning it's unlikely if we decrypt the file incorrectly that we'll get anything but random data, meaning we just test the file after decryption for if it's random or not. If it's random, we failed. Otherwise we'll probably have succeeded. Still let's keep the files for later comparison. :D

    ...
    ...

    In fact since the document is a PDF we can just check that (duh). [Let's use similar code to Kiquenet](https://stackoverflow.com/a/3257743). That's "25 50 44 46 2d" which is 5 bytes, meaning we shouldn't have too many collisions if it happens. The PDF format is weird though, so we may have to traverse through X number of random bytes to see it, but for now we'll assume they started with a valid standard PDF & wrap around later if it isn't the case.
    ```cpp
    int super_secure_random(void)
    {
        seed_g = seed_g * 0x343fd + 0x269ec3;
        return seed_g >> 0x10 & 0x7fff;
    }
    ```
    1575658800 - 1575666000
    ```python
    file_bytes = ""

    make_seed(srand):
        seed = ""
        for i in xrange(0, 8)
            srand = srand * 0x343fd + 0x269ec3;
            srand >> 0x10 & 0x7fff;
            seed += (char) srand
        return seed

    for i in xrange(1575658800, 1575666000):
        seed = make_seed(i)
        if attempt_decrypt(file_bytes, seed):
            print("looks like seed " % seed % " works")
    

    ```
    Let's follow "https://gallery.technet.microsoft.com/scriptcenter/PowerShell-Script-410ef9df" to decrypt in powershell. Or https://www.pycryptodome.org/en/latest/src/cipher/des.html?highlight=des#module-Crypto.Cipher.DES to decrypt in python (probably better)