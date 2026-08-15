## Port of the official ORX tutorial: scrolling.
## Adapted to Nim by jseb at finiderire.com, modernized for Norx.

#[
  There is no special code for the parallax scrolling: the default 2D render
  plugin does the job based on the objects' AutoScroll and DepthScale config
  properties. Our code merely moves the camera in 3D space.

  The sky object's frame is a child of the camera's frame in config, so the
  sky follows the camera and stays in the background at depth 1000 (matching
  the camera far plane).

  Controls:
  - Arrows move the camera along X and Y.
  - +/- move it along Z.
  - Scrolling speed and other values can be tweaked in config and reloaded.
]#

import strformat
import norx
import os

import S_commons

{.push cdecl.}

var cam: ptr orxCAMERA

proc showHints() =
  echo fmt"""
  {bindingName("CameraUp")}, {bindingName("CameraLeft")}, {bindingName("CameraRight")} and
  {bindingName("CameraDown")} will move the camera.
  {bindingName("CameraZoomIn")} and {bindingName("CameraZoomOut")} will zoom in/out.
  * The scrolling and auto-scaling of objects is data-driven, no code required.
  * The sky background follows the camera (parent/child frame relation)."""

proc update(clockInfo: ptr orxCLOCK_INFO, context: pointer) =
  var movement = newVECTOR()
  var scrollSpeed = newVECTOR()

  discard pushSection("Tutorial")
  discard getVector("ScrollSpeed", addr scrollSpeed)
  discard popSection()

  scrollSpeed = scrollSpeed * clockInfo.fDT
  if isActive("CameraLeft"): movement.fX -= scrollSpeed.fX
  if isActive("CameraRight"): movement.fX += scrollSpeed.fX
  if isActive("CameraDown"): movement.fY += scrollSpeed.fY
  if isActive("CameraUp"): movement.fY -= scrollSpeed.fY
  if isActive("CameraZoomIn"): movement.fZ += scrollSpeed.fZ
  if isActive("CameraZoomOut"): movement.fZ -= scrollSpeed.fZ

  var position: orxVECTOR
  discard cam.getPosition(addr position)
  let target = position + movement
  discard cam.setPosition(addr target)

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

  # The whole scene is an object with two children: Sky and CloudSpawner.
  discard objectCreateFromConfig("Scene")
  result = STATUS_SUCCESS

proc bootstrap(): orxSTATUS =
  result = addStorage(CONFIG_KZ_RESOURCE_GROUP, getAppDir(), false)
  if result.isFailure:
    echo "Could not add config storage"

discard setBootstrap(bootstrap)
execute(init, run, exit)
