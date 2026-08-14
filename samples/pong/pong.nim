## A complete two-player Pong game built with Norx.

import math
import os
import norx

type
  Player = enum
    playerLeft
    playerRight

  GamePhase = enum
    phaseServing
    phasePlaying
    phasePaused
    phaseFinished

  GameEventKind = enum
    eventNone
    eventWallHit
    eventPaddleHit
    eventPointScored
    eventMatchWon

  CollisionKind = enum
    collisionNone
    collisionTopWall
    collisionBottomWall
    collisionPaddle
    collisionGoal

  Vec2 = object
    x, y: float32

  GameEvent = object
    case kind: GameEventKind
    of eventPaddleHit, eventPointScored, eventMatchWon:
      player: Player
    of eventNone, eventWallHit:
      discard

  Collision = object
    kind: CollisionKind
    time: float32
    player: Player

  InputBinding = tuple[action: string, key: orxKEYBOARD_KEY]

  GameModel = object
    paddleY: array[Player, float32]
    ballPosition: Vec2
    ballVelocity: Vec2
    scores: array[Player, int]
    phase: GamePhase
    serveTarget: Player
    serveTimer: float32
    serveNumber: int
    statusText: string
    uiDirty: bool

  Scene = object
    court: ptr orxOBJECT
    paddles: array[Player, ptr orxOBJECT]
    ball: ptr orxOBJECT
    scores: array[Player, ptr orxOBJECT]
    status: ptr orxOBJECT

