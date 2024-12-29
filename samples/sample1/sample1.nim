## This is a port of the trivial sample that ORX comes with.
import strutils, os
import norx

proc Update(clockInfo: ptr struct_orxCLOCK_INFO_t, context: pointer) {.cdecl.} =
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
  if status == STATUS_SUCCESS:
    echo "Clock registered"

  # Done!
  return STATUS_SUCCESS

proc run(): orxSTATUS {.sideEffect, cdecl, gcsafe.} =
  ## Run function, it should not contain any game logic
  # Return orxSTATUS_FAILURE to instruct orx to quit
  return STATUS_SUCCESS

proc exit() {.cdecl, gcsafe.} =
  ## Exit function, it is called before exiting from orx
  echo "Exit called"

proc bootstrap(): orxSTATUS {.cdecl, gcsafe.} =
  ## Bootstrap function, it is called before config is initialized, allowing for early resource storage definitions
  # Add a config storage to find the initial config file
  var dir = getCurrentDir()
  var status = addStorage(CONFIG_KZ_RESOURCE_GROUP, cstring(dir &
      "/data/config"), false)
  if status == STATUS_SUCCESS:
    echo "Added storage"
  # Return orxSTATUS_FAILURE to prevent orx from loading the default config file
  return STATUS_SUCCESS


when isMainModule:
  # Set the bootstrap function to provide at least one resource storage before loading any config files
  var status = orxConfig_SetBootstrap(bootstrap)
  if status == STATUS_SUCCESS:
    echo "Bootstrap was set"

  # Execute our game
  execute(init, run, exit)

  # Done!
  quit(0)

