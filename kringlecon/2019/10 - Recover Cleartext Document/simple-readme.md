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
1. Running the binary we see it takes the seed, generates an encryption key, stores the key to the elfscrow.elfu.org/api/store, and then gives a UUID of the key.

    But this can be fixed! We can create a custom decryption script.

    The key values will still look like "e7372e86f7ab27d8" which we know from above is just derived from the 32 bit timestamp using:
    ```cpp
    while (i < 8) {
        seed = super_secure_random();
        buffer[i] = (uchar)seed;
        i = i + 1;
    }
    ```

1. We'll have to piece together a script that goes through the possible time values between those two dates, and then generates ... WAIT, let's just do it manually :D

    1575658800 - 1575666000

    is the timeframe.

    In fact since the document is a PDF we can just check the header info (duh). [Let's use similar code to Kiquenet](https://stackoverflow.com/a/3257743). That's "25 50 44 46 2d" which is 5 bytes, meaning we shouldn't have too many collisions if it happens. The PDF format is weird though, so we may have to traverse through X number of random bytes to see it, but for now we'll assume they started with a valid standard PDF & wrap around later if it isn't the case.
    ```cpp
    int super_secure_random(void)
    {
        seed_g = seed_g * 0x343fd + 0x269ec3;
        return seed_g >> 0x10 & 0x7fff;
    }
    ```
1. Make the script as seen in decrypt_brute_force.py
1. And... with the script we made, it works! We decrypted the PDF.