## Adaptation to Nim of the C tutorial creating two rotating objects, with keyboard speed control.
## comments: jseb at finiderire.com

#[
  Debug compilation
  nim c S02_clock
  (it will use S01_object.nim.cfg and liborxd.so loaded at runtime)

  Release compilation
  nim c -d:release --skipProjcfg S01_object
  (skip nim project cfg, liborx.so loaded at runtime)

  See tutorial S01_object.nim for more info about the basic object creation.

  For details about Orx side , please refer to the tutorial of the C++ sample:
  https://wiki.orx-project.org/en/tutorials/clock

  Summary is:
  Here we register our callback on 2 different clocks for didactic purpose only.
  All objects can of course be updated with only one clock, and the given clock context is also
  used here for demonstration only.
  The first clock runs at 100 Hz and the second one at 5 Hz.
  You can alter the time of the first clock by activating the "Fast", "Normal" and "Slow" inputs,
  which are defined in the S02_clock.ini file.
  It'll still be updated at the same rate, but the time information that the clock will pass
  to the callback will be stretched.
  This provides an easy way of adding time distortion and having parts
  of your logic code updated at different frequencies.
  One clock can have as many callbacks registered as you want.

  For example, the FPS displayed in the top left corner is computed with a non-stretched clock
  of tick size = 1 second.
]#

import strformat, math
import norx

{.push cdecl.}

proc getBindingName(input_name: string): cstring =
  ## Returns the keycode corresponding to the physical key defined in .ini
  var eType: orxINPUT_TYPE
  var eID: orxENUM
  var eMode: orxINPUT_MODE

  var is_ok = getBinding(input_name, 0 #[index of desired binding]#, addr eType, addr eID, addr eMode)
  if is_ok == STATUS_SUCCESS:
    echo getKeyDisplayName(eID.orxKEYBOARD_KEY)
    return getKeyDisplayName(eID.orxKEYBOARD_KEY)

  return fmt"key {input_name} not found".cstring

proc Update(clockInfo: ptr orxCLOCK_INFO, context: pointer) =
  # Log display section
  discard pushSection("Main")
  if getBool("DisplayLog"):
    let clockName = $clockInfo.getFromInfo.getName
    echo (&"{clockName} time:{clockInfo.fTime:3.2f} delta:{clockInfo.fDT:1.4f}")
  discard popSection()

  # Object update section
  var obj = cast[ptr orxOBJECT](context)
  discard obj.setRotation(PI * clockInfo.fTime)

proc inputUpdate(clockInfo: ptr orxCLOCK_INFO, context: pointer) =
  discard pushSection("Main")
  if hasBeenActivated("Log"):
    discard setBool("DisplayLog", not getBool("DisplayLog"))
  discard popSection()

  var clock1 = clockGet("Clock1")
  if clock1 != nil:
    if isActive("Faster"):
      discard clock1.setModifier(CLOCK_MODIFIER_MULTIPLY, 4.0f)
    elif isActive("Slower"):
      discard clock1.setModifier(CLOCK_MODIFIER_MULTIPLY, 0.25f)
    elif isActive("Normal"):
      discard clock1.setModifier(CLOCK_MODIFIER_MULTIPLY, 0f)

proc init(): orxSTATUS =
  result = STATUS_SUCCESS
  echo(&"""
* Press {getBindingName("Log")} to toggle log display
* To stretch time for the first clock (updating the box):
* Press key {getBindingName("Faster")} to set it 4 times faster
* Press key {getBindingName("Slower")} to set it 4 times slower
* Press key {getBindingName("Normal")} to set it back to normal""")

  # Creates viewport and objects
  var viewport = viewportCreateFromConfig("Viewport")
  if viewport.isNil: return STATUS_FAILURE
  
  var object1 = objectCreateFromConfig("Object1")
  if object1.isNil: return STATUS_FAILURE
  
  var object2 = objectCreateFromConfig("Object2")
  if object2.isNil: return STATUS_FAILURE

  # Creates clocks and registers callbacks
  var clock1 = clockCreateFromConfig("Clock1")
  var clock2 = clockCreateFromConfig("Clock2")
  discard clock1.clockRegister(Update, object1, MODULE_ID_MAIN, CLOCK_PRIORITY_NORMAL)
  discard clock2.clockRegister(Update, object2, MODULE_ID_MAIN, CLOCK_PRIORITY_NORMAL)

  var clockMain = clockGet(CLOCK_KZ_CORE)
  discard clockMain.clockRegister(inputUpdate, nil, MODULE_ID_MAIN, CLOCK_PRIORITY_NORMAL)

proc run(): orxSTATUS =
  # Should quit?
  if isActive("Quit"):
    return STATUS_FAILURE
  return STATUS_SUCCESS

proc exit() =
  quit(0)

execute(init, run, exit)
