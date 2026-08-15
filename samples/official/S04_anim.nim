## Port of the official ORX tutorial: animation.
## Adapted to Nim by jseb at finiderire.com, modernized for Norx.

#[
  Animations are stored in a directed graph of possible transitions, defined
  entirely in config. When an animation is requested, the engine walks the
  chain from the current one to the new one.

  The soldier has four animations: IdleRight, IdleLeft, WalkRight, WalkLeft.
  With no key pressed, the graph falls back to the idle animation matching
  the last walking direction - no code needed.

  We also subscribe to animation events to log start, stop, cut, loop and
  custom events.

  Controls:
  - Left/right arrows walk in the matching direction.
  - '+' / '-' keys scale the soldier up / down.
]#

import strformat
import norx
import os

import S_commons

{.push cdecl.}

var soldier: ptr orxOBJECT

proc setAnimation(animation: cstring) =
  if soldier.setTargetAnim(animation).isFailure:
    echo "Error while setting soldier animation ", animation

proc update(clockInfo: ptr orxCLOCK_INFO, context: pointer) =
  if isActive("GoRight"):
    setAnimation("WalkRight")
  elif isActive("GoLeft"):
    setAnimation("WalkLeft")
  else:
    setAnimation(nil)   # follow the graph back to idle

  if isActive("ScaleUp"):
    discard soldier.setScale(soldier.getScale() * 1.02)
  elif isActive("ScaleDown"):
    discard soldier.setScale(soldier.getScale() * 0.98)

proc animationHandler(event: ptr orxEVENT): orxSTATUS {.cdecl.} =
  let payload = cast[ptr orxANIM_EVENT_PAYLOAD](event.pstPayload)
  let owner = cast[ptr orxOBJECT](event.hRecipient)
  case event.eID
  of ord(ANIM_EVENT_START):
    echo fmt"Animation {payload.zAnimName}@{owner.getName} has started!"
  of ord(ANIM_EVENT_STOP):
    echo fmt"Animation {payload.zAnimName}@{owner.getName} has stopped!"
  of ord(ANIM_EVENT_CUT):
    echo fmt"Animation {payload.zAnimName}@{owner.getName} has been cut " &
         fmt"[time: {payload.anon0.stCut.fTime:1.4f}]"
  of ord(ANIM_EVENT_LOOP):
    echo fmt"Animation {payload.zAnimName}@{owner.getName} has looped " &
         fmt"[count: {payload.anon0.stLoop.u32Count}]"
  of ord(ANIM_EVENT_CUSTOM_EVENT):
    echo fmt"Animation {payload.zAnimName}@{owner.getName} has sent " &
         fmt"the event [{payload.anon0.stCustom.zName}]"
  else:
    echo "Unknown animation event ", $event.eID
  result = STATUS_SUCCESS

proc init(): orxSTATUS =
  echo fmt"""
{bindingName("GoLeft")} & {bindingName("GoRight")} will change the soldier animation
{bindingName("ScaleUp")} & {bindingName("ScaleDown")} will scale the soldier"""

  if viewportCreateFromConfig("Viewport").isNil:
    return STATUS_FAILURE

  discard addHandler(EVENT_TYPE_ANIM, animationHandler)

  soldier = objectCreateFromConfig("Soldier")
  if soldier.isNil:
    return STATUS_FAILURE

  if clockRegister(clockGet(CLOCK_KZ_CORE), update, nil,
                   MODULE_ID_MAIN, CLOCK_PRIORITY_NORMAL).isFailure:
    return STATUS_FAILURE
  result = STATUS_SUCCESS

proc bootstrap(): orxSTATUS =
  result = addStorage(CONFIG_KZ_RESOURCE_GROUP, getAppDir(), false)
  if result.isFailure:
    echo "Could not add config storage"

discard setBootstrap(bootstrap)
execute(init, run, exit)
