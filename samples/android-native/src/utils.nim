import norx/[obj, vector, config, typ, display]

template notNil*[T](a:T): bool =
  not a.isNil

proc newVector*(): orxVECTOR {.inline.} =
  (0.cfloat, 0.cfloat, 0.cfloat)

proc newVector*(x, y, z: float): orxVECTOR {.inline.} =
  (x.cfloat, y.cfloat, z.cfloat)

proc newSPVector*(): orxSPVECTOR {.inline.} =
  (0.cfloat, 0.cfloat, 0.cfloat)

proc newColor*(rgbVec: orxRGBVECTOR): orxCOLOR {.inline.} =
  #var rgbVec: orxRGBVECTOR = (0.cfloat, 0.cfloat, 0.cfloat)
  (rgbVec, 1.cfloat)

proc box*[T](arg: T): ref T {.inline.} =
  ## Jehan's helper to dynamically allocate a ref T from a T
  new result
  result[] = arg

proc newRGBA*(r,g,b,a: float): ptr orxCOLOR {.inline.} =
  ## Allocate a new color
  cast[ptr orxCOLOR](box((vRGB: (fR: r.cfloat, fG: g.cfloat, fB: b.cfloat), fAlpha: a.cfloat)))

proc newRGBA*(v: ptr orxVECTOR, a: float): ptr orxCOLOR {.inline.} =
  ## Allocate a new color
  cast[ptr orxCOLOR](box((vRGB: v[], fAlpha: a.cfloat)))

proc RGBA*(r,g,b,a: float): orxCOLOR {.inline.} =
  ## Allocate a new color
  (vRGB: (fR: r.cfloat, fG: g.cfloat, fB: b.cfloat), fAlpha: a.cfloat)

proc intFromConfig*(section, key: string): int =
  ## Look up int value for key in section 
  if not hasSection(section):
    echo "No such section: " & $section
    return 0
  discard selectSection(section)
  if not hasValue(key):
    echo "No such value in section " & $section
    return 0
  else:
    return getU32(key).int

proc findOwner*(orxObject: ptr orxOBJECT, configName: string): ptr orxOBJECT =
  ## Check owner chain for object by config name
  var owner = cast[ptr orxOBJECT](orxObject.getOwner());
  if owner.isNil or configName == owner.getName():
    return owner
  else:
    return findOwner(owner, configName)

when defined(ANDROID_NATIVE):
  proc androidlog(prio: cint; tag: cstring; fmt: cstring): cint
      {.importc: "__android_log_print", header: "<android/log.h>", varargs, discardable.}
