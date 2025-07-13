import pure/math, basics

when defined(processAnnotations):
  import annotation

  static: processAnnotations(currentSourcePath())

## @file orx/code/include/math/orxVector.h:"typedef struct __orxVECTOR_t":891:1571c6f58bc4b8ca144d540649ac7bf1

proc set*(pvVec: ptr orxVECTOR; fX: orxFLOAT; fY: orxFLOAT; fZ: orxFLOAT): ptr orxVECTOR {.inline, cdecl.} =
  ## Sets vector XYZ values
  assert(pvVec != nil)
  pvVec.fX = fX
  pvVec.fY = fY
  pvVec.fZ = fZ
  pvVec

proc setAll*(pvVec: ptr orxVECTOR; fValue: orxFLOAT): ptr orxVECTOR {.inline, cdecl.} =
  ## Sets all the vector coordinates with the given value
  set(pvVec, fValue, fValue, fValue)

proc copy*(pvDst: ptr orxVECTOR; pvSrc: ptr orxVECTOR): ptr orxVECTOR {.inline, cdecl.} =
  ## Copies a vector onto another one
  assert(pvDst != nil)
  assert(pvSrc != nil)
  copyMem(pvDst, pvSrc, sizeof((orxVECTOR)).orxU32)
  pvDst

proc add*(pvRes: ptr orxVECTOR; pvOp1: ptr orxVECTOR; pvOp2: ptr orxVECTOR): ptr orxVECTOR {.inline, cdecl.} =
  ## Adds vectors and stores result in a third one
  assert(pvRes != nil)
  assert(pvOp1 != nil)
  assert(pvOp2 != nil)
  pvRes.fX = pvOp1.fX + pvOp2.fX
  pvRes.fY = pvOp1.fY + pvOp2.fY
  pvRes.fZ = pvOp1.fZ + pvOp2.fZ
  pvRes

proc sub*(pvRes: ptr orxVECTOR; pvOp1: ptr orxVECTOR; pvOp2: ptr orxVECTOR): ptr orxVECTOR {.inline, cdecl.} =
  ## Subtracts vectors and stores result in a third one
  assert(pvRes != nil)
  assert(pvOp1 != nil)
  assert(pvOp2 != nil)
  pvRes.fX = pvOp1.fX - pvOp2.fX
  pvRes.fY = pvOp1.fY - pvOp2.fY
  pvRes.fZ = pvOp1.fZ - pvOp2.fZ
  pvRes

proc mulf*(pvRes: ptr orxVECTOR; pvOp1: ptr orxVECTOR; fOp2: orxFLOAT): ptr orxVECTOR {.inline, cdecl.} =
  ## Multiplies a vector by a float and stores result in another one
  assert(pvRes != nil)
  assert(pvOp1 != nil)
  pvRes.fX = pvOp1.fX * fOp2
  pvRes.fY = pvOp1.fY * fOp2
  pvRes.fZ = pvOp1.fZ * fOp2
  pvRes

proc mul*(pvRes: ptr orxVECTOR; pvOp1: ptr orxVECTOR; pvOp2: ptr orxVECTOR): ptr orxVECTOR {.inline, cdecl.} =
  ## Multiplies a vector by another vector and stores result in a third one
  assert(pvRes != nil)
  assert(pvOp1 != nil)
  assert(pvOp2 != nil)
  pvRes.fX = pvOp1.fX * pvOp2.fX
  pvRes.fY = pvOp1.fY * pvOp2.fY
  pvRes.fZ = pvOp1.fZ * pvOp2.fZ
  pvRes

proc divf*(pvRes: ptr orxVECTOR; pvOp1: ptr orxVECTOR; fOp2: orxFLOAT): ptr orxVECTOR {.inline, cdecl.} =
  ## Divides a vector by a float and stores result in another one
  assert(pvRes != nil)
  assert(pvOp1 != nil)
  assert(fOp2 != 0.0)
  let fRecCoef = 1.0 / fOp2
  pvRes.fX = pvOp1.fX * fRecCoef
  pvRes.fY = pvOp1.fY * fRecCoef
  pvRes.fZ = pvOp1.fZ * fRecCoef
  pvRes

