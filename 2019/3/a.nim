from strutils import split
from parseutils import parseUint
import adventus

const part1 = false

type
  Direction = enum
    down='D', left='L', right='R', up='U'
  Point = tuple[x, y, m: int]
  WirePath = seq[Point]

template sx(a,b: Point): bool = a.x == b.x
template sy(a,b: Point): bool = a.y == b.y
template canIntersect(a0,a1,b0,b1: Point): bool =
  (sy(a0, a1) and sx(b0, b1))
template bx(b, a0,a1: Point): bool =
  ((a0.x > a1.x and b.x in a1.x..a0.x) or b.x in a0.x..a1.x)
  #b.x in min(a0.x, a1.x)..max(a0.x, a1.x)
template by(b, a0,a1: Point): bool =
  ((a0.y > a1.y and b.y in a1.y..a0.y) or b.y in a0.y..a1.y)
template isBetween(a0,a1, b0,b1: Point): bool =
  (bx(b0, a0,a1) and by(a0, b0,b1))
template intersect(a0,a1, b0,b1: Point): bool =
  ((
    canIntersect(a0,a1, b0,b1) and
       isBetween(a0,a1, b0,b1)
  ) or (
    canIntersect(b0,b1, a0,a1) and
       isBetween(b0,b1, a0,a1)
  ))

proc xy(wp: WirePath; d: Direction; m: int): Point =
  let l = wp[^1]
  case d
  of up:    (l.x, l.y + m, m)
  of right: (l.x + m, l.y, m)
  of down:  (l.x, l.y - m, m)
  of left:  (l.x - m, l.y, m)

var wps: array[2, WirePath]
for i,ln in ilines(input("3")):
  var wp: WirePath
  add(wp, (x: 0, y: 0, m: 0))
  for ins in split(ln, ','):
    let
      dir = Direction ins[0]
      mov = parse(int, ins[1..^1])
    add(wp, xy(wp, dir, mov))
  wps[i] = wp

when part1:
  var dis = high(int)
var (a0,a1) = (wps[0][0], Point 0)
for i in 1..<len(wps[0]):
  a1 = wps[0][i]
  var (b0,b1) = (wps[1][0], Point (0,0,0))
  for j in i..<len(wps[1]):
    b1 = wps[1][j]
    if intersect(a0,a1, b0,b1):
      let (x, y) = if a0.x == a1.x:
        (a1.x, b1.y)
      else:
        (b1.x, a1.y)
      when part1:
        let ndis = abs(x) + abs(y)
        if ndis == 0: continue
        echo "Intersection at ", x, ", ", y, ". distance ", ndis
        if ndis < dis:
          echo "New lower distance: ", ndis
          dis = ndis
      else:
        var (d0, d1) = (0, 0)
        for i in countdown(i+1, 1): d0 += wps[0][i].m
        for j in countdown(j+1, 1): d1 += wps[1][j].m
        echo wps[0][i+2]
        echo wps[1][j+2]
        echo d0, " ", d1
    b0 = b1
  a0 = a1

when part1:
  echo dis