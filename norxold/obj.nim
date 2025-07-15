import oobject, typ
export oobject

proc rotation*(pstObject: ptr orxOBJECT): float {.inline.} = 
  ## Get object world rotation in radians. See orxObject_SetWorldRotation().
  getRotation(pstObject).float

proc rotation*(pstObject: ptr orxOBJECT, rotation: float): orxSTATUS {.inline, discardable.} = 
  ## Sets object rotation in its parent's reference frame. See orxObject_SetWorldRotation() for setting an object's
  ##  rotation in the global reference frame.
  setRotation(pstObject, rotation)
