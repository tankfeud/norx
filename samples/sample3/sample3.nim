## This is a simple shader example

import os

import norx, norx/[incl, clock, event, system, config, resource, input, viewport, obj, version, joystick]

proc Update(clockInfo: ptr orxCLOCK_INFO, context: pointer) {.cdecl.} =
  ## Update function, it has been registered to be called every tick of the core clock
  # Should we quit due to user pressing ESC?
  if isActive("Quit"):
    # Send close event
    echo "User quitting"
    discard sendShort(orxEVENT_TYPE_SYSTEM, orxSYSTEM_EVENT_CLOSE.orxU32)

proc init(): orxSTATUS {.cdecl.} =
  ## Init function, it is called when all orx's modules have been initialized
  orxLOG("Sample3 starting")

  orxlog("VERSION_FULL_STRING: " & $ORX_VERSION_FULL_STRING)

  # Create the viewports
  discard config.pushSection("Main")
  for i in 0 ..< config.getListCount("ViewportList"):
    var viewportName = config.getListString("ViewportList", i)
    var v = viewportCreateFromConfig(viewportName)
    if not v.isNil:
      echo viewportName, " created"
  discard config.popSection()

  # Create the scene
  var s = objectCreateFromConfig("Scene")
  if not s.isNil:
    echo "Scene created"

  # Register the Update function to the core clock
  let clock = clockGet(orxCLOCK_KZ_CORE)
  if not clock.isNil:
    echo "Clock gotten"
  var status = clock.register(Update, nil, orxMODULE_ID_MAIN, orxCLOCK_PRIORITY_NORMAL)
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

proc bootstrap(): orxSTATUS {.cdecl.} =
  ## Bootstrap function, it is called before config is initialized, allowing for early resource storage definitions
  # Add a config storage to find the initial config file
  var dir = getCurrentDir()
  var status = addStorage(orxCONFIG_KZ_RESOURCE_GROUP, $dir & "/data/config", false)
  if status == orxSTATUS_SUCCESS:
    echo "Added storage"
  # Return orxSTATUS_FAILURE to prevent orx from loading the default config file
  return orxSTATUS_SUCCESS

when isMainModule:
  # Set the bootstrap function to provide at least one resource storage before loading any config files
  var status = setBootstrap(bootstrap)
  if status == orxSTATUS_SUCCESS:
    echo "Bootstrap was set"

  # Execute our game
  execute(init, run, exit)

  # Done!
  quit(0)
