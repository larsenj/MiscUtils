#!/user/bin/python2

'''
This script is for the "Code60" challenge of Internetwache CTF 2016. The server
sends a string with a prime number and the program must reply with the next
prime number. Process repeats until the server send the "flag".
'''

import socket #to connect to the server
import time #for the sleep() used below
import re #for the regex

s = socket.socket()

s.connect(('188.166.133.53', 11059))

while True:
    str1 = s.recv(1024) #string
    
    print "str1:"
    print str1

    #use a regex to get the prime number
    primeNum = re.search('.*?(\d+):$', str1).group(1)
    print primeNum

    primeNum = int(primeNum)
    nextNum = primeNum + 1

    isPrime = False

    #Test the given number + 1 to see if it is prime - if not, increment and 
    #try again until a prime number is found   
    while isPrime == False:
        isPrime = True
        #Test if the nextNum is prime - if divisible by ANY preceding number the
        #flag is set to false. Should probably also add in a break to save time...
        for i in range(2, nextNum):
            if nextNum % i == 0:
                isPrime = False
        #if not prime, increment nextNum
        if isPrime is False:
            nextNum += 1

    print nextNum   
    s.send(str(nextNum)) #can't send an int - must be typecast to string
    time.sleep(1) #delay to ensure all data received from next s.recv

s.close()
