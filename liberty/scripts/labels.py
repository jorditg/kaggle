#!/usr/bin/python

import fileinput
import sys

for line in fileinput.input():
  val = line.strip()
  if val == '1' or val == '2' or val == '3':
    print '1'
  elif val == '4' or val == '5' or val == '6':
    print '2'
  elif val == '7' or val == '8' or val == '9':
    print '3'
  elif val == '10' or val == '11' or val == '12':
    print '4'
  else:
    print '5'




