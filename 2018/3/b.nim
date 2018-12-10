import streams, parseutils, strutils
type Piece = object
  x,y, w,h: int
type Pieces = array[1301, Piece]
proc parseDimensions(str: TaintedString): Piece=
  let pr = str.split({' ', 'x', ','})[2..5]
  discard pr[0].parseInt(result.x)
  discard pr[1].parseInt(result.y)
  discard pr[2].parseInt(result.w)
  discard pr[3].parseInt(result.h)
proc process(fn: string): Pieces=
  var
    fs = newFileStream(fn)
    i: uint
  for ln in fs.lines:
    result[i] = parseDimensions(ln)
    inc i
  fs.close()
import math
template `==`(a,b: Piece): untyped= ((a.x == b.x) and (a.y == b.y) and (a.w == b.w) and (a.h == b.h))
#template collides(a,b: Piece): untyped= ((abs(a.x - b.x) * 2 <= (a.w + b.w)) and (abs(a.y - b.y) * 2 <= (a.h + b.h)))
template collides(a,b: Piece): untyped= ((a.x <= b.x+b.w and a.x+a.w >= b.x) and (a.y <= b.y+b.h and a.y+a.h >= b.y))
let pieces = process("input3.txt")
for i, p1 in pieces:
  var collisions: uint = 0
  for p2 in pieces:
    if p1 == p2: continue
    if collides(p1, p2):
      collisions += 1
  if collisions == 0:
    echo i+1
#[
proc initPiece(x,y,w,h: int): Piece=
  result.x = x
  result.y = y
  result.w = w
  result.h = h

var
  p1 = initPiece(1,1,3,3)
  p2 = initPiece(5,5,1,1)
echo collides(p1,p2)
]#