## This is an adaptation to Nim of the C tutorial creating a viewport and an object.
## comments: jseb at finiderire.com

#[
  Debug compilation
  nim c S01_object
  (it will use S01_object.nim.cfg and liborxd.so loaded at runtime)
  
  Release compilation
  nim c -d:release --skipProjcfg S01_object
  (skip nim project cfg, liborx.so loaded at runtime)
]#
import norx

# We need cdecl for all functions, as they are called from C code
{.push cdecl.}

proc init(): orxSTATUS =
  result = STATUS_SUCCESS
  # for getting logs in a file , as well as terminal output, compile in debug.
  echo """* This tutorial creates a viewport/camera couple and an object
* You can play with the config parameters in S01_object.ini
* After changing them, relaunch the tutorial to see their effects"""
  
  # Creates viewport
  var vres = viewportCreateFromConfig("Viewport")
  if vres.isNil:
    return STATUS_FAILURE

  # Creates object
  var ores = objectCreateFromConfig("Object");
  if ores.isNil:
    return STATUS_FAILURE

proc run(): orxSTATUS =
  # Should quit?
  if isActive("Quit"):
    STATUS_FAILURE
  else:
    STATUS_SUCCESS

proc exit() =
  quit(0)

execute(init, run, exit)
