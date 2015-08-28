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
from random import randint

from random import shuffle

def get_image(FILENAME, flip, rot):
  im = Image.open(FILENAME)
  im.load()
  
  if flip == 1:
    im = im.transpose(Image.FLIP_LEFT_RIGHT)
  elif flip == 2:
    im = im.transpose(Image.FLIP_TOP_BOTTOM)
    
  if rot != 0:
    im = im.rotate(rot)
  data = numpy.asarray(im)
  w = im.size[0]
  h = im.size[1]
  R = bytearray(data[:,:,0])
  G = bytearray(data[:,:,1])
  B = bytearray(data[:,:,2])
  databytes = R + G + B
  if len(databytes) != 30000:
    print 'Size error: not 3x100x100 image: ' + FILENAME
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

def to_files(output_file, test_file, file_list, TEST_DATA, t, N):
  MAX_RND_ANGLE = 360
  random.shuffle(file_list)
  i = 0
  while i < N:
    for FILENAME in file_list:
      print 'Filename:' + FILENAME
      a = get_image(FILENAME, randint(0,2), random.random()*MAX_RND_ANGLE)
      a.append(t)
      a.append(0xFF)
      assert len(a) == 30002
    
      base = os.path.basename(FILENAME)
      fil = os.path.splitext(base)[0]
    
      classifier = random.random()
      if classifier > TEST_DATA:
         output_file.write(a)
      else:
         test_file.write(a)
      i = i + 1
      if i == N:
        break    
    random.shuffle(file_list)

random.seed()

TEST_DATA = -1

OUTPUT_FILE = '06.bin'
TEST_FILE = 'test-data.bin'

output_file = open(OUTPUT_FILE, 'wb')
test_file = open(TEST_FILE, 'wb')

image_f0 = glob.glob('./train/100x100/0/*.jpeg')
image_f1 = glob.glob('./train/100x100/1/*.jpeg')
image_f2 = glob.glob('./train/100x100/2/*.jpeg')
image_f3 = glob.glob('./train/100x100/3/*.jpeg')
image_f4 = glob.glob('./train/100x100/4/*.jpeg')

#idx = list(xrange(len(image_filenames))
#random.shuffle(idx)

N = 5000

to_files(output_file, test_file, image_f4, TEST_DATA, 4, N)
to_files(output_file, test_file, image_f3, TEST_DATA, 3, N)
to_files(output_file, test_file, image_f2, TEST_DATA, 2, N)
to_files(output_file, test_file, image_f1, TEST_DATA, 1, N)
to_files(output_file, test_file, image_f0, TEST_DATA, 0, N)

output_file.close()
test_file.close()

