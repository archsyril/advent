import streams, tables, sequtils, algorithm
type Orders = Table[char, seq[char]]
proc initOrders(fn: string): Orders=
  result = initTable[char, seq[char]](16)
  var fs = newFileStream(fn)
  for ln in fs.lines:
    let step = ln[36]
    let waits = ln[5]
    if step in result:
      result[step].add waits
    else:
      result[step] = @[]
  for k in result.keys:
    result[k].sort(system.cmp)

let ord = initOrders("input7.txt")
var str: string
for i in 0..12:
  for k, sq in ord:
    if sq.len == i:
      str.add k
for i in 12..0:
  stdout.write result[i]