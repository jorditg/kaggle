#!/usr/bin/python

lines1 = [line.rstrip('\n') for line in open('sampleSubmission.csv')]
lines2 = [line.rstrip('\n') for line in open('output.csv')]

idx = 0
for line in lines1:
  act_value = line.split(',')[0]   
  if(lines2[idx].split(',')[0] == act_value):
    print lines2[idx]
    idx = idx + 1
  else:
    print line