proc divv*(pvRes: ptr orxVECTOR; pvOp1: ptr orxVECTOR; pvOp2: ptr orxVECTOR): ptr orxVECTOR {.inline, cdecl.} =
  ## Divides a vector by another vector and stores result in a third one
  assert(pvRes != nil)
  assert(pvOp1 != nil)
  assert(pvOp2 != nil)
  pvRes.fX = pvOp1.fX / pvOp2.fX
  pvRes.fY = pvOp1.fY / pvOp2.fY
  pvRes.fZ = pvOp1.fZ / pvOp2.fZ
  pvRes

proc modv*(pvRes: ptr orxVECTOR; pvOp1: ptr orxVECTOR; pvOp2: ptr orxVECTOR): ptr orxVECTOR {.inline, cdecl.} =
  ## Gets the modulo of a vector by another vector and stores result in a third one
  assert(pvRes != nil)
  assert(pvOp1 != nil)
  assert(pvOp2 != nil)
  pvRes.fX = pvOp1.fX mod pvOp2.fX
  pvRes.fY = pvOp1.fY mod pvOp2.fY
  pvRes.fZ = pvOp1.fZ mod pvOp2.fZ
  pvRes

proc powv*(pvRes: ptr orxVECTOR; pvOp1: ptr orxVECTOR; pvOp2: ptr orxVECTOR): ptr orxVECTOR {.inline, cdecl.} =
  ## Gets the power of a vector by another vector and stores result in a third one
  assert(pvRes != nil)
  assert(pvOp1 != nil)
  assert(pvOp2 != nil)
  pvRes.fX = pow(pvOp1.fX, pvOp2.fX)
  pvRes.fY = pow(pvOp1.fY, pvOp2.fY)
  pvRes.fZ = pow(pvOp1.fZ, pvOp2.fZ)
  pvRes

proc lerpv*(pvRes: ptr orxVECTOR; pvOp1: ptr orxVECTOR; pvOp2: ptr orxVECTOR; fOp: orxFLOAT): ptr orxVECTOR {.inline, cdecl.} =
  ## Lerps from one vector to another one using a coefficient
  assert(pvRes != nil)
  assert(pvOp1 != nil)
  assert(pvOp2 != nil)
  pvRes.fX = lerp(pvOp1.fX, pvOp2.fX, fOp)
  pvRes.fY = lerp(pvOp1.fY, pvOp2.fY, fOp)
  pvRes.fZ = lerp(pvOp1.fZ, pvOp2.fZ, fOp)
  pvRes

proc remapv*(pvRes: ptr orxVECTOR; pvA1: ptr orxVECTOR; pvB1: ptr orxVECTOR;
           pvA2: ptr orxVECTOR; pvB2: ptr orxVECTOR; pvV: ptr orxVECTOR): ptr orxVECTOR {.inline, cdecl.} =
  ## Remaps a vector value from one interval to another one
  assert(pvRes != nil)
  assert(pvA1 != nil)
  assert(pvB1 != nil)
  assert(pvA2 != nil)
  assert(pvB2 != nil)
  assert(pvV != nil)
  pvRes.fX = remap(pvA1.fX, pvB1.fX, pvA2.fX, pvB2.fX, pvV.fX)
  pvRes.fY = remap(pvA1.fY, pvB1.fY, pvA2.fY, pvB2.fY, pvV.fY)
  pvRes.fZ = remap(pvA1.fZ, pvB1.fZ, pvA2.fZ, pvB2.fZ, pvV.fZ)
  pvRes

proc minv*(pvRes: ptr orxVECTOR; pvOp1: ptr orxVECTOR; pvOp2: ptr orxVECTOR): ptr orxVECTOR {.inline, cdecl.} =
  ## Gets minimum between two vectors
  assert(pvRes != nil)
  assert(pvOp1 != nil)
  assert(pvOp2 != nil)
  pvRes.fX = min(pvOp1.fX, pvOp2.fX)
  pvRes.fY = min(pvOp1.fY, pvOp2.fY)
  pvRes.fZ = min(pvOp1.fZ, pvOp2.fZ)
  pvRes

proc maxv*(pvRes: ptr orxVECTOR; pvOp1: ptr orxVECTOR; pvOp2: ptr orxVECTOR): ptr orxVECTOR {.inline, cdecl.} =
  ## Gets maximum between two vectors
  assert(pvRes != nil)
  assert(pvOp1 != nil)
  assert(pvOp2 != nil)
  pvRes.fX = max(pvOp1.fX, pvOp2.fX)
  pvRes.fY = max(pvOp1.fY, pvOp2.fY)
  pvRes.fZ = max(pvOp1.fZ, pvOp2.fZ)
  pvRes

