import streams, strutils, parseutils, math
type
  Header = ref object
    children: seq[Header]
    metadata: seq[uint]
    childnum, metanum: uint
iterator reverse[T](oa: openArray[T]): T=
  for i in 0..oa.high:
    yield oa[i]
proc reverse[T](sq: var seq[T])=
  var tmp: seq[T]
  for i in countdown(sq.len-1, 0):
    tmp.add(sq[i])
  sq = tmp
proc pull[T](sq: var seq[T]): T=
  let ind = sq.len-1
  result = sq[ind]
  sq.delete(ind)
proc process(fn: string): seq[uint]=
  var fs = newFileStream(fn)
  for c in fs.readAll().split(' '):
    var ui: uint
    discard c.parseUint(ui)
    result.add(ui)
  fs.close()
  result.reverse()
proc initHeader(sq: var seq[uint]): Header=
  new result
  result.childNum = sq.pop()
  result.metaNum = sq.pop()
  for i in 1..result.childNum:
    result.children.add(sq.initHeader())
  for i in 1..result.metaNum:
    result.metadata.add(sq.pop())
proc generateHeaders(sq: var seq[uint]): seq[Header]=
  var hdr = new Header
  while sq.len > 0:
    result.add(sq.initHeader())
proc `$`(hd: Header): string= return "<children: $#, metadata: $#>".format(hd.childNum, hd.metaNum)
var hdr: Header
block:
  var data = process("input")
  hdr = data.initHeader()
proc countMetadata(hd: Header): uint=
  for child in hd.children:
    result += countMetadata(child)
  result += sum(hd.metadata)
echo hdr.countMetadata()
  
