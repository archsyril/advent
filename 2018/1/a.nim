import streams, parseutils, intsets

proc repeat(): int=
  var
    total: int
    freq: int
    st: IntSet
  while true:
    var fs = newFileStream("../input/1")
    for ln in fs.lines:
      discard parseInt(ln, freq)
      total += freq
      if total in st:
        return total
      st.incl total
    fs.close()

echo repeat()
