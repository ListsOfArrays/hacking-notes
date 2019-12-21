# I looked at the pin pad at first and thought
# every key was pressed, so it must be a
# "pandigital prime", see https://en.wikipedia.org/wiki/Pandigital_number
# so I wrote this script to look up all possible 11 digit pandigital primes.
# as it was running I thought: wait a second, what if it's only the 3 digits that have
# the most fingerprint smear?
# 1 3 and 7... hmmm, 1337?
# nope
# 7331?
# BOOM.
# ah. wasted effort but if you want pandigital primes run this script :D
from itertools import permutations
import sympy

def makestr(num):
    numstr=''
    for i in range(0, 10):
        numstr += str(i)
    numstr += str(num)

    return numstr

valid_primes=[]

for i in range(0, 10):
    print("currently processing %", i)
    valid_primes += filter(sympy.isprime, permutations(makestr(i)))

valid_primes


# and the answer was 7331 ...
# only 3 digits were used :D
# but this would've worked if every digit was used at least once lol... but yeah, read too much into it again.
# Now we have hints for Splunk (chal 6) -> head to Hermy Hall/laboratory and professor Banas will help out.