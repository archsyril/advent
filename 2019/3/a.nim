from strutils import split
from parseutils import parseUint
import adventus

const
  part1 = false
  which = $3

type
  Direction = enum
    down='D', left='L', right='R', up='U'
  Point = object
    x, y: int
    d: Direction
    m: int
  WirePath = seq[Point]

template hrz(a,b: Point): bool = a.x == b.x
template vrt(a,b: Point): bool = a.y == b.y
template canIntersect(a0,a1,b0,b1: Point): bool =
  (vrt(a0, a1) and hrz(b0, b1))
template bx(b, a0,a1: Point): bool =
  ((a0.x > a1.x and b.x in a1.x..a0.x) or b.x in a0.x..a1.x)
  #b.x in min(a0.x, a1.x)..max(a0.x, a1.x)
template by(b, a0,a1: Point): bool =
  ((a0.y > a1.y and b.y in a1.y..a0.y) or b.y in a0.y..a1.y)
template isBetween(a0,a1, b0,b1: Point): bool =
  (bx(b0, a0,a1) and by(a0, b0,b1))
template intersect(a0,a1, b0,b1: Point): bool =
  ((canIntersect(a0,a1, b0,b1) and
       isBetween(a0,a1, b0,b1)
  ) or (
    canIntersect(b0,b1, a0,a1) and
       isBetween(b0,b1, a0,a1) ))
#template pnt(nx: int = 0, ny: int = 0): Point = (x:nx, y:ny, m:0)

proc xy(wp: WirePath; d: Direction; m: int): Point =
  let l = wp[^1]
  (result.d, result.m) = (d, m)
  (result.x, result.y) = case d
  of up:    (l.x, l.y + m)
  of right: (l.x + m, l.y)
  of down:  (l.x, l.y - m)
  of left:  (l.x - m, l.y)

var wps: array[2, WirePath]
for i,ln in ilines(input(which)):
  var wp: WirePath
  add(wp, Point())
  for ins in split(ln, ','):
    let
      dir = Direction ins[0]
      mov = parse(int, ins[1..^1])
    add(wp, xy(wp, dir, mov))
  wps[i] = wp

when part1:
  var dis = high(int)
var (a0,a1) = (wps[0][0], Point())
for i in 1..<len(wps[0]):
  a1 = wps[0][i]
  var (b0,b1) = (wps[1][0], Point())
  for j in 1..<len(wps[1]):
    b1 = wps[1][j]
    if intersect(a0,a1, b0,b1):
      let (x, y) =
        if a0.x == a1.x: (a1.x, b1.y)
                   else: (b1.x, a1.y)
      when part1:
        if (ndis := x |+| y) != 0:
          echo "Intersection at ", x, ", ", y, ". distance ", ndis
          if ndis < dis:
            echo "New lower distance: ", ndis
            dis = ndis
      else:
        if x == 0 and y == 0: continue
        var (d0, d1) = (0, 0)
        for i in countdown(i-1, 1): d0 += wps[0][i].m
        for j in countdown(j-1, 1): d1 += wps[1][j].m
        when true:
          if a0.d in {right, left}: # w0 is hrz
            echo '>', x - b0.x
            echo '>', a0.y - y
            d0 += (if b0.d == right: x - b0.x else: b0.x - x)
            d1 += (if a0.d == up:    y - a0.y else: a0.y - y)
          else:
            echo '>', x - a0.x
            echo '>', b0.y - y
            d1 += (if a0.d == right: x - a0.x else: a0.x - x)
            d0 += (if b0.d == up:    y - b0.y else: b0.y - y)
        echo "(x", x, ",  y", y, ")\n  totals: one ", d0, ", two ", d1, ", grand ", d0 + d1
    b0 = b1
  a0 = a1

when part1:
  echo dis