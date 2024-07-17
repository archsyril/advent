import adventus
import std/math

var file = dl(2023, 3, 1)

type
  PartKind = enum Empty, Number, Symbol
  Part = object
    case kind: PartKind
    of Number:
      value: int
      scanned: bool
    else: discard
  Line = ref array[0..140, Part]
  Schematic = ref array[-1..1, Line]

converter toLine(s: string): Line =
  new result
  for i,c in pairs(s):
    let kind = case c:
      of {'*'}: Symbol
      of {'0','1','2','3','4','5','6','7','8','9'}: Number
      else: Empty
    var part = Part(kind: kind)
    if part.kind == Number:
      part.value = int.parse $c
      part.scanned = false
    result[i] = part

iterator cycle(f: File): Schematic =
  var schema: Schematic
  new schema
  let emptyLine = toLine (".........." * 14)[0..139]
  schema[-1] = emptyLine
  schema[ 0] = file.readLine()
  schema[ 1] = file.readLine()
  yield schema
  while not f.endOfFile():
    schema[-1] = schema[0]
    schema[ 0] = schema[1]
    schema[ 1] = file.readLine()
    yield schema
  schema[-1] = schema[0]
  schema[ 0] = schema[1]
  schema[ 1] = emptyLine
  yield schema

type Direction = enum
  NW, N, NE,  W, E,  SW, S, SE

proc dir(d: Direction): tuple[x,y: int] =
  case d: #x, y
  of NW: (-1,-1)
  of N : ( 0,-1)
  of NE: ( 1,-1)
  of  W: (-1, 0)
  of  E: ( 1, 0)
  of SW: (-1, 1)
  of S : ( 0, 1)
  of SE: ( 1, 1)  

proc get(s: Schematic, x,y: int): Part =
  const emptyPart = Part(kind: Empty)
  if x < s[0][].low or s[0][].high < x: emptyPart
  else: s[y][x]
proc get(s: Schematic, d: Direction): Part =
  let (x,y) = dir(d)
  s.get(x,y)

proc check(p: Part): bool = ((p.kind == Number) and (p.scanned == false))

proc `$`(s: Schematic): string =
  for p in s[0][]:
    result.add case p.kind:
    of Empty: ' '
    of Symbol: '#'
    of Number: ($p.value)[0]

var total = 0
for s in cycle(file):
  for i in countup(0,139):
    let pr: Part = s[0][i]
    if pr.kind == Symbol:
      var true_numbers: seq[int]
      for d in [NW, N, NE, W, E, SW, S, SE]:
        var (x,y) = dir(d)
        x += i
        if s.get(x,y).check():
          var j = 1
          while s.get(x-j,y).kind == Number: # scan right until end
            inc j
          var numbers: seq[Part]
          while s.get(x-j+1,y).kind == Number:
            s[y][x-j+1].scanned = true
            numbers.add(s[y][x-j+1])
            dec j
          var
            true_number = 0
            zero_amnt = len(numbers) - 1
          for part in numbers:
            true_number += part.value * (10 ^ zero_amnt)
            dec zero_amnt
          true_numbers.add(true_number)
      if len(true_numbers) == 2:
        var true_number = 1
        for number in true_numbers:
          true_number *= number
        total += true_number
echo total
