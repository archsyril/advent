import adventus, strutils

let file = dl(2023, 2, 1)

type
  CubeKind = enum Red, Green, Blue
  Cubes = tuple[kind: CubeKind, num: int]
  Round = seq[Cubes]
  Game = seq[Round]
var games: array[1..100, Game]

# Parse
for i, ln in ilines(file):
  let i = i + 1
  var
    cube = @["",""]
    ln = ln.split(": ")[1]
    game: Game
  for ln in ln.split("; "):
    var round: Round
    for ln in ln.split(", "):
      var cube = ln.split(' ')
      var cubes: Cubes
      cubes.num = int.parse cube[0]
      cubes.kind = case cube[1]:
        of "red": Red
        of "green": Green
        of "blue": Blue
        else: break
      round.add(cubes)
    game.add(round)
  games[i] = game

# Solution
var total = 0
for i, game in pairs(games):
  var maxRed, maxGreen, maxBlue: int
  for round in game:
    for cubes in round:
      case cubes.kind:
        of Red:
          if cubes.num > maxRed:
            maxRed = cubes.num
        of Green:
          if cubes.num > maxGreen:
            maxGreen = cubes.num
        of Blue:
          if cubes.num > maxBlue:
            maxBlue = cubes.num
  total += maxRed * maxGreen * maxBlue
echo total