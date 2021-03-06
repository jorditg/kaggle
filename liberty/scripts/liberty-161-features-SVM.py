#!/usr/bin/python

import fileinput
import sys

def rescale(x, maxval, minval):
  return (2*x - maxval - minval)/(maxval - minval)

def standarize(x, mean, sigma):
  return (x - mean) / sigma

header = [
['1-19'],
['1-24'],
['1','2','3','4','5','6','7','8','9'],
['B','C','E','G','H','N','S','W'],
['A','B','C','D','E','H','I','J','K','L'],
['Y','N'],
['A','B','C','D'],
['A','B','C','D'],
['B','C','D','F','G'],
['2','3','7','8','12'],
['A','B','D','E','F','H','I','J','K','L','M','N'],
['A','B','C','D'],
['5','10','15','20'],
['0','1','2','3','4'],
['A','C','D','F','H','N','S','W'],
['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R'],
['Y','N'],
['1-100'],
['1-39'],
['Y','N'],
['1-22'],
['A','B','C','D','E','F'],
['1','2','3','4','5','6','7'],
['22','25','28','31','34','37','40'],
['1','2','3'],
['1-25'],
['1','2','3','4','5','6','7'],
['Y','N'],
['Y','N'],
['A','B','C','D','E'],
['1','2','3','4','5','6','7'],
['1','2','3','4','5','6','7','8','9','10','11','12']
]

for line in fileinput.input():
  fields = line.split(',')
  output = ''
  for i in range(len(fields)):
    field = fields[i]
    field_type = header[i]
    if len(field_type) == 1:
      rng = field_type[0].split('-')
      low = float(rng[0])
      high = float(rng[1])
      out = field
#      out = str(rescale(float(field), high, low))
    elif len(field_type) == 2:
      if field == field_type[0]:
        out = '-1'
      elif field == field_type[1]:
        out = '1'
    else:
      out = ''
      for val in field_type:  
        if val == field:
          out = out + '1,'
        else:
          out = out + '-1,'
      out = out[:-1]
    output += out + ","
  print output[:-1]

