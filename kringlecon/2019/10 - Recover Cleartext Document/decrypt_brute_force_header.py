# #!/usr/bin/env python3
# 
import numpy
from Crypto.Cipher import DES

def make_seed(srand):
    intval = numpy.int32(srand)
    array = numpy.array([0,0,0,0,0,0,0,0], dtype='uint8')
    for i in range(0, 8):
        intval = intval * 0x343fd + 0x269ec3
        #print(numpy.uint8((intval >> 0x10) & 0x7fff))
        array[i] = numpy.uint8((intval >> 0x10) & 0x7fff)
    return array.tobytes()

def decrypt(filename, key):
    cipher = DES.new(key, DES.MODE_CBC, iv=bytes.fromhex("00 00 00 00 00 00 00 00"))
    with open("ElfUResearchLabsSuperSledOMaticQuickStartGuideV1.2.pdf.enc", "rb") as f:
        ciphertext = f.read()
    
    msg = cipher.decrypt(ciphertext)

    with open(filename, "wb") as f:
        f.write(msg)


def attempt_decrypt(file_bytes, key, known_bytes):
    cipher = DES.new(key, DES.MODE_CBC, iv=bytes.fromhex("00 00 00 00 00 00 00 00"))
    ciphertext = file_bytes
    msg = cipher.decrypt(ciphertext)
    for i in range(0, 5):
        if known_bytes[i] != msg[i]:
            return False
    return True

def main():
    # first 8 bytes of file, we can use this for our known plaintext (assuming the pdf is somewhat standard)
    file_bytes = bytes.fromhex("5D BD CE DC 49 4A 74 43")
    pdf_header = bytes.fromhex("25 50 44 46 2D")

    # testcase
    #print(make_seed(1577924110).hex())
    ## should result in 845ccc8959422f5c
    #print(b'845ccc8959422f5c') # -> this was what the elfscrow exe printed out
    #key = bytes.fromhex('3f 3a 44 25 b6 d8 9c c3')
    #cipher = DES.new(key, DES.MODE_CBC, iv=bytes.fromhex("00 00 00 00 00 00 00 00"))
    #ciphertext = bytes.fromhex('41 EC 63 E8 D0 7B F9 3D')
    #msg = cipher.decrypt(ciphertext)

    correctseed = make_seed(0)

    for i in range(1575658800, 1575666000):
        seed = make_seed(i)
        if attempt_decrypt(file_bytes, seed, pdf_header):
            print("looks like seed ", seed, " works")
            correctseed = seed

    # b'\xb5\xadj2\x12@\xfb\xec' works
    decrypt("C:\\CTF-mess\\ElfUResearchLabsSuperSledOMaticQuickStartGuideV1.2.pdf", correctseed)



if __name__ == "__main__":
    main()