const
  CourtTop = -202.0'f32
  CourtBottom = 202.0'f32
  GoalX = 480.0'f32
  PaddleHalfWidth = 8.0'f32
  PaddleHalfHeight = 52.0'f32
  BallRadius = 8.0'f32
  PaddleSpeed = 430.0'f32
  InitialBallSpeed = 390.0'f32
  BallSpeedIncrease = 28.0'f32
  MaximumBallSpeed = 760.0'f32
  MaximumBounceAngle = 62.0'f32 * DEG_TO_RAD
  ServeDelay = 0.85'f32
  FixedTimeStep = 1.0'f32 / 120.0'f32
  MaximumFrameTime = 0.1'f32
  CollisionEpsilon = 0.00001'f32
  MaximumCollisionsPerStep = 4
  WinningScore = 7
  StartupTestFrameCount = 5

  BuildConfigPath = currentSourcePath().parentDir / "data" / "config"

  PaddleX: array[Player, float32] = [-410.0'f32, 410.0'f32]
  PaddleSections: array[Player, string] = ["LeftPaddle", "RightPaddle"]
  ScoreSections: array[Player, string] = ["LeftScore", "RightScore"]
  PaddleControls: array[Player, tuple[upAction, downAction: string]] = [
    (upAction: "LeftUp", downAction: "LeftDown"),
    (upAction: "RightUp", downAction: "RightDown")
  ]
  ServeAngles = [-22.0'f32, 14.0'f32, -9.0'f32,
                 25.0'f32, -17.0'f32, 8.0'f32]
  NoPaddleInput: array[Player, float32] = [0.0'f32, 0.0'f32]
  ExpectedInputBindings: array[7, InputBinding] = [
    (action: "Quit", key: KEYBOARD_KEY_ESCAPE),
    (action: "Restart", key: KEYBOARD_KEY_R),
    (action: "Pause", key: KEYBOARD_KEY_SPACE),
    (action: "LeftUp", key: KEYBOARD_KEY_W),
    (action: "LeftDown", key: KEYBOARD_KEY_S),
    (action: "RightUp", key: KEYBOARD_KEY_UP),
    (action: "RightDown", key: KEYBOARD_KEY_DOWN)
  ]
  ExpectedCourtChildren = 6
  EventSounds: array[GameEventKind, string] = [
    "", "WallSound", "PaddleSound", "PointSound", "WinSound"
  ]

var
  game: GameModel
  scene: Scene
  coreClock: ptr orxCLOCK
  timeAccumulator: float32
  startupFrames: int
  initializationSucceeded: bool
  executionFailed: bool

let startupTest = "--startup-test" in commandLineParams()

template checkStartup(condition: bool; message: string) =
  if not condition:
    echo message
    return false

proc vec2(x, y: float32): Vec2 = Vec2(x: x, y: y)

proc `+`(left, right: Vec2): Vec2 =
  vec2(left.x + right.x, left.y + right.y)

proc `*`(vector: Vec2; scalar: float32): Vec2 =
  vec2(vector.x * scalar, vector.y * scalar)

proc length(vector: Vec2): float32 =
  math.sqrt(vector.x * vector.x + vector.y * vector.y)

proc opponent(player: Player): Player =
  if player == playerLeft: playerRight else: playerLeft

proc playerName(player: Player): string =
  if player == playerLeft: "LEFT" else: "RIGHT"

proc directionToward(player: Player): float32 =
  if player == playerLeft: -1.0'f32 else: 1.0'f32

proc paddleContactX(player: Player): float32 =
  if player == playerLeft:
    PaddleX[player] + PaddleHalfWidth + BallRadius
  else:
    PaddleX[player] - PaddleHalfWidth - BallRadius

proc setPhase(model: var GameModel; phase: GamePhase; status: string) =
  model.phase = phase
  model.statusText = status
  model.uiDirty = true

proc prepareServe(model: var GameModel; target: Player; message: string) =
  model.setPhase(phaseServing, message)
  model.serveTarget = target
  model.serveTimer = ServeDelay
  model.ballPosition = vec2(0.0, 0.0)
  model.ballVelocity = vec2(0.0, 0.0)

proc resetMatch(model: var GameModel) =
  model = GameModel()
  model.prepareServe(playerLeft,
                     "FIRST TO " & $WinningScore & " - GET READY")

proc launchBall(model: var GameModel) =
  let angle = ServeAngles[model.serveNumber mod ServeAngles.len] * DEG_TO_RAD
  let horizontalDirection = directionToward(model.serveTarget)
  model.ballVelocity = vec2(
    horizontalDirection * InitialBallSpeed * math.cos(angle),
    InitialBallSpeed * math.sin(angle)
  )
  inc model.serveNumber
  model.setPhase(phasePlaying, "")

proc nextCollision(model: GameModel; maximumTime: float32;
                   paddleY, paddleVelocity: array[Player, float32]): Collision =
  result = Collision(kind: collisionNone,
                     time: maximumTime + CollisionEpsilon)

  template consider(kindValue: CollisionKind; collisionTime: float32;
                    collisionPlayer: Player = playerLeft) =
    block:
      let candidateTime = max(0.0'f32, collisionTime)
      if collisionTime >= -CollisionEpsilon and
          candidateTime <= maximumTime and candidateTime < result.time:
        result = Collision(kind: kindValue, time: candidateTime,
                           player: collisionPlayer)

  let minimumY = CourtTop + BallRadius
  let maximumY = CourtBottom - BallRadius
  if model.ballVelocity.y < 0.0:
    consider(collisionTopWall,
             (minimumY - model.ballPosition.y) / model.ballVelocity.y)
  elif model.ballVelocity.y > 0.0:
    consider(collisionBottomWall,
             (maximumY - model.ballPosition.y) / model.ballVelocity.y)

  for player in Player:
    let movingTowardPaddle =
      if player == playerLeft:
        model.ballVelocity.x < 0.0 and
          model.ballPosition.x >= paddleContactX(player)
      else:
        model.ballVelocity.x > 0.0 and
          model.ballPosition.x <= paddleContactX(player)
    if not movingTowardPaddle:
      continue

    let collisionTime =
      (paddleContactX(player) - model.ballPosition.x) /
        model.ballVelocity.x
    let impactY = model.ballPosition.y +
                  model.ballVelocity.y * collisionTime
    let paddleImpactY = paddleY[player] +
                        paddleVelocity[player] * collisionTime
    if abs(impactY - paddleImpactY) <=
        PaddleHalfHeight + BallRadius:
      consider(collisionPaddle, collisionTime, player)

  if model.ballVelocity.x < 0.0:
    consider(collisionGoal,
             (-GoalX - model.ballPosition.x) / model.ballVelocity.x,
             playerRight)
  elif model.ballVelocity.x > 0.0:
    consider(collisionGoal,
             (GoalX - model.ballPosition.x) / model.ballVelocity.x,
             playerLeft)

proc bounceOffPaddle(model: var GameModel; player: Player; paddleY: float32) =
  let impact = clamp(
    (model.ballPosition.y - paddleY) /
      (PaddleHalfHeight + BallRadius),
    -1.0'f32,
    1.0'f32
  )
  let angle = impact * MaximumBounceAngle
  let speed = min(MaximumBallSpeed,
                  model.ballVelocity.length + BallSpeedIncrease)
  let horizontalDirection = -directionToward(player)

  model.ballPosition.x = paddleContactX(player)
  model.ballVelocity = vec2(
    horizontalDirection * speed * math.cos(angle),
    speed * math.sin(angle)
  )

proc awardPoint(model: var GameModel; scorer: Player): GameEvent =
  inc model.scores[scorer]
  if model.scores[scorer] == WinningScore:
    model.setPhase(phaseFinished, playerName(scorer) & " WINS - PRESS R")
    model.ballPosition = vec2(0.0, 0.0)
    model.ballVelocity = vec2(0.0, 0.0)
    return GameEvent(kind: eventMatchWon, player: scorer)

  model.prepareServe(opponent(scorer), playerName(scorer) & " SCORES")
  result = GameEvent(kind: eventPointScored, player: scorer)

proc stepGame(model: var GameModel; deltaTime: float32;
              paddleInput: array[Player, float32] = NoPaddleInput): GameEvent =
  let minimumPaddleY = CourtTop + PaddleHalfHeight
  let maximumPaddleY = CourtBottom - PaddleHalfHeight
  var
    currentPaddleY = model.paddleY
    nextPaddleY = model.paddleY
    paddleVelocity: array[Player, float32]
  for player in Player:
    nextPaddleY[player] = clamp(
      model.paddleY[player] +
        clamp(paddleInput[player], -1.0'f32, 1.0'f32) *
          PaddleSpeed * deltaTime,
      minimumPaddleY,
      maximumPaddleY
    )
    paddleVelocity[player] =
      (nextPaddleY[player] - model.paddleY[player]) / deltaTime
  defer:
    model.paddleY = nextPaddleY

  if model.phase == phaseServing:
    model.serveTimer -= deltaTime
    if model.serveTimer <= 0.0:
      model.launchBall()
    return GameEvent(kind: eventNone)
  if model.phase != phasePlaying:
    return GameEvent(kind: eventNone)

  var remainingTime = deltaTime
  result = GameEvent(kind: eventNone)
  for _ in 0 ..< MaximumCollisionsPerStep:
    if remainingTime <= CollisionEpsilon:
      break

    let collision = model.nextCollision(remainingTime, currentPaddleY,
                                        paddleVelocity)
    if collision.kind == collisionNone:
      model.ballPosition = model.ballPosition +
                           model.ballVelocity * remainingTime
      return

    model.ballPosition = model.ballPosition +
                         model.ballVelocity * collision.time
    for player in Player:
      currentPaddleY[player] += paddleVelocity[player] * collision.time
    remainingTime -= collision.time
    case collision.kind
    of collisionTopWall:
      model.ballPosition.y = CourtTop + BallRadius
      model.ballVelocity.y = abs(model.ballVelocity.y)
      if result.kind == eventNone:
        result = GameEvent(kind: eventWallHit)
    of collisionBottomWall:
      model.ballPosition.y = CourtBottom - BallRadius
      model.ballVelocity.y = -abs(model.ballVelocity.y)
      if result.kind == eventNone:
        result = GameEvent(kind: eventWallHit)
    of collisionPaddle:
      model.bounceOffPaddle(collision.player,
                            currentPaddleY[collision.player])
      result = GameEvent(kind: eventPaddleHit, player: collision.player)
    of collisionGoal:
      return model.awardPoint(collision.player)
    of collisionNone:
      discard

  if remainingTime > CollisionEpsilon:
    model.ballPosition = model.ballPosition +
                         model.ballVelocity * remainingTime

proc place(gameObject: ptr orxOBJECT; position: Vec2): bool =
  gameObject != nil and
    gameObject.setPosition(newVector(position.x, position.y)).isSuccess

proc syncScene(): bool =
  result = true
  for player in Player:
    if not scene.paddles[player].place(vec2(PaddleX[player],
                                             game.paddleY[player])):
      echo "Could not position the ", playerName(player), " paddle"
      result = false
  if not scene.ball.place(game.ballPosition):
    echo "Could not position the ball"
    result = false

proc syncUI(): bool =
  if not game.uiDirty:
    return true

  result = true
  for player in Player:
    if scene.scores[player].setTextString($game.scores[player]).isFailure:
      echo "Could not update the ", playerName(player), " score"
      result = false

  let statusVisible = game.statusText.len > 0
  if statusVisible and scene.status.setTextString(game.statusText).isFailure:
    echo "Could not update the status text"
    result = false
  if scene.status.enable(statusVisible).isFailure:
    echo "Could not ", (if statusVisible: "show" else: "hide"),
         " the status text"
    result = false
  game.uiDirty = not result

proc handleGameEvent(gameEvent: GameEvent) =
  case gameEvent.kind
  of eventPaddleHit:
    discard scene.paddles[gameEvent.player].addFX("PaddleHit")
  of eventPointScored, eventMatchWon:
    discard scene.scores[gameEvent.player].addFX("ScorePulse")
  of eventNone, eventWallHit:
    discard
  let sound = EventSounds[gameEvent.kind]
  if sound.len > 0:
    discard scene.ball.addSound(sound)

proc readPaddleInput(): array[Player, float32] =
  for player in Player:
    if isActive(PaddleControls[player].upAction):
      result[player] -= 1.0
    if isActive(PaddleControls[player].downAction):
      result[player] += 1.0

proc runModelChecks(): bool =
  var model: GameModel
  model.resetMatch()
  model.serveTimer = FixedTimeStep * 0.5
  discard model.stepGame(FixedTimeStep)
  checkStartup(model.phase == phasePlaying and model.ballVelocity.x < 0.0,
               "Pong check failed: serve")

  model.ballPosition = vec2(0.0, CourtTop + BallRadius + 1.0)
  model.ballVelocity = vec2(0.0, -400.0)
  let wallHit = model.stepGame(FixedTimeStep)
  checkStartup(wallHit.kind == eventWallHit and model.ballVelocity.y > 0.0,
               "Pong check failed: wall bounce")

  model.ballPosition = vec2(paddleContactX(playerLeft) + 2.0, 0.0)
  model.ballVelocity = vec2(-400.0, 0.0)
  let hit = model.stepGame(FixedTimeStep)
  checkStartup(hit.kind == eventPaddleHit and hit.player == playerLeft and
                 model.ballVelocity.x > 0.0,
               "Pong check failed: paddle bounce")

  model.paddleY[playerLeft] = CourtTop + PaddleHalfHeight
  model.ballPosition = vec2(paddleContactX(playerLeft) + 2.0,
                            CourtTop + BallRadius + 2.0)
  model.ballVelocity = vec2(-400.0, -400.0)
  let cornerHit = model.stepGame(FixedTimeStep)
  checkStartup(cornerHit.kind == eventPaddleHit and
                 model.ballPosition.y >= CourtTop + BallRadius,
               "Pong check failed: paddle and wall corner")

  model.resetMatch()
  model.phase = phasePlaying
  model.ballPosition = vec2(GoalX - 1.0, 0.0)
  model.ballVelocity = vec2(400.0, 0.0)
  let point = model.stepGame(FixedTimeStep)
  checkStartup(point.kind == eventPointScored and
                 point.player == playerLeft and
                 model.scores[playerLeft] == 1 and
                 model.phase == phaseServing,
               "Pong check failed: point scoring")

  model.scores[playerLeft] = WinningScore - 1
  model.phase = phasePlaying
  model.ballPosition = vec2(GoalX - 1.0, 0.0)
  model.ballVelocity = vec2(400.0, 0.0)
  let win = model.stepGame(FixedTimeStep)
  checkStartup(win.kind == eventMatchWon and win.player == playerLeft and
                 model.phase == phaseFinished,
               "Pong check failed: match scoring")

  echo "Pong model checks passed"
  result = true

proc inputConfigured(binding: InputBinding): bool =
  var
    inputType: orxINPUT_TYPE
    inputId: orxENUM
    inputMode: orxINPUT_MODE
  result = getBinding(binding.action, 0, addr inputType, addr inputId,
                      addr inputMode).isSuccess and
           inputType == INPUT_TYPE_KEYBOARD_KEY and
           inputId == binding.key.orxENUM

proc runEngineChecks(): bool =
  for binding in ExpectedInputBindings:
    checkStartup(inputConfigured(binding),
                 "Pong check failed: incorrect input action " & binding.action)

  for player in Player:
    checkStartup(scene.paddles[player].getWorkingGraphic() != nil and
                   scene.scores[player].getWorkingGraphic() != nil,
                 "Pong check failed: missing " & playerName(player) &
                   " graphic")
  checkStartup(scene.ball.getWorkingGraphic() != nil and
                 scene.status.getWorkingGraphic() != nil,
               "Pong check failed: missing ball or status graphic")

  var
    child = scene.court.getOwnedChild()
    childCount = 0
  while child != nil:
    checkStartup(child.getWorkingGraphic() != nil,
                 "Pong check failed: missing court child graphic")
    inc childCount
    child = child.getOwnedSibling()
  checkStartup(childCount == ExpectedCourtChildren,
               "Pong check failed: expected " & $ExpectedCourtChildren &
                 " court children, got " & $childCount)

  checkStartup(scene.paddles[playerLeft].addFX("PaddleHit").isSuccess and
                 scene.scores[playerLeft].addFX("ScorePulse").isSuccess,
               "Pong check failed: visual effects")
  for section in EventSounds:
    if section.len == 0:
      continue
    let sound = soundCreateFromConfig(section)
    checkStartup(sound != nil, "Pong check failed: sound " & section)
    discard soundDelete(sound)
  echo "Pong engine checks passed"
  result = true

proc createScene(): bool =
  scene.court = objectCreateFromConfig("Court")
  scene.ball = objectCreateFromConfig("Ball")
  scene.status = objectCreateFromConfig("Status")
  if scene.court == nil or scene.ball == nil or scene.status == nil:
    echo "Could not create the Pong court"
    return false

  for player in Player:
    scene.paddles[player] =
      objectCreateFromConfig(PaddleSections[player])
    scene.scores[player] = objectCreateFromConfig(ScoreSections[player])
    if scene.paddles[player] == nil or scene.scores[player] == nil:
      echo "Could not create objects for ", playerName(player), " player"
      return false
  result = true

proc updateGame(clockInfo: ptr orxCLOCK_INFO; context: pointer) {.cdecl.} =
  if isActive("Quit"):
    discard eventSendShort(EVENT_TYPE_SYSTEM, SYSTEM_EVENT_CLOSE.orxU32)
    return

  if hasBeenActivated("Restart"):
    game.resetMatch()
    timeAccumulator = 0.0

  if hasBeenActivated("Pause") and
      game.phase in {phasePlaying, phasePaused}:
    if game.phase == phasePlaying:
      game.setPhase(phasePaused, "PAUSED")
    else:
      game.setPhase(phasePlaying, "")

  let deltaTime = min(clockInfo.fDT.float32, MaximumFrameTime)
  if game.phase in {phaseServing, phasePlaying}:
    let paddleInput = readPaddleInput()
    timeAccumulator += deltaTime
    while timeAccumulator >= FixedTimeStep:
      timeAccumulator -= FixedTimeStep
      handleGameEvent(game.stepGame(FixedTimeStep, paddleInput))

  let sceneUpdated = syncScene()
  let uiUpdated = syncUI()
  if not sceneUpdated or not uiUpdated:
    executionFailed = true
    discard eventSendShort(EVENT_TYPE_SYSTEM, SYSTEM_EVENT_CLOSE.orxU32)

proc init(): orxSTATUS {.cdecl.} =
  echo "Pong starting with ORX ", getVersionFullString()

  if viewportCreateFromConfig("MainViewport") == nil:
    echo "Could not create the main viewport"
    return STATUS_FAILURE
  if not createScene():
    return STATUS_FAILURE

  game.resetMatch()
  if not syncScene() or not syncUI():
    echo "Could not initialize the Pong scene"
    return STATUS_FAILURE
  if startupTest and (not runModelChecks() or not runEngineChecks()):
    return STATUS_FAILURE

  coreClock = clockGet(CLOCK_KZ_CORE)
  if coreClock == nil:
    return STATUS_FAILURE
  result = clockRegister(coreClock, updateGame, nil, MODULE_ID_MAIN,
                         CLOCK_PRIORITY_NORMAL)
  initializationSucceeded = result.isSuccess

proc run(): orxSTATUS {.cdecl.} =
  if startupTest:
    inc startupFrames
    if startupFrames >= StartupTestFrameCount:
      return STATUS_FAILURE
  result = STATUS_SUCCESS

proc exit() {.cdecl.} =
  if coreClock != nil:
    discard unregister(coreClock, updateGame, nil)
  echo "Pong stopped"

proc bootstrap(): orxSTATUS {.cdecl.} =
  for configPath in [
    getAppDir() / "data" / "config",
    getCurrentDir() / "data" / "config",
    BuildConfigPath
  ]:
    let soundPath = configPath.parentDir / "sound"
    if not fileExists(configPath / "pong.ini") or
        not fileExists(soundPath / "push.ogg"):
      continue
    if addStorage(CONFIG_KZ_RESOURCE_GROUP, configPath, false).isSuccess and
        addStorage(SOUND_KZ_RESOURCE_GROUP, soundPath, false).isSuccess:
      return STATUS_SUCCESS
  echo "Could not find Pong config and sound data"
  result = STATUS_FAILURE

when isMainModule:
  if setBootstrap(bootstrap).isFailure:
    quit("Could not register the bootstrap callback")
  execute(init, run, exit)
  if not initializationSucceeded or executionFailed or
      (startupTest and startupFrames < StartupTestFrameCount):
    quit(1)
