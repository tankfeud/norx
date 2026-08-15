## Port of the official ORX tutorial: physics.
## Adapted to Nim by jseb at finiderire.com, modernized for Norx.

#[
  Physical properties are completely data-driven: creating an object with a
  body or without is the same code. A body is static or dynamic and is made
  of up to 8 parts, each with a shape, collision "self" flags and a "check"
  mask - two parts collide when
    (A.SelfFlags & B.CheckMask) && (A.CheckMask & B.SelfFlags).

  Here we create static solid walls around the screen and spawn boxes in the
  middle. Left/right keys (or mouse buttons) rotate the camera, and we rotate
  the gravity vector with it, so boxes always seem to fall toward the bottom
  of the screen.

  We register to the physics events to add a visual FX on colliding objects.
  Scaling an object with a physical body is expensive (shapes are recreated),
  as Box2D doesn't allow real-time rescaling.
]#

import strformat
import norx
import os

import S_commons

{.push cdecl.}

var cam: ptr orxCAMERA

proc showHints() =
  echo fmt"""
  {bindingName("RotateLeft")} and {bindingName("RotateRight")} will rotate the camera.
  Gravity follows the camera. A bump visual FX is played on objects that collide."""

proc physicsHandler(event: ptr orxEVENT): orxSTATUS {.cdecl.} =
  if event.eID == ord(PHYSICS_EVENT_CONTACT_ADD):
    # A new contact: add a "bump" effect on both colliding objects.
    let box1 = cast[ptr orxOBJECT](event.hRecipient)
    let box2 = cast[ptr orxOBJECT](event.hSender)
    discard box1.addFX("Bump")
    discard box2.addFX("Bump")
  result = STATUS_SUCCESS

proc update(clockInfo: ptr orxCLOCK_INFO, context: pointer) =
  var deltaRotation = 0.0
  if isActive("RotateLeft"):
    deltaRotation = 4.0 * clockInfo.fDT
  if isActive("RotateRight"):
    deltaRotation = -4.0 * clockInfo.fDT

  if deltaRotation != 0.0:
    # Rotates the camera
    discard cam.setRotation(cam.getRotation() + deltaRotation)
    # Rotates the gravity vector with it
    var gravity: orxVECTOR
    discard getGravity(addr gravity)
    gravity = gravity.rotate2D(deltaRotation)
    discard setGravity(addr gravity)

proc init(): orxSTATUS =
  showHints()

  let viewport = viewportCreateFromConfig("Viewport")
  if viewport.isNil:
    echo "Couldn't create viewport"
    return STATUS_FAILURE

  cam = viewport.getCamera()
  if clockRegister(clockGet(CLOCK_KZ_CORE), update, nil,
                   MODULE_ID_MAIN, CLOCK_PRIORITY_NORMAL).isFailure:
    return STATUS_FAILURE

  discard addHandler(EVENT_TYPE_PHYSICS, physicsHandler)

  # The whole scene is created from config: walls, spawner, sky.
  discard objectCreateFromConfig("Scene")
  result = STATUS_SUCCESS

proc bootstrap(): orxSTATUS =
  result = addStorage(CONFIG_KZ_RESOURCE_GROUP, getAppDir(), false)
  if result.isFailure:
    echo "Could not add config storage"

discard setBootstrap(bootstrap)
execute(init, run, exit)
