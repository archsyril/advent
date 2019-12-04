from strutils import split
from parseutils import parseUint
import adventus

type
  Direction = enum
    down='D', left='L', right='R', up='U'
  Point = tuple[x, y: int]
  WirePath = seq[Point]

proc intersect(a0,a1, b0,b1: Point): bool =
  (a1.x <= b0.x and a0.x >= b1.x and
   a1.y <= b0.y and a0.y >= b1.y) or
  (a1.x >= b0.x and a0.x <= b1.x and
   a1.y >= b0.y and a0.y <= b1.y)

proc xy(wp: WirePath; dir: Direction; m: int): Point =
  let l = wp[^1]
  case dir
  of up:    (l.x, l.y + m)
  of right: (l.x + m, l.y)
  of down:  (l.x, l.y - m)
  of left:  (l.x - m, l.y)

var wps: array[2, WirePath]
for i,ln in ilines(input("1")):
  var wp: WirePath
  add(wp, (x: 0, y: 0))
  for ins in split(ln, ','):
    let
      dir = Direction ins[0]
      mov = parse(int, ins[1..^1])
    add(wp, xy(wp, dir, mov))
  wps[i] = wp

echo wps
echo len(wps[1])
var (a0,a1, dis) = (wps[0][0], Point (0,0), high(int))
for i in 1..<len(wps[0]):
  a1 = wps[0][i]
  var (b0,b1) = (wps[1][0], Point (0,0))
  for j in 1..<len(wps[1]):
    b1 = wps[1][j]
    if intersect(a0,a1, b0,b1):
      let (x, y) = if a0.x == a1.x:
        (a1.x, b1.y)
      else:
        (b1.x, a1.y)
      let ndis = abs(x) + abs(y)
      if ndis == 0: continue
      echo "Intersection at ", x, ", ", y, ". distance ", ndis
      if ndis < dis:
        echo "New lower distance: ", ndis
        dis = ndis
    b0 = b1
  a0 = a1
# 142 too low
echo dis