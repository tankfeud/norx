## A small Boulder Dash-style game built with Norx.
import os
import norx

const
  TileSize = 28.0'f32
  GridLeft = -280.0'f32
  GridTop = -210.0'f32
  GridWidth = 20
  GridHeight = 15
  GameTime = 120.0'f32
  MoveInterval = 0.11'f32
  FallInterval = 0.18'f32
  RandomBoulderCount = 10
  DiamondCount = 6

type
  TileKind = enum
    tkEmpty
    tkDirt
    tkWall
    tkBoulder
    tkDiamond
    tkExit

  GameState = enum
    gsPlaying
    gsWon
    gsLost

  TileGrid = array[GridHeight, array[GridWidth, TileKind]]

var
  grid, levelTemplate: TileGrid
  tileObjects: array[GridHeight, array[GridWidth, ptr orxOBJECT]]
  tileFalling: array[GridHeight, array[GridWidth, bool]]
  playerX, playerY: int
  levelStartX, levelStartY: int
  playerObject: ptr orxOBJECT
  hudObject: ptr orxOBJECT
  messageObject: ptr orxOBJECT
  coreClock: ptr orxCLOCK
  score: int
  diamondsLeft: int
  timeRemaining: float32
  moveCooldown: float32
  fallAccumulator: float32
  messageTime: float32
  gameState: GameState
  levelName: string
  randomCaveNumber: int
  startupFrames: int

let startupTest = "--startup-test" in commandLineParams()

proc playSound(configName: string) =
  if playerObject != nil:
    discard playerObject.addSound(configName)

