## Port of the official ORX tutorial: FX.
## Adapted to Nim by jseb at finiderire.com, modernized for Norx.

#[
  FXs combine curves (sine, triangle, square, linear) applied to scale,
  rotation, position, speed, alpha or color. Up to 8 curves form one FX, and
  up to 8 FXs can be active on an object at the same time.

  Almost everything is data-driven: one line of Nim applies an FX defined in
  config. FX parameters can be tweaked and reloaded on the fly with backspace,
  unless the FX is kept in cache.

  Controls:
  - Number keys (or F1..F6 equivalents in config) select the FX.
  - Left control + M selects the multi-FX.
  - Space applies the selected FX to the soldier.

  We also register to the FX events, and bind a small user-data struct to the
  soldier to lock it while an FX is playing - only one FX at a time here.
  The box object has a looping FX applied directly from config, no code.
]#

import strformat
import norx
import os

import S_commons

{.push cdecl.}

type
  SoldierData = object
    locked: bool

var soldier: ptr orxOBJECT
var box: ptr orxOBJECT
var selectedFx = "WobbleFX"
var soldierData = SoldierData()

const fxChoices = [
  ("SelectMultiFX", "MultiFX"),
  ("SelectWobble", "WobbleFX"),
  ("SelectCircle", "CircleFX"),
  ("SelectFade", "FadeFX"),
  ("SelectFlash", "FlashFX"),
  ("SelectMove", "MoveFX"),
  ("SelectFlip", "FlipFX"),
]

proc showHints() =
  echo fmt"""
  To select the FX to apply: {bindingName("SelectWobble")}, {bindingName("SelectCircle")},
  {bindingName("SelectFade")}, {bindingName("SelectFlash")}, {bindingName("SelectMove")},
  {bindingName("SelectFlip")}, or {bindingName("SelectMultiFX")} (multi-FX).
  {bindingName("ApplyFX")} applies the selected FX on the soldier.
  The box has a looping FX applied directly from config."""

proc eventHandler(event: ptr orxEVENT): orxSTATUS {.cdecl.} =
  if event.eType == EVENT_TYPE_INPUT:
    # Log which physical keys triggered the input (single key or combination).
    if event.eID == ord(INPUT_EVENT_ON):
      let payload = cast[ptr orxINPUT_EVENT_PAYLOAD](event.pstPayload)
      if payload.aeType[1] != INPUT_TYPE_NONE:
        echo fmt"{payload.zInputName} triggered by the combination of " &
             fmt"{getBindingName(payload.aeType[0], payload.aeID[0], payload.aeMode[0])} + " &
             fmt"{getBindingName(payload.aeType[1], payload.aeID[1], payload.aeMode[1])}"
      else:
        echo fmt"{payload.zInputName} triggered by " &
             fmt"{getBindingName(payload.aeType[0], payload.aeID[0], payload.aeMode[0])}"

  if event.eType == EVENT_TYPE_FX:
    let payload = cast[ptr orxFX_EVENT_PAYLOAD](event.pstPayload)
    let owner = cast[ptr orxOBJECT](event.hRecipient)
    case event.eID
    of ord(FX_EVENT_START):
      echo fmt"FX {payload.zFXName} {owner.getName} has started!"
      if owner == soldier:
        cast[ptr SoldierData](owner.getUserData()).locked = true
    of ord(FX_EVENT_STOP):
      echo fmt"FX {payload.zFXName} {owner.getName} has stopped!"
      if owner == soldier:
        cast[ptr SoldierData](owner.getUserData()).locked = false
    else:
      echo fmt"Unknown FX event {event.eID} on {owner.getName}"
  result = STATUS_SUCCESS

proc update(clockInfo: ptr orxCLOCK_INFO, context: pointer) =
  for (input, fx) in fxChoices:
    if isActive(input):
      selectedFx = fx
      break

  if hasBeenActivated("ApplyFX"):
    let data = cast[ptr SoldierData](soldier.getUserData())
    if not data.locked:
      discard soldier.addFX(selectedFx)
    else:
      echo "ApplyFX activated, but the soldier is locked: cancel."

proc init(): orxSTATUS =
  showHints()

  if viewportCreateFromConfig("Viewport").isNil:
    return STATUS_FAILURE

  soldier = objectCreateFromConfig("Soldier")
  box = objectCreateFromConfig("Box")
  if soldier.isNil or box.isNil:
    return STATUS_FAILURE

  if clockRegister(clockGet(CLOCK_KZ_CORE), update, nil,
                   MODULE_ID_MAIN, CLOCK_PRIORITY_NORMAL).isFailure:
    return STATUS_FAILURE
  if addHandler(EVENT_TYPE_FX, eventHandler).isFailure or
      addHandler(EVENT_TYPE_INPUT, eventHandler).isFailure:
    return STATUS_FAILURE

  # Bind the user data. soldierData is a global, so it outlives init.
  soldier.setUserData(cast[pointer](addr soldierData))
  result = STATUS_SUCCESS

proc bootstrap(): orxSTATUS =
  result = addStorage(CONFIG_KZ_RESOURCE_GROUP, getAppDir(), false)
  if result.isFailure:
    echo "Could not add config storage"

discard setBootstrap(bootstrap)
execute(init, run, exit)
