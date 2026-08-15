## Port of the official ORX tutorial: linked frames.
## Adapted to Nim by jseb at finiderire.com, modernized for Norx.

#[
  All object positions, scales and rotations are stored in orxFRAME
  structures, assembled in a hierarchy: changing a parent frame affects all
  its children.

  Here four objects are linked to a common invisible parent; two are created
  through the object's ChildList config property, the other two are linked in
  code. The parent follows the mouse cursor.

  Controls:
  - Left/right mouse buttons rotate the parent object.
  - Left shift / left control scale it up / down.
]#

import strformat
import norx
import os

import S_commons

{.push cdecl.}

var parentObject: ptr orxOBJECT

proc update(clockInfo: ptr orxCLOCK_INFO, context: pointer) =
  let dt = clockInfo.fDT

  if isActive("RotateLeft"):
    discard parentObject.setRotation(parentObject.getRotation() - PI * dt)
  if isActive("RotateRight"):
    discard parentObject.setRotation(parentObject.getRotation() + PI * dt)

  if isActive("ScaleUp"):
    discard parentObject.setScale(parentObject.getScale() * 1.02)
  if isActive("ScaleDown"):
    discard parentObject.setScale(parentObject.getScale() * 0.98)

  # If the mouse is over the display, move the parent (and thus its children)
  # under the cursor. getWorldPosition returns nil when outside.
  var mouse = newVECTOR()
  if getWorldPosition(getPosition(addr mouse), nil, addr mouse) != nil:
    var parentPosition: orxVECTOR
    discard parentObject.getWorldPosition(addr parentPosition)
    mouse.fZ = parentPosition.fZ
    discard parentObject.setPosition(mouse)

proc init(): orxSTATUS =
  echo fmt"""
The parent object will follow the mouse.
{bindingName("RotateLeft")} & {bindingName("RotateRight")} will rotate it.
{bindingName("ScaleUp")} & {bindingName("ScaleDown")} will scale it."""

  if viewportCreateFromConfig("Viewport").isNil:
    return STATUS_FAILURE

  # The invisible parent is used as the father of Object3 and Object4 in config.
  parentObject = objectCreateFromConfig("ParentObject")
  discard objectCreateFromConfig("Object0")   # static box, not linked

  let child1 = objectCreateFromConfig("Object1")
  let child2 = objectCreateFromConfig("Object2")
  if parentObject.isNil or child1.isNil or child2.isNil:
    return STATUS_FAILURE
  discard child1.setParent(parentObject)
  discard child2.setParent(parentObject)

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
