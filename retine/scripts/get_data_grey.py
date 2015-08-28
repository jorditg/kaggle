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

from random import shuffle

def get_image(FILENAME, rot):
  im = Image.open(FILENAME)
  im.load()
  if rot != 0:
    im.rotate(rot)
  data = numpy.asarray(im)
  w = im.size[0]
  h = im.size[1]
  databytes = bytearray(data)

  if len(databytes) != 10000:
    print 'Size error: not 1x100x100 image: ' + FILENAME
    sys.exit(0)
  return databytes

def get_target(TARGET_FILE, label):
  with open(TARGET_FILE, 'rt') as f:
    reader = csv.reader(f, delimiter=',')
    for row in reader:
      if label == row[0]:
        return row[1]
  print 'Error: label not found ' + label
  sys.exit(1)

def to_files(output_file, test_file, file_list, TEST_DATA, t):
  for FILENAME in file_list:
    print 'Filename:' + FILENAME
    a = get_image(FILENAME,0)
    a90 = get_image(FILENAME,90)
    a180 = get_image(FILENAME,180)
    a270 = get_image(FILENAME,270)

    a.append(t)
    a90.append(t)
    a180.append(t)
    a270.append(t)

    a.append(0xFF)
    a90.append(0xFF)
    a180.append(0xFF)
    a270.append(0xFF)
    
    assert len(a) == 10002 and len(a90) == 10002 and len(a180) == 10002 and len(a270) == 10002
    
    base = os.path.basename(FILENAME)
    fil = os.path.splitext(base)[0]
    
    classifier = random.random()
    if classifier > TEST_DATA:
       output_file.write(a)
       output_file.write(a90)
       output_file.write(a180)
       output_file.write(a270)
    else:
       test_file.write(a)
       test_file.write(a90)
       test_file.write(a180)
       test_file.write(a270)

random.seed()

TEST_DATA = 0.05

OUTPUT_FILE = 'train-data-grey.bin'
TEST_FILE = 'test-data-grey.bin'

output_file = open(OUTPUT_FILE, 'wb')
test_file = open(TEST_FILE, 'wb')

image_f0 = glob.glob('./train/100x100-G/0/*.jpeg')
image_f1 = glob.glob('./train/100x100-G/1/*.jpeg')
image_f2 = glob.glob('./train/100x100-G/2/*.jpeg')
image_f3 = glob.glob('./train/100x100-G/3/*.jpeg')
image_f4 = glob.glob('./train/100x100-G/4/*.jpeg')

#idx = list(xrange(len(image_filenames))
#random.shuffle(idx)

#N = 11000
to_files(output_file, test_file, image_f4, TEST_DATA, 4)
l = len(image_f4)

random.shuffle(image_f3,random.random)
image_f3 = image_f3[0:l]
to_files(output_file, test_file, image_f3, TEST_DATA, 3)

random.shuffle(image_f2,random.random)
image_f2 = image_f2[0:l]
to_files(output_file, test_file, image_f2, TEST_DATA, 2)

random.shuffle(image_f1,random.random)
image_f1 = image_f1[0:l]
to_files(output_file, test_file, image_f1, TEST_DATA, 1)

random.shuffle(image_f0,random.random)
image_f0 = image_f0[0:l]
to_files(output_file, test_file, image_f0, TEST_DATA, 0)

output_file.close()
test_file.close()

