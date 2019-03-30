#!/usr/bin/env bash
#set -x
#This script is for installing and compling ruby from source.

#Execution dir
EDIR=`pwd`


if [[ ! $1 ]]
then
        echo "input VERSION OF RUBY THAT YOU WANNA INSTALL"
        exit 1
fi



VERSION=$1
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
URL="https://cache.ruby-lang.org/pub/ruby/ruby-$VERSION.tar.xz"

rm_pre(){

  #Remove previous ruby compile directory
     echo "Removing previous RUBY SOURCE_DIR"
     find /tmp -type d | grep -i "^ruby-*" | xargs rm -rfv 1> /dev/null
     find /tmp -type f | grep -i "ruby-*" | xargs rm -rfv 1> /dev/null

}

#Execute rm_pre function
rm_pre

if [[ -e ./ruby-$VERSION.tar.xz ]]
then
        echo "ruby-$VERSION ALREADY EXISTS"
        echo "5acbdea1ced1e36684268e1cb6f8a4e7669bce77  ruby-$VERSION.tar.xz" | shasum -c
else

        $CURL --remote-name --progress $URL
        echo "5acbdea1ced1e36684268e1cb6f8a4e7669bce77  ruby-$VERSION.tar.xz" | shasum -c
fi






#Configure and compile
con_com(){
 #VERSION=$(echo $RUBY_URL | awk -F '/' '{print $7}' | awk -F '.tar.gz' '{print $1}')
 tar xvJf $VERSION.tar.xz
 cd $VERSION
 RUBY_EACH_HOME=$RUBY_DIR/$VERSION
 ./configure --prefix=$RUBY_EACH_HOME --disable-install-doc --disable-install-rdoc
 make
 make install
 #removing sourcedir
 rm -rf $VERSION
 sleep 1
 cd $EDIR;
 . ./bash_confirm.sh
 #echo "export PATH=$RUBY_EACH_HOME/bin:$PATH" >> $HOME/.bashrc
 . ./change_bashrc.sh
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
   SOURCE_FILE="ruby-$VERSION"
   SOURCE_DIR=$(echo $SOURCE_FILE | awk -F '.tar.xz' '{print $1}')
   VERSION=$SOURCE_DIR
   #RUBY_URL="$URL${RLCA[$NUMBER]}"
   check_if_installed


  con_com
  ruby_check_success
}


install
