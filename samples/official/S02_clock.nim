## Port of the official ORX tutorial: clocks.
## Adapted to Nim by jseb at finiderire.com, modernized for Norx.

#[
  Registers the same callback on two different clocks, for didactic purposes:
  Clock1 runs at 100 Hz, Clock2 at 5 Hz. The "Fast", "Normal" and "Slow"
  inputs stretch the time of Clock1 - it still ticks at the same rate, but
  the time passed to the callback is modified. This provides easy time
  distortion for parts of your logic.

  One clock can have as many callbacks as you want. The FPS counter in the
  top-left corner is computed with a non-stretched clock of tick size = 1 s.
]#

import strformat
import norx
import os

import S_commons

{.push cdecl.}

proc update(clockInfo: ptr orxCLOCK_INFO, context: pointer) =
  discard pushSection("Main")
  if getBool("DisplayLog"):
    let clockName = $clockInfo.getFromInfo.getName
    echo fmt"{clockName} time:{clockInfo.fTime:3.2f} delta:{clockInfo.fDT:1.4f}"
  discard popSection()

  let gameObject = cast[ptr orxOBJECT](context)
  discard gameObject.setRotation(PI * clockInfo.fTime)

proc inputUpdate(clockInfo: ptr orxCLOCK_INFO, context: pointer) =
  discard pushSection("Main")
  if hasBeenActivated("Log"):
    discard setBool("DisplayLog", not getBool("DisplayLog"))
  discard popSection()

  let clock1 = clockGet("Clock1")
  if clock1 != nil:
    if isActive("Faster"):
      discard clock1.setModifier(CLOCK_MODIFIER_MULTIPLY, 4.0)
    elif isActive("Slower"):
      discard clock1.setModifier(CLOCK_MODIFIER_MULTIPLY, 0.25)
    elif isActive("Normal"):
      discard clock1.setModifier(CLOCK_MODIFIER_MULTIPLY, 0.0)

proc init(): orxSTATUS =
  echo fmt"""
* Press {bindingName("Log")} to toggle log display
* To stretch time for the first clock (updating the box):
  Press {bindingName("Faster")} to set it 4 times faster
  Press {bindingName("Slower")} to set it 4 times slower
  Press {bindingName("Normal")} to set it back to normal"""

  if viewportCreateFromConfig("Viewport").isNil:
    return STATUS_FAILURE
  let object1 = objectCreateFromConfig("Object1")
  let object2 = objectCreateFromConfig("Object2")
  if object1.isNil or object2.isNil:
    return STATUS_FAILURE

  let clock1 = clockCreateFromConfig("Clock1")
  let clock2 = clockCreateFromConfig("Clock2")
  discard clock1.clockRegister(update, object1, MODULE_ID_MAIN,
                                CLOCK_PRIORITY_NORMAL)
  discard clock2.clockRegister(update, object2, MODULE_ID_MAIN,
                                CLOCK_PRIORITY_NORMAL)
  discard clockGet(CLOCK_KZ_CORE).clockRegister(inputUpdate, nil,
                                                MODULE_ID_MAIN,
                                                CLOCK_PRIORITY_NORMAL)
  result = STATUS_SUCCESS

proc bootstrap(): orxSTATUS =
  result = addStorage(CONFIG_KZ_RESOURCE_GROUP, getAppDir(), false)
  if result.isFailure:
    echo "Could not add config storage"

discard setBootstrap(bootstrap)
execute(init, run, exit)
