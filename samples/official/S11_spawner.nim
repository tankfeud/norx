## Port of the official ORX tutorial: spawners.
## Adapted to Nim by jseb at finiderire.com, modernized for Norx.

#[
  Spawners are used here for particle effects, but they also generate
  monsters or fire bullets. The code has only two tasks:
    1. creating one scene and a viewport
    2. switching between test configurations by reloading ini files

  Everything else - physics, blend modes, masking, speed/acceleration - is
  data-driven. Config changes are applied without restarting: files are
  reloaded when switching tests.

  Controls: 1 / 2 (or mouse wheel) switch to the next/previous test config.
  If there are too many particles, lower WaveSize and/or WaveDelay in the
  spawner config sections.
]#

import strformat
import norx
import os

import S_commons

{.push cdecl.}

var currentScene: ptr orxOBJECT = nil
var configIndex: orxS32 = 0

proc loadConfig(): orxSTATUS =
  # Delete the current scene...
  if currentScene != nil:
    discard objectDelete(currentScene)
    currentScene = nil

  # ...and all viewports.
  var structure = getFirst(STRUCTURE_ID_VIEWPORT)
  while structure != nil:
    discard viewportDelete(cast[ptr orxVIEWPORT](structure))
    structure = getFirst(STRUCTURE_ID_VIEWPORT)

  # Clear all config data and reload the main config.
  if clear(nil).isFailure:
    echo "Problem when clearing config!"
  if configLoad(getMainFileName()).isFailure:
    echo fmt"Problem when loading {getMainFileName()}!"

  discard selectSection("Tutorial")
  if configIndex < getListCount("ConfigList"):
    let configFile = getListString("ConfigList", configIndex)
    echo fmt"Trying to load {configFile}"
    if configLoad(configFile).isSuccess:
      discard pushSection("Tutorial")
      for i in 0 ..< getListCount("ViewportList"):
        discard viewportCreateFromConfig(getListString("ViewportList", i))
      currentScene = objectCreateFromConfig("Scene")
      discard popSection()
      echo fmt"Finished loading {configFile}"
    else:
      echo fmt"Problem with config index {configIndex}"
  result = STATUS_SUCCESS

proc init(): orxSTATUS =
  echo fmt"""
{bindingName("NextConfig")} will switch to the next config settings.
{bindingName("PreviousConfig")} will switch to the previous config settings.
*** All the tests use the same minimalist code (1 scene & 1 viewport)."""

  result = loadConfig()

proc run(): orxSTATUS {.cdecl.} =
  # Input is polled in the main loop here, not in a clock callback.
  if hasBeenActivated("NextConfig"):
    inc configIndex
    if configIndex == getListCount("ConfigList"):
      configIndex = 0
    return loadConfig()

  if hasBeenActivated("PreviousConfig"):
    dec configIndex
    if configIndex < 0:
      configIndex = getListCount("ConfigList") - 1
    return loadConfig()

  if isActive("Quit"):
    return STATUS_FAILURE
  result = STATUS_SUCCESS

proc bootstrap(): orxSTATUS =
  result = addStorage(CONFIG_KZ_RESOURCE_GROUP, getAppDir(), false)
  if result.isFailure:
    echo "Could not add config storage"

discard setBootstrap(bootstrap)
execute(init, run, exit)
