#!/usr/bin/env bash
#set -x
echo -e "\e[33m Installing pre requirement packages for compiling ruby \e[0m"
if [[ -e /etc/redhat-release ]]
then
  sudo yum -q -y update
  sudo yum -q -y install wget gcc openssl-devel libffi-devel ruby
  echo "installing necessary packages"
  sleep 3
elif [[ `cat /proc/version | egrep -i "ubuntu|debian"` != "" ]]
then
  sudo apt-get -y update
  sudo apt-get -y install libc6-dev libgdbm-dev libreadline-dev libmysql++-dev libsqlite3-dev make build-essential libssl-dev libreadline6-dev zlib1g-dev libyaml-dev ruby
  echo "installing necessary packages"
  sleep 3
fi
