import streams, parseutils, strutils, times, tables
type Event = enum sleep, wake, start
type Record = object
  dt: DateTime
  case event: Event
  of start:
    id: uint
  else: discard
type Schedule = seq[Slice[uint]]
type Schedules = Table[uint, Schedule]
type Records = seq[Record]
proc process(fn: string): Records=
  var fs = newFileStream(fn)
  var i: uint
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
    inc i

proc organize(unorg: var Records)=
  var
    cur = initDateTime(1, mJan, 2000, 1, 1, 1, 1)
    ind: int
    tmp: Records
  for i in 0..Records.high:
    for j, rcrd in unorg:
      if rcrd.dt < cur:
        cur = rcrd.dt
        ind = j
    tmp.add unorg[ind]
  urorg = tmp

proc convertdt(r: DateTime): uint= (r.month.int*1000000 + r.monthday*10000 + r.hour*100 + r.minute).uint8
proc schedule(rcrds: var Records): Schedules=
  result = initTable[uint, Schedule]()
  result[0].id = rcrds.pop().id
  result[0]
  while i <= rcrds.high-3:
    var rcrd = rcrds[i]
    case rcrd.event:
    of start:
      id = rcrd.id
      if id notin result:
        result[id] = @[]
    else: discard
    result[id].add(rcrds[i+1].dt.convertdt() .. rcrds[i+2].dt.convertdt())
    if rcrds[i+3].event == start: i += 3
    else: i += 2

var records = process("input")
records.organize()
for guard, times in schedule(records):
  echo times
