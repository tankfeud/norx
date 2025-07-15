## Minimal test sample to debug spawner issues with Cannon + BulletSpawner setup
## This replicates the tankfeud cannon/spawner hierarchy to isolate spawning problems

import norx

# Shared functions for input handling
import S_commons

var scene: ptr orxOBJECT = nil
var cannon: ptr orxOBJECT = nil
var bulletSpawner: ptr orxSPAWNER = nil

proc objectEventHandler(event: ptr orxEVENT): orxSTATUS {.cdecl.} =
  echo "=== OBJECT EVENT HANDLER CALLED ==="
  
  if (event.eID.ord == OBJECT_EVENT_ENABLE.ord):
    echo "OBJECT_EVENT_ENABLE detected!"
    var obj = cast[ptr orxOBJECT](event.hSender)
    echo "Object enabled: " & $obj.getName()
  elif (event.eID.ord == OBJECT_EVENT_DISABLE.ord):
    echo "OBJECT_EVENT_DISABLE detected!"
    var obj = cast[ptr orxOBJECT](event.hSender)
    echo "Object disabled: " & $obj.getName()
    
  result = STATUS_SUCCESS

proc spawnerEventHandler(event: ptr orxEVENT): orxSTATUS {.cdecl.} =
  echo "=== SPAWNER EVENT HANDLER CALLED ==="
  
  if (event.eID.ord == SPAWNER_EVENT_SPAWN.ord):
    echo "SPAWNER_EVENT_SPAWN detected!"
    
    var spawnerObject = cast[ptr orxOBJECT](event.hSender)
    var spawnedObject = cast[ptr orxOBJECT](event.hRecipient)
    
    echo "Spawner object: " & $spawnerObject.getName()
    echo "Spawned object: " & $spawnedObject.getName()
    
    # Add a simple sound effect if available
    if spawnedObject.getName() == "BulletObject".cstring:
      echo "Bullet spawned successfully!"
    
  result = STATUS_SUCCESS

proc Update(clockInfo: ptr orxCLOCK_INFO, context: pointer) {.cdecl.} =
  
  # Handle fire input - toggle cannon enable state
  if hasBeenActivated("Fire"):
    echo "\n=== FIRE KEY PRESSED ==="
    echo "Cannon current state: " & $cannon.isEnabled()
    
    if cannon.isEnabled():
      echo "Disabling cannon..."
      cannon.enable(false)
    else:
      echo "Enabling cannon..."
      cannon.enable(true)
      
    echo "Cannon new state: " & $cannon.isEnabled()
    echo "BulletSpawner enabled: " & $bulletSpawner.isEnabled()
    echo "========================\n"

proc init(): orxSTATUS {.cdecl.} =
  echo "=== INITIALIZING CANNON SPAWNER TEST ==="
  
  # Create main scene
  scene = objectCreateFromConfig("Scene")
  if scene.isNil:
    echo "ERROR: Failed to create Scene object"
    return STATUS_FAILURE
  echo "Scene created successfully"
  
  # Find the cannon object through Tank->Turret->Cannon hierarchy
  var tank = scene.getChild()
  if tank.isNil:
    echo "ERROR: Failed to find Tank object as child of Scene"
    return STATUS_FAILURE
  echo "Tank found: " & $tank.getName()
  
  var turret = tank.getChild()
  if turret.isNil:
    echo "ERROR: Failed to find Turret object as child of Tank"
    return STATUS_FAILURE
  echo "Turret found: " & $turret.getName()
  
  cannon = turret.getChild()
  if cannon.isNil:
    echo "ERROR: Failed to find Cannon object as child of Turret"
    return STATUS_FAILURE
  echo "Cannon found: " & $cannon.getName()
  
  # Find the bullet spawner via the Spawner structure
  var spawnerStruct = internal_orxObject_GetStructure(cannon, STRUCTURE_ID_SPAWNER)
  if spawnerStruct.isNil:
    echo "ERROR: Failed to find BulletSpawner structure"
    return STATUS_FAILURE
  bulletSpawner = cast[ptr orxSPAWNER](spawnerStruct)
  echo "BulletSpawner found via structure access"
  
  # Initially disable the cannon
  cannon.enable(false)
  echo "Cannon initially disabled"
  
  # Register event handlers
  if addHandler(EVENT_TYPE_OBJECT, objectEventHandler) == STATUS_FAILURE:
    echo "ERROR: Failed to register object event handler"
    return STATUS_FAILURE
  echo "Object event handler registered"
  
  if addHandler(EVENT_TYPE_SPAWNER, spawnerEventHandler) == STATUS_FAILURE:
    echo "ERROR: Failed to register spawner event handler"
    return STATUS_FAILURE
  echo "Spawner event handler registered"
  
  # Register update function on core clock
  var coreClock = clockGet(CLOCK_KZ_CORE)
  if coreClock.clockRegister(Update, nil, MODULE_ID_MAIN, CLOCK_PRIORITY_NORMAL) == STATUS_FAILURE:
    echo "ERROR: Failed to register update function"
    return STATUS_FAILURE
  echo "Update function registered"
  
  echo "=== INITIALIZATION COMPLETE ==="
  echo "Press SPACE to fire (enable/disable cannon)"
  echo "Press ESC to quit"
  
  result = STATUS_SUCCESS

proc run(): orxSTATUS {.cdecl.} =
  result = STATUS_SUCCESS
  
  # Check for quit
  if isActive("Quit"):
    result = STATUS_FAILURE

proc exit() {.cdecl.} =
  echo "=== CLEANUP ==="
  
  # Remove event handlers
  discard removeHandler(EVENT_TYPE_OBJECT, objectEventHandler)
  discard removeHandler(EVENT_TYPE_SPAWNER, spawnerEventHandler)
  echo "Event handlers removed"

# Start ORX with our functions
echo "Starting ORX engine..."
execute(init, run, exit)