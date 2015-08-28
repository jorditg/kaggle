#!/bin/bash

function fcomp() {
    awk -v n1=$1 -v n2=$2 'BEGIN{ if (n1<n2) exit 0; exit 1}'
}

IFS=$'\n'

for linea in $(cat $1); do 
 id=$(echo $linea | cut -d "," -f 1)
 v1=$(echo $linea | cut -d "," -f 2 | cut -d "." -f 1)
 v2=$(echo $linea | cut -d "," -f 4)
 if [ $v1 -ge 10 ]; then
   echo $id,$v1
 else
   echo $id,$v2
 fi
done

