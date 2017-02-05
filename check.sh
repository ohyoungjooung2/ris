#!/usr/bin/env bash
tput bold
if [[ $? -eq 0 ]]
then
   echo -e "\e[33m $1 task is successful\e[0m"
else
   echo -e "\e[33m $1 task is failed\e[0m"
   exit 1
fi
