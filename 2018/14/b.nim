const part2 = true
var
  choc = @[3'u8, 7'u8]
  (elf1, elf2) = (0, 1)
  total, sc1, sc2: uint8
  l: int

template tick(): untyped =
  (sc1, sc2) = (choc[elf1], choc[elf2]) 
  total = sc1 + sc2
  add(choc,
    if total >= 10'u8: @[total div 10, total mod 10] else: @[total]
  )
  l = len(choc)
  (elf1, elf2) = ((elf1+int sc1+1) mod l, (elf2+int sc2+1) mod l)

for x in 0..<10:
  tick()
while true:
  tick()
  when not part2:
    const chk = 652601
    if l > chk+10:
      echo choc[chk..chk+9]
      quit(0)
  else:
    let c = choc[l-6..l-1]
    const chk = [6'u8,5,2,6,0,1]
    if c == chk:
      echo l
      quit(0)
  #echo choc