import streams, sequtils
type
  Pot = enum
    empty = 0.int8, plant = 1.int8
  Pots = seq[Pot]
  Spread = object
    pots: array[5, Pot]
    effect: Pot
  Spreads = array[32, Spread]
  Cavern = tuple[pots: Pots, sprds: Spreads]
var setback = 2
template getType(ch: char): untyped=
  case ch:
  of '#': plant
  else: empty
proc process(fn: string): Cavern=
  var fs = newFileStream(fn)
  var ln = fs.readLine()
  result[0].add empty
  result[0].add empty
  result[0].add empty
  result[0].add empty
  result[0].add empty
  for ch in ln[15 .. ln.len-1]:
    result[0].add ch.getType()
  result[0].add empty
  result[0].add empty
  result[0].add empty
  result[0].add empty
  discard fs.readLine()
  var i: uint
  for ln in fs.lines:
    for j, ch in ln[0..4]:
      result[1][i].pots[j] = ch.getType()
    result[1][i].effect = ln[9].getType()
    inc(i)
template items(sp: Spread): untyped= sp.pots.items()
proc `$`(pot: Pot): string=
  case pot:
  of plant: "#"
  of empty: "."
proc `$`(pots: Pots): string=
  for pot in pots:
    result.add $pot
proc `$`(sprd: Spread): string=
  for pot in sprd:
    result.add $pot
  result.add " => " & $sprd.effect
template same(pots: Pots, i: int, sprd: Spread): bool= pots[i..i+4] == sprd.pots
proc mutate(cvrn: var Cavern): string=
  var tmpPots: seq[Pot] = repeat(empty, cvrn.pots.len+setback)
  for sprd in cvrn.sprds:
    let pots = cvrn.pots
    for i in 0..pots.len-7:
      if pots.same(i, sprd):
        # two is added because i isn't centered
        tmpPots[i+2] = sprd.effect
  cvrn.pots = tmpPots
  return $cvrn.pots

var cavern = process("input")
echo cavern.pots
#97 - 50000000000
for i in 1..100:
  echo i, " ", cavern.mutate()
#for i, pot in cavern.pots:
#  if pot == plant:
#    result += i-5
#"..........................".len-5
  var result: uint64 = 0
var subt: uint64= (50000000000 - 97).uint64
#echo subt
#..........................##.#..##.#..##.#..##.#..##.#....##.#..##.#..##.#..##.#....##.#....##.#..##.#....##.#..##.#..##.#..##.#..##.#....##.#..##.#..##.#..##.#..##.#....##.#..##.#..##.#..##.#....##.#
for i, c in ".....................##.#..##.#..##.#..##.#..##.#....##.#..##.#..##.#..##.#....##.#....##.#..##.#....##.#..##.#..##.#..##.#..##.#....##.#..##.#..##.#..##.#..##.#....##.#..##.#..##.#..##.#....##.#":
  if c == '#':
    result += (subt + i.uint64)
echo result
#[
  too low:
    4049999996586
    4049999996667
  too high:
    18446740023709566427
]#