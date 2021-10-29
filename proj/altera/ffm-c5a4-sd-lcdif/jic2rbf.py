#!/usr/bin/env python3

# usage:
# jic2rbf.py size project.jic project.rbf

from sys import argv

src  = open(argv[1], "rb")
dst  = open(argv[2], "wb")

# more or equal of consecutive 0xFF bytes indicate end of flash
ffendcount = 10000

# 1-byte buffer
b = bytearray(1)
# find first occurence of 0xFF byte
while b[0] != 0xFF:
  src.readinto(b)
# write already read 0xFF byte
dst.write(b)
# copy until end of file or detected end of flash
ffcount = 0
while src.readinto(b):
  # detected end of flash
  if b[0] == 0xFF:
    ffcount += 1
  else:
    if ffcount > ffendcount:
      break
    ffcount = 0
  # copy
  dst.write(b)
  