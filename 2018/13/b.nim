#b.nim
#1. 2   5. 32
#2. 4   6. 64
#3. 8   7. 128
#4. 16  8. 256

import algorithm as alg

const Size = 150'u8

template next(a) = (if a==high(a): a=low(a) else: inc a)
template prev(a) = (if a==low(a): a=high(a) else: dec a)

type
  Track = enum none, inter, rturn, lturn
  Tile = object
    track {.bitsize: 2.}: Track
    prsnt {.bitsize: 1.}: bool
  Direction = enum north, east, south, west
  Intersect = enum left, straight, right
  CartRef = ref Cart
  Cart = object
    x,y: uint8
    dir  {.bitsize: 2.}: Direction
    intr {.bitsize: 2.}: Intersect
  Warehouse = array[Size, array[Size, Tile]]

var
  carts: seq[CartRef]
  wh: Warehouse

template cart(x,y: uint8; d: Direction): void =
  var c = new CartRef
  c.dir = d
  (c.x, c.y) = (x,y)
  wh[y][x].prsnt = true
  add(carts, c)

block:
  var y: uint8
  for ln in lines("2018/13/input"):
    var x: uint8
    for c in ln:
      case c
      of '^': cart(x,y, north); wh[y][x].prsnt = true
      of 'v': cart(x,y, south); wh[y][x].prsnt = true
      of '<': cart(x,y, west);  wh[y][x].prsnt = true
      of '>': cart(x,y, east);  wh[y][x].prsnt = true
      of '/':  wh[y][x].track = rturn
      of '+':  wh[y][x].track = inter
      of '\\': wh[y][x].track = lturn
      else: discard
      x += 1
    y += 1

# part 2: if carts crash in the next tick, remove those carts
# aka... must see a tick in the future to see if carts crash and remove them if they do

while true:
  carts = alg.sortedByIt(carts, it.y)
  for i in 0..<len(carts):
    let (c, d) = (carts[i], carts[i].dir)
    wh[c.y][c.x].prsnt = false
    case d
    of north: c.y -= 1
    of east:  c.x += 1
    of south: c.y += 1
    of west:  c.x -= 1
    let v = wh[c.y][c.x]
    if v.prsnt:
      echo "crash at ", c.x, ", ", c.y
    wh[c.y][c.x].prsnt = true
    case v.track:
    of none: discard
    of inter:
      case c.intr
      of left:     prev c.dir
      of straight: discard
      of right:    next c.dir
      next c.intr
    of rturn #[/]#:
      case d
      of north, south: next c.dir
      of east, west: prev c.dir
    of lturn #[\]#:
      case d
      of north, south: prev c.dir
      of east, west: next c.dir
