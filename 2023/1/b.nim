import adventus
import std/strutils

var file = dl(2023, 1, 1)

const Number = {'1','2','3','4','5','6','7','8','9'}
const WrittenNumber = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]

var total: int
for line in lines(file):
  var result: int
  let lnlen = len(line) - 1

  for i in countup(0, lnlen):
    let c = line[i]
    if c in Number:
      result += int.parse($c) * 10
      break
    var breakout = false
    for j, wn in pairs(WrittenNumber):
      let wlen = len(wn) - 1
      if i + wlen <= lnlen and wn == line[i..i+wlen]:
        result += (j+1) * 10
        breakout = true
        break
    if breakout: break

  for i in countdown(lnlen, 0):
    let c = line[i]
    if c in Number:
      result += int.parse($c)
      break
    var breakout = false
    for j, wn in pairs(WrittenNumber):
      let wlen = len(wn) - 1
      if i - wlen >= 0 and wn == line[i-wlen..i]:
        result += (j+1)
        breakout = true
        break
    if breakout: break

  total += result

echo total