## This is a port of the trivial sample that ORX comes with.
import futhark, strutils, os, norx/typ

# These names are too short so we protect them so they will be renamed with the module name as prefix
const protectedNames = ["Setup", "Init", "Exit", "Create", "CreateFromConfig",
  "Get", "Register", "Send", "SendShort", "Update"]
# These modules will 
const shortenedModules = ["input", "system", "object", "event", "clock",
  "resource", "module"]

# Rename logic
proc renameCb(n, k: string, p = ""): string =
  # For enumval and const we just remove the orx prefix
  if k == "enumval" or k == "const":
    if n.startsWith("orx"):
      return n[3..^1]
    else:
      return n
  # We don't want to rename anything that starts with an underscore
  if n.startsWith("_"):
    return n
  # Split out the module name
  let splits = n.split("_", maxsplit=1)
  if splits.len == 1:
    return n
  var module = splits[0]
  # Remove the orx prefix of the module name
  if module.len > 3 and module.startsWith("orx"):
    module = module[3..^1]

  # Ensure the first module character is lowercase
  module[0] = module[0].toLowerAscii()
  let name = splits[1]
  # Treat protected names by prepending module name.
  if name in protectedNames:
    return module & name

  # For these modules we use just the name
  if module in shortenedModules:
    result = name
  else:
    result = n
  # Ensure the first character is lowercase
  result[0] = result[0].toLowerAscii()

# Tell futhark where to find the C libraries you will compile with, and what
# header files you wish to import.
importc:
  path "../../headers"
  renameCallback renameCb
  "base/orxType.h"      # Import base types first
  "base/orxBuild.h"     # Then build info
  "base/orxVersion.h"   # Then version
  "base/orxModule.h"    # Then module
  "core/orxClock.h"
  "core/orxEvent.h"
  "core/orxSystem.h"
  "core/orxConfig.h"
  "core/orxResource.h"
  "debug/orxDebug.h"
  "io/orxInput.h"
  "render/orxViewport.h"
  "object/orxObject.h"
  "orx.h"


proc Update(clockInfo: ptr orxCLOCK_INFO, context: pointer) {.cdecl.} =
  ## Update function, it has been registered to be called every tick of the core clock
  # Should we quit due to user pressing ESC?
  if isActive("Quit"):
    # Send close event
    echo "User quitting"
    discard eventSendShort(EVENT_TYPE_SYSTEM, SYSTEM_EVENT_CLOSE.orxU32)

proc init(): orxSTATUS {.cdecl, gcsafe.} =
  ## Init function, it is called when all orx's modules have been initialized
  echo("Sample1 starting")
  echo("VERSION_FULL_STRING: " & $getVersionFullString())

  # Create the viewport
  var v = viewportCreateFromConfig("MainViewport")
  if not v.isNil:
    echo "Viewport created"

  # Create the scene
  var s = objectCreateFromConfig("Scene")
  if not s.isNil:
    echo "Scene created"

  # Register the Update function to the core clock
  let clock = clockGet(CLOCK_KZ_CORE)
  if not clock.isNil:
    echo "Clock gotten"
  var status = clockRegister(clock, Update, nil, MODULE_ID_MAIN, CLOCK_PRIORITY_NORMAL)
  if status == orxSTATUS_SUCCESS:
    echo "Clock registered"

  # Done!
  return orxSTATUS_SUCCESS

proc run(): orxSTATUS {.sideEffect, cdecl, gcsafe.} =
  ## Run function, it should not contain any game logic
  # Return orxSTATUS_FAILURE to instruct orx to quit
  return orxSTATUS_SUCCESS

proc exit() {.cdecl, gcsafe.} =
  ## Exit function, it is called before exiting from orx
  echo "Exit called"

proc bootstrap(): orxSTATUS {.cdecl, gcsafe.} =
  ## Bootstrap function, it is called before config is initialized, allowing for early resource storage definitions
  # Add a config storage to find the initial config file
  var dir = getCurrentDir()
  var status = addStorage(CONFIG_KZ_RESOURCE_GROUP, cstring(dir &
      "/data/config"), false)
  if status == orxSTATUS_SUCCESS:
    echo "Added storage"
  # Return orxSTATUS_FAILURE to prevent orx from loading the default config file
  return orxSTATUS_SUCCESS

proc mainSetup*() {.cdecl.} =
  ##  Adds module dependencies
  addDependency(MODULE_ID_MAIN, MODULE_ID_OBJECT)
  addDependency(MODULE_ID_MAIN, MODULE_ID_RENDER)
  addOptionalDependency(MODULE_ID_MAIN, MODULE_ID_SCREENSHOT)

