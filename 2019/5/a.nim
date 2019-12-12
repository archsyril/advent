import adventus

const size = 678 # this probably changes per user's puzzle input
type
  ParamMode = enum pos, imd
  Program = object
    code: array[size, int]
    pntr, inpt: int

bracketAccess(Program, code)
template `+=`(pr: var Program; i: int) = pr.pntr += i
#template `+`(pr: var Program; i: int): Program = pr += i; pr
template next(pr: var Program): var Program = pr.pntr += 1; pr

proc get(pr: Program; md: ParamMode or int): int =
  if ParamMode(md) == pos:
    pr[pr[pr.pntr]]
  else:
    pr[pr.pntr]
proc put(pr: var Program; vl: int) =
  let pt = pr[pr.pntr]
  pr[pt] = vl
  echo "putting " & $vl & " at index " & $pt
proc modes(size: static[int]; pm: int): array[size, int] =
  for i, v in ichop(pm):
    result[i] = v
template c(pr: Program): int = pr[pr.pntr]

proc code_Add(pr: var Program) =
  var md = modes(2, pr.c div 100)
  for i, m in pairs(md):
    md[i] = get(next pr, m)
  put(next pr, md[0] + md[1])
proc code_Mul(pr: var Program) =
  var md = modes(2, pr.c div 100)
  for i, m in pairs(md):
    md[i] = get(next pr, m)
  put(next pr, md[0] * md[1])

proc code_Inp(pr: var Program) =
  put(next pr, pr.inpt)
proc code_Out(pr: var Program) =
  echo "Output: " & $get(next pr, pos)

proc code_Jit(pr: var Program) =
  let md = modes(2, pr.c div 100)
  #here, make jump if 1st param is non-zero
  pr.ptnr = get(next pr, md) - 1
proc code_Jif(pr: var Program) =

proc code_Les(pr: var Program) =
proc code_Eql(pr: var Program) =

proc code_Ext(pr: var Program) =
  quit("Program Exit", 0)

var base = Program(inpt: 1)
for i, l in slines(inputf(), ','):
  base[i] = parse(int, l)

proc eval(pr: var Program): void =
  case pr.c mod 100
  of  1: echo "add"; code_Add(pr)
  of  2: echo "mul"; code_Mul(pr) 
  of  3: echo "inp"; code_Inp(pr)
  of  4: echo "out"; code_Out(pr)
  of  5: echo "jit"; code_Jit(pr)
  of  5: echo "jif"; code_Jif(pr)
  of  5: echo "les"; code_Les(pr)
  of  5: echo "eql"; code_Eql(pr)
  of 99: echo "ext"; code_Ext(pr)
  else:
    quit("Error " & $pr.c, 0)
  pr += 1
while true:
  eval(base)
