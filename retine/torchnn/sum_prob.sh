#!/bin/bash

LC_NUMERIC="C"

paste -d ',' o0.txt o1.txt o2.txt o3.txt o4.txt o5.txt o6.txt o7.txt o8.txt o9.txt o10.txt o11.txt | awk '
BEGIN { FS = "," } ; 
{
a = ($1+$6 +$11+$16+$21+$26+$31+$36+$41+$46+$51+$56)/12
b = ($2+$7 +$12+$17+$22+$27+$32+$37+$42+$47+$52+$57)/12
c = ($3+$8 +$13+$18+$23+$28+$33+$38+$43+$48+$53+$58)/12
d = ($4+$9 +$14+$19+$24+$29+$34+$39+$44+$49+$54+$59)/12
e = ($5+$10+$15+$20+$25+$30+$35+$40+$45+$50+$55+$60)/12

max = a
col = 0
if(b>max) { max = b; col = 1; }
if(c>max) { max = c; col = 2; }
if(d>max) { max = d; col = 3; }
if(e>max) { max = e; col = 4; }

print a,b,c,d,e

}'