proc tilePosition(x, y: int): orxVECTOR =
  newVector(GridLeft + TileSize * (x.float32 + 0.5'f32),
            GridTop + TileSize * (y.float32 + 0.5'f32))

proc deleteObject(gameObject: var ptr orxOBJECT) =
  if gameObject != nil:
    discard objectDelete(gameObject)
    gameObject = nil

proc removeTile(x, y: int) =
  deleteObject(tileObjects[y][x])
  grid[y][x] = tkEmpty
  tileFalling[y][x] = false

proc clearLevel() =
  for y in 0 ..< GridHeight:
    for x in 0 ..< GridWidth:
      removeTile(x, y)
  deleteObject(playerObject)

proc readLevel(): bool =
  if pushSection("LevelData").isFailure:
    echo "Could not select the LevelData config section"
    return false
  defer:
    discard popSection()

  var playerCount = 0
  var exitCount = 0
  diamondsLeft = 0

  for y in 0 ..< GridHeight:
    let key = "Row" & $y
    let rowValue = getString(key)
    if rowValue == nil:
      echo "Missing LevelData.", key
      return false

    let row = $rowValue
    if row.len != GridWidth:
      echo "LevelData.", key, " must contain exactly ", GridWidth, " tiles"
      return false

    for x, symbol in row:
      case symbol
      of ' ': grid[y][x] = tkEmpty
      of '.': grid[y][x] = tkDirt
      of '#': grid[y][x] = tkWall
      of 'O': grid[y][x] = tkBoulder
      of 'D':
        grid[y][x] = tkDiamond
        inc diamondsLeft
      of 'E':
        grid[y][x] = tkExit
        inc exitCount
      of '@':
        grid[y][x] = tkEmpty
        playerX = x
        playerY = y
        inc playerCount
      else:
        echo "Unknown level symbol '", symbol, "' at ", x, ",", y
        return false

  if playerCount != 1 or exitCount != 1 or diamondsLeft == 0:
    echo "Level requires one player, one exit, and at least one diamond"
    return false
  result = true

proc countTemplateTiles(tile: TileKind): int =
  for row in levelTemplate:
    for cell in row:
      if cell == tile:
        inc result

proc isTemplateReachable(targetX, targetY: int): bool =
  var visited: array[GridHeight, array[GridWidth, bool]]

  proc visit(x, y: int) =
    if x < 0 or x >= GridWidth or y < 0 or y >= GridHeight or visited[y][x]:
      return
    if levelTemplate[y][x] == tkWall or levelTemplate[y][x] == tkBoulder:
      return
    visited[y][x] = true
    visit(x - 1, y)
    visit(x + 1, y)
    visit(x, y - 1)
    visit(x, y + 1)

  visit(levelStartX, levelStartY)
  result = visited[targetY][targetX]

proc placeRandomTiles(tile: TileKind; count: int; requireReachable = false): bool =
  var placed = 0
  var attempts = 0
  while placed < count and attempts < 1000:
    inc attempts
    let x = getRandomU32(2, GridWidth.orxU32 - 3).int
    let y = getRandomU32(2, GridHeight.orxU32 - 3).int
    if levelTemplate[y][x] == tkDirt and
        (not requireReachable or isTemplateReachable(x, y)):
      levelTemplate[y][x] = tile
      inc placed
  result = placed == count

proc generateRandomTemplate(): bool =
  for _ in 0 ..< 100:
    for y in 0 ..< GridHeight:
      for x in 0 ..< GridWidth:
        if x == 0 or x == GridWidth - 1 or y == 0 or y == GridHeight - 1:
          levelTemplate[y][x] = tkWall
        elif getRandomU32(0, 99) < 22:
          levelTemplate[y][x] = tkEmpty
        else:
          levelTemplate[y][x] = tkDirt

    levelStartX = 1
    levelStartY = 1
    levelTemplate[1][1] = tkEmpty
    levelTemplate[1][2] = tkEmpty
    levelTemplate[2][1] = tkEmpty
    levelTemplate[2][2] = tkEmpty
    levelTemplate[GridHeight - 2][GridWidth - 2] = tkExit

    if not placeRandomTiles(tkBoulder, RandomBoulderCount):
      continue
    if not isTemplateReachable(GridWidth - 2, GridHeight - 2):
      continue
    if not placeRandomTiles(tkDiamond, DiamondCount, true):
      continue

    inc randomCaveNumber
    levelName = "Random " & $randomCaveNumber
    return true

proc configName(tile: TileKind): cstring =
  case tile
  of tkDirt: "Dirt"
  of tkWall: "Wall"
  of tkBoulder: "Boulder"
  of tkDiamond: "Diamond"
  of tkExit: "Exit"
  of tkEmpty: nil

proc createLevelObjects(): bool =
  for y in 0 ..< GridHeight:
    for x in 0 ..< GridWidth:
      let section = configName(grid[y][x])
      if section == nil:
        continue

      let gameObject = objectCreateFromConfig(section)
      if gameObject == nil:
        echo "Could not create object from config section ", section
        return false

      if gameObject.setPosition(tilePosition(x, y)).isFailure:
        return false
      tileObjects[y][x] = gameObject

  playerObject = objectCreateFromConfig("Player")
  if playerObject == nil:
    echo "Could not create the player"
    return false
  result = playerObject.setPosition(tilePosition(playerX, playerY)).isSuccess

proc setMessage(text: string; duration: float32 = 0.0'f32) =
  discard messageObject.setTextString(text)
  discard messageObject.enable(true)
  messageTime = duration

proc hideMessage() =
  discard messageObject.enable(false)
  messageTime = 0.0

proc loseGame(reason: string) =
  gameState = gsLost
  playSound("LoseSound")
  setMessage(reason & "! Final score: " & $score & " - press R to restart")

proc updateUI() =
  let seconds = max(0, int(timeRemaining + 0.999'f32))
  let hud = levelName & "    Score: " & $score & "    Diamonds: " & $diamondsLeft &
            "    Time: " & $seconds
  discard hudObject.setTextString(hud)

proc resetGame(): bool =
  clearLevel()
  score = 0
  timeRemaining = GameTime
  moveCooldown = 0.0
  fallAccumulator = 0.0
  gameState = gsPlaying
  hideMessage()

  grid = levelTemplate
  playerX = levelStartX
  playerY = levelStartY
  diamondsLeft = countTemplateTiles(tkDiamond)
  if not createLevelObjects():
    return false
  updateUI()
  result = true

proc moveTile(fromX, fromY, toX, toY: int; falling = false) =
  grid[toY][toX] = grid[fromY][fromX]
  grid[fromY][fromX] = tkEmpty
  tileObjects[toY][toX] = tileObjects[fromY][fromX]
  tileObjects[fromY][fromX] = nil
  tileFalling[toY][toX] = falling
  tileFalling[fromY][fromX] = false
  discard tileObjects[toY][toX].setPosition(tilePosition(toX, toY))

proc movePlayerTo(x, y: int) =
  playerX = x
  playerY = y
  discard playerObject.setPosition(tilePosition(x, y))

proc tryMove(dx, dy: int): bool =
  let targetX = playerX + dx
  let targetY = playerY + dy
  if targetX < 0 or targetX >= GridWidth or targetY < 0 or targetY >= GridHeight:
    return false

  case grid[targetY][targetX]
  of tkEmpty:
    discard
  of tkDirt:
    removeTile(targetX, targetY)
    playSound("DigSound")
  of tkDiamond:
    removeTile(targetX, targetY)
    inc score, 10
    dec diamondsLeft
    playSound("CollectSound")
    if diamondsLeft == 0:
      setMessage("EXIT OPEN - reach the green door!", 2.5)
  of tkBoulder:
    if dy != 0:
      return false
    let beyondX = targetX + dx
    if beyondX < 0 or beyondX >= GridWidth or grid[targetY][beyondX] != tkEmpty:
      return false
    moveTile(targetX, targetY, beyondX, targetY)
    playSound("PushSound")
  of tkExit:
    if diamondsLeft != 0:
      setMessage("Collect every diamond before exiting", 1.5)
      return false
    movePlayerTo(targetX, targetY)
    gameState = gsWon
    playSound("WinSound")
    setMessage("CAVE CLEARED! Final score: " & $score & " - press R to restart")
    return true
  of tkWall:
    return false

  movePlayerTo(targetX, targetY)
  result = true

proc updateMovement(deltaTime: float32) =
  moveCooldown = max(0.0'f32, moveCooldown - deltaTime)

  var dx, dy: int
  if isActive("MoveUp"):
    dy = -1
  elif isActive("MoveDown"):
    dy = 1
  elif isActive("MoveLeft"):
    dx = -1
  elif isActive("MoveRight"):
    dx = 1
  else:
    moveCooldown = 0.0
    return
  if moveCooldown > 0.0:
    return

  discard tryMove(dx, dy)
  moveCooldown = MoveInterval

proc isLoose(tile: TileKind): bool = tile == tkBoulder or tile == tkDiamond

proc isPlayerAt(x, y: int): bool = playerX == x and playerY == y

proc isEmptyAt(x, y: int): bool =
  x >= 0 and x < GridWidth and y >= 0 and y < GridHeight and
    grid[y][x] == tkEmpty and not isPlayerAt(x, y)

proc updateFallingTiles() =
  for y in countdown(GridHeight - 2, 0):
    for x in 0 ..< GridWidth:
      let tile = grid[y][x]
      if not isLoose(tile):
        continue

      if isPlayerAt(x, y + 1):
        if tileFalling[y][x]:
          moveTile(x, y, x, y + 1, true)
          loseGame("CRUSHED")
          return
        tileFalling[y][x] = false
      elif grid[y + 1][x] == tkEmpty:
        moveTile(x, y, x, y + 1, true)
      elif isLoose(grid[y + 1][x]) and isEmptyAt(x - 1, y) and isEmptyAt(x - 1, y + 1):
        moveTile(x, y, x - 1, y + 1, true)
      elif isLoose(grid[y + 1][x]) and isEmptyAt(x + 1, y) and isEmptyAt(x + 1, y + 1):
        moveTile(x, y, x + 1, y + 1, true)
      elif tileFalling[y][x]:
        discard tileObjects[y][x].addSound("LandSound")
        tileFalling[y][x] = false

proc runStartupChecks(): bool =
  template check(condition: bool; message: string) =
    if not condition:
      echo "Startup check failed: ", message
      return false

  template reset() =
    check(resetGame(), "level reset")

  check(diamondsLeft == DiamondCount, "expected six diamonds")

  let playerSize = playerObject.getSize()
  check(playerSize.fX == 64.0 and playerSize.fY == 64.0,
        "player texture is not using its full region")
  check(tryMove(1, 0) and grid[1][2] == tkEmpty, "player could not dig through dirt")

  reset()
  removeTile(9, 1)
  movePlayerTo(9, 1)
  check(tryMove(1, 0) and score == 10 and diamondsLeft == DiamondCount - 1,
        "diamond collection")

  reset()
  removeTile(4, 1)
  removeTile(6, 1)
  movePlayerTo(4, 1)
  check(tryMove(1, 0) and grid[1][6] == tkBoulder and playerX == 5,
        "horizontal boulder push")

  reset()
  removeTile(17, 13)
  movePlayerTo(17, 13)
  check(not tryMove(1, 0) and gameState == gsPlaying, "exit opened too early")
  diamondsLeft = 0
  check(tryMove(1, 0) and gameState == gsWon, "open exit")

  reset()
  removeTile(13, 3)
  moveTile(10, 1, 13, 3)
  removeTile(12, 2)
  removeTile(12, 3)
  updateFallingTiles()
  check(grid[3][12] == tkBoulder and tileFalling[3][12],
        "boulder did not roll off a diamond")

  reset()
  removeTile(10, 2)
  moveTile(13, 2, 10, 2)
  removeTile(9, 1)
  removeTile(9, 2)
  updateFallingTiles()
  check(grid[2][9] == tkDiamond and tileFalling[2][9],
        "diamond did not roll off a boulder")

  reset()
  removeTile(10, 2)
  updateFallingTiles()
  check(grid[2][10] == tkDiamond and tileFalling[2][10],
        "unsupported diamond did not fall")

  reset()
  removeTile(13, 3)
  movePlayerTo(13, 3)
  updateFallingTiles()
  check(grid[2][13] == tkBoulder and gameState == gsPlaying,
        "player did not support a resting boulder")

  removeTile(14, 3)
  check(tryMove(1, 0), "player could not move past a boulder")
  updateFallingTiles()
  check(grid[3][13] == tkBoulder and tileFalling[3][13],
        "boulder did not fall behind the player")

  removeTile(13, 4)
  movePlayerTo(13, 4)
  updateFallingTiles()
  check(gameState == gsLost, "moving boulder did not crush the player")

  let original = (tiles: levelTemplate, x: levelStartX, y: levelStartY,
                  name: levelName, number: randomCaveNumber)
  for _ in 0 ..< 25:
    check(generateRandomTemplate(), "random cave generation")
    check(countTemplateTiles(tkDiamond) == DiamondCount and
          countTemplateTiles(tkBoulder) == RandomBoulderCount and
          countTemplateTiles(tkExit) == 1, "random cave contents")
    for x in 0 ..< GridWidth:
      check(levelTemplate[0][x] == tkWall and levelTemplate[GridHeight - 1][x] == tkWall,
            "random cave horizontal border")
    for y in 0 ..< GridHeight:
      check(levelTemplate[y][0] == tkWall and levelTemplate[y][GridWidth - 1] == tkWall,
            "random cave vertical border")
      for x in 0 ..< GridWidth:
        check(levelTemplate[y][x] != tkDiamond or isTemplateReachable(x, y),
              "unreachable random cave diamond")
  check(resetGame() and diamondsLeft == DiamondCount,
        "random cave could not be instantiated")

  levelTemplate = original.tiles
  levelStartX = original.x
  levelStartY = original.y
  levelName = original.name
  randomCaveNumber = original.number
  result = resetGame()
  if result:
    echo "Boulder Dash startup checks passed"

proc updateGame(clockInfo: ptr orxCLOCK_INFO; context: pointer) {.cdecl.} =
  if isActive("Quit"):
    discard eventSendShort(EVENT_TYPE_SYSTEM, SYSTEM_EVENT_CLOSE.orxU32)
    return

  if hasBeenActivated("NewLevel"):
    if not generateRandomTemplate() or not resetGame():
      discard eventSendShort(EVENT_TYPE_SYSTEM, SYSTEM_EVENT_CLOSE.orxU32)
    else:
      setMessage("NEW RANDOM CAVE", 1.5)
    return

  if hasBeenActivated("Restart"):
    if not resetGame():
      discard eventSendShort(EVENT_TYPE_SYSTEM, SYSTEM_EVENT_CLOSE.orxU32)
    return

  let deltaTime = clockInfo.fDT.float32
  if gameState == gsPlaying and messageTime > 0.0:
    messageTime -= deltaTime
    if messageTime <= 0.0:
      hideMessage()

  if gameState != gsPlaying:
    return

  timeRemaining = max(0.0'f32, timeRemaining - deltaTime)
  if timeRemaining <= 0.0:
    loseGame("TIME UP")
    updateUI()
    return

  updateMovement(deltaTime)
  fallAccumulator += deltaTime
  while fallAccumulator >= FallInterval and gameState == gsPlaying:
    fallAccumulator -= FallInterval
    updateFallingTiles()
  updateUI()

proc init(): orxSTATUS {.cdecl.} =
  echo "Boulder Dash starting with ORX ", getVersionFullString()

  if viewportCreateFromConfig("MainViewport") == nil:
    echo "Could not create the main viewport"
    return STATUS_FAILURE

  hudObject = objectCreateFromConfig("Hud")
  let helpObject = objectCreateFromConfig("Help")
  messageObject = objectCreateFromConfig("Message")
  if hudObject == nil or helpObject == nil or messageObject == nil:
    echo "Could not create the user interface"
    return STATUS_FAILURE

  if not readLevel():
    return STATUS_FAILURE
  levelTemplate = grid
  levelStartX = playerX
  levelStartY = playerY
  levelName = "Cave 1"
  if not resetGame():
    return STATUS_FAILURE
  if startupTest and not runStartupChecks():
    return STATUS_FAILURE

  coreClock = clockGet(CLOCK_KZ_CORE)
  if coreClock == nil:
    return STATUS_FAILURE
  result = clockRegister(coreClock, updateGame, nil, MODULE_ID_MAIN, CLOCK_PRIORITY_NORMAL)

proc run(): orxSTATUS {.cdecl.} =
  if startupTest:
    inc startupFrames
    if startupFrames >= 5:
      return STATUS_FAILURE
  result = STATUS_SUCCESS

proc exit() {.cdecl.} =
  if coreClock != nil:
    discard unregister(coreClock, updateGame, nil)
  echo "Boulder Dash stopped"

proc bootstrap(): orxSTATUS {.cdecl.} =
  let configPath = getCurrentDir() / "data" / "config"
  result = addStorage(CONFIG_KZ_RESOURCE_GROUP, configPath, false)
  if result.isFailure:
    echo "Could not add config storage: ", configPath

when isMainModule:
  if setBootstrap(bootstrap).isFailure:
    quit("Could not register the bootstrap callback")
  execute(init, run, exit)
