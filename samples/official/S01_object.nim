## Port of the official ORX tutorial: objects.
## Adapted to Nim by jseb at finiderire.com, modernized for Norx.

#[
  Creates a viewport/camera couple and an object from configuration.
  Play with the parameters in S01_object.ini and relaunch to see their effects.
]#

import norx
import os

import S_commons

{.push cdecl.}

proc init(): orxSTATUS =
  if viewportCreateFromConfig("Viewport").isNil:
    return STATUS_FAILURE
  if objectCreateFromConfig("Object").isNil:
    return STATUS_FAILURE
  result = STATUS_SUCCESS

proc bootstrap(): orxSTATUS =
  ## Adds this directory to the config search path before ORX loads config.
  result = addStorage(CONFIG_KZ_RESOURCE_GROUP, getAppDir(), false)
  if result.isFailure:
    echo "Could not add config storage"

discard setBootstrap(bootstrap)
execute(init, run, exit)
