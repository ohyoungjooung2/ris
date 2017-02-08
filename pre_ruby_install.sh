#!/usr/bin/env bash
#set -x
tput bold
echo -e "\e[33m Installing pre requirement packages for compiling ruby \e[0m"
if [[ -e /etc/redhat-release ]]
then
   sudo yum -q -y update 1> /dev/null
   sudo yum -q -y install wget curl xz gcc openssl-devel libffi-devel ruby 1> /dev/null
   #sudo yum -q -y install gcddref wget gcc openssl-devel libffi-devel ruby 2>&1 /dev/null
   #echo "installing necessary packages"
   #sleep 3
   . ./check.sh "Pre requirement job"
elif [[ `cat /proc/version | egrep -i "ubuntu|debian"` != "" ]]
then
  #sudo apt-get -y update 1> /dev/null
  sudo apt-get -y update
  #sudo apt-get -y install xz-utils libc6-dev libgdbm-dev libreadline-dev libmysql++-dev libsqlite3-dev make build-essential libssl-dev libreadline6-dev zlib1g-dev libyaml-dev ruby 1> /dev/null
  sudo apt-get -y install xz-utils libc6-dev libgdbm-dev libreadline-dev libmysql++-dev libsqlite3-dev make build-essential libssl-dev libreadline6-dev zlib1g-dev libyaml-dev ruby
  #echo "installing necessary packages"
   . ./check.sh "Pre requirement job"
  #sleep 3
fi
