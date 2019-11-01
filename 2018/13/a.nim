from sequtils import toSeq
type
  Nt = uint8
  Direction = enum right, down, left, up
  Rail = object
    x1,y1,x2,y2: Nt
    carts: seq[Cart]
  Cart = ref object
    x,y: Nt
    dir: Direction

template move(a: untyped; d: Direction): untyped =
  when d==right: x+=1 elif d==down:  y+=1
  elif d==left:  x-=1 elif d==up:    y-=1
  a[y][x]

template newCart(c: char): untyped =
  var rs = new Cart
  add(r.carts, rs); add(carts, rs)
  (rs.x, rs.y) = (x, y)
  rs.dir = case c
  of '>': right
  of 'v': down
  of '<': left
  else:   up

template search(d: static[Direction]): untyped =
  let (ender, carts) = when d in {right, left}:
        ({'\\'}, {'<', '>'})
  else: ({ '/'}, {'^', 'v'})
  while (let c = move(raw, d); c) notin ender:
    if c in carts:
      newCart(c)

var
  carts: seq[Cart]
  rails: seq[Rail]
when true:
  var raw = toSeq(lines("2018/13/input"))
  let
    height = len(raw).Nt
    width  = len(raw[0]).Nt
  for sy in 0.Nt..<height:
    for sx in 0.Nt..<width:
      let c = raw[sy][sx]
      if c in {'/'}:
        var (r,x,y) = (Rail(x1: sx, y1: sy),sx,sy)
        search(right); r.x2 = x
        search( down); r.y2 = y
        raw[r.y2][r.x2] = '#'
        search(left); search(up)
        add(rails, r)
    raw[sy] = ""

template quick(dcmp; cmp, wt1,rs1, wt2,rs2): untyped =
  when dir==dcmp:(if cmp==wt1:c.dir=rs1)else:(if cmp==wt2:c.dir=rs2)

template turnIf(d: static[Direction]): untyped {.dirty.} =
  const dir = d
  when dir in {right, left}:
    if c.y == r.y1:
          quick(left,  c.x, r.x1,down, r.x2,up) #top
    else: quick(right, c.x, r.x1,up,   r.x2,down) #bottom
  else:
    if c.x == r.x1:
          quick(up,    c.y, r.y1,right, r.y2,left) #left
    else: quick(down,  c.y, r.y1,left,  r.y2,right) #right

template tick(): untyped {.dirty.} =
  bind rails
  block:
    bind carts
    let c = carts[0]
    echo domain(c.x.int,c.y.int,raw)
  for r in rails:
    for c in r.carts:
      case c.dir
      of right:
        c.x += 1; turnIf(right)
      of down:  c.y += 1; turnIf(down)
      of left:  c.x -= 1; turnIf(left)
      of up:    c.y -= 1; turnIf(up)

proc domain(x,y: int; s: var seq[string]; r: int = 1): seq[string] =
  let
    ln: int = r.int*2+1
    df: int = r*2
  result = newSeqOfCap[string](ln)
  for i in 0..<ln:
    add(result, newStringOfCap(ln))
  for i in y-r..<y+r:
    for j in x-r..<x+r:
      echo i, ' ', j
      result[i][j] = raw[i-df][j-df]

template collision(): untyped =
  bind carts
  let lc = len(carts)
  var i: int
  while i < lc:
    let c1 = carts[i]
    var j = i+1
    while j < lc:
      let c2 = carts[j]
      if c1.x==c2.x and c1.y==c2.y:
        echo "COLLISION AT " & $c1.x & ", " & $c1.y
        #quit(0)
      inc j
    inc i

while true:
  tick()
  collision()
