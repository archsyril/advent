import streams, strutils, parseutils
type Grid = array[1000, array[1000, uint]]

proc grid(fn: string): Grid=
  for ln in newFileStream(fn).lines:
    var x,y,w,h: uint
    block:
      let
        dims = ln.split(' ')[2..3]
        d1 = dims[0].split(',')
        d2 = dims[1].split('x')
      discard d1[0].parseUint(x)
      discard d1[1].parseUint(y)
      discard d2[0].parseUint(w)
      discard d2[1].parseUint(h)
    for i in y..y+h:
      for j in x..x+w:
        result[i][j] += 1

var
  total: uint = 0
  gr = grid("input")
for row in gr:
  for item in row:
    if item <= 2:
      total += 1
echo gr 
echo total
