import streams, strutils, parseutils
type
  Header = ref object
    children: seq[Header]
    metadata: seq[uint]
    childnum, metanum: uint
template postInc[T](v: var T): T=
  let tmp = v
  inc(v)
  return tmp
proc readUntil(fs: FileStream, until: char): string=
  var
    pos = fs.getPosition()
    length: int = 1
    rd: char
  while 
    rd = fs.readChar()
    inc length
  fs.setPosition(pos)
  return fs.readStr(length)
proc newHeader[N]: Header= new result[N]
proc process(fn: string): seq[Header]=
  var fs = newFileStream(fn)
  var
    head: bool = false
    curr: Header
  while not fs.atEnd():
    #var ui: uint
    echo fs.readUntil(' ')#.parseUint(ui)
    #echo ui
  fs.close()
discard process("input")
