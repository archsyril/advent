const SIZE = 300
type Grid = array[SIZE, array[SIZE, int]]
let serial = 2694
template calc(id, y, serial: int): untyped= (((id*y+serial)*id) mod 1000/100).int-5

proc area(g: Grid, x,y, square: int): int=
  for a in y..<y+square:
    for b in x..<x+square:
      result += g[a][b]

proc initGrid(serial: int): Grid=
  for y in 0..<SIZE:
    for x in 0..<SIZE:
      let id = x+10
      result[y][x] = calc(id,y,serial)

proc findGreatest(g: Grid, square: int): (int, int, int)=
  var top = 0
  for y in 0..<SIZE-square-1:
    for x in 0..<SIZE-square-1:
      let area = g.area(x,y, square)
      if area > top:
        top = area
        result = (x, y, top)

var
  grid = initGrid(serial)
  top,  x,y, sz: int
for sqr_sz in 1..<300:
  let rslt = grid.findGreatest(sqr_sz)
  if rslt[2] > top:
    top = rslt[2]
    x = rslt[0]; y = rslt[1]
    sz = sqr_sz
  echo sqr_sz, " ", top, " ", x, " ", y, " ", sz
echo x, " ", y, " ", sz
