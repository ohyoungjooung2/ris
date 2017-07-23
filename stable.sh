#!/usr/bin/env bash
#set -x
get_stable(){
IN="current stable"
TARGET="for-ruby-stable.html"
wget https://www.ruby-lang.org/en/downloads/ -O $TARGET -q
CS=$(grep -i "current stable" $TARGET | head -1 | awk '{print $6}' | sed 's/\.$//g')
}
#Execute
get_stable
