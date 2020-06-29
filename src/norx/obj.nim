import oobject, typ
export oobject

proc rotation*(pstObject: ptr orxOBJECT): float {.inline.} = 
  ## Get object world rotation in radians. See orxObject_SetWorldRotation().
  orxObject_GetRotation(pstObject).float

proc rotation*(pstObject: ptr orxOBJECT, rotation: float): orxSTATUS {.inline, discardable.} = 
  ## Sets object rotation in its parent's reference frame. See orxObject_SetWorldRotation() for setting an object's
  ##  rotation in the global reference frame.
  orxObject_SetRotation(pstObject, rotation)
