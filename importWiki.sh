#!/bin/bash

# $1 = pages directory
# $2 = maintenance directory

php="/opt/rh/php55/root/usr/bin/php"

usage="$(basename "$0") [-h] -- program to convert MoinMoin to MediaWiki

where:
    -h  show this help text
    First argument is the directory for MoinMoin pages
    Second argument is the maintenance directory for MediaWiki"

while getopts ':hs:' option; do
  case "$option" in
    h) echo "$usage"
       exit
       ;;
    :) printf "missing argument for -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
   \?) printf "illegal option: -%s\n" "$OPTARG" >&2
       echo "$usage" >&2
       exit 1
       ;;
  esac
done
shift $((OPTIND - 1))

for file in $1*/current
do

revDir=$(echo $file | sed "s|current|revisions|")
title=$(echo $file | sed "s|current||")

currentFile="$revDir/$(cat $file)"

if [ -e $currentFile ]
then
	bash mm2mw.sh $currentFile
	title=$(basename $title |
		sed "s|(|\\\x|g" | #Replace ( with \x to decode the % encoding, globally
		sed "s|)||g" | #Remove ), globally
		sed "s|\(Category\)\([A-Z]\)|\1:\2|" | #Place a : after the word Category
		sed "s|\([A-Z][^A-Z]\)| \1|" | #Put a space before the first capital of a word FAQPage > FAQ Page
		sed "s|\([a-z]\)\([A-Z]\)|\1 \2|g") #Put a space between words, globally
	title=$(echo -e $title) #Read \x encoding as UTF-8
	#echo $title #For testing, print to terminal
	$php $2'edit.php' -s "First Final Merge" "$title" < $currentFile
fi

done

$php $2'importImages.php' --search-recursively $1 svg png jpg jpeg gif bmp pdf SVG PNG JPG JPEG GIF BMP PDF

$php $2'runJobs.php'
