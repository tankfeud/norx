import norx, norx/[input, joystick, incl, clock, event, system, config, resource, viewport, obj]

import sequtils, math
import norx/extras/[map_controls, joystick_extras]

import map_box


var
  infoOrxObject: ptr orxOBJECT
  infoOrxObject2: ptr orxOBJECT
  remapMode = false
  emulationFlag = false
  joyInfo: JoyInfo
  mappingBoxes: seq[MappingBox] = @[] # same nr of boxes as joyInfo.joysticks


var mapControl: MapControls

# Mock getters for joystick emulation by keyboard
proc getActiveButtonsFromKeys*(joyNr: int): seq[int] =
  var buttonIds: seq[int] = @[]

  var keys : seq[tuple[inp:string, btn:orxJOYSTICK_BUTTON]] = @[
    ("AKey", orxJOYSTICK_1_BUTTON_A),
    ("BKey", orxJOYSTICK_1_BUTTON_B),
    ("XKey", orxJOYSTICK_1_BUTTON_X),
    ("YKey", orxJOYSTICK_1_BUTTON_Y)
  ]

  for key in keys:
    if isActive(key.inp & $joyNr):
      buttonIds.add(key.btn.ord)
  return buttonIds;

proc getActiveAxesFromKeys*(joyNr: int): seq[ActiveAxis] =
  var axisIds: seq[ActiveAxis] = @[]

  var active: tuple[axis: orxJOYSTICK_AXIS, value: float]
  active = if isActive("LXPosKey" & $joyNr):
    (orxJOYSTICK_1_AXIS_LX, 1.0)
  elif isActive("LXNegKey" & $joyNr):
    (orxJOYSTICK_1_AXIS_LX, -1.0)
  elif isActive("LYPosKey" & $joyNr):
    (orxJOYSTICK_1_AXIS_LY, 1.0)
  elif isActive("LYNegKey" & $joyNr):
    (orxJOYSTICK_1_AXIS_LY, -1.0)
  elif isActive("RXPosKey" & $joyNr):
    (orxJOYSTICK_1_AXIS_RX, 1.0)
  elif isActive("RXNegKey" & $joyNr):
    (orxJOYSTICK_1_AXIS_RX, -1.0)
  elif isActive("RYPosKey" & $joyNr):
    (orxJOYSTICK_1_AXIS_RY, 1.0)
  elif isActive("RYNegKey" & $joyNr):
    (orxJOYSTICK_1_AXIS_RY, -1.0)
  else:
    (orxJOYSTICK_AXIS_NONE, 0.0)

  if active.axis != orxJOYSTICK_AXIS_NONE:
    var activeAxis: ActiveAxis = (active.axis.ord, active.value, active.value.sgn)
    axisIds.add(activeAxis)
  return axisIds;


proc connected2JoysticksFake(): JoyInfo =
  var joyinfo = JoyInfo(joysticks: @[])

  var joyNrs = @[1,2]
  for joyNr in joyNrs:
    var joyname = "JOYSTICK" & $joyNr
    var id = "JoyID" & $joyNr
    joyinfo.joysticks.add((joyNr, $joyname, $id))
  return joyinfo

proc getConnected(): JoyInfo =
  var joyinfo = if emulationFlag: connected2JoysticksFake() else: getConnectedJoysticks()
  return joyinfo

proc showConnected() =
  var joyinfo = getConnected()
  orxLOG("Connected Joysticks:")
  for joy in joyinfo.joysticks:
      orxLOG("Joy #" & $joy.nr & ":" & joy.name & ", id:" & $joy.id)

proc toggleJoyKeyEmul() =
  emulationFlag = not emulationFlag
  orxLOG("Joystick emulation from Keyboard is: " & $emulationFlag)



# Display the mapping states for all joysticks (mapControl.mapResponse.joysticks)
# in the corresponding MappingBoxes with
# header: Name of joystick already filled in
# step states:
proc displayMappingState(mapState: MapStepState) =

  for mappingBox in mappingBoxes:
    if mappingBox.joy.nr == mapState.joyNr:

      var stepIdx = 0
      for stepText in mappingBox.steptexts:
        let step = stepText.step
        var resultText = ""
        if stepIdx < mapState.results.len:
          let result = mapState.results[stepIdx]
          let inputTypeStr = if result.inputType == JOY_BTN: "BTN"
            elif result.inputType == JOY_AXIS: "AXIS"
            else: "ANY"
          let axisDirStr = if result.inputType == JOY_AXIS:
            if result.axisDir > 0: "/P" else: "/N"
            else: ""
          resultText = $inputTypeStr & ":" & $result.inputID & $axisDirStr

        let textString = $step.desc & ":" & $resultText
        discard stepText.textObj.setTextString(textString.cstring)
        stepIdx += 1


