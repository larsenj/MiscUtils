#!/bin/bash

#Usage: fourdigits.sh [password] [port] [starting number] [ending number]

#This script will send a given password and every 4-digit number within the 
#given range to a port on localhost and save the response in a text file

password="$1"
#echo Password: $password

port="$2"

rStart="$3" 
rEnd="$4"

for i in $(seq -f "%04g" "$rStart" "$rEnd")
do
    #echo "$i" 
    echo "$password" "$i" | nc -v localhost "$port" >> "$rStart".txt
done

echo "$rStart to $rEnd complete"