proc clampv*(pvRes: ptr orxVECTOR; pvOp: ptr orxVECTOR; pvMin: ptr orxVECTOR;
           pvMax: ptr orxVECTOR): ptr orxVECTOR {.inline, cdecl.} =
  ## Clamps a vector between two others
  assert(pvRes != nil)
  assert(pvOp != nil)
  assert(pvMin != nil)
  assert(pvMax != nil)
  pvRes.fX = clamp(pvOp.fX, pvMin.fX, pvMax.fX)
  pvRes.fY = clamp(pvOp.fY, pvMin.fY, pvMax.fY)
  pvRes.fZ = clamp(pvOp.fZ, pvMin.fZ, pvMax.fZ)
  pvRes

proc absv*(pvRes: ptr orxVECTOR; pvOp: ptr orxVECTOR): ptr orxVECTOR {.inline, cdecl.} =
  ## Gets the absolute value of a vector and stores it in another one
  assert(pvRes != nil)
  assert(pvOp != nil)
  pvRes.fX = abs(pvOp.fX)
  pvRes.fY = abs(pvOp.fY)
  pvRes.fZ = abs(pvOp.fZ)
  pvRes

proc neg*(pvRes: ptr orxVECTOR; pvOp: ptr orxVECTOR): ptr orxVECTOR {.inline, cdecl.} =
  ## Negates a vector and stores result in another one
  assert(pvRes != nil)
  assert(pvOp != nil)
  pvRes.fX = -pvOp.fX
  pvRes.fY = -pvOp.fY
  pvRes.fZ = -pvOp.fZ
  pvRes

proc rec*(pvRes: ptr orxVECTOR; pvOp: ptr orxVECTOR): ptr orxVECTOR {.inline, cdecl.} =
  ## Gets reciprocal (1.0 /) vector and stores the result in another one
  assert(pvRes != nil)
  assert(pvOp != nil)
  pvRes.fX = 1.0 / pvOp.fX
  pvRes.fY = 1.0 / pvOp.fY
  pvRes.fZ = 1.0 / pvOp.fZ
  pvRes

proc floorv*(pvRes: ptr orxVECTOR; pvOp: ptr orxVECTOR): ptr orxVECTOR {.inline, cdecl.} =
  ## Gets floored vector and stores the result in another one
  assert(pvRes != nil)
  assert(pvOp != nil)
  pvRes.fX = floor(pvOp.fX)
  pvRes.fY = floor(pvOp.fY)
  pvRes.fZ = floor(pvOp.fZ)
  pvRes

proc roundv*(pvRes: ptr orxVECTOR; pvOp: ptr orxVECTOR): ptr orxVECTOR {.inline, cdecl.} =
  ## Gets rounded vector and stores the result in another one
  assert(pvRes != nil)
  assert(pvOp != nil)
  pvRes.fX = round(pvOp.fX)
  pvRes.fY = round(pvOp.fY)
  pvRes.fZ = round(pvOp.fZ)
  pvRes

proc getSquareSize*(pvOp: ptr orxVECTOR): orxFLOAT {.inline, cdecl.} =
  ## Gets vector squared size
  assert(pvOp != nil)
  (pvOp.fX * pvOp.fX) + (pvOp.fY * pvOp.fY) + (pvOp.fZ * pvOp.fZ)

proc getSize*(pvOp: ptr orxVECTOR): orxFLOAT {.inline, cdecl.} =
  ## Gets vector size
  assert(pvOp != nil)
  sqrt((pvOp.fX * pvOp.fX) + (pvOp.fY * pvOp.fY) + (pvOp.fZ * pvOp.fZ))

proc getSquareDistance*(pvOp1: ptr orxVECTOR; pvOp2: ptr orxVECTOR): orxFLOAT {.inline, cdecl.} =
  ## Gets squared distance between 2 positions
  assert(pvOp1 != nil)
  assert(pvOp2 != nil)
  var vTemp: orxVECTOR
  discard sub(addr(vTemp), pvOp2, pvOp1)
  getSquareSize(addr(vTemp))

