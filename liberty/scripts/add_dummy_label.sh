#!/bin/bash

IFS=$'\n'

for line in $(cat $1); do
  echo "0,$line"
done

