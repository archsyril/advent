from parseutils import parseInt
var (sum, n) = (0'i64,0)
for ln in lines("2019/1/input"):
  discard parseInt(ln, n)
  while (n = int(n/3)-2; n) > 0:
    sum += n
echo sum