proc getDistance*(pvOp1: ptr orxVECTOR; pvOp2: ptr orxVECTOR): orxFLOAT {.inline, cdecl.} =
  ## Gets distance between 2 positions
  assert(pvOp1 != nil)
  assert(pvOp2 != nil)
  var vTemp: orxVECTOR
  discard sub(addr(vTemp), pvOp2, pvOp1)
  getSize(addr(vTemp))

proc normalize*(pvRes: ptr orxVECTOR; pvOp: ptr orxVECTOR): ptr orxVECTOR {.inline, cdecl.} =
  ## Normalizes a vector
  assert(pvRes != nil)
  assert(pvOp != nil)
  let fOp = (pvOp.fX * pvOp.fX) + (pvOp.fY * pvOp.fY) + (pvOp.fZ * pvOp.fZ)
  let fRecSize = 1.0 / (TINY_EPSILON + sqrt(fOp))
  pvRes.fX = fRecSize * pvOp.fX
  pvRes.fY = fRecSize * pvOp.fY
  pvRes.fZ = fRecSize * pvOp.fZ
  pvRes

proc rotate2D*(pvRes: ptr orxVECTOR; pvOp: ptr orxVECTOR; fAngle: orxFLOAT): ptr orxVECTOR {.inline, cdecl.} =
  ## Rotates a 2D vector (along Z-axis)
  assert(pvRes != nil)
  assert(pvOp != nil)
  if fAngle == 0.0:
    discard copy(pvRes, pvOp)
  elif fAngle == PI_BY_2:
    discard set(pvRes, -pvOp.fY, pvOp.fX, pvOp.fZ)
  elif fAngle == -PI_BY_2:
    discard set(pvRes, pvOp.fY, -pvOp.fX, pvOp.fZ)
  elif fAngle == PI:
    discard set(pvRes, -pvOp.fX, -pvOp.fY, pvOp.fZ)
  else:
    let fCos = cos(fAngle)
    let fSin = sin(fAngle)
    discard set(pvRes, (fCos * pvOp.fX) - (fSin * pvOp.fY), (fSin * pvOp.fX) + (fCos * pvOp.fY), pvOp.fZ)
  pvRes

proc isNull*(pvOp: ptr orxVECTOR): orxBOOL {.inline, cdecl.} =
  ## Is vector null?
  assert(pvOp != nil)
  (pvOp.fX == 0.0 and pvOp.fY == 0.0 and pvOp.fZ == 0.0).orxBOOL

proc areEqual*(pvOp1: ptr orxVECTOR; pvOp2: ptr orxVECTOR): orxBOOL {.inline, cdecl.} =
  ## Are vectors equal?
  assert(pvOp1 != nil)
  assert(pvOp2 != nil)
  (pvOp1.fX == pvOp2.fX and pvOp1.fY == pvOp2.fY and pvOp1.fZ == pvOp2.fZ).orxBOOL

proc fromCartesianToSpherical*(pvRes: ptr orxVECTOR; pvOp: ptr orxVECTOR): ptr orxVECTOR {.inline, cdecl.} =
  ## Transforms a cartesian vector into a spherical one
  assert(pvRes != nil)
  assert(pvOp != nil)
  if (pvOp.fX == 0.0) and (pvOp.fY == 0.0) and (pvOp.fZ == 0.0):
    pvRes.fX = 0.0  # Using X for Rho in spherical
    pvRes.fY = 0.0  # Using Y for Theta in spherical
    pvRes.fZ = 0.0  # Using Z for Phi in spherical
  else:
    var fRho, fTheta, fPhi: orxFLOAT
    if pvOp.fZ == 0.0:
      if pvOp.fX == 0.0:
        fRho = abs(pvOp.fY)
      elif pvOp.fY == 0.0:
        fRho = abs(pvOp.fX)
      else:
        fRho = sqrt((pvOp.fX * pvOp.fX) + (pvOp.fY * pvOp.fY))
      fPhi = 0.0
    else:
      if (pvOp.fX == 0.0) and (pvOp.fY == 0.0):
        if pvOp.fZ < 0.0:
          fRho = abs(pvOp.fZ)
          fPhi = PI_BY_2
        else:
          fRho = pvOp.fZ
          fPhi = -PI_BY_2
      else:
        fRho = sqrt(getSquareSize(pvOp))
        fPhi = arccos(pvOp.fZ / fRho) - PI_BY_2
    fTheta = arctan2(pvOp.fY, pvOp.fX)
    pvRes.fX = fRho   # X field for Rho
    pvRes.fY = fTheta # Y field for Theta
    pvRes.fZ = fPhi   # Z field for Phi
  pvRes

