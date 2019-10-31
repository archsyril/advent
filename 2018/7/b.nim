import tables, strutils, sequtils, algorithm

var f = open("2018/7/input")
type Item = ref object
  c: char
  satisfied: bool
  par, chl: seq[char]

func `$`(n: Item): string =
  "$1: ^($2) v($3)" % [
    $n.c, join(n.par, ", "), join(n.chl, ", ")
  ]

var key = initTable[char, Item](32)

proc item(c,d: char): void =
  if c notin key: key[c] = new Item; key[c].c = c
  if d notin key: key[d] = new Item; key[d].c = d
  add(key[c].par, d)
  add(key[d].chl, c)

for ln in lines(f):
  item(ln[5], ln[36])

var result: string

for v in values(key):
  echo v

for v in values(key):
  sort(v.par)
  sort(v.chl)

while len(result) != 26:
  
  var eye: Item
  for v in values(key):
    if v.satisfied: continue
    if isNil(eye) and len(v.par) == 0:
      eye = v
      eye.satisfied = true
      add(result, eye.c)
  
  for c in eye.chl:
    for i,v in pairs(key[c].par):
      delete(key[c].par, i)
      continue

  echo "> " & result