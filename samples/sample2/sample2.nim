## This is a port of the trivial sample that ORX comes with but using
## it's own main loop basically copied from norx.nim in Norx.
##
## NOTE: THIS IS NOT THE RECOMMENDED ORX WAY.
import os
import norx

proc update(clockInfo: ptr orxCLOCK_INFO, context: pointer) {.cdecl.} =
  ## Update function registered to be called every tick of the core clock
  # Should we quit due to user pressing ESC?
  if isActive("Quit"):
    # Send close event
    echo "User quitting"
    discard eventSendShort(EVENT_TYPE_SYSTEM, SYSTEM_EVENT_CLOSE.orxU32)

proc init(): orxSTATUS {.cdecl.} =
  ## Init function, it is called when all ORX modules have been initialized
  echo "Sample2 starting"
  echo "Version: " & $getVersionFullString()

  # Create viewport and scene
  discard viewportCreateFromConfig("MainViewport")
  discard objectCreateFromConfig("Scene")

  # Register the Update function to the core clock
  let clock = clockGet(CLOCK_KZ_CORE)
  discard clockRegister(clock, update, nil, MODULE_ID_MAIN, CLOCK_PRIORITY_NORMAL)
  return STATUS_SUCCESS

proc run(): orxSTATUS {.sideEffect, cdecl, gcsafe.} =
  ## Run function, it should not contain any game logic
  return STATUS_SUCCESS

proc exit() {.cdecl.} =
  ## Exit function, it is called before exiting from ORX
  echo "Exit called"

proc bootstrap(): orxSTATUS {.cdecl, gcsafe.} =
  ## Bootstrap function, it is called before config is initialized, allowing for early resource storage definitions
  # Add a config storage to find the initial config file
  var dir = getCurrentDir()
  var status = addStorage(CONFIG_KZ_RESOURCE_GROUP, cstring(dir & "/data/config"), false)
  if status == STATUS_SUCCESS:
    echo "Added storage"
  # Return STATUS_FAILURE to prevent ORX from loading the default config file
  return STATUS_SUCCESS

# Set the bootstrap function to provide at least one resource storage before loading any config files
discard setBootstrap(bootstrap)

#
# From here and below is where we implement our own main loop.
#

# We use this global variable to stop the main loop.
var stopByEvent* = false

proc eventHandler(pstEvent: ptr orxEVENT): orxSTATUS {.cdecl.} =
  # Check for close event
  assert(pstEvent.eType == EVENT_TYPE_SYSTEM)
  if pstEvent.eID == ord(SYSTEM_EVENT_CLOSE):
    # This will be detected by the main loop below.
    stopByEvent = true
  return STATUS_SUCCESS

proc mainSetup() {.cdecl.} =
  # Adds module dependencies
  addDependency(MODULE_ID_MAIN, MODULE_ID_OBJECT)
  addDependency(MODULE_ID_MAIN, MODULE_ID_RENDER)
  addOptionalDependency(MODULE_ID_MAIN, MODULE_ID_SCREENSHOT)

# Inits the Debug System
debugInitMacro()

# Registers main module
moduleRegister(MODULE_ID_MAIN, "MAIN", mainSetup, init, exit)

# Hack to produce C style argc/argv to pass on
var argc = paramCount()
var nargv = newSeq[string](argc + 1)
nargv[0] = getAppFilename()  # Better than paramStr(0)
var x = 1
while x <= argc:
  nargv[x] = paramStr(x)
  inc(x)
var argv: cstringArray = nargv.allocCStringArray()
inc(argc)

# Sends the command line arguments to orxParam module
if setArgs(argc.orxU32, argv) != STATUS_FAILURE:
  # Inits the engine
  if moduleInit(MODULE_ID_MAIN) != STATUS_FAILURE:
    var
      payload: struct_orxSYSTEM_EVENT_PAYLOAD_t
      clockStatus: orxSTATUS
      mainStatus: orxSTATUS
    # Registers event handler above
    var st = addHandler(EVENT_TYPE_SYSTEM, eventHandler)
    # Set handler ID flags
    discard setHandlerIDFlags(eventHandler, EVENT_TYPE_SYSTEM, nil, eventGetFlag(SYSTEM_EVENT_CLOSE), EVENT_KU32_MASK_ID_ALL.orxU32)
    # Clears payload
    zeroMem(addr(payload), sizeof(struct_orxSYSTEM_EVENT_PAYLOAD_t).orxU32)
    # Main loop
    var
      bStop = false
    stopByEvent = false
    while not bStop:
      # Sends frame start event
      eventSendMacro(EVENT_TYPE_SYSTEM, SYSTEM_EVENT_GAME_LOOP_START, nil, nil, addr(payload))
      # Runs game specific code
      mainStatus = run()
      # Updates clock system
      clockStatus = clockUpdate()
      # Sends frame stop event
      eventSendMacro(EVENT_TYPE_SYSTEM, SYSTEM_EVENT_GAME_LOOP_STOP, nil, nil, addr(payload))
      # Updates frame count
      payload.anon0.u32FrameCount += 1
      bStop = (stopByEvent or (mainStatus == STATUS_FAILURE) or (clockStatus == STATUS_FAILURE))

    # Removes event handler
    discard removeHandler(EVENT_TYPE_SYSTEM, eventHandler)
    # Exits from the engine
    moduleExit(MODULE_ID_MAIN)
debugExitMacro()

quit(0)