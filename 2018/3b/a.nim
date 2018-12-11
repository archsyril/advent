import streams, strutils, parseutils
type
  Box = object
    x1,y1,x2,y2: uint
  Grid = array[1301, Box]
proc initBox(x1,x2, y1,y2: uint): Box=
  result.x1 = x1
  result.x2 = x2
  result.y1 = y1
  result.y2 = y2
proc initGrid(fn: string): Grid=
  var i: int
  for ln in newFileStream(fn).lines:
    let
      dims = ln.split(' ')[2..3]
      d1 = dims[0].split(',')
      d2 = dims[1].split('x')
    discard d1[0].parseUint(result[i].x1)
    discard d1[1].parseUint(result[i].y1)
    discard d2[0].parseUint(result[i].x2)
    discard d2[1].parseUint(result[i].y2)
    result[i].x2 += result[i].x1
    result[i].y2 += result[i].y1
    inc(i)
template collides(a, b: Box): untyped=
  a.x1 <= b.x2 and a.x2 >= b.x1 and 
   a.y1 <= b.y2 and a.y2 >= b.y1
proc intersection(a, b: Box): Box=
  result.x1 = if b.x1 in a.x1..a.x2: b.x1
   else: a.x1
  result.x2 = if b.x2 in a.x1..a.x2: b.x2
   else: a.x2
  result.y1 = if b.y1 in a.y1..a.y2: b.y1
   else: a.y1
  result.y2 = if b.y2 in a.y1..a.y2: b.y2
   else: a.y2
template area(b: Box): untyped= (itr.x2 - itr.x1) * (itr.y2 - itr.y1)

var
  grid = initGrid("input")
  total: uint
  itrs: seq[Box]
for i, box in grid:
  for cmp in grid[i+1..grid.high]:
    if collides(box, cmp):
      var itr = intersection(box, cmp)
      total += area(itr)
echo total
#[
var total: uint
for i, itr in itrs:
  echo "itr: ", area(itr)
  for cmp in itrs[i+1..itrs.high]:
    if collides(itr, cmp):
      echo "col:  ", area(intersection(itr, cmp))
echo total
]#