proc remap() =
  mapControl.mappingUpdateHandler()

  for mapState in mapControl.mapResponse.states:
    displayMappingState(mapState)

  var text = "States:"
  for mapState in mapControl.mapResponse.states:
    text = text & ("\njoy #: " & $mapState.joyNr & " stat:" & $mapState.status)
    if mapState.status == WaitNext:
      text = text & ", Release inputId " & $mapState.lastBtnId
      if mapState.warn == WARN_AXIS_ACTIVE:
        text = text & "/Axis"
      if mapState.warn == WARN_BTN_ACTIVE:
        text = text & "/Button"
    if mapState.status == Mapping:
      var stepText = ""
      if mapState.stepIdx < 0:
        stepText = "Init"
      else:
        let step = mapControl.mapRequest.steps[mapState.stepIdx]
        stepText = (" step #" & $mapState.stepIdx & ":" & $step.desc)
      text = text & $stepText
      text = text & "\nbtn:" & $mapState.lastBtnId & (if mapState.warn != WARN_NONE: (",warn:" & $mapState.warn) else: "")

    text = text & "\n\nResults:"
    for result in mapState.results:
      let axisDirStr = if result.inputType == JOY_AXIS:
        if result.axisDir > 0: "P" else: "N"
        else: ""
      let inputIdStr = if result.inputType == JOY_AXIS:
        $toJoystickAxis(mapState.joyNr, result.inputID)
      else:
        $toJoystickButton(mapState.joyNr, result.inputID)
      let inputIdValueStr = "(" & $result.inputID & ")"
      text = text & ("\n" & $result.inputType & ":" & $inputIdStr & inputIdValueStr & " " & $axisDirStr)
    text = text & "\n"

  discard infoOrxObject2.setTextString(text.cstring)

proc startMapping() =
  showConnected()
  joyinfo = getConnected()

  let joyNrSeq: seq[int] = joyinfo.joysticks.map(proc(j: JoyIdName): int = j.nr)

  let steps: seq[MapStep] = @[
    MapStep(id:"s1", desc:"Left", ctrlType: JOY_ANY),
    MapStep(id:"s2", desc:"RIGHT", ctrlType: JOY_ANY, oppositePrev: true), # opposite to preivous/Left
    MapStep(id:"s3", desc:"THRUST", ctrlType: JOY_ANY),
    MapStep(id:"s4", desc:"FIRE", ctrlType: JOY_BTN)
  ]

  proc activeInputsGetter(joyNr: int): ActiveInputs =
    if emulationFlag:
      return ActiveInputs(
          buttons: getActiveButtonsFromKeys(joyNr),
          axes: getActiveAxesFromKeys(joyNr))
    else:
      return ActiveInputs(
          buttons: getActiveButtons(joyNr),
          axes: getActiveAxes(joyNr))

  let mapRequest = MapRequest(joystickNrs: joyNrSeq, steps: steps, stableCount: 25, run: true)
  mapControl = newMapControls(mapRequest, activeInputsGetter)

  # GUI: mapping boxes
  var posXBase = -550
  var posYBase = -200
  var distanceX = 250+10
  var distanceY = 350

  for mapBox in mappingBoxes:
    mapBox.destroy()

  mappingBoxes = @[];
  for joyIdName in joyInfo.joysticks:
    var idx:int = joyIdName.nr - 1
    var x:int = idx mod 4
    var y:int = idx div 4
    var posX = posXBase + x * distanceX
    var posY = posYBase + y * distanceY
    mappingBoxes.add(map_box.mapBox(joyIdName, steps, posX, posY))


proc update(pstClockInfo: ptr orxCLOCK_INFO, pContext: pointer) {.cdecl.} =
  ## Update function, it has been registered to be called every tick of the core clock

  ## Should quit?
  if isActive("Quit"):
     # Updates result
     #  eResult = orxSTATUS_FAILURE;
    discard sendShort(orxEVENT_TYPE_SYSTEM, orxSYSTEM_EVENT_CLOSE.orxU32)
    return

  if hasBeenActivated("ShowJoy"):
    showConnected()

  if hasBeenActivated("ToggleJoyKeyEmul"):
    toggleJoyKeyEmul()

  if hasBeenActivated("StopMapping"):
    orxLOG("StopMapping")
    remapMode = false
    mapControl.mapRequest.run = false

  if hasBeenActivated("Remap"):
    orxLOG("Remap is started")
    remapMode = true
    discard infoOrxObject.setTextString("Press and hold 2 buttons to\ninitiate mapping sequence")
    startMapping()

  if remapMode:
    remap()
    if not remapMode:
      discard infoOrxObject.setTextString("Press enter to remap")


proc init(): orxSTATUS {.cdecl.} =
  orxLOG("App starting")

  # Creates viewport
  var vres = viewportCreateFromConfig("Viewport");
  if vres.isNil:
    result = orxSTATUS_FAILURE

  infoOrxObject = objectCreateFromConfig("InfoOverlay")
  infoOrxObject2 = objectCreateFromConfig("InfoOverlay2")
  discard objectCreateFromConfig("Scene")

  showConnected()

  # Event handlers
  #discard infoOrxObject.setTextString("Press Enter to remap joystick input")

  # Register the Update function to the core clock
  let clock = clockGet(orxCLOCK_KZ_CORE)
  var status = clock.register(update, nil, orxMODULE_ID_MAIN, orxCLOCK_PRIORITY_NORMAL)
  if status == orxSTATUS_SUCCESS:
    return orxSTATUS_SUCCESS
  return orxSTATUS_FAILURE

proc run(): orxSTATUS {.cdecl.} =
  return orxSTATUS_SUCCESS

proc exit() {.cdecl.} =
  ## Exit function, it is called before exiting from orx
  discard

proc bootstrap(): orxSTATUS {.cdecl.} =
  discard addStorage(orxCONFIG_KZ_RESOURCE_GROUP, "data/config", false)
  return orxSTATUS_SUCCESS

when isMainModule:
  discard setBootstrap(bootstrap)

  execute(init, run, exit)

  quit(0)
