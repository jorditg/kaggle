#!/bin/bash

LC_NUMERIC="C"

paste -d ',' o0.txt o1.txt o2.txt o3.txt o4.txt o5.txt o6.txt o7.txt o8.txt o9.txt o10.txt o11.txt | awk -f file.awk
