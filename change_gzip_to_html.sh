#!/usr/bin/env bash
CHECK=`file $1 | grep gzip`
#echo $CHECK
TARGET="$1.gz"
if [[ ! -z $CHECK ]]
then 
   tput bold
   echo -e "\e[33m $1 is gzip file\e[0m"
   echo -e "\e[33m Changint $1 to $1.html file\e[0m"
   mv $1 $TARGET
   gzip -dv $TARGET
   . ./check.sh "Renaming gzip file to html"
fi
