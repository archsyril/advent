#652601
import sequtils, strutils, algorithm, math
type
  Elves = object
    elf: array[2, int]
    recipes: seq[uint8]
proc initElves(a,b: uint8): Elves=
  result.elf[0] = 0
  result.elf[1] = 1
  result.recipes.add [a, b]
proc `$`(e: var Elves): string=
  var sq = e.recipes.map do (a: uint8) -> string: $a
  sq[e.elf[0]] = "(" & sq[e.elf[0]] & ")"
  sq[e.elf[1]] = "[" & sq[e.elf[1]] & "]"
  return sq.join(" ")
template score(e: Elves, n: int): untyped= e.recipes[e.elf[n]]

proc tryRecipe(e: var Elves): int8=
  let
    scr0 = e.score(0)
    scr1 = e.score(1)
  var
    vl = scr0 + scr1
    tmp: seq[uint8]
  while vl != 0:
    tmp.add vl mod 10.uint8
    vl = (vl.float / 10).uint8
    inc result
  tmp.reverse()
  e.recipes.add tmp
  let lnth = e.recipes.len
  e.elf[0] = ((e.elf[0] + scr0.int8 + 1) mod lnth).int
  e.elf[1] = ((e.elf[1] + scr1.int8 + 1) mod lnth).int
  
var
  elves = initElves(3,7)
  digits: int8
  ind = 9+9
#ind = (ind*2-2)
for tries in 4..ind:
  digits = elves.tryRecipe()
echo elves
#digits = 0
var lnth = elves.recipes.len
echo elves.recipes[lnth-14 .. lnth-1]
echo elves.recipes[lnth-(10+digits) .. lnth-digits-1]
for v in elves.recipes[lnth-(10+digits) .. lnth-digits-1]:
  stdout.write($v)
#[
wrong:
  1171414210 (this is it baby)
  1414210668 (didnt' say)
  1714142106 (too high)
  x 7141421066
  x 8822231222

]#