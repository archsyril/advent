import streams, parseutils, math, sequtils
type Star = object
  x,y, xv,yv: ref int
type Stars = object
  stars: array[355, Star]
  x,y: seq[ref int]
template newStar(st: var Star)= new st.x; new st.y; new st.xv; new st.yv
template moveParser[T](str: string, asgn: T)=
  let sub = str
  if sub[0] == '-': discard sub[0.. sub.len-1].parseInt(asgn)
  else: discard sub[1.. sub.len-1].parseInt(asgn)
template `[]`[T](sts: Stars, i: T): Star= sts.stars[i]
proc process(fn: string): Stars=
  var
    fs = newFileStream(fn)
    i: uint
  for ln in fs.lines:
    newStar(result[i])
    discard if ln[10] == '-': ln[10..15].parseInt(result[i].x[])
            else:             ln[11..15].parseInt(result[i].x[])
    discard if ln[18] == '-': ln[18..23].parseInt(result[i].y[])
            else:             ln[19..23].parseInt(result[i].y[])
    discard if ln[36] == '-': ln[36..37].parseInt(result[i].xv[])
            else:             ln[37..37].parseInt(result[i].xv[])
    discard if ln[40] == '-': ln[40..41].parseInt(result[i].yv[])
            else:             ln[41..41].parseInt(result[i].yv[])
    result.x.add(result[i].x)
    result.y.add(result[i].y)
    inc(i)
proc max[T](vs: seq[ref T]): T=
  result = T.low
  for v in vs:
    if result < v:
      result = v
proc min[T](vs: seq[ref T]): T=
  result = T.high
  for v in vs:
    if result > v:
      result = v
converter derefInt(ri: ref int): int= ri[]
template `$`(ri: ref SomeNumber): string= $(ri[])
template update(st: var Star, by: int)= st.x[] += (st.xv * by); st.y[] += (st.xv * by)
proc avg[T](sq: seq[ref T]): T=
  result = 0
  for each in sq:
    result += each[]
  result = (result.float / sq.len.float).T
#proc area(sts: Stars): int= min(sts.x).abs+max(sts.x).abs * min(sts.y).abs+max(sts.y).abs
proc wait(sts: var Stars, scnds: int = 1)= 
  for i in 0..sts.stars.high:
    sts[i].update(scnds)
var stars = process("input")
#27..33
stars.wait(10127)
echo stars.x.avg, " ", stars.y.avg
echo stars.y