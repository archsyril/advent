import adventus
from tables import initTable
from strutils import split

var orb = initTable[string, seq[string]](128)
for ln in lines(inputf()):
  let
    o = split(ln, ')', 1)
    (prim, sat) = (o[0], o[1])
  orb[prim] = sat

var (dir, idr) = (0, 0)
proc idrfind(ks: seq[string]) =
  for k in ks:
    idr += 1
    if k in orb:
      idrfind(orb[k])
  
for k, v in orb:
  dir += (len(v))
  idrfind(v)

echo 'd', dir
echo 'i', idr
echo dir + idr

# too high: 252829
