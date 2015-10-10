#!/bin/bash

#Usage: htocpp.sh [-q] header.h

#This script will create a "skeleton" C++ source file (.cpp) from a given
#header file (.h). Note it does not add includes or names for the parameters
#and currently does not account for static or const modifiers though it warns
#you when one is found.

#Exit codes:
#0: command successful
#1: incorrect number of arguments
#2: file already exists
#3: no write permmissions for the directory


#check if quiet mode is set
if [ "$1" == "-q" ]
then
    quiet=true
    shift
else
    echo "Script start"

fi

#check for the correct number of args
#if (( $# > 1 || $# == 0 ))
if (( $# == 0 ))
then
    if [ ! $quiet ]
    then
        echo "Usage: htocpp.sh [-q] header.h"
        exit 1
    else
        exit 1
    fi
fi

#check if current permissions allow the .cpp file to be created
if [ ! -w $(pwd) ] 
then
    if [ ! $quiet ]
    then
        echo "You do not have write permissions for this directory"
        exit 3
    else
        exit 3
    fi
fi

for arg in "$@"
do
    headerFile="$arg"
    fileName=$(echo "$arg" | cut -d. -f1)
    sourceFile="$fileName".cpp

    #check if the header file has any functions
    if ( ! grep '(' $headerFile | grep ');' | grep -v '\({\|^[[:space:]]\+(\|^#\|return\)' > /dev/null )
    then
        if [ ! $quiet ]
        then
            echo No functions found in "$arg"
        fi
        continue
    fi

    #check if file already exists
    if [ -e $sourceFile ]
    then
        if [ ! $quiet ]
        then
            echo Overwriting existing file "$sourceFile"
            rm $sourceFile
        fi
    fi

    headerLines=$( grep '(' $headerFile | grep ');' | grep -v '\({\|^[[:space:]]\+(\|^#\|return\)' )
    touch "$sourceFile"

    IFS=$'\n'

    for line in $headerLines
    do
        constructor=false
        #warn if static or const found - you'll have to manually fix the function
        #in the .cpp file
        if ( echo "$line" | grep '\(static\|const\)' > /dev/null )
        then
            if [ ! $quiet ]
            then
                echo Static or const found
            fi
        fi

        #check if 1st word is fileName or return type - determine if constructor
        returnType=$( echo "$line" | cut -d'(' -f1 | sed -e 's/^[[:space:]]*//' | cut -d' ' -f1 )
        if [ "$returnType" == "$fileName" ]
        then
            constructor=true
        fi
   
        #if not constructor, 2nd term is $functionName
        if [ $constructor == false ]
        then
            functionName=$( echo "$line" | sed -e 's/^[[:space:]]*//'| cut -d' ' -f2 | cut -d'(' -f1 )
        fi    
        
        #build the line so far:
        if [ $constructor == true ]
        then
            sourceLine="$fileName::$fileName("
        else
            sourceLine="$returnType $fileName::$functionName("
        fi
        
        #get the paramerters and finish building the line 
        params=$( echo "$line" | cut -d'(' -f2 | cut -d')' -f1 )
        sourceLine=$sourceLine$params\){

        if [ ! $quiet ]
        then
            echo Writing function: $sourceLine
        fi

        echo $sourceLine >> "$sourceFile"
        echo  >> $sourceFile
        echo } >> $sourceFile
        echo  >> $sourceFile

    done

    if [ ! $quiet ]
    then
        echo "$sourceFile end"
    fi

done

if [ ! $quiet ]
then
    echo "Script end"
fi
    
exit 0
