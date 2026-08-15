## Debug sample: a cannon with a bullet spawner.
## Replicates the Tankfeud cannon/spawner hierarchy to isolate spawning issues.

#[
  The scene hierarchy is created in config: Scene > Tank > Turret > Cannon,
  with a BulletSpawner attached to the cannon. Space toggles the cannon
  (enabled cannons spawn bullets in waves); ESC quits.
]#

import norx
import os

import S_commons

{.push cdecl.}

var cannon: ptr orxOBJECT
var bulletSpawner: ptr orxSPAWNER

proc objectHandler(event: ptr orxEVENT): orxSTATUS {.cdecl.} =
  let gameObject = cast[ptr orxOBJECT](event.hSender)
  case event.eID
  of ord(OBJECT_EVENT_ENABLE):
    echo "Object enabled: ", gameObject.getName
  of ord(OBJECT_EVENT_DISABLE):
    echo "Object disabled: ", gameObject.getName
  else:
    discard
  result = STATUS_SUCCESS

proc spawnerHandler(event: ptr orxEVENT): orxSTATUS {.cdecl.} =
  if event.eID == ord(SPAWNER_EVENT_SPAWN):
    let spawner = cast[ptr orxOBJECT](event.hSender)
    let spawned = cast[ptr orxOBJECT](event.hRecipient)
    echo "Spawner ", spawner.getName, " spawned ", spawned.getName
  result = STATUS_SUCCESS

proc update(clockInfo: ptr orxCLOCK_INFO, context: pointer) =
  if hasBeenActivated("Fire"):
    echo "Toggling cannon (was ", (if cannon.isEnabled: "enabled" else: "disabled"), ")"
    discard cannon.enable(not cannon.isEnabled)
    echo "Cannon now: ", (if cannon.isEnabled: "enabled" else: "disabled"),
         ", spawner: ", (if bulletSpawner.isEnabled: "enabled" else: "disabled")

proc init(): orxSTATUS =
  let scene = objectCreateFromConfig("Scene")
  if scene.isNil:
    return STATUS_FAILURE

  # Walk the hierarchy: Scene > Tank > Turret > Cannon.
  let tank = scene.getChild()
  let turret = tank.getChild()
  cannon = turret.getChild()
  if tank.isNil or turret.isNil or cannon.isNil:
    echo "ERROR: failed to find the Tank > Turret > Cannon hierarchy"
    return STATUS_FAILURE

  # Find the bullet spawner through the Cannon's spawner structure.
  let spawnerStructure = internal_orxObject_GetStructure(cannon,
                                                         STRUCTURE_ID_SPAWNER)
  if spawnerStructure.isNil:
    echo "ERROR: failed to find the bullet spawner structure"
    return STATUS_FAILURE
  bulletSpawner = cast[ptr orxSPAWNER](spawnerStructure)

  discard cannon.enable(false)

  if addHandler(EVENT_TYPE_OBJECT, objectHandler).isFailure or
      addHandler(EVENT_TYPE_SPAWNER, spawnerHandler).isFailure:
    return STATUS_FAILURE

  if clockRegister(clockGet(CLOCK_KZ_CORE), update, nil,
                   MODULE_ID_MAIN, CLOCK_PRIORITY_NORMAL).isFailure:
    return STATUS_FAILURE

  echo "Press SPACE to fire (enable/disable the cannon), ESC to quit."
  result = STATUS_SUCCESS

proc bootstrap(): orxSTATUS =
  result = addStorage(CONFIG_KZ_RESOURCE_GROUP, getAppDir(), false)
  if result.isFailure:
    echo "Could not add config storage"

discard setBootstrap(bootstrap)
execute(init, run, exit)
