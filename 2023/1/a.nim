import adventus
import std/strutils

var file = dl(2023, 1, 1)

const Number = {'1','2','3','4','5','6','7','8','9'}

var total: int
for line in lines(file):
  var result: int
  result += line[ find(line, Number)].int * 10
  result += line[rfind(line, Number)].int
  total += result
echo total