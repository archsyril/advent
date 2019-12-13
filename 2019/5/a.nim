import adventus

const
  debug = false
  size = 678 # this probably changes per user's puzzle input
type
  ParamMode = enum pos, imd
  Program = object
    code: array[size, int]
    pntr, inpt: int

bracketAccess(Program, code)
template `+=`(pr: var Program; i: int) = pr.pntr += i
#template `+`(pr: var Program; i: int): Program = pr += i; pr
template next(): var Program = pr.pntr += 1; pr
template skip() = pr.pntr += 1
template jump(p: int) = pr.pntr = p

template c(pr: Program): int = pr[pr.pntr]
proc get(pr: Program; md: ParamMode or int): int =
  if ParamMode(md) == pos:
    pr[pr[pr.pntr]]
  else:
    pr[pr.pntr]
proc put(pr: var Program; vl: int) =
  pr[pr[pr.pntr]] = vl
  when debug:
    echo "putting " & $vl & " at index " & $pt
proc modes(size: static[int]; pm: int): array[size, int] =
  for i, v in ichop(pm):
    result[i] = v
template modes(size: static[int]): array[size, int] =
  modes(size, pr.c div 100)

proc code_Add(pr: var Program) =
  let
    md = modes(2)
    a = get(next, md[0])
    b = get(next, md[1])
  put(next, a + b)
proc code_Mul(pr: var Program) =
  let
    md = modes(2)
    a = get(next, md[0])
    b = get(next, md[1])
  put(next, a * b)

proc code_Inp(pr: var Program) =
  put(next, pr.inpt)
proc code_Out(pr: var Program) =
  echo "Output[" & $(pr.pntr+1) & "]: " & $get(next, pos)

proc code_Jit(pr: var Program) =
  let
    md = modes(2)
    notZero = get(next, md[0]) != 0
  if notZero:
    jump get(next, md[1]) - 1
  else:
    pr += 1
proc code_Jif(pr: var Program) =
  let
    md = modes(2)
    isZero = get(next, md[0]) == 0
  if isZero:
    pr.pntr = get(next, md[1]) - 1
  else:
    skip

proc code_Les(pr: var Program) =
  let
    md = modes(2)
    a = get(next, md[0])
    b = get(next, md[1])
  put(next, int(a < b))

proc code_Eql(pr: var Program) =
  let
    md = modes(2)
    a = get(next, md[0])
    b = get(next, md[1])
  put(next, int(a == b))

proc code_Ext(pr: var Program) =
  quit("Program Exit", 0)

var base = Program(inpt: 5)
for i, l in slines(inputf(), ','):
  base[i] = parse(int, l)

proc eval(pr: var Program): void =
  case pr.c mod 100
  of  1: #[echo "add";]# code_Add(pr)
  of  2: #[echo "mul";]# code_Mul(pr) 
  of  3: #[echo "inp";]# code_Inp(pr)
  of  4: #[echo "out";]# code_Out(pr)
  of  5: #[echo "jit";]# code_Jit(pr)
  of  6: #[echo "jif";]# code_Jif(pr)
  of  7: #[echo "les";]# code_Les(pr)
  of  8: #[echo "eql";]# code_Eql(pr)
  of 99: #[echo "ext";]# code_Ext(pr)
  else:
    quit("Error " & $pr.c, 0)
  pr += 1
while true:
  eval(base)
