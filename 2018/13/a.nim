import streams
type
  Rail = ref object
    next, prev: Rail
    x, y: uint
    cart: bool
  Intersection = seq[Rail]

iterator ilines(fs: FileStream): (uint, string)=
  var i: uint
  for ln in fs.lines:
    yield (i, ln)
    inc(i)

discard initRail("input")