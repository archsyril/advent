#458 players; last marble is worth 72019 points
import lists
const PlayerNum: int = 458
type
  Marble = ref object
    next, prev: Marble
    id: uint
  Circle = object
    curr: Marble
  Players = array[PlayerNum, uint]
proc newMarble(id: SomeNumber): Marble=
  new result
  result.id = id.uint
proc newCircle(): Circle= 
  var m = newMarble(0)
  m.prev = m
  m.next = m
  result.curr = m
proc addNext(before: var Marble, add: Marble): Marble=
  var after = before.next
  add.next = after
  add.prev = before
  before.next = add
  after.prev  = add
  return add
proc addNext(m: var Marble, add: SomeNumber): Marble= m.addNext(newMarble(add))
template add(c: var Circle, add: SomeNumber)= c.curr = c.curr.addNext(add)
proc deletePrev(m: var Marble): (Marble, SomeInteger)=
  let score = m.prev.id
  var before = m.prev.prev
  before.next = m
  m.prev = before
  return (m, score)
iterator items(c: Circle): SomeNumber=
  var
    id = c.curr.id
    cmp = c.curr.next
  yield c.curr.id
  while id != cmp.id:
    yield cmp.id
    cmp = cmp.next
#6
iterator ritems(c: Circle): SomeNumber=
  var
    id = c.curr.id
    cmp = c.curr.prev
  yield c.curr.id
  while id != cmp.id:
    yield cmp.id
    cmp = cmp.prev
iterator orderedItems(c: Circle): SomeNumber=
  var get = c.curr
  while get.id != 0:
    get = get.next
  var cmp = get.next
  yield get.id
  while get.id != cmp.id:
    yield cmp.id
    cmp = cmp.next
proc `$`(c: Circle): string=
  for i in c.orderedItems:
    result.add($i & " ")
var
  circle = newCircle()
  players: Players
  rounds: int= 72019 * 100 + 1
for i in 1..rounds:
  if i mod 23 == 0:
    let playerId = i mod PlayerNum
    var vl = circle.curr.prev.prev.prev.prev.prev.prev.deletePrev()
    players[playerId] += i.uint + vl[1].uint
    circle.curr = vl[0]
  else:
    circle.curr = circle.curr.next.addNext(i)
echo len(players)
echo max(players)