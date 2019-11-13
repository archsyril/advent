
type
  Obj = ref object
    x: int
var
  y = Obj(x:1)
  x = new y