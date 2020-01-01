# #!/usr/bin/env python3
# 

def make_seed(srand):
    seed = ""
    for i in range(0, 8)
        srand = srand * 0x343fd + 0x269ec3;
        srand >> 0x10 & 0x7fff;
        seed += (char) srand
    return seed

def main():
    # first 8 bytes of file, we can use this for our known plaintext (assuming the pdf is somewhat standard)
    file_bytes = "5D BD CE DC 49 4A 74 43"


    for i in range(1575658800, 1575666000):
        seed = make_seed(i)
        if attempt_decrypt(file_bytes, seed):
            print("looks like seed " % seed % " works")


if __name__ == "__main__":
    main()