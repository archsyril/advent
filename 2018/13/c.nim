type
  Tile = object
    tr {.bitsize: 2.}: Track
    pr {.bitsize: 1.}: bool  # cart present?
    mv {.bitsize: 1.}: bool  # has moved?
    dr {.bitsize: 2.}: Direction
    ir {.bitsize: 2.}: Intersect
  Track     = enum none, inter, rturn, lturn
  Direction = enum north, east, south, west
  Intersect = enum left, straight, right

template next(a) = (if a==high(a): a=low(a) else: inc a)
template prev(a) = (if a==low(a): a=high(a) else: dec a)
template `^`(a,b): untyped = a[y][x].b

var w,p: array[150, array[150, Tile]]
block:
  var y: int = -1
  for ln in lines("2018/13/input"):
    inc y; for x,c in ln:
      case ln[x]
      of '^': w^pr = true; w^dr = north
      of '>': w^pr = true; w^dr =  east
      of 'v': w^pr = true; w^dr = south
      of '<': w^pr = true; w^dr =  west
      of '/':  w^tr = rturn
      of '+':  w^tr = inter
      of '\\': w^tr = lturn
      else: discard

template intersect(dr, ir): untyped =
  case ir
  of left: prev dr
  of straight: discard
  of right: next dr
  next ir
template turn(dr, a,b): untyped =
  if dr in {north, south}: a(dr) else: b(dr)
iterator xy(a: int): (int,int) =
  for y in 0..<a:(for x in 0..<a:yield(x,y))
while true:
  var
    count: int
    crash: bool
  p = w
  for x,y in xy(150):
    if not (w^pr) or w^mv: continue
    w^pr = false
    var
      (dr,ir) = (w^dr,w^ir)
      (x,y) = case dr
      of north: (x,y-1)
      of east:  (x+1,y)
      of south: (x,y+1)
      of west:  (x-1,y)
    if w^pr:
      (w^pr,crash) = (false,true)
      echo "crash at ", x, ", ", y
      continue
    case w^tr
    of none:  discard
    of inter: intersect(dr, ir)
    of rturn: turn(dr, next, prev)
    of lturn: turn(dr, prev, next)
    (w^dr,w^ir,w^mv,w^pr) = (dr,ir,true,true)
    count += 1
  if crash:
    echo count, " carts left"
  if count == 1:
    for x,y in xy(150):
      if w^pr:
        echo "the last cart is at ", x, ", ", y
        quit(0)
  else:
    for x,y in xy(150): (if w^mv: w^mv = false)
  