proc fromSphericalToCartesian*(pvRes: ptr orxVECTOR; pvOp: ptr orxVECTOR): ptr orxVECTOR {.inline, cdecl.} =
  ## Transforms a spherical vector into a cartesian one
  assert(pvRes != nil)
  assert(pvOp != nil)
  let fRho = pvOp.fX     # X field contains Rho
  let fTheta = pvOp.fY   # Y field contains Theta
  let fPhi = pvOp.fZ     # Z field contains Phi
  var fSinTheta = sin(fTheta)
  var fCosTheta = cos(fTheta)
  var fSinPhi = sin(fPhi + PI_BY_2)
  var fCosPhi = cos(fPhi + PI_BY_2)
  if abs(fSinTheta) < EPSILON:
    fSinTheta = 0.0
  if abs(fCosTheta) < EPSILON:
    fCosTheta = 0.0
  if abs(fSinPhi) < EPSILON:
    fSinPhi = 0.0
  if abs(fCosPhi) < EPSILON:
    fCosPhi = 0.0
  pvRes.fX = fRho * fCosTheta * fSinPhi
  pvRes.fY = fRho * fSinTheta * fSinPhi
  pvRes.fZ = fRho * fCosPhi
  pvRes

proc dot*(pvOp1: ptr orxVECTOR; pvOp2: ptr orxVECTOR): orxFLOAT {.inline, cdecl.} =
  ## Gets dot product of two vectors
  assert(pvOp1 != nil)
  assert(pvOp2 != nil)
  (pvOp1.fX * pvOp2.fX) + (pvOp1.fY * pvOp2.fY) + (pvOp1.fZ * pvOp2.fZ)

proc dot2D*(pvOp1: ptr orxVECTOR; pvOp2: ptr orxVECTOR): orxFLOAT {.inline, cdecl.} =
  ## Gets 2D dot product of two vectors
  assert(pvOp1 != nil)
  assert(pvOp2 != nil)
  (pvOp1.fX * pvOp2.fX) + (pvOp1.fY * pvOp2.fY)

proc cross*(pvRes: ptr orxVECTOR; pvOp1: ptr orxVECTOR; pvOp2: ptr orxVECTOR): ptr orxVECTOR {.inline, cdecl.} =
  ## Gets cross product of two vectors
  assert(pvRes != nil)
  assert(pvOp1 != nil)
  assert(pvOp2 != nil)
  let fTemp1 = (pvOp1.fY * pvOp2.fZ) - (pvOp1.fZ * pvOp2.fY)
  let fTemp2 = (pvOp1.fZ * pvOp2.fX) - (pvOp1.fX * pvOp2.fZ)
  pvRes.fZ = (pvOp1.fX * pvOp2.fY) - (pvOp1.fY * pvOp2.fX)
  pvRes.fY = fTemp2
  pvRes.fX = fTemp1
  pvRes

# Vector constructor templates updated for tuple-based orxVECTOR type
template newVECTOR*(x, y, z: untyped): orxVECTOR =
  (fX: x.orxFLOAT, fY: y.orxFLOAT, fZ: z.orxFLOAT)

template newVECTOR*(): orxVECTOR =
  (0, 0, 0)

template newSPVECTOR*(rho, theta, phi: untyped): orxSPVECTOR =
  (fX: rho.orxFLOAT, fY: theta.orxFLOAT, fZ: phi.orxFLOAT)

template newSPVECTOR*(): orxSPVECTOR =
  (0, 0, 0)

template newRGBVECTOR*(r, g, b: untyped): orxRGBVECTOR =
  (fX: r.orxFLOAT, fY: g.orxFLOAT, fZ: b.orxFLOAT)

template newHSLVECTOR*(h, s, l: untyped): orxHSLVECTOR =
  (fX: h.orxFLOAT, fY: s.orxFLOAT, fZ: l.orxFLOAT)

template newHSVVECTOR*(h, s, v: untyped): orxHSVVECTOR =
  (fX: h.orxFLOAT, fY: s.orxFLOAT, fZ: v.orxFLOAT)