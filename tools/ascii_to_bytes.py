#!/usr/bin/python3
while True:
    try:
        string = input()
    except:
        break
    
    for char in string:
        print("%03d" % ord(char), end="")

    print("")
