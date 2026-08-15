## Port of the official ORX tutorial: viewports and cameras.
## Adapted to Nim by jseb at finiderire.com, modernized for Norx.

#[
  Creates four viewports arranged as (1)(2) / (3)(4). Viewports 1 and 4 share
  camera 1; viewport 2 uses a narrower frustum camera (2x zoom); viewport 3
  has its own camera with the same settings as camera 1.

  When two viewports overlap, the oldest one is displayed on top.

  Controls:
  - Left/right mouse buttons rotate camera 1, arrows move it, +/- zoom it.
  - WASD moves viewport 1, Q/E resizes it.
  - The soldier's feet follow the mouse cursor on screen, whatever viewport
    and camera the cursor is over.

  Camera 1's location is shown as a blue square in every viewport (from ini)
  and as a black dot drawn by code in viewport 1.

  Cameras store their position/zoom/rotation in an orxFRAME structure, so
  they can take part in the frame hierarchy - the standard trick for HUDs.
]#

import strformat
import norx
import os

import S_commons

{.push cdecl.}

var viewports: array[4, ptr orxVIEWPORT]
var soldier: ptr orxOBJECT

proc showHints() =
  echo fmt"""
* Workspaces 1 & 4 display camera 1, workspace 2 camera 2, workspace 3 camera 3.
* The soldier stays under the mouse cursor.
  {bindingName("CameraLeft")}/{bindingName("CameraRight")}/{bindingName("CameraUp")}/{bindingName("CameraDown")}: move camera 1
  {bindingName("CameraRotateLeft")}/{bindingName("CameraRotateRight")}: rotate camera 1
  {bindingName("CameraZoomIn")}/{bindingName("CameraZoomOut")}: zoom camera 1
  {bindingName("ViewportLeft")}/{bindingName("ViewportRight")}/{bindingName("ViewportUp")}/{bindingName("ViewportDown")}: move viewport 1
  {bindingName("ViewportScaleUp")}/{bindingName("ViewportScaleDown")}: resize viewport 1"""

proc drawCameraMarker(cameraPosition: ptr orxVECTOR) =
  # The blue square markers are defined in the ini; this one is drawn by code.
  var screenPosition = newVECTOR()
  let onScreen = getScreenPosition(cameraPosition, viewports[0],
                                   addr screenPosition)
  discard drawCircle(onScreen, 10.0, orx2RGBA(0, 0, 0, 255), true)

proc update(clockInfo: ptr orxCLOCK_INFO, context: pointer) =
  let dt = clockInfo.fDT

  # Camera 1 control
  let camera = viewports[0].getCamera()
  if isActive("CameraRotateLeft"):
    discard camera.setRotation(camera.getRotation() - 4.0 * dt)
  if isActive("CameraRotateRight"):
    discard camera.setRotation(camera.getRotation() + 4.0 * dt)
  if isActive("CameraZoomIn"):
    discard camera.setZoom(camera.getZoom() * 1.02)
  if isActive("CameraZoomOut"):
    discard camera.setZoom(camera.getZoom() * 0.98)

  var cameraPosition: orxVECTOR
  discard camera.getPosition(addr cameraPosition)
  if isActive("CameraLeft"): cameraPosition.fX -= 500.0 * dt
  if isActive("CameraRight"): cameraPosition.fX += 500.0 * dt
  if isActive("CameraUp"): cameraPosition.fY -= 500.0 * dt
  if isActive("CameraDown"): cameraPosition.fY += 500.0 * dt
  discard camera.setPosition(addr cameraPosition)
  drawCameraMarker(addr cameraPosition)

  # Viewport 1 control
  var width, height: orxFLOAT
  viewports[0].getRelativeSize(addr width, addr height)
  if isActive("ViewportScaleUp"):
    width *= 1.02
    height *= 1.02
  if isActive("ViewportScaleDown"):
    width *= 0.98
    height *= 0.98
  discard viewports[0].setRelativeSize(width, height)

  var x, y: orxFLOAT
  viewports[0].getPosition(addr x, addr y)
  if isActive("ViewportRight"): x += 500.0 * dt
  if isActive("ViewportLeft"): x -= 500.0 * dt
  if isActive("ViewportDown"): y += 500.0 * dt
  if isActive("ViewportUp"): y -= 500.0 * dt
  viewports[0].setPosition(x, y)

  # Put the soldier under the cursor
  var mouse = newVECTOR()
  if getWorldPosition(getPosition(addr mouse), nil, addr mouse) != nil:
    var soldierPosition: orxVECTOR
    discard soldier.getWorldPosition(addr soldierPosition)
    mouse.fZ = soldierPosition.fZ
    discard soldier.setPosition(mouse)

proc init(): orxSTATUS =
  showHints()

  # Creation order matters: more recently created viewports are on top.
  let names = ["Viewport4", "Viewport3", "Viewport2", "Viewport1"]
  for i, name in names:
    viewports[3 - i] = viewportCreateFromConfig(name.cstring)
    if viewports[3 - i].isNil:
      echo fmt"Couldn't create viewport {4 - i}"
      return STATUS_FAILURE

  discard objectCreateFromConfig("Box")
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
