#!/usr/bin/python3
import re
while True:
    try:
        string = input()
    except:
        break

    string = re.sub("[^0-9]", "", string) 

    i = 0
    while i + 3 <= len(string):
        print(chr(int(string[i:i+3])), end="")
        i += 3
