import streams, tables
var
  fs = newFileStream("../input/2")
  two, three: uint

for ln in fs.lines:
  var vl = initTable[char, uint8](16)
  for c in ln:
    if c in vl:
      vl[c] += 1
    else:
      vl[c] = 1
  var
    tog2, tog3: bool
  for v in vl.values:
    if not tog2 and v == 2:
      two += 1
      tog2 = true
    elif not tog3 and v == 3:
      three += 1
      tog3 = true
fs.close()
echo two * three
