import streams, parseutils, strutils
type Box = object
  x,y: uint
  w,h: uint
type Grid = array[1301, Box]
iterator i_lines(fs: FileStream): (uint, string)=
  var i: uint
  for ln in fs.lines:
    yield (i, ln)
    inc(i)
proc newGrid(fn: string): Grid=
  var fs = newFileStream(fn)
  for i, ln in fs.i_lines:
    var
      grp = ln.split(' ')[2..3]
      dim1 = grp[0].split(',')
      dim2 = grp[1].split('x')
    discard dim1[0].parseUint(result[i].x)
    discard dim1[1].parseUint(result[i].y)
    discard dim2[0].parseUint(result[i].w)
    discard dim2[1].parseUint(result[i].h)
template area(b: Box): untyped= (b.w * b.h)
template collides(itm, cmp: Box): untyped=
  itm.y <= cmp.y+cmp.h and itm.y+itm.h >= cmp.y and
   itm.x <= cmp.x+cmp.w and itm.x+itm.w >= cmp.x
proc getCollision(itm, cmp: Box): Box=
  discard
var
  grid: Grid = newGrid("input.txt")
  intrsct: uint
for i, itm in grid:
  let pnt = i+1
  for cmp in grid[pnt..grid.high]:
    if collides(itm, cmp):
      echo 
      inc(intrsct)
echo intrsct