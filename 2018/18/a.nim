type
  Acre = enum yard = '#', open = '.', tree = '|'
  Land = array[50, array[50, Acre]]
  Cardinal = enum N,NE,E,SE,S,SW,W,NW
  Coord = tuple[x,y: int]

func `$`(l: Land): string =
  result = newStringOfCap(51*50)
  for y in 0..<50:
    for x in 0..<50:
      add(result, char(l[y][x]))
    add(result, '\n')

var l,n: Land
block:
  let f = open("2018/18/input")
  for y in 0..<50:
    let ln = readLine(f)
    for x in 0..<50:
      l[y][x] = Acre(ln[x])
  close(f)
  n = l

template `^`(c: static[Cardinal]): Coord =
  when c==N: ( 0,-1) elif c==NE: ( 1,-1) elif c==E: ( 1, 0) elif c==SE: ( 1, 1)
  elif c==S: ( 0, 1) elif c==SW: (-1, 1) elif c==W: (-1, 0) elif c==NW: (-1,-1)
converter toCoord(c: static[Cardinal]): Coord = ^c
template adj(a: Coord): Acre = l[y+a.y][x+a.x]
#template bnd(x,y: int; a: Coord): bool =
#  when c==N: a.y+y >= 0  elif c==E: a.x+x <= 49
#  elif c==S: a.y+y <= 49 elif c==W: a.x+x >= 0
template chk(r: Acre; cs: varargs[Coord, `^`]): int =
  var rs = 0; (for c in cs: (if adj(c) == r: rs += 1)); rs
template ul(v: bool): bool = unlikely(v)
template t(v: int; a,b,c: untyped): untyped = (if ul v==0: a elif ul v==49: b else: c)
template count(r: Acre): int =
  y.t(x.t(r.chk(E,SE,S), r.chk(S,SW,W), r.chk(E,SE,S,SW,W)),
      x.t(r.chk(N,NE,E), r.chk(W,NW,N), r.chk(W,NW,N,NE,E)),
      x.t(r.chk(N,NE,E,SE,S), r.chk(S,SW,W,NW,N), r.chk(N,NE,E,SE,S,SW,W,NW)))

for m in 0..<1000000000:
  #echo l, "\n\n"
  for y in 0..<50:
    for x in 0..<50:
      case l[y][x]
      of open:
        let trees = count(tree)
        if trees >= 3:
          n[y][x] = tree
      of tree:
        let yards = count(yard)
        if yards >= 3:
          n[y][x] = yard
      of yard:
        let
          yards = count(yard)
          trees = count(tree)
        if yards == 0 or trees == 0:
          n[y][x] = open
  l = n

var (yards, trees) = (0, 0)
for y in 0..<50:
  for x in 0..<50:
    case l[y][x]
    of yard: yards += 1
    of tree: trees += 1
    else: discard

echo "Score: trees ", trees, ", yards ", yards, ", TOTAL: ", trees * yards

# too low: 7254
