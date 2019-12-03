from strutils import split
from parseutils import parseUint
import adventus

type
  Direction = enum
    down='D', left='L', right='R', up='U'
  Point = tuple[x, y: int]
  Line = array[2, Point]
  WirePath = seq[Point]

proc intersect(a, b: Line): bool =
  a[0].x <= b[1].x and a[1].x >= b[0].x and
  a[0].y <= b[1].y and a[1].y >= b[0].y

proc xy(wp: WirePath; dir: Direction; mov: int): Point =
  let l = wp[^1]
  case dir
  of up:    (l.x, l.y + mov)
  of right: (l.x + mov, l.y)
  of down:  (l.x, l.y - mov)
  of left:  (l.x - mov, l.y)

var wps: array[2, WirePath]
for i,ln in ilines(input):
  var wp: WirePath
  add(wp, (x: 0, y: 0))
  for ins in split(ln, ','):
    let
      dir = Direction ins[0]
      mov = parse(int, ins[1..^1])
    add(wp, xy(wp, dir, mov))
  wps[i] = wp

echo wps[0]

var
  rs: seq[Point]
  p1 = wps[0][0]
for i in 1..<len(wps[0]):
  let l1 = Line [ p1, wps[0][i] ]
  p1 = l1[1]
  var p2 = wps[1][0]
  for j in i..<len(wps[1]):
    let l2 = Line [ p2, wps[1][j] ]
    p2 = l2[1]
    if l1[0].x in l2[0].x .. l2[1].x:

    else
    #if intersect(l1, l2):
    #  echo "cool"