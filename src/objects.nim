import wrapper

proc objectCreateFromConfig*(configId: string): ptr orxOBJECT {.inline.} =
  ## Creates an object from a Nim string configuration ID.
  wrapper.objectCreateFromConfig(configId.cstring)

proc setTextString*(gameObject: ptr orxOBJECT;
                    text: string): orxSTATUS {.inline.} =
  ## Sets an object's text from a Nim string.
  wrapper.setTextString(gameObject, text.cstring)

proc addFX*(gameObject: ptr orxOBJECT; configId: string): orxSTATUS {.inline.} =
  ## Adds a configured effect using a Nim string ID.
  wrapper.addFX(gameObject, configId.cstring)

proc addSound*(gameObject: ptr orxOBJECT;
               configId: string): orxSTATUS {.inline.} =
  ## Adds a configured sound using a Nim string ID.
  wrapper.addSound(gameObject, configId.cstring)

proc setPivot*(gameObject: ptr orxOBJECT; pivot: orxVECTOR): orxSTATUS {.inline.} =
  ## Sets an object's pivot from a vector value.
  var value = pivot
  gameObject.setPivot(addr value)

proc getPivot*(gameObject: ptr orxOBJECT): orxVECTOR {.inline.} =
  ## Gets an object's pivot as a vector value.
  discard gameObject.getPivot(addr result)

proc setOrigin*(gameObject: ptr orxOBJECT; origin: orxVECTOR): orxSTATUS {.inline.} =
  ## Sets an object's origin from a vector value.
  var value = origin
  gameObject.setOrigin(addr value)

proc getOrigin*(gameObject: ptr orxOBJECT): orxVECTOR {.inline.} =
  ## Gets an object's origin as a vector value.
  discard gameObject.getOrigin(addr result)

proc setSize*(gameObject: ptr orxOBJECT; size: orxVECTOR): orxSTATUS {.inline.} =
  ## Sets an object's size from a vector value.
  var value = size
  gameObject.setSize(addr value)

proc getSize*(gameObject: ptr orxOBJECT): orxVECTOR {.inline.} =
  ## Gets an object's size as a vector value.
  discard gameObject.getSize(addr result)

proc setPosition*(gameObject: ptr orxOBJECT;
                  position: orxVECTOR): orxSTATUS {.inline.} =
  ## Sets an object's local position from a vector value.
  var value = position
  gameObject.setPosition(addr value)

proc getPosition*(gameObject: ptr orxOBJECT): orxVECTOR {.inline.} =
  ## Gets an object's local position as a vector value.
  discard gameObject.getPosition(addr result)

proc setWorldPosition*(gameObject: ptr orxOBJECT;
                       position: orxVECTOR): orxSTATUS {.inline.} =
  ## Sets an object's world position from a vector value.
  var value = position
  gameObject.setWorldPosition(addr value)

proc getWorldPosition*(gameObject: ptr orxOBJECT): orxVECTOR {.inline.} =
  ## Gets an object's world position as a vector value.
  discard gameObject.getWorldPosition(addr result)

proc setScale*(gameObject: ptr orxOBJECT; scale: orxVECTOR): orxSTATUS {.inline.} =
  ## Sets an object's local scale from a vector value.
  var value = scale
  gameObject.setScale(addr value)

proc getScale*(gameObject: ptr orxOBJECT): orxVECTOR {.inline.} =
  ## Gets an object's local scale as a vector value.
  discard gameObject.getScale(addr result)

proc setWorldScale*(gameObject: ptr orxOBJECT;
                    scale: orxVECTOR): orxSTATUS {.inline.} =
  ## Sets an object's world scale from a vector value.
  var value = scale
  gameObject.setWorldScale(addr value)

proc getWorldScale*(gameObject: ptr orxOBJECT): orxVECTOR {.inline.} =
  ## Gets an object's world scale as a vector value.
  discard gameObject.getWorldScale(addr result)

proc setSpeed*(gameObject: ptr orxOBJECT; speed: orxVECTOR): orxSTATUS {.inline.} =
  ## Sets an object's speed from a vector value.
  var value = speed
  gameObject.setSpeed(addr value)

proc getSpeed*(gameObject: ptr orxOBJECT): orxVECTOR {.inline.} =
  ## Gets an object's speed as a vector value.
  discard gameObject.getSpeed(addr result)
