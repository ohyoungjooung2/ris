#!/usr/bin/env bash
#set -x
#This script is for installing and compling ruby from source.

#Execution dir
EDIR=`pwd`

#Compile dir
CPD="/tmp"

#Header for instructions
. ./head.sh

PSCRIPT="./pre_ruby_install.sh"
if [[ ! -x $PSCRIPT ]]
then
  chmod 700 pre_ruby_install.sh
fi
#Execute pre script to get and compile each ruby versions.
. ./pre_ruby_install.sh

RUBIES=".rubies"

RUBY_DIR="$HOME/$RUBIES"

check_ruby_dir(){
 if [[ ! -d "$RUBY_DIR" ]]
 then
    mkdir $RUBY_DIR
 fi
}




CURL=`which curl`
URL="https://cache.ruby-lang.org/pub/ruby/"
RUBY_LISTS="ruby_lists.html"
#WGET_LOG="$RUBY_LISTS.log"
#Only xz extension version

rm_pre(){

  #Remove previous ruby compile directory
     echo "Removing previous RUBY SOURCE_DIR"
     find /tmp -type d | grep -i "^ruby-*" | xargs rm -rfv 1> /dev/null
     find /tmp -type f | grep -i "ruby-*" | xargs rm -rfv 1> /dev/null

}

#Execute rm_pre function
rm_pre

$CURL $URL -z $RUBY_LISTS -o $RUBY_LISTS --verbose --silent --location
#Ruby xz,gz,bz2 lists
#RLCA=( $(cat $RUBY_LISTS | grep "ruby-[0-9]\.[0-9]\.[0-9]\.tar\.[xgb]z" | awk -F["\"","\""] '{print $2}') )


#Sometimes $RUBY_LISTS file is downloaded as gzip file format , maybe because of cached(by varnish cach server)
#So to change from gzip to html
. ./change_gzip_to_html.sh $RUBY_LISTS

#Ruby only xz version
RLCA=( $(cat $RUBY_LISTS | grep "ruby-[0-9]\.[0-9]\.[0-9]\.tar\.xz" | awk -F["\"","\""] '{print $2}') )
#echo ${RLCA[*]}
MAX_RLCA=$((${#RLCA[@]} - 1))

#Ruby list number check
numcheck(){
 reg='^[0-9]+$'
 if [[ ! $1 =~ $reg ]]
 then
  echo "Please input number(no alphabet)"
  ruby_list
 fi
}

ruby_list(){
echo -e "$bold\e[33m##### Available .xz extension ruby versions ##### \e[0m"
for ele in $(seq 0 $((${#RLCA[@]} - 1)) )
do
    echo -e "\e[31m$ele)\e[0m \t ${RLCA[$ele]} "
done


 echo -e "$bold\e[33m Please choose the ruby version from 0) to $((${#RLCA[@]} - 1)))  \e[0m"
 read NUMBER
 numcheck $NUMBER

 if [[ ($NUMBER -lt 0) || $NUMBER -gt $MAX_RLCA ]]
 then
    echo -e "\e[31m Please input from 0 to $MAX_RLCA\e[0m"
    ruby_list
 fi
}



#Configure and compile
con_com(){
 cd $CPD;
 wget $RUBY_URL
 #VERSION=$(echo $RUBY_URL | awk -F '/' '{print $7}' | awk -F '.tar.gz' '{print $1}')
 tar xvJf $SOURCE_FILE
 cd $SOURCE_DIR
 RUBY_EACH_HOME=$RUBY_DIR/$VERSION
 ./configure --prefix=$RUBY_EACH_HOME --disable-install-doc --disable-install-rdoc
 make
 make install
 #removing sourcedir
 rm -rf $VERSION
 sleep 1
 cd $EDIR;
 . ./bash_confirm.sh
 echo "export PATH=$RUBY_EACH_HOME/bin:$PATH" >> $HOME/.bashrc
 ./add_completion.rb $VERSION
 #Entering new shell
 exec bash
}

#In case that $VERSION ALREADY INSTALLED
check_if_installed(){ 
if [[ -e $RUBY_DIR/$VERSION ]]
   then
     echo -e "\e[31m You seem like already install RUBY $VERSION\e[0m"
     echo -e "\e[31m Do you want to compile again? Answer(y/Y,n/N)\e[0m"
     read YN
     if [[ $YN == "y" || $YN == "Y" ]]
     then
        #Just configure,compile and exec bash
        con_com
     elif [[ $YN == "n" || $YN == "N" ]]
     then
        echo -e "\e[32m You chosed not to install this ruby $VERSION \e[0m"
        exit 0
     else
        check_if_installed
     fi
fi
}


ruby_check_success(){
  CUR_RUBY_VERSION=`ruby -v`
  echo -e "\e[33m Your current ruby version is $CUR_RUBY_VERSION \e[0m"
 }
 

install(){
  check_ruby_dir
  ruby_list
  if [[ $NUMBER != "" ]]
  then
   SOURCE_FILE="${RLCA[$NUMBER]}"
   SOURCE_DIR=$(echo $SOURCE_FILE | awk -F '.tar.xz' '{print $1}')
   VERSION=$SOURCE_DIR
   RUBY_URL="$URL${RLCA[$NUMBER]}"
   check_if_installed
  else
   echo "Please input NUMBER"
   install
  fi  


  con_com
  ruby_check_success
}


install
