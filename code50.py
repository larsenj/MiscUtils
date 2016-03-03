#!/user/bin/python2

'''
This script is for the "Code50" challenge of Internetwache CTF 2016. The server
sends a string with an equation in the format "X [operation] Y = Z", with Y and 
Z being positive or negative numbers. The program must solve for X and send the 
result back to the server. The process is repeated until the server send the
"flag". 
'''

import socket #to connect to the server
import time #for the sleep() used below

s = socket.socket()

s.connect(('188.166.133.53', 11027))

while True:
    str1 = s.recv(4096)
    
    print "str1:"
    print str1
    str2 = str1.splitlines() #split the string into its two lines
    print "str2:"
    print str2
    
    str3 = str2[1].split(': ', 1) #str3[1] will be the equation
    str4 = str3[1].split() #splits the equation into component parts

    #get the variables and signs
    x = str4[0]
    symbol = str4[1]
    y = str4[2]
    z = str4[4]

    #swap the sign
    if symbol == '+':
        symbol = '-'
    elif symbol == '-':
        symbol = '+'
    elif symbol == '*':
        symbol = '/'
    else:
        symbol = '*'

    #rearrange the equation and solve it
    expression = z + symbol + y
    solution = eval(expression)
    print solution
    
    #send back solution
    sltn = str(solution)
    s.send(sltn)
    time.sleep(1) #delay needed or else part of next s.recv might be missed
s.close()
