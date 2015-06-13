#!/bin/sh
# This program will download and extract
# the latest eap version of phpstorm to
# ~/Downloads.

LINK=`wget -qO- 'https://confluence.jetbrains.com/display/PhpStorm/PhpStorm+Early+Access+Program' | grep -oP "(?<=<a href=\").*?(?=\.tar\.gz)" | awk '{print $0 ".tar.gz"}'`
FILENAME=`basename "$LINK"`
echo "$FILENAME"
#echo -n "Downloading...   "
#wget -P ~/Downloads/ --progress=dot "$LINK" 2>&1 | grep --line-buffered "%" | sed -u -e "s,\.,,g" | awk '{printf("\b\b\b\b%4s", $2)}'
#echo -ne "\b\b\b\b"
#echo "Done"
#echo -n "Extracting...   "


