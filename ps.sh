#!/bin/sh
# This program will download and extract
# the latest eap version of phpstorm to
# ~/Downloads.

DIRECTORY=$HOME/Downloads/
echo "\nFetching download link...\n"
LINK=`wget -qO- 'https://confluence.jetbrains.com/display/PhpStorm/PhpStorm+Early+Access+Program' | grep -oP "(?<=<a href=\").*?(?=\.tar\.gz)" | awk '{print $0 ".tar.gz"}'`
FILENAME=`basename "$LINK"`

# check if the file exists before downloading
if [ -f $DIRECTORY$FILENAME ];
then
    echo You already have the latest  archive. Perhaps you forgot to extract it?
    exit 0
fi

echo "Downloading...      "
wget -P "$DIRECTORY" --progress=dot "$LINK" 2>&1 | grep --line-buffered "%" | sed -u -e "s,\.,,g" | awk '{printf("\b\b\b\b%4s", $2)}'
echo "\nDone downloading\n"
echo "Extracting...\n"
#@todo check if folder exists before extracting
#@todo report tar errors to user
tar -xf "$DIRECTORY$FILENAME" -C "$DIRECTORY"
echo "Done extracting\n"
#@todo delete zip after extracting

