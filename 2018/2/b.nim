import streams, sequtils
let fn = "../input/2"

proc check: (string, string)=
  var fs1 = newFileStream(fn)
  for s1 in fs1.lines:
    var fs2 = newFileStream(fn)
    for s2 in fs2.lines:
      var wrong: uint
      for c in zip(s1, s2):
        if c[0] != c[1]:
          inc wrong
      if wrong == 1:
        fs1.close()
        fs2.close()
        return (s1.string, s2.string)

let res= check()
echo res[0]
echo res[1]

