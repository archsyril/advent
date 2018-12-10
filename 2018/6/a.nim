import streams, strutils, parseutils

type
  Point = object
    x, y: uint
  Coordinates = array[50, Point]
  Grid = array[360, array[360, uint]]
proc initGrid(fn: string): Grid=
  var fs = newFileStream(fn)
  var id: uint = 1
  for ln in fs.lines:
    var x, y: uint
    let ls = ln.split(' ')
    discard ls[0].parseUint(x)
    discard ls[1].parseUint(y)
    result[y][x] = id
    inc id
  fs.close()
proc `$`(g: Grid): string=
  for x in 0..<360:
    for y in 0..<360:
      result.add toHex(g[y][x])
    result.add('\n')

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
