import streams, parseutils, strutils
#const
#  HEIGHT: uint8 = 1000.uint8
#  WIDTH: uint8 = 1000.uint8
type Fabric = array[1000, array[1000, uint8]]
type Piece = object
  x,y, w,h: uint
proc parseDimensions(str: TaintedString): Piece=
  let pr = str.split({' ', 'x', ','})[2..5]
  discard pr[0].parseUint(result.x)
  discard pr[1].parseUint(result.y)
  discard pr[2].parseUint(result.w)
  discard pr[3].parseUint(result.h)
proc process(fn: string): Fabric=
  var
    fs = newFileStream(fn)
    i: uint
  for ln in fs.lines:
    let pce = parseDimensions(ln)
    for y in pce.y..<pce.y+pce.h:
      for x in pce.x..<pce.x+pce.w:
        result[y][x] += 1
  fs.close()

proc `$`(fb: Fabric): string=
  for row in fb:
    for itm in row:
      result.add $itm
    result.add '\n'
var count: uint
let fabric = process("input3.txt")
for row in fabric:
  for item in row:
    if item > 1.uint8:
      count += 1
echo count