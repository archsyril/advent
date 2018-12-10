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
type UnorgRecords = seq[Record]
type Records = array[1040, Record]
proc process(fn: string): UnorgRecords=
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

proc organize(unorg: var UnorgRecords): Records=
  let sml: DateTime = initDateTime(1, mJan, 2000, 1, 1, 1, 1)
  for i in 0..Records.high:
    var
      ind: int
      cur = sml
    for j, rcrd in unorg:
      if rcrd.dt < cur:
        cur = rcrd.dt
        ind = j
    result[i] = unorg[ind]
    unorg.delete(ind)

proc convertdt(r: DateTime): uint= (r.month.int*1000000 + r.monthday*10000 + r.hour*100 + r.minute).uintN
proc schedule(rcrds: var Records): Schedules=
  result = initTable[uint, Schedule]()
  var i, id: uint
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

var
  records: Records
block:
  var unorganized = process("input4.txt")
  records = unorganized.organize()
for s in schedule(records):
  echo s