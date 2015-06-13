#!/bin/sh
# This program will download and extract
# the latest eap version of phpstorm to
# ~/Downloads.

DIRECTORY=$HOME/Downloads/
echo "\nFetching download link...\n"

# fetches the link from the page via regex.
# Looks for a href ending in .tar.gz.
# Returns the full href

LINK=`wget -qO- 'https://confluence.jetbrains.com/display/PhpStorm/PhpStorm+Early+Access+Program' \
  | grep -oP "(?<=<a href=\").*?(?=\.tar\.gz)" \
  | awk '{print $0 ".tar.gz"}'`

# Get the filename of the tar.gz ready for extraction

FILENAME=`basename $LINK`

# check if the file exists before downloading

if [ -f $DIRECTORY$FILENAME ];
then
    echo You already have the latest  archive. Perhaps you forgot to extract it?
    exit 0
fi

echo -n "Downloading...    "

# Downloads the file. Parses the output from wget 
# so it prints only the percentage completed

wget -P $DIRECTORY --progress=dot $LINK 2>&1 \
  | grep --line-buffered "%" \
  | sed -u -e "s,\.,,g" \
  | awk '{printf("\b\b\b\b%4s", $2)}'

echo -ne "\b\b\b\b"
echo "\nDone downloading\n"

echo "Extracting...\n"

# finds out what the first level directory is called

MAIN_DIR=`tar -ztf $DIRECTORY$FILENAME --exclude '*/*/*' \
  | head -n 1 \
  | xargs dirname`

# Checks if that directory already exists
if [ -d $DIRECTORY$MAIN_DIR ];
then
    echo A directory with the expected name already exists. Perhaps \
      you already have the latest version installed?
    exit 0
fi

#@todo report tar extraction errors to user
tar -xf "$DIRECTORY$FILENAME" -C "$DIRECTORY"
echo "Done extracting\n"
#@todo add cleanup option to delete all old phpstorm zips and directories

