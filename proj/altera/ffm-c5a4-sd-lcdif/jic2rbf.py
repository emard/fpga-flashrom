#!/usr/bin/env python3

# usage:
# jic2rbf.py project.jic project.rbf

from sys import argv, exit
from io import SEEK_END

src  = open(argv[1], "rb")
dst  = open(argv[2], "wb")

#src.seek(0, SEEK_END) # end of file
#length = src.tell()
#print(length)

#src.seek(0) # start of file
#pos = src.tell()
#print(pos)

# more or equal of consecutive 0xFF bytes indicate end of flash
ffendcount = 10000

# 1-byte buffer (initial value 0)
b = bytearray(1)

# find first occurence of 0xFF byte
while b[0] != 0xFF:
  src.readinto(b)
# start position is position of first 0xFF in file
pos_start = src.tell()-1

# find first occurence of a long series of 0xFF bytes
pos_end = 0
ffcount = 0
while src.readinto(b):
  # detecting end of flash
  if b[0] == 0xFF:
    ffcount += 1
    if pos_end == 0:
      pos_end = src.tell()
  else:
    if ffcount > ffendcount:
      break
    ffcount = 0
    pos_end = 0

# rewind file to start position
src.seek(pos_start)
# copy
while src.readinto(b):
  if src.tell() >= pos_end:
    break
  dst.write(b)
  