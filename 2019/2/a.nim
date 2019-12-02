from strutils import split
from parseutils import parseUInt

var sq: seq[uint]
block:
  let f = open("2019/2/input")
  for v in split(readAll(f), ','):
    var a: uint
    discard parseUint(v, a)
    add(sq, a)
  close(f)

proc eval(sq: seq[uint]; noun, verb: uint): uint =
  var sq = sq
  sq[1] = noun
  sq[2] = verb
  for i in countup(0, len(sq), 4):
    let
      n1 = sq[sq[i+1]]
      n2 = sq[sq[i+2]]
      oi = sq[i+3]
    case sq[i]
    of 1: sq[oi] = n1 + n2
    of 2: sq[oi] = n1 * n2
    of 99: return sq[0]
    else:
      echo "Error"
      return 0

#part 1
echo eval(sq, 12'u, 2'u)

#part 2
const input = 19690720'u
for n in 0'u..<100'u:
  for v in 0'u..<100'u:
    if eval(sq, n,v) == input:
      echo 100'u * n + v