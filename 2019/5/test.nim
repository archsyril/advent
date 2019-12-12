# 0000 0000 8
# 0000 0000 16
# 0000 0000 *24
# 0000 0000 32

const First = false

type Bit = object
  a {.bitsize: 1.}, b {.bitsize: 1.}, c {.bitsize: 1.}, d {.bitsize: 1.}: uint
  e {.bitsize: 1.}, f {.bitsize: 1.}, g {.bitsize: 1.}, h {.bitsize: 1.}: uint
proc `$`(b: Bit): string =
  when First:
    $b.a & $b.b & $b.c & $b.d & " " & $b.e & $b.f & $b.g & $b.h
  else:
    $b.h & $b.g & $b.f & $b.e & " " & $b.d & $b.c & $b.b & $b.a

type Check = object {.union.}
  i: int8
  b: Bit
proc `$`(c: Check): string =
  const h = when First:
        "abcd efgh\n" 
  else: "hgfe dcba\n"
  h & $c.b & " = " & $c.i

var c: Check
c.i = 100'i8 # + 1echo c
echo c
