## Classic Pong Game
## Left player: W/S keys, Right player: UP/DOWN arrow keys

import os
import norx

{.push cdecl.}

# Game objects
var leftPaddle, rightPaddle, ball, topWall, bottomWall: ptr orxOBJECT
var scoreLeft, scoreRight: int = 0

# Game constants
const PADDLE_SPEED = 400.0
const BALL_RESET_DELAY = 1.0
const FIELD_WIDTH = 1000.0
const FIELD_HEIGHT = 600.0

var ballResetTimer: float = 0.0

proc resetBall() =
  ## Reset ball to center with random direction
  if not ball.isNil:
    var centerPos: orxVECTOR = (0.0f, 0.0f, 0.0f)
    discard ball.setPosition(addr centerPos)
    # Random direction: either left or right, with random Y component
    let dirX = if getRandomFloat(-1.0, 1.0) > 0: 300.0f else: -300.0f
    let dirY = getRandomFloat(-200.0, 200.0)
    var ballSpeed: orxVECTOR = (dirX, dirY, 0.0f)
    discard ball.setSpeed(addr ballSpeed)

proc updatePaddles(clockInfo: ptr orxCLOCK_INFO, context: pointer) =
  ## Update paddle positions based on input
  let deltaTime = clockInfo.fDT
  
  # Left paddle controls (W/S)
  if not leftPaddle.isNil:
    var moveY: float = 0.0
    if isActive("LeftPaddleUp"):
      moveY = -PADDLE_SPEED * deltaTime
    elif isActive("LeftPaddleDown"):
      moveY = PADDLE_SPEED * deltaTime
    
    if moveY != 0.0:
      var pos: orxVECTOR = (0.0f, 0.0f, 0.0f)
      discard leftPaddle.getPosition(addr pos)
      pos.fY += moveY
      # Clamp to screen bounds (accounting for paddle height: 150/2 = 75)
      if pos.fY < -225.0: pos.fY = -225.0
      if pos.fY > 225.0: pos.fY = 225.0
      discard leftPaddle.setPosition(addr pos)

  # Right paddle controls (UP/DOWN)
  if not rightPaddle.isNil:
    var moveY: float = 0.0
    if isActive("RightPaddleUp"):
      moveY = -PADDLE_SPEED * deltaTime
    elif isActive("RightPaddleDown"):
      moveY = PADDLE_SPEED * deltaTime
    
    if moveY != 0.0:
      var pos: orxVECTOR = (0.0f, 0.0f, 0.0f)
      discard rightPaddle.getPosition(addr pos)
      pos.fY += moveY
      # Clamp to screen bounds (accounting for paddle height: 150/2 = 75)
      if pos.fY < -225.0: pos.fY = -225.0
      if pos.fY > 225.0: pos.fY = 225.0
      discard rightPaddle.setPosition(addr pos)

proc updateBall(clockInfo: ptr orxCLOCK_INFO, context: pointer) =
  ## Update ball and check for scoring
  let deltaTime = clockInfo.fDT
  
  if ballResetTimer > 0.0:
    ballResetTimer -= deltaTime
    if ballResetTimer <= 0.0:
      resetBall()
    return
  
  if not ball.isNil:
    var pos: orxVECTOR = (0.0f, 0.0f, 0.0f)
    discard ball.getPosition(addr pos)
    
    # Check for scoring (ball went off screen)
    if pos.fX < -500.0:
      # Right player scores
      scoreRight += 1
      echo "Score: Left ", scoreLeft, " - Right ", scoreRight
      ballResetTimer = BALL_RESET_DELAY
    elif pos.fX > 500.0:
      # Left player scores
      scoreLeft += 1
      echo "Score: Left ", scoreLeft, " - Right ", scoreRight
      ballResetTimer = BALL_RESET_DELAY

proc physicsEventHandler(event: ptr orxEVENT): orxSTATUS =
  ## Handle physics collisions
  if event.eType == EVENT_TYPE_PHYSICS and event.eID == PHYSICS_EVENT_CONTACT_ADD.orxU32:
    # Get the colliding objects
    let objA = cast[ptr orxOBJECT](event.hRecipient)
    let objB = cast[ptr orxOBJECT](event.hSender)
    
    # Check if ball is involved in collision
    if objA == ball or objB == ball:
      # Ball hit something, we could add sound effects here
      discard
      
  return STATUS_SUCCESS

proc update(clockInfo: ptr orxCLOCK_INFO, context: pointer) =
  ## Main update function
  # Check for quit
  if isActive("Quit"):
    echo "Game Over! Final Score: Left ", scoreLeft, " - Right ", scoreRight
    discard eventSendShort(EVENT_TYPE_SYSTEM, SYSTEM_EVENT_CLOSE.orxU32)

proc init(): orxSTATUS =
  echo "Starting Pong Game!"
  echo "Left Player: W (up) / S (down)"
  echo "Right Player: UP arrow (up) / DOWN arrow (down)"
  echo "Press ESC to quit"
  
  # Create viewport
  let viewport = viewportCreateFromConfig("MainViewport")
  if viewport.isNil: 
    echo "Failed to create viewport"
    return STATUS_FAILURE
  
  # Create walls
  echo "Creating walls..."
  topWall = objectCreateFromConfig("TopWall")
  bottomWall = objectCreateFromConfig("BottomWall")

  # Create game objects one at a time
  echo "Creating left paddle..."
  leftPaddle = objectCreateFromConfig("LeftPaddle")
  if leftPaddle.isNil:
    echo "Failed to create left paddle"
    return STATUS_FAILURE
  echo "Left paddle created successfully"
  
  echo "Creating right paddle..."  
  rightPaddle = objectCreateFromConfig("RightPaddle")
  if rightPaddle.isNil:
    echo "Failed to create right paddle"
    return STATUS_FAILURE
  echo "Right paddle created successfully"
  
  echo "Creating ball..."
  ball = objectCreateFromConfig("Ball")
  if ball.isNil:
    echo "Failed to create ball"
    return STATUS_FAILURE
  echo "Ball created successfully"
  
  # Set up physics event handler
  discard addHandler(EVENT_TYPE_PHYSICS, physicsEventHandler)
  
  # Set up update callbacks
  let clock = clockGet(CLOCK_KZ_CORE)
  if clock.isNil: return STATUS_FAILURE
  
  discard clockRegister(clock, update, nil, MODULE_ID_MAIN, CLOCK_PRIORITY_NORMAL)
  discard clockRegister(clock, updatePaddles, nil, MODULE_ID_MAIN, CLOCK_PRIORITY_NORMAL)
  discard clockRegister(clock, updateBall, nil, MODULE_ID_MAIN, CLOCK_PRIORITY_NORMAL)
  
  # Initialize ball
  resetBall()
  
  return STATUS_SUCCESS

proc run(): orxSTATUS = STATUS_SUCCESS

proc exit() = 
  echo "Pong game ended. Thanks for playing!"

proc bootstrap(): orxSTATUS =
  # Setup config path
  let configPath = getCurrentDir() & "/data/config"
  result = addStorage(CONFIG_KZ_RESOURCE_GROUP, cstring(configPath), false)
  if result == STATUS_SUCCESS:
    echo "Config storage added successfully"

{.pop.}

# Main program
when isMainModule:
  if setBootstrap(bootstrap) == STATUS_SUCCESS:
    echo "Bootstrap set successfully"
    execute(init, run, exit)
  else:
    echo "Failed to set bootstrap"
    quit(1)
  
  quit(0)
