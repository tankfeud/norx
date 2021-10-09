# Joystick Extras
# helpers and typedefs

import sequtils, math
import norx, norx/[input, joystick, incl, config] # resource, viewport, obj, physics, spawner, vector, display, sound]
import map_controls

type JoyIdName* = tuple[nr: int, name: string, id:string]

type JoyInfo* = ref object
  joysticks*: seq[JoyIdName]

proc getConnectedJoysticks*(): JoyInfo =
  var finnsSektion: bool = hasSection("Input")
  assert finnsSektion , "Sektion Input måste finnas"

  discard selectSection("Input")
  var joyinfo = JoyInfo(joysticks: @[])

  for i in 1..16:
    var isConnected: bool = hasValue("JoyName" & $i)
    if isConnected:
      var joyname = getString("JoyName" & $i)
      var id = getString("JoyID" & $i)
      joyinfo.joysticks.add((i, $joyname, $id))
  return joyinfo

# Convert from joyNr:int & buttonIdx:int to orxJOYSTICK_BUTTON
proc toJoystickButton*(joyNr: int, buttonIdx: int): orxJOYSTICK_BUTTON =
  var eID: int = buttonIdx + (joyNr-1)*(orxJOYSTICK_BUTTON_SINGLE_NUMBER.ord)
  return orxJOYSTICK_BUTTON(uint(eID))

# Return active joystick button(s) for specified joystick nr (1..16) as buttonId:int
# This id is 0..39 (15+25 buttons) which is the range of joystick buttons per joystick (0..orxJOYSTICK_BUTTON_SINGLE_NUMBER.ord-1)
proc getActiveButtons*(joyNr: int): seq[int] =
  var buttonIds: seq[int] = @[]

  for buttonId in (0..orxJOYSTICK_BUTTON_SINGLE_NUMBER.ord-1):
    var joystickButton = toJoystickButton(joyNr, buttonId)
    var isPressed = joystick.isButtonPressed(joystickButton)
    if isPressed == orxTRUE:
      buttonIds.add(buttonId)
  return buttonIds;

# Convert from joyNr:int & axisIdx:int to orxJOYSTICK_AXIS
proc toJoystickAxis*(joyNr: int, axisIdx: int): orxJOYSTICK_AXIS =
  var eID: int = axisIdx + (joyNr-1)*(orxJOYSTICK_AXIS_SINGLE_NUMBER.ord)
  return orxJOYSTICK_AXIS(uint(eID))

# Return active joystick axes for specified joystick nr (1..16) as ActiveAxis
# The ActiveAxis axis is 0..5 (6 axes) which is the range of joystick axes per joystick (0..orxJOYSTICK_AXIS_SINGLE_NUMBER.ord-1)
proc getActiveAxes*(joyNr: int): seq[ActiveAxis] =
  var activeAxes: seq[ActiveAxis] = @[]

  for axisId in (0..orxJOYSTICK_AXIS_SINGLE_NUMBER.ord-1):
    var joystickAxis = toJoystickAxis(joyNr, axisId)
    var value = joystick.getAxisValue(joystickAxis).float
    if value.abs > 0.15:
      activeAxes.add((axisId, value, value.sgn))
  return activeAxes;
