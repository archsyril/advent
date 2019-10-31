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
block:
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

template tick(): untyped =
  # THIS IS WRONG!! ITER OVER RAILS
  for c in carts:
    case c.dir
    of right:
      c.x += 1

    of down:  c.y += 1
    of left:  c.x -= 1
    of up:    c.y -= 1

template collision(): untyped =
  let lc = len(carts)
  for i,c1 in 0..<lc:
    for c2 in (i+1)..<lc:
      if c1.x==c2.x and c1.y==c2.y:
        echo "COLLISION AT "&c1.x&", "&c1.y

#underway. finish tick. collission done?
