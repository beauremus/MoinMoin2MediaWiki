#!/bin/bash

# $1 = input file

## CLEANUP

sed "s_\/\!\\\__g" -i $1 #Remove alert symbol
sed -r "s_<<BR>>|<<br>>_<br\/>_g" -i $1 #Replace breaks
sed "s_<<TableOfContents\(([0-9]*)\)\?>>__g" -i $1 #Remove TableOfContents tags
sed -r "s_<<[Ff]oot[nN]ote\(([^>>]+)\)>>_<ref>\1</ref>_g" -i $1 #Replace Footnote tags with <ref></ref>
sed "s_\(Category\)\([a-zA-Z]\+\)_[[\1:\2]]_g" -i $1 #Reformat Categories
#sed "s_\([a-z]\)\([A-Z]\)_\1 \2_g" -i $1 #Seperate CamelCase words
sed -r "s_\{\{\{([^\}\}\}]+)\}\}\}_<code><nowiki>\1<\/nowiki><\/code>_g" -i $1 #Convert {{{ * }}} -> <code><nowiki> * </code>, if on the same line
sed "s_{{{\(.*\?\)_<pre><nowiki>\1_g" -i $1 #Convert {{{ *  -> <pre> *, when }}} is on a different line
sed "s_\(.*\?\)}}}_\1\<\/nowiki><\/pre>_g" -i $1 #Convert -  * }}} ->  * <\pre><\nowiki>
sed -r "s_--([^--]+)--_<s>\1<\/s>_g" -i $1 #Strikethrough convert
sed -r "s_\^([^\^]+)\^_<sup>\1<\/sup>_g" -i $1 #Convert ^ * ^ -> <sup> * </sup>
sed -r "s_,,([^,]+),,_<sub>\1<\/sub>_g" -i $1 #Convert  ,, * ,, -> <sub> * </sub>
sed -r "s_~-([^-~]+)-~_<small>\1<\/small>_g" -i $1 #Convert ~- * -~ -> <small> * </small>
sed -r "s_~\+([^+~]+)\+~_<big>\1<\/big>_g" -i $1 #Convert ~+ * +~ -> <big> * </big>
sed -r "s_\[\[.+\|<<.+\]\] \| \[\[.+\|.+\]\] \| \[\[.+\|.+>>\]\]__g" -i $1 #Remove Left/Right page link
sed -r "s_\[\[.+\|.+\]\] \| \[\[.+\|.+>>\]\]__g" -i $1 #Remove Right page link
sed -r "s_\[\[.+\|<<.+\]\] \| \[\[.+\|.+\]\]__g" -i $1 #Remove Left page link
sed -r "s|__([^__]+)__|<u>\1</u>|g" -i $1 #Replace __*__ with <u>*</u>
sed -r "s_<<[Pp]hone\(([0-9]+[NVC]*),([a-zA-Z]+[ a-zA-Z]*)\)>>_[http://www-tele.fnal.gov/cgi-bin/telephone.script?uname=\1\&which=id \2]_g" -i $1 #Replace <<Phone(*,**)>> with fnal phone link to **

## TABLES

sed -r 's_(<\|)([0-9]+)(>)_rowspan="\2"\|_g' -i $1 #Replace table rowspan
sed -r 's_(<-)([0-9]+)(>)_colspan="\2"\|_g' -i $1 #Replace table colspan
sed -r 's_\|\|[\r\n]__g' -i $1 #Remove end of row
sed -r 's_<table[^>]+[^<]+>__g' -i $1 #Remove table styling
sed -r 's_<#[^>]+[^<]+>__g' -i $1 #Remove color formatting
sed -r 's_<style[^>]+[^<]+>__g' -i $1 #Remove color formatting
sed -r 's_<bgcolor[^>]+[^<]+>__g' -i $1 #Remove color formatting
sed -r 's_<:>__g' -i $1 #Remove center syntax <:>

isTable=0
beginTable="^\|\|"
lineNum=1
tableCount=0

