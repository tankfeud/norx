## This is a port of the trivial sample that ORX comes with but using
## it's own main loop basically copied from norx.nim in Norx.
##
## NOTE: THIS IS NOT THE RECOMMENDED ORX WAY.
import os

# Note here that we do not import norx, only it's sub modules
import norx/[incl, param, clock, event, system, config, resource, input, viewport, memory, obj]

## Should stop execution by default event handling?
var sbStopByEvent* = false

##  Orx default basic event handler.
##  @param[in]   pstEvent                     Sent event
##  @return      orxSTATUS_SUCCESS if handled / orxSTATUS_FAILURE otherwise
proc eventHandler(pstEvent: ptr orxEVENT): orxSTATUS {.cdecl.} =
  ##  Checks
  assert(pstEvent.eType == orxEVENT_TYPE_SYSTEM)
  ##  Depending on event ID
  case pstEvent.eID:
    of ord(orxSYSTEM_EVENT_CLOSE):
      ##  Updates status
      sbStopByEvent = true
    else:
      discard
  return orxSTATUS_SUCCESS

## Default main setup (module dependencies)
proc mainSetup() {.cdecl.} =
  ##  Adds module dependencies
  addDependency(orxMODULE_ID_MAIN, orxMODULE_ID_PARAM)
  addDependency(orxMODULE_ID_MAIN, orxMODULE_ID_CLOCK)
  addDependency(orxMODULE_ID_MAIN, orxMODULE_ID_CONFIG)
  addDependency(orxMODULE_ID_MAIN, orxMODULE_ID_INPUT)
  addDependency(orxMODULE_ID_MAIN, orxMODULE_ID_EVENT)
  addDependency(orxMODULE_ID_MAIN, orxMODULE_ID_FILE)
  addDependency(orxMODULE_ID_MAIN, orxMODULE_ID_LOCALE)
  addDependency(orxMODULE_ID_MAIN, orxMODULE_ID_PLUGIN)
  addDependency(orxMODULE_ID_MAIN, orxMODULE_ID_OBJECT)
  addDependency(orxMODULE_ID_MAIN, orxMODULE_ID_RENDER)
  addOptionalDependency(orxMODULE_ID_MAIN, orxMODULE_ID_CONSOLE)
  addOptionalDependency(orxMODULE_ID_MAIN, orxMODULE_ID_PROFILER)
  addOptionalDependency(orxMODULE_ID_MAIN, orxMODULE_ID_SCREENSHOT)

proc Update(clockInfo: ptr orxCLOCK_INFO, context: pointer) {.cdecl.} =
  ## Update function, it has been registered to be called every tick of the core clock
  # Should we quit due to user pressing ESC?
  if isActive("Quit"):
    # Send close event
    echo "User quitting"
    discard sendShort(orxEVENT_TYPE_SYSTEM, orxSYSTEM_EVENT_CLOSE.ord)

proc init(): orxSTATUS {.cdecl.} =
  ## Init function, it is called when all orx's modules have been initialized
  orxLOG("Sample2 starting")

  # Create viewport, scene and register the Update function to the core clock
  discard viewportCreateFromConfig("MainViewport")
  discard objectCreateFromConfig("Scene")
  let clock = clockGet(orxCLOCK_KZ_CORE)
  discard clock.register(Update, nil, orxMODULE_ID_MAIN, orxCLOCK_PRIORITY_NORMAL)

  # Done!
  return orxSTATUS_SUCCESS

proc run(): orxSTATUS =
  ## Run function, it should not contain any game logic
  # Return orxSTATUS_FAILURE to instruct orx to quit
  return orxSTATUS_SUCCESS

proc exit() {.cdecl.} =
  ## Exit function, it is called before exiting from orx
  echo "Exit called"

proc bootstrap(): orxSTATUS {.cdecl.} =
  ## Bootstrap function, it is called before config is initialized, allowing for early resource storage definitions
  # Add a config storage to find the initial config file
  var dir = getCurrentDir()
  var status = addStorage(orxCONFIG_KZ_RESOURCE_GROUP, $dir & "/data/config", false)
  if status == orxSTATUS_SUCCESS:
    echo "Added storage"
  # Return orxSTATUS_FAILURE to prevent orx from loading the default config file
  return orxSTATUS_SUCCESS

# Register bootstrap
discard setBootstrap(bootstrap)

# Inits the Debug System
orxDEBUG_INIT_MACRO()

#  Registers main module
register(orxMODULE_ID_MAIN, "MAIN", mainSetup, init, exit)

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

#  Sends the command line arguments to orxParam module
if setArgs(argc.orxU32, argv) != orxSTATUS_FAILURE:
  #  Inits the engine
  if moduleInit(orxMODULE_ID_MAIN) != orxSTATUS_FAILURE:
    var
      stPayload: orxSYSTEM_EVENT_PAYLOAD
      eClockStatus: orxSTATUS
      eMainStatus: orxSTATUS
    #  Registers default event handler
    var st = addHandler(orxEVENT_TYPE_SYSTEM, eventHandler)
    #  Clears payload, hmm, is this needed in Nim?
    discard zero(addr(stPayload), sizeof(orxSYSTEM_EVENT_PAYLOAD).orxU32)
    
    # Main loop
    var bStop = false
    sbStopByEvent = false
    while not bStop:
      #  Sends frame start event
      orxEVENT_SEND_MACRO(orxEVENT_TYPE_SYSTEM, orxSYSTEM_EVENT_GAME_LOOP_START, nil, nil, addr(stPayload))
      #  Runs the engine
      eMainStatus = run()
      #  Updates clock system
      eClockStatus = update()
      #  Sends frame stop event
      orxEVENT_SEND_MACRO(orxEVENT_TYPE_SYSTEM, orxSYSTEM_EVENT_GAME_LOOP_STOP, nil, nil, addr(stPayload))
      #  Updates frame count
      stPayload.u32FrameCount += 1
      bStop = (sbStopByEvent or (eMainStatus == orxSTATUS_FAILURE) or (eClockStatus == orxSTATUS_FAILURE))
  discard removeHandler(orxEVENT_TYPE_SYSTEM, eventHandler)
  
  # Exits from engine
  moduleExit(orxMODULE_ID_MAIN)

orxDEBUG_EXIT_MACRO()

quit(0)