proc defaultEventHandler*(pstEvent: ptr orxEVENT): orxSTATUS {.cdecl.} =
  ##  Checks
  assert(pstEvent.eType == EVENT_TYPE_SYSTEM)
  if pstEvent.eID == ord(SYSTEM_EVENT_CLOSE):
    sbStopByEvent = true
  ##  Done!
  return orxSTATUS_SUCCESS

template initDebug*(): void =
  var u32DebugFlags: orxU32
  discard internal_orxDebug_Init()
  u32DebugFlags = internal_orxDebug_GetFlags()
  internal_orxDebug_SetFlags(DEBUG_KU32_STATIC_MASK_DEBUG, DEBUG_KU32_STATIC_MASK_USER_ALL)
  internal_orxDebug_SetFlags(u32DebugFlags, DEBUG_KU32_STATIC_MASK_USER_ALL)

template exitDebug*(): untyped =
  internal_orxDebug_Exit()

template eventSendMacro*(TYPE, ID, SENDER, RECIPIENT, PAYLOAD: untyped): void =
  var stEvent: orxEVENT
  stEvent.eType = cast[orxEVENT_TYPE](TYPE)
  stEvent.eID = cast[orxENUM](ID)
  stEvent.hSender = cast[orxHANDLE](SENDER)
  stEvent.hRecipient = cast[orxHANDLE](RECIPIENT)
  stEvent.pstPayload = cast[pointer](PAYLOAD)
  discard eventSend(addr(stEvent))


proc execute*(initProc: proc(): orxSTATUS {.cdecl.};
                       runProc: proc(): orxSTATUS {.cdecl.};
                       exitProc: proc() {.cdecl.}) {.inline} =
  ## Inits the Debug System
  echo "Inits the Debug System"
  initDebug()
  ## Checks
  assert(runProc != nil)
  ##  Registers main module
  moduleRegister(MODULE_ID_MAIN, "MAIN", mainSetup, initProc, exitProc)
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
  ##  Sends the command line arguments to orxParam module
  if orxParam_SetArgs(argc.orxU32, argv) != orxSTATUS_FAILURE:
    ##  Inits the engine
    if moduleInit(MODULE_ID_MAIN) != orxSTATUS_FAILURE:
      var
        stPayload: struct_orxSYSTEM_EVENT_PAYLOAD_t
        eClockStatus: orxSTATUS
        eMainStatus: orxSTATUS
      ##  Registers default event handler
      var st = addHandler(EVENT_TYPE_SYSTEM, defaultEventHandler)
      # ?? discard orxEvent_SetHandlerIDFlags(orx_DefaultEventHandler, orxEVENT_TYPE_SYSTEM, nil, orxEVENT_GET_FLAG(orxSYSTEM_EVENT_CLOSE), orxEVENT_KU32_MASK_ID_ALL)
      ##  Clears payload
      zeroMem(addr(stPayload), sizeof(struct_orxSYSTEM_EVENT_PAYLOAD_t).orxU32)
      ##  Main loop
      var
        bStop = false
      sbStopByEvent = false
      while not bStop:
        ##  Sends frame start event
        eventSendMacro(EVENT_TYPE_SYSTEM, SYSTEM_EVENT_GAME_LOOP_START, nil, nil, addr(stPayload))
        ##  Runs game specific code
        eMainStatus = runProc()
        ##  Updates clock system
        eClockStatus = clockUpdate()
        ##  Sends frame stop event
        eventSendMacro(EVENT_TYPE_SYSTEM, SYSTEM_EVENT_GAME_LOOP_STOP, nil, nil, addr(stPayload))
        ##  Updates frame count
        stPayload.anon0.u32FrameCount += 1
        bStop = (sbStopByEvent or (eMainStatus == orxSTATUS_FAILURE) or (eClockStatus == orxSTATUS_FAILURE))

      ##  Removes event handler
      discard removeHandler(EVENT_TYPE_SYSTEM, cast[orxEVENT_HANDLER](defaultEventHandler))
      ##  Exits from the engine
      moduleExit(MODULE_ID_MAIN)
  exitDebug()




when isMainModule:
  # Set the bootstrap function to provide at least one resource storage before loading any config files
  var status = orxConfig_SetBootstrap(bootstrap)
  if status == orxSTATUS_SUCCESS:
    echo "Bootstrap was set"

  # Execute our game
  execute(init, run, exit)

  # Done!
  quit(0)

