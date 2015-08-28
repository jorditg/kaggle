#!/bin/bash

IFS=$'\n'
PIXELS="100x100"
TOTAL=$(ls *.jpeg| wc -l)

i=0
for file in $(ls *.jpeg); do
	FILE=$file
	NAME=`echo "$FILE" | cut -d'.' -f1`
	EXTENSION=`echo "$FILE" | cut -d'.' -f2`

	convert $FILE -fill none -fuzz 10% -draw 'matte 0,0 floodfill' -flop -draw 'matte 0,0 floodfill' -flop $NAME-bck.$EXTENSION
	./autotrim -f 20 -c NorthEast $NAME-bck.$EXTENSION $NAME-trimmed.$EXTENSION
	rm $NAME-bck.$EXTENSION
	convert $NAME-trimmed.$EXTENSION -resize $PIXELS -filter Lanczos $NAME-pretrain.$EXTENSION
	rm $NAME-trimmed.$EXTENSION
	convert $NAME-pretrain.$EXTENSION -thumbnail $PIXELS -background black -gravity center -extent $PIXELS ./$PIXELS/$NAME.$EXTENSION
	rm $NAME-pretrain.$EXTENSION
	let i=i+1
        echo "$i of $TOTAL done - $file"
done
