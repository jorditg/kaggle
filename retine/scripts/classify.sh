#!/bin/bash

CSV_FILE="trainLabels.csv"
IFS=$'\n'
DIR="./train/100x100"

for line in $(cat $CSV_FILE); do
    FILENAME=$(echo $line | cut -d "," -f 1).jpeg
    TARGET=$(echo $line | cut -d "," -f 2)
    echo "File: "$FILENAME
    mv $DIR/$FILENAME $DIR/$TARGET
done
