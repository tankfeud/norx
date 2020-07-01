## This is a port of the trivial sample that ORX comes with.
## Things can be fixed and cleaned, but it runs!

import os

import norx, norx/[incl, clock, event, system, config, resource, input, viewport, obj]

proc Update(clockInfo: ptr orxCLOCK_INFO, context: pointer) =
  ## Update function, it has been registered to be called every tick of the core clock
  # Should we quit due to user pressing ESC?
  if isActive("Quit"):
    # Send close event
    echo "User quitting"
    discard orxEvent_SendShort(orxEVENT_TYPE_SYSTEM, orxSYSTEM_EVENT_CLOSE.orxU32)

proc init(): orxSTATUS {.cdecl.} =
  ## Init function, it is called when all orx's modules have been initialized
  orxLOG("Sample1 starting")

  # Create the viewport
  var v = createFromConfig[orxVIEWPORT]("MainViewport")
  if not v.isNil:
    echo "Viewport created"
  
  # Create the scene
  var s = createFromConfig[orxOBJECT]("Scene")
  if not s.isNil:
    echo "Scene created"

  # Register the Update function to the core clock
  let clock = orxClock_Get(orxCLOCK_KZ_CORE)
  if not clock.isNil:
    echo "Clock gotten"
  var status = orxClock_Register(clock, cast[orxCLOCK_FUNCTION](Update), nil, orxMODULE_ID_MAIN, orxCLOCK_PRIORITY_NORMAL)
  if status == orxSTATUS_SUCCESS:
    echo "Clock registered"

  # Done!
  return orxSTATUS_SUCCESS

proc run(): orxSTATUS {.cdecl.} =
  ## Run function, it should not contain any game logic
  # Return orxSTATUS_FAILURE to instruct orx to quit
  return orxSTATUS_SUCCESS

proc exit() {.cdecl.} =
  ## Exit function, it is called before exiting from orx
  echo "Exit called"

proc bootstrap(): orxSTATUS =
  ## Bootstrap function, it is called before config is initialized, allowing for early resource storage definitions
  # Add a config storage to find the initial config file
  var dir = getCurrentDir()
  var status = orxResource_AddStorage(KZ_RESOURCE_GROUP, $dir & "/data/config", orxFALSE)
  if status == orxSTATUS_SUCCESS:
    echo "Added storage"
  # Return orxSTATUS_FAILURE to prevent orx from loading the default config file
  return orxSTATUS_SUCCESS

when isMainModule:
  # Set the bootstrap function to provide at least one resource storage before loading any config files
  var status = setBootstrap(cast[BOOTSTRAP_FUNCTION](bootstrap))
  if status == orxSTATUS_SUCCESS:
    echo "Bootstrap was set"

  # Execute our game
  execute(init, run, exit)

  # Done!
  quit(0)