while IFS= read -r line #Print changes to temp file
do
	#echo "lineNum: $lineNum, line: $line, isTable: $isTable"
	if [[ $line =~ $beginTable ]]
	then
		if [ "$isTable" -eq "0" ]
		then
			isTable=1
			((tableCount++))
			> $1_$tableCount
			sed -n -r $lineNum's_^\|\|_\{\|\n\|_p' $1 >> $1_$tableCount #Begin table
			sed -r $lineNum's_^\|\|_@'$tableCount'@_' -i $1
			#echo "begin table"
		else
			sed -n -r $lineNum's_^\|\|_\|-\n\|_p' $1 >> $1_$tableCount #Define row
			#echo "start of row"
		fi
	else
		if [ "$isTable" -eq "1" ]
		then
			isTable=0
			sed -n -r $lineNum's_(.*)$_\1\|\}\n_p' $1 >> $1_$tableCount #End table
			#echo "end table"
		fi
	fi
((lineNum++))
done < $1

for ((n=1;n<=$tableCount;n++))
do
	sed -e '/@'$n'@/r '$1'_'$n'' -e '/^@'$n'@/d;/^||/d' -i $1
	rm "$1"_"$n"
done

## LISTS

sed "s/^[ ]//" -i $1 #Remove first leading space
sed "/^[ ]*[0-9]/s/[0-9]./#/" -i $1 #Replace numbers with #
sed -r "/^[ ]{6}[*]/s/^[ ]{6}/******/" -i $1 #Replace remaining leading spaces with bullets
sed -r "/^[ ]{5}[*]/s/^[ ]{5}/*****/" -i $1 #Replace remaining leading spaces with bullets
sed -r "/^[ ]{4}[*]/s/^[ ]{4}/****/" -i $1 #Replace remaining leading spaces with bullets
sed -r "/^[ ]{3}[*]/s/^[ ]{3}/***/" -i $1 #Replace remaining leading spaces with bullets
sed -r "/^[ ]{2}[*]/s/^[ ]{2}/**/" -i $1 #Replace remaining leading spaces with bullets
sed -r "/^[ ]{1}[*]/s/^[ ]{1}/*/" -i $1 #Replace remaining leading spaces with bullets
sed -r "/^[ ]{6}[#]/s/^[ ]{6}/######/" -i $1 #Replace remaining leading spaces with numbers
sed -r "/^[ ]{5}[#]/s/^[ ]{5}/#####/" -i $1 #Replace remaining leading spaces with numbers
sed -r "/^[ ]{4}[#]/s/^[ ]{4}/####/" -i $1 #Replace remaining leading spaces with numbers
sed -r "/^[ ]{3}[#]/s/^[ ]{3}/###/" -i $1 #Replace remaining leading spaces with numbers
sed -r "/^[ ]{2}[#]/s/^[ ]{2}/##/" -i $1 #Replace remaining leading spaces with numbers
sed -r "/^[ ]{1}[#]/s/^[ ]{1}/#/" -i $1 #Replace remaining leading spaces with numbers

## ATTACHMENTS

sed 's/[aA]ttachment:/File:/g' -i $1 #Replace [aA]ttachment with File
sed 's/width\="*\([0-9]\+\)"*/\1px/g' -i $1 #Exchange the attachment width syntax
sed -r 's_\{\{_\[\[_g' -i $1 #Replace left double curly braces with left double square brackets
sed -r 's_\}\}_\]\]_g' -i $1 #Replace right double curly braces with right double square brackets
#sed -r "s@(?:http:\/\/www-opswiki.*)(?:target\=)([\w,\s-\(\)_\.]+\.[A-Za-z]{3})@File:\3\1@g" test.txt #Replace absolute links with relative links
sed -r 's_(\[\[[^]]+)\|\|([^\[]+\]\])_\1|\2_g' -i $1 #Replace || in links, [[]], with |
#                ^
#                |
##SED is fucking dumb and treats left square brackets and right square brackets differently.
##This left squre bracket MUST be unescaped.
sed -r 's_\$\$(.*)\$\$_<math>\1</math>_g' -i $1 #This is dumb and only works if there is one instance of $$...$$ on a line.