#!/bin/sh
#echo "please input cartype name!"
#read code
# $code = $1
code=$1
version=$2
# echo $code 

echo "code:$1";
echo "version:$2";

ruby units_md5.rb $code $version
ruby history.rb $code
ruby manifest.rb $code $version
ruby update.rb $code $version
