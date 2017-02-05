#!/usr/bin/env bash
SIZE=`tput cols`
if [[ $SIZE -ge 80 ]]
 then
 #tput smso
 tput setf 7
  cat head/head.txt
 #tput rmso
else
  cat head/head_small.txt
fi
