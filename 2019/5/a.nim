import adventus

type
  Codes = enum
    cAdd, cMul, cInp, cUnk, cEnd
  Program = object
    data: seq[int]
    pntr: int

var f = open(inputf(1))
for i, l in slines(f, '|'):
  echo len(l), ' ', l

#[
var cd: Program
block:
  let f = open(inputf())
  for v in split(readAll(f), ','):
    var a: int
    discard parseUint(v, a)
    add(sq.data, a)
  close(f)

proc eval(sq: Program): uint =
  for i in countup(0, len(sq.data), 4):
    let
      n1 = sq[sq[i+1]]
      n2 = sq[sq[i+2]]
      oi = sq[i+3]
    case sq[i]
    of 1: sq[oi] = n1 + n2
    of 2: sq[oi] = n1 * n2
    of 3: 
    of 99: return sq[0]
    else:
      echo "Error"
      return 0
]#