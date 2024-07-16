import adventus

var file = dl(2023, 3, 1)

type
  PartKind = enum Empty, Number, Symbol
  Part = object
    case kind: PartKind
    of Number:
      value: int
    else: discard
  Line = ref array[140, Part]
  Schematic = array[3, Line]

converter toLine(s: string): Line =
  new result
  for i,c in pairs(s):
    let kind = case c:
      of '.': Empty
      of {'!','@','#','$','%','^','&','*','-','+','=','/'}: Symbol
      of {'0','1','2','3','4','5','6','7','8','9'}: Number
      else:
        echo "missed " & c
        Empty
    var part = Part(kind: kind)
    if part.kind == Number:
      part.value = int.parse $c
    result[i] = part

var schema: Schematic
schema[0] = file.readLine()
schema[1] = file.readLine()
schema[2] = file.readLine()
