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

def to_files(output_file, file_list):
#  MAX_RND_ANGLE = 360
#  random.shuffle(file_list)
  for FILENAME in file_list:
    print 'Filename:' + FILENAME
    flip = randint(0,2)
    rotate = random.random()*360
    a = get_image(FILENAME, flip, rotate)
    a.append(0)
    a.append(0xFF)
    assert len(a) == 30002
    
    base = os.path.basename(FILENAME)
    fil = os.path.splitext(base)[0]
    
    output_file.write(a)

#    random.shuffle(file_list)


OUTPUT_FILE = 'test-data6.bin'

random.seed()
output_file = open(OUTPUT_FILE, 'wb')
image_f0 = glob.glob('./test/100x100/*.jpeg')


#idx = list(xrange(len(image_filenames))
#random.shuffle(idx)

to_files(output_file, image_f0)
output_file.close()

