## This is an adaptation to Nim of the C tutorial creating a viewport and an object.
## comments: jseb at finiderire.com

#[
  Debug compilation
  nim c S01_object
  (it will use S01_object.nim.cfg and liborxd.so loaded at runtime)
  
  Release compilation
  nim c -d:release --skipProjcfg S01_object
  (skip nim project cfg, liborx.so loaded at runtime)

  Note from gokr:
  The choice of the lib is made in lib.nim
  It will use liborxd for debug build, liborx for release build and liborxp if you use -d:profile

]#


import norx, norx/[incl, config, viewport, obj, input] 

proc init(): orxSTATUS {.cdecl.} =
  result = orxSTATUS_SUCCESS
  # for getting logs in a file , as well as terminal output, compile in debug.
  orxLOG("""* This tutorial creates a viewport/camera couple and an object
* You can play with the config parameters in S01_object.ini
* After changing them, relaunch the tutorial to see their effects""");
  
  # Creates viewport
  #orxViewport_CreateFromConfig("Viewport");
  var vres = viewportCreateFromConfig("Viewport");
  if vres.isNil:
    result = orxSTATUS_FAILURE

  # Creates object
  var ores = objectCreateFromConfig("Object");
  if ores.isNil:
    result = orxSTATUS_FAILURE


proc run(): orxSTATUS {.cdecl.} =
  result = orxSTATUS_SUCCESS

  # Should quit?
  if (input.isActive("Quit")):
    # Updates result
    result = orxSTATUS_FAILURE;


proc exit() {.cdecl.} =
  quit(0)


proc Main =
  #[ execute is declared in norx.nim , and needs 3 functions:
      proc execute*(initProc: proc(): orxSTATUS {.cdecl.};
                    runProc: proc(): orxSTATUS {.cdecl.};
                    exitProc: proc() {.cdecl.}
                   )
  ]#
  execute(init, run, exit)

Main()

