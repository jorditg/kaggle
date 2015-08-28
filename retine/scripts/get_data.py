#!/usr/bin/python

import PIL
import Image
import math
import glob
import numpy
import sys
import os
import csv
import struct
import random

def get_image(FILENAME):
  im = Image.open(FILENAME)
  pix = im.load()
  data = bytearray(list(im.getdata()))
  w = im.size[0]
  h = im.size[1]
  if w != 256 or h != 256:
    print 'Size error: not 256x256 image: ' + FILENAME
    sys.exit(0)
  return data

def get_target(TARGET_FILE, label):
  with open(TARGET_FILE, 'rt') as f:
    reader = csv.reader(f, delimiter=',')
    for row in reader:
      if label == row[0]:
        return row[1]
  print 'Error: label not found ' + label
  sys.exit(1)


random.seed()

TEST_DATA = -0.1

OUTPUT_FILE = 'train-data.bin'
TEST_FILE = 'test-data.bin'
TARGET_FILE = 'trainLabels.csv'

output_file = open(OUTPUT_FILE, 'wb')
test_file = open(TEST_FILE, 'wb')

image_filenames = glob.glob('./256/*.jpeg')
for FILENAME in image_filenames:
  
  a = get_image(FILENAME)
  
  base = os.path.basename(FILENAME)
  fil = os.path.splitext(base)[0]
  t = get_target(TARGET_FILE, fil)

  classifier = random.random()
  if classifier > TEST_DATA:
    output_file.write(a)
    output_file.write(struct.pack('B', int(t)))
  else:
    test_file.write(a)
    test_file.write(struct.pack('B', int(t)))
    
  # Here < means little endian and f means float (32 bits, IEEE)

output_file.close()
test_file.close()
