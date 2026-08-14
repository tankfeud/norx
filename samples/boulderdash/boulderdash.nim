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

var
  grid: array[GridHeight, array[GridWidth, TileKind]]
  levelTemplate: array[GridHeight, array[GridWidth, TileKind]]
  tileObjects: array[GridHeight, array[GridWidth, ptr orxOBJECT]]
  tileFalling: array[GridHeight, array[GridWidth, bool]]
  playerX, playerY: int
  levelStartX, levelStartY: int
  playerObject: ptr orxOBJECT
  hudObject: ptr orxOBJECT
  helpObject: ptr orxOBJECT
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

proc inputActive(name: cstring): bool = isActive(name) == orxTRUE

proc inputActivated(name: cstring): bool = hasBeenActivated(name) == orxTRUE

proc playSound(configName: cstring) =
  if playerObject != nil:
    discard playerObject.addSound(configName)

proc tilePosition(x, y: int): orxVECTOR =
  newVECTOR(GridLeft + TileSize * (x.float32 + 0.5'f32),
            GridTop + TileSize * (y.float32 + 0.5'f32), 0.0)

proc deleteObject(gameObject: var ptr orxOBJECT) =
  if gameObject != nil:
    discard objectDelete(gameObject)
    gameObject = nil

proc clearLevel() =
  for y in 0 ..< GridHeight:
    for x in 0 ..< GridWidth:
      deleteObject(tileObjects[y][x])
      grid[y][x] = tkEmpty
      tileFalling[y][x] = false
  deleteObject(playerObject)

proc parseTile(symbol: char; x, y: int): bool =
  case symbol
  of ' ':
    grid[y][x] = tkEmpty
  of '.':
    grid[y][x] = tkDirt
  of '#':
    grid[y][x] = tkWall
  of 'O':
    grid[y][x] = tkBoulder
  of 'D':
    grid[y][x] = tkDiamond
    inc diamondsLeft
  of 'E':
    grid[y][x] = tkExit
  of '@':
    grid[y][x] = tkEmpty
    playerX = x
    playerY = y
  else:
    echo "Unknown level symbol '", symbol, "' at ", x, ",", y
    return false
  result = true

proc readLevel(): bool =
  if pushSection("LevelData") == STATUS_FAILURE:
    echo "Could not select the LevelData config section"
    return false
  defer:
    discard popSection()

  var playerCount = 0
  var exitCount = 0
  diamondsLeft = 0

  for y in 0 ..< GridHeight:
    let key = "Row" & $y
    let rowValue = getString(key.cstring)
    if rowValue == nil:
      echo "Missing LevelData.", key
      return false

    let row = $rowValue
    if row.len != GridWidth:
      echo "LevelData.", key, " must contain exactly ", GridWidth, " tiles"
      return false

    for x, symbol in row:
      if symbol == '@':
        inc playerCount
      elif symbol == 'E':
        inc exitCount
      if not parseTile(symbol, x, y):
        return false

  if playerCount != 1 or exitCount != 1 or diamondsLeft == 0:
    echo "Level requires one player, one exit, and at least one diamond"
    return false
  result = true

proc saveLevelTemplate(name: string) =
  levelTemplate = grid
  levelStartX = playerX
  levelStartY = playerY
  levelName = name

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
  for generationAttempt in 0 ..< 100:
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

    if not placeRandomTiles(tkBoulder, 10):
      continue
    if not isTemplateReachable(GridWidth - 2, GridHeight - 2):
      continue
    if not placeRandomTiles(tkDiamond, 6, true):
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

      var position = tilePosition(x, y)
      if gameObject.setPosition(addr position) == STATUS_FAILURE:
        return false
      tileObjects[y][x] = gameObject

  playerObject = objectCreateFromConfig("Player")
  if playerObject == nil:
    echo "Could not create the player"
    return false
  var position = tilePosition(playerX, playerY)
  result = playerObject.setPosition(addr position) == STATUS_SUCCESS

proc setMessage(text: string; duration: float32 = 0.0'f32) =
  discard messageObject.setTextString(text.cstring)
  discard messageObject.enable(true)
  messageTime = duration

proc hideMessage() =
  discard messageObject.enable(false)
  messageTime = 0.0

proc updateUI() =
  let seconds = max(0, int(timeRemaining + 0.999'f32))
  let hud = levelName & "    Score: " & $score & "    Diamonds: " & $diamondsLeft &
            "    Time: " & $seconds
  discard hudObject.setTextString(hud.cstring)

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

proc removeTile(x, y: int) =
  deleteObject(tileObjects[y][x])
  grid[y][x] = tkEmpty
  tileFalling[y][x] = false

proc moveTile(fromX, fromY, toX, toY: int; falling = false) =
  grid[toY][toX] = grid[fromY][fromX]
  grid[fromY][fromX] = tkEmpty
  tileObjects[toY][toX] = tileObjects[fromY][fromX]
  tileObjects[fromY][fromX] = nil
  tileFalling[toY][toX] = falling
  tileFalling[fromY][fromX] = false
  var position = tilePosition(toX, toY)
  discard tileObjects[toY][toX].setPosition(addr position)

proc movePlayerTo(x, y: int) =
  playerX = x
  playerY = y
  var position = tilePosition(x, y)
  discard playerObject.setPosition(addr position)

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
  let moving = inputActive("MoveUp") or inputActive("MoveDown") or
               inputActive("MoveLeft") or inputActive("MoveRight")
  if not moving:
    moveCooldown = 0.0
    return
  if moveCooldown > 0.0:
    return

  if inputActive("MoveUp"):
    discard tryMove(0, -1)
  elif inputActive("MoveDown"):
    discard tryMove(0, 1)
  elif inputActive("MoveLeft"):
    discard tryMove(-1, 0)
  elif inputActive("MoveRight"):
    discard tryMove(1, 0)
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
          gameState = gsLost
          playSound("LoseSound")
          setMessage("CRUSHED! Final score: " & $score & " - press R to restart")
          return
        tileFalling[y][x] = false
      elif grid[y + 1][x] == tkEmpty:
        moveTile(x, y, x, y + 1, true)
      elif isLoose(grid[y + 1][x]) and isEmptyAt(x - 1, y) and isEmptyAt(x - 1, y + 1):
        moveTile(x, y, x - 1, y + 1, true)
      elif isLoose(grid[y + 1][x]) and isEmptyAt(x + 1, y) and isEmptyAt(x + 1, y + 1):
        moveTile(x, y, x + 1, y + 1, true)
      else:
        if tileFalling[y][x]:
          discard tileObjects[y][x].addSound("LandSound")
        tileFalling[y][x] = false

proc runStartupChecks(): bool =
  if diamondsLeft != 6:
    echo "Startup check failed: expected six diamonds"
    return false

  var playerSize: orxVECTOR
  if playerObject.getSize(addr playerSize) == nil or playerSize.fX != 64.0 or playerSize.fY != 64.0:
    echo "Startup check failed: player texture is not using its full region"
    return false

  if not tryMove(1, 0) or grid[1][2] != tkEmpty:
    echo "Startup check failed: player could not dig through dirt"
    return false

  if not resetGame():
    return false
  removeTile(9, 1)
  movePlayerTo(9, 1)
  if not tryMove(1, 0) or score != 10 or diamondsLeft != 5:
    echo "Startup check failed: diamond collection"
    return false

  if not resetGame():
    return false
  removeTile(4, 1)
  removeTile(6, 1)
  movePlayerTo(4, 1)
  if not tryMove(1, 0) or grid[1][6] != tkBoulder or playerX != 5:
    echo "Startup check failed: horizontal boulder push"
    return false

  if not resetGame():
    return false
  removeTile(17, 13)
  movePlayerTo(17, 13)
  if tryMove(1, 0) or gameState != gsPlaying:
    echo "Startup check failed: exit opened too early"
    return false

  if not resetGame():
    return false
  removeTile(17, 13)
  movePlayerTo(17, 13)
  diamondsLeft = 0
  if not tryMove(1, 0) or gameState != gsWon:
    echo "Startup check failed: open exit"
    return false

  if not resetGame():
    return false
  removeTile(13, 3)
  moveTile(10, 1, 13, 3)
  removeTile(12, 2)
  removeTile(12, 3)
  updateFallingTiles()
  if grid[3][12] != tkBoulder or not tileFalling[3][12]:
    echo "Startup check failed: boulder did not roll off a diamond"
    return false

  if not resetGame():
    return false
  removeTile(10, 2)
  moveTile(13, 2, 10, 2)
  removeTile(9, 1)
  removeTile(9, 2)
  updateFallingTiles()
  if grid[2][9] != tkDiamond or not tileFalling[2][9]:
    echo "Startup check failed: diamond did not roll off a boulder"
    return false

  if not resetGame():
    return false
  removeTile(10, 2)
  updateFallingTiles()
  if grid[2][10] != tkDiamond or not tileFalling[2][10]:
    echo "Startup check failed: unsupported diamond did not fall"
    return false

  if not resetGame():
    return false
  removeTile(13, 3)
  movePlayerTo(13, 3)
  updateFallingTiles()
  if grid[2][13] != tkBoulder or gameState != gsPlaying:
    echo "Startup check failed: player did not support a resting boulder"
    return false

  removeTile(14, 3)
  if not tryMove(1, 0):
    echo "Startup check failed: player could not move past a boulder"
    return false
  updateFallingTiles()
  if grid[3][13] != tkBoulder or not tileFalling[3][13]:
    echo "Startup check failed: boulder did not fall behind the player"
    return false

  removeTile(13, 4)
  movePlayerTo(13, 4)
  updateFallingTiles()
  if gameState != gsLost:
    echo "Startup check failed: moving boulder did not crush the player"
    return false

  let originalTemplate = levelTemplate
  let originalStartX = levelStartX
  let originalStartY = levelStartY
  let originalName = levelName
  let originalRandomCaveNumber = randomCaveNumber
  for _ in 0 ..< 25:
    if not generateRandomTemplate():
      echo "Startup check failed: random cave generation"
      return false
    if countTemplateTiles(tkDiamond) != 6 or countTemplateTiles(tkBoulder) != 10 or
        countTemplateTiles(tkExit) != 1:
      echo "Startup check failed: random cave contents"
      return false
    for x in 0 ..< GridWidth:
      if levelTemplate[0][x] != tkWall or levelTemplate[GridHeight - 1][x] != tkWall:
        echo "Startup check failed: random cave horizontal border"
        return false
    for y in 0 ..< GridHeight:
      if levelTemplate[y][0] != tkWall or levelTemplate[y][GridWidth - 1] != tkWall:
        echo "Startup check failed: random cave vertical border"
        return false
      for x in 0 ..< GridWidth:
        if levelTemplate[y][x] == tkDiamond and not isTemplateReachable(x, y):
          echo "Startup check failed: unreachable random cave diamond"
          return false
  if not resetGame() or diamondsLeft != 6:
    echo "Startup check failed: random cave could not be instantiated"
    return false

  levelTemplate = originalTemplate
  levelStartX = originalStartX
  levelStartY = originalStartY
  levelName = originalName
  randomCaveNumber = originalRandomCaveNumber
  result = resetGame()
  if result:
    echo "Boulder Dash startup checks passed"

proc updateGame(clockInfo: ptr orxCLOCK_INFO; context: pointer) {.cdecl.} =
  if inputActive("Quit"):
    discard eventSendShort(EVENT_TYPE_SYSTEM, SYSTEM_EVENT_CLOSE.orxU32)
    return

  if inputActivated("NewLevel"):
    if not generateRandomTemplate() or not resetGame():
      discard eventSendShort(EVENT_TYPE_SYSTEM, SYSTEM_EVENT_CLOSE.orxU32)
    else:
      setMessage("NEW RANDOM CAVE", 1.5)
    return

  if inputActivated("Restart"):
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
    gameState = gsLost
    playSound("LoseSound")
    setMessage("TIME UP! Final score: " & $score & " - press R to restart")
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
  helpObject = objectCreateFromConfig("Help")
  messageObject = objectCreateFromConfig("Message")
  if hudObject == nil or helpObject == nil or messageObject == nil:
    echo "Could not create the user interface"
    return STATUS_FAILURE

  if not readLevel():
    return STATUS_FAILURE
  saveLevelTemplate("Cave 1")
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
  result = addStorage(CONFIG_KZ_RESOURCE_GROUP, configPath.cstring, false)
  if result == STATUS_FAILURE:
    echo "Could not add config storage: ", configPath

when isMainModule:
  if setBootstrap(bootstrap) == STATUS_FAILURE:
    quit("Could not register the bootstrap callback")
  execute(init, run, exit)
