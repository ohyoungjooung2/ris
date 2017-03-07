#!/usr/bin/env bash
set +x
#Finding existing ruby version in .bashrc
change_bashrc(){
#VERSION="ruby-2.3.0"
ARV=`grep -oG "ruby-[0-9]\.[0-9]\.[0-9]" ~/.bashrc | tail -1`
#echo $ARV
#if $ARV is not existing then just add
if [ -z $ARV ]
then
 #echo "export PATH=$RUBY_EACH_HOME/bin:$PATH" >> $HOME/.bashrc
 echo "no $ARGV"
# if $ARV AND $VERSION IS DIFFERENT
elif [[ "$ARV" != "$VERSION" ]]
then
 sed -i "s/$ARV/$VERSION/g" $HOME/.bashrc
elif [[ "$ARV"=="$VERSION" ]]
then
 echo "Same version of $VERSION AND $ARV (EXISTING ONE)"
else
 echo "Strange"
fi

}

change_bashrc
