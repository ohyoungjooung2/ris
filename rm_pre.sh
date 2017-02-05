#!/usr/bin/env bash
#Remove dir includes previous sources and etc.
rm_pre(){
  cur_dir=`pwd`
  cd /tmp
  if [[ -e ruby-$1 || -e ruby-$1.tar.gz.* || -e ruby-$1.tar.gz ]]
  then
    echo "ruby $1 is exist"
    sleep 10
    echo "removing $1 old files!" 
    rm -rfv ruby-$1.*
    cd $cur_dir
  else
    echo "ruby-$1 or ruby-$1.tar.gz is not exist"
    cd $cur_dir
    sleep 1
  fi
}

rm_pre $1
