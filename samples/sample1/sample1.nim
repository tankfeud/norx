## This is a port of the trivial sample that ORX comes with.
import os
import norx

# We need cdecl for all functions, as they are called from C code
{.push cdecl.}

proc update(clockInfo: ptr orxCLOCK_INFO, context: pointer) =
  ## Update function, it has been registered to be called every tick of the core clock
  # Should we quit due to user pressing ESC?
  if isActive("Quit"):
    # Send close event
    echo "User quitting"
    discard eventSendShort(EVENT_TYPE_SYSTEM, SYSTEM_EVENT_CLOSE.orxU32)

proc init(): orxSTATUS =
  echo "Sample1 starting (Version: " & $getVersionFullString() & ")"
  
  # Setup game objects
  let viewport = viewportCreateFromConfig("MainViewport")
  if viewport.isNil: return STATUS_FAILURE
  echo "Viewport created"

  let scene = objectCreateFromConfig("Scene")
  if scene.isNil: return STATUS_FAILURE
  echo "Scene created"

  # Setup update callback
  let clock = clockGet(CLOCK_KZ_CORE)
  if clock.isNil: return STATUS_FAILURE
  
  let status = clockRegister(clock, update, nil, MODULE_ID_MAIN, CLOCK_PRIORITY_NORMAL)
  if status == STATUS_SUCCESS:
    echo "Clock registered"
    return STATUS_SUCCESS
  
  return STATUS_FAILURE

proc run(): orxSTATUS = STATUS_SUCCESS

proc exit() = echo "Exit called"

proc bootstrap(): orxSTATUS =
  # Setup initial config storage
  let configPath = getCurrentDir() & "/data/config"
  result = addStorage(CONFIG_KZ_RESOURCE_GROUP, cstring(configPath), false)
  if result == STATUS_SUCCESS:
    echo "Added storage"

# Main program
when isMainModule:
  if setBootstrap(bootstrap) == STATUS_SUCCESS:
    echo "Bootstrap was set"
    execute(init, run, exit)
  
  quit(0)
