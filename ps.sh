#!/bin/sh
# This program will download and extract
# the latest eap version of phpstorm to
# ~/Downloads.

DIRECTORY=$HOME/Downloads/
echo "\nFetching download link...\n"

# fetches the link from the page via regex.
# Looks for a href ending in .tar.gz.
# Returns the full href

JET_URL='https://confluence.jetbrains.com/display/PhpStorm/PhpStorm+Early+Access+Program'

LINK=`wget -qO- $JET_URL \
  | grep -oP "(?<=<p>Unix<\/p><\/td><td class=\"confluenceTd\"><p><a href=\").*?(?=\.tar\.gz\")" \
  | awk '{print $0 ".tar.gz"}'`

# check link was found. sometimes the page changes during milestone releases

if [ -z  $LINK  ];
then
    echo "Could not find a valid EAP link at:"
    echo $(tput setaf 2)$JET_URL$(tput sgr0)
    exit 0
fi

# Get the filename of the tar.gz ready for extraction

FILENAME=`basename $LINK`

# check if the file exists before downloading

if [ -f $DIRECTORY$FILENAME ];
then
    echo "$(tput setaf 2)You already have the latest archive.$(tput sgr0)"
    echo "Perhaps you forgot to extract it?\n"
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
    echo "The directory $(tput setaf 2)$DIRECTORY$MAIN_DIR$(tput sgr0) already exists.\n"
    exit 0
fi

#@todo report tar extraction errors to user

# extract the archive

tar -xf "$DIRECTORY$FILENAME" -C "$DIRECTORY"

echo "Done extracting\n"
echo "New version can be found here: $(tput setaf 2)$DIRECTORY$MAIN_DIR$(tput sgr0)\n"

#@todo add cleanup option to delete all old phpstorm zips and directories

