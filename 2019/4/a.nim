import adventus

const part1 = true

type Password = array[6, int8]
# within input range
# two adjacent # are the same.
# l-r, # never decrease
# HOW MANY DIFFERENT PASSWORDS ARE WITHIN THE RANGE

const
  puzzleInput = "353096-843212"
  l = parse(int, puzzleInput[0..5])
  h = parse(int, puzzleInput[7..12])
var p = l

proc conv(p: int): Password =
  var p = p
  for i in countdown(5,0):
    result[i] = int8 p mod 10
    p = p div 10

var total = 0
while p <= h:
  let ps = conv(p)
  block success:
    var (pr, ad, sm) = (-1, false, 0)
    for dg in ps:
      if dg == pr:
        ad = true
      elif dg < pr:
        break success
      pr = dg
    if ad:
      when part1:
        total += 1
      else:
        var cn: array[10, uint8]
        for dg in ps:
          cn[dg] += 1
        var vl = false
        for c in cn:
          if c == 2:
            vl = true
        if vl:
          total += 1
  p += 1

echo total