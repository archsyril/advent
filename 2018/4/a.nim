import streams, parseutils, strutils, times, tables, algorithm
type Event = enum sleep, wake, start
type Record = object
  dt: DateTime
  case event: Event
  of start:
    id: uint
  else: discard
type Records = seq[Record]
type Schedule = seq[Slice[uint]]
type Schedules = Table[uint, Schedule]
type Asleep = array[60, uint]
proc process(fn: string): Records=
  var fs = newFileStream(fn)
  for ln in fs.lines:
    var rcrd: Record
    rcrd.dt = parse(ln[1..16], "yyyy-MM-dd HH:mm")
    case ln[19]:
    of 'w': rcrd.event = wake
    of 'f': rcrd.event = sleep
    else:
      rcrd.event = start
      discard parseUint(ln[26..29], rcrd.id)
    result.add rcrd
  fs.close()
proc convert(r: DateTime): uint=
  (r.hour*100 + r.minute).uint
proc schedule(rcrds: var Records): Schedules=
  result = initTable[uint, Schedule]()
  while rcrds.len != 0:
    let id = rcrds.pop().id
    if id notin result:
      result[id] = @[]
    while rcrds.len != 0 and rcrds[rcrds.len-1].event != start:
      var sleep = rcrds.pop().dt.convert
      var wake  = rcrds.pop().dt.convert
      result[id].add sleep..wake-1
#year, month, day, hour, minute
var records = process("input")
records.sort do (a,b: Record) -> int:
  result = cmp(a.dt, b.dt)
records.reverse()
proc mostAsleep(aslp: Asleep): uint=
  result = 0
  var top: uint
  for i, mn in aslp:
    if mn > top:
      result = i
      top = mn

for guard, times in schedule(records):
  var aslp: Asleep
  for time in times:
    for minute in 0.uint..61.uint:
      if minute in time:
        aslp[minute] += 1
  echo guard, ": ", max(aslp), ", ", aslp.mostAsleep()
  #let minute = aslp.mostAsleep()
  #if aslp[minute] > top:
  #  top = aslp[minute]
  #  id = guard
  #  top_minute = minute
  #  #echo guard, ": ", minute, ", ", aslp[minute]
#echo id * top_minute
#echo id, " ", top, " ", top_minute
# 4842, 10760
#[
proc mostAsleep(aslp: Asleep): uint=
  result = 0
  var top: uint
  for i, mn in aslp:
    if mn > top:
      result = i
      top = mn
template calcSleep(times: Slice[uint]): uint= times.b-times.a
var mostSleepy, sleepTime: uint
var sleepSchedule = schedule(records)
for guard, times in sleepSchedule:
  var guardSleepTime: uint
  for time in times:
    guardSleepTime += time.calcSleep()
  if guardSleepTime > sleepTime:
    echo guard, " ", guardSleepTime
    sleepTime = guardSleepTime
    mostSleepy = guard
var aslp: Asleep
for time in sleepSchedule[mostSleepy]:
  for minute in 0.uint..<60.uint:
    if minute in time:
      aslp[minute] += 1
let minute = aslp.mostAsleep
echo mostSleepy, ": ", minute, ", ", aslp[minute]
echo mostSleepy * minute
]#