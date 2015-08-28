#!/bin/bash

IFS=$'\n'

for file in $(find . -name *.jpeg); do
    convert $file -colorspace Gray ./100x100-grey/${file:2}
done
