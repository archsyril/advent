import streams, strutils, parseutils
const
  HEIGHT: uint = 360
  WIDTH:  uint = 360
type
  Point = object
    x, y: uint
  Coordinates = array[50, Point]
  Grid = array[HEIGHT, array[WIDTH, uint16]]
proc initGrid(fn: string): Grid=
  var fs = newFileStream(fn)
  var id: uint = 1
  for ln in fs.lines:
    var x, y: uint
    let ls = ln.split(' ')
    discard ls[0].parseUint(x)
    discard ls[1].parseUint(y)
    result[y][x] = id * 10
    inc id
  fs.close()
proc `$`(g: Grid): string=
  for x in 0..<HEIGHT:
    for y in 0..<WIDTH:
      result.add toHex(g[y][x])
    result.add('\n')
template inBounds(a,b: uint): untyped= a in 0..<WIDTH and b in 0..<HEIGHT
template add(g: var Grid, x,y, id: uint): untyped=
  if inBounds(x,y):
    if g[y][x] != 
proc evaluate(g: var Grid): uint=
  for y in 0..<HEIGHT:
    for x in 0..<WIDTH:
      let id = g[y][x]
      if inBounds(x,y):
        g[y][x]
var grid = initGrid("input")
echo grid

#[
proc mutate(g: var Grid, x, y: uint)=
  let id = (g[y][x] % 50) + 1
  if id 
  g[y-1][x]

var
  grid = initGrid("input6.txt")
  mutations: uint = 1
while mutations != 0:
  mutations = 0
  for y in 0..<360:
    for x in 0..<360:
      if grid[y][x] != 0:
        grid[y][x]
]#