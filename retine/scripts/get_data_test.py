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
  R = bytearray(data[:,:,0])
  G = bytearray(data[:,:,1])
  B = bytearray(data[:,:,2])
  databytes = R + G + B
  if len(databytes) != 30000:
    print 'Size error: not 3x100x100 image: ' + FILENAME
    sys.exit(0)
  return databytes

def to_files(test_file, file_list):
  for FILENAME in file_list:
    print FILENAME
    a = get_image(FILENAME,0)
    a.append(0)
    a.append(0xFF)
    assert len(a) == 30002
    base = os.path.basename(FILENAME)
    fil = os.path.splitext(base)[0]
    test_file.write(a)

TEST_FILE = 'test-submit.bin'
test_file = open(TEST_FILE, 'wb')
images = glob.glob('./test/100x100/*.jpeg')
to_files(test_file, images)
test_file.close()

