#!/bin/bash

IFS=$'\n'

for line in $(cat $1); do
  class=$(echo $line | cut -d "," -f 1)
  if [ "$class" -le "3" ]; then
    echo $line
  elif [ "$class" -le "6" ]; then
    echo $line
    echo $line
  elif [ "$class" -le "9" ]; then
    echo $line
    echo $line
    echo $line
    echo $line
    echo $line
  elif [ "$class" -le "12" ]; then
    echo $line
    echo $line
    echo $line
    echo $line
    echo $line
    echo $line
    echo $line
    echo $line
    echo $line
    echo $line
    echo $line
  else
    echo $line
    echo $line
    echo $line
    echo $line
    echo $line
    echo $line
    echo $line
    echo $line
    echo $line
    echo $line
    echo $line
    echo $line
  fi
done

