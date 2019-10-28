import os, sys

f= open("2018/6/input")
xm, ym = 0, 0
for l in f:
  l= l.split(",")
  x, y= int(l[0]), int(l[1])
  if x > xm: xm = x
  if y > ym: ym = y
print(xm, ym)

