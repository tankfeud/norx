import norx, norx/[input, incl, clock, event, system, config, resource, viewport, obj, sound]

var
  introScene: ptr orxOBJECT
  musicPlaying: bool
  music: ptr orxSOUND

proc toggleMusic() =
  if musicPlaying:
    discard music.stop()
  else:
    discard music.play()
  musicPlaying = not musicPlaying

proc update(pstClockInfo: ptr orxCLOCK_INFO, pContext: pointer) {.cdecl.} =
  ## Update function, it has been registered to be called every tick of the core clock
  if isActive("Quit"):
    discard sendShort(orxEVENT_TYPE_SYSTEM, orxSYSTEM_EVENT_CLOSE.orxU32)
  if isActive("ToggleMusic"):
    toggleMusic()

proc init(): orxSTATUS {.cdecl.} =
  ## Main init function (should init all the main stuff and register the main event handler to override the default one)
  orxLOG("Norxdemo starting")
  var v = viewportCreateFromConfig("MainViewport")
  if v.isNil:
    echo "Ooops, no viewport! Failed to find ini file??"
  introScene = objectCreateFromConfig("IntroScene")
  music = soundCreateFromConfig("IntroMusic")
  toggleMusic()
  # Register the Update function to the core clock
  let clock = clockGet(orxCLOCK_KZ_CORE)
  var status = clock.register(norxdemo.update, nil, orxMODULE_ID_MAIN, orxCLOCK_PRIORITY_NORMAL)
  if status == orxSTATUS_SUCCESS:
    return orxSTATUS_SUCCESS
  return orxSTATUS_FAILURE

proc run(): orxSTATUS {.cdecl.} =
  ## Run function, it is called once per frame
  return orxSTATUS_SUCCESS

proc exit() {.cdecl.} =
  ## Exit function, it is called before exiting from orx
  discard

proc bootstrap(): orxSTATUS {.cdecl.} =
  ## Bootstrap function, it is called before config is initialized, allowing for early resource storage definitions
  discard setBaseName("norxdemo")
  discard addStorage(orxCONFIG_KZ_RESOURCE_GROUP, "data", false)
  # Return orxSTATUS_FAILURE to prevent orx from loading the default config file
  return orxSTATUS_SUCCESS

proc start() =
  # Set the bootstrap function to provide at least one resource storage before loading any config files
  discard setBootstrap(bootstrap)
  # Execute our game
  execute(init, run, exit)
  quit(0)

when defined(ANDROID_NATIVE):
  # Declaring NimMain so we can call it below
  proc NimMain() {.importc, cdecl.}

  proc main*(argc: cint, argv: cstringArray): cint {.exportc, cdecl.} =
    # We can't echo before this is done
    setupForeignThreadGc()
    echo "setupForeignThreadGc done"
    NimMain()
    echo "NimMain done"
    start()

when isMainModule:
  start()