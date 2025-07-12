import wrapper, vector
export wrapper, vector

when defined(processAnnotations):
  import annotation

  static: processAnnotations(currentSourcePath())


## @file orx/code/include/display/orxDisplay.h:"#define orx2RGBA(R, G, B, A)":10:1aaa54d3a45275ae7f0b700b1e9faec7
template orx2RGBA*(r, g, b, a: untyped): orxRGBA =
  ## Creates RGBA color value from components  
  rgbaSet(r, g, b, a)

template rgbaR*(rgba: orxRGBA): orxU32 =
  ## Extracts red component from RGBA
  orxU32(rgba) and 0xFF

template rgbaG*(rgba: orxRGBA): orxU32 =
  ## Extracts green component from RGBA
  (orxU32(rgba) shr 8) and 0xFF

template rgbaB*(rgba: orxRGBA): orxU32 =
  ## Extracts blue component from RGBA
  (orxU32(rgba) shr 16) and 0xFF

template rgbaA*(rgba: orxRGBA): orxU32 =
  ## Extracts alpha component from RGBA
  (orxU32(rgba) shr 24) and 0xFF

const colorNormalizer* = 1.0f / 255.0f
  ## Normalizes color values

const colorDenormalizer* = 255.0f
  ## Denormalizes color values


## @file orx/code/include/display/orxDisplay.h:"/** Sets all components of an orxRGBA":368:1aaa54d3a45275ae7f0b700b1e9faec7

proc rgbaSet*(r: orxU8, g: orxU8, b: orxU8, a: orxU8): orxRGBA {.inline.} =
  ## Sets all components of an orxRGBA
  result.anon0.anon0.u8R = r
  result.anon0.anon0.u8G = g
  result.anon0.anon0.u8B = b
  result.anon0.anon0.u8A = a

proc setRGBA*(pstColor: ptr orxCOLOR, stRGBA: orxRGBA): ptr orxCOLOR {.inline.} =
  ## Sets all components from an orxRGBA
  assert(pstColor != nil)
  # Stores RGB using vector set operation
  discard set(addr(pstColor.anon0.vRGB), 
    colorNormalizer * stRGBA.anon0.anon0.u8R.orxFLOAT,
    colorNormalizer * stRGBA.anon0.anon0.u8G.orxFLOAT, 
    colorNormalizer * stRGBA.anon0.anon0.u8B.orxFLOAT)
  # Stores alpha
  pstColor.fAlpha = colorNormalizer * stRGBA.anon0.anon0.u8A.orxFLOAT
  pstColor

proc setColor*(pstColor: ptr orxCOLOR, pvRGB: ptr orxVECTOR, fAlpha: orxFLOAT): ptr orxCOLOR {.inline.} =
  ## Sets all components
  assert(pstColor != nil)
  # Stores RGB
  discard copy(addr(pstColor.anon0.vRGB), pvRGB)
  # Stores alpha
  pstColor.fAlpha = fAlpha
  pstColor

proc setRGB*(pstColor: ptr orxCOLOR, pvRGB: ptr orxVECTOR): ptr orxCOLOR {.inline.} =
  ## Sets RGB components
  assert(pstColor != nil)
  assert(pvRGB != nil)
  # Stores components
  discard copy(addr(pstColor.anon0.vRGB), pvRGB)
  pstColor

proc setAlpha*(pstColor: ptr orxCOLOR, fAlpha: orxFLOAT): ptr orxCOLOR {.inline.} =
  ## Sets alpha component
  assert(pstColor != nil)
  # Stores it
  pstColor.fAlpha = fAlpha
  pstColor

proc toRGBA*(pstColor: ptr orxCOLOR): orxRGBA {.inline.} =
  ## Gets orxRGBA from an orxCOLOR
  var vColor: orxVECTOR
  var fAlpha: orxFLOAT
  assert(pstColor != nil)
  # Clamps RGB components
  discard clampv(addr(vColor), addr(pstColor.anon0.vRGB), addr(orxVECTOR_BLACK), addr(orxVECTOR_WHITE))
  # De-normalizes vector
  discard mulf(addr(vColor), addr(vColor), colorDenormalizer)
  # Clamps alpha
  fAlpha = clamp(pstColor.fAlpha, 0.0, 1.0)
  # Updates result
  rgbaSet(vColor.fX.orxU8, vColor.fY.orxU8, vColor.fZ.orxU8, (colorDenormalizer * fAlpha).orxU8)

proc copyColor*(pstDst: ptr orxCOLOR, pstSrc: ptr orxCOLOR): ptr orxCOLOR {.inline.} =
  ## Copies an orxCOLOR into another one
  assert(pstDst != nil)
  assert(pstSrc != nil)
  # Copies it
  copyMem(pstDst, pstSrc, sizeof(orxCOLOR))
  pstDst