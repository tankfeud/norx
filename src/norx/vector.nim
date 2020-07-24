
import lib, typ, memory, pure/math, math as orxMath

## * Public structure definition
##

type
  #INNER_C_UNION_orxVector_72* {.bycopy, union.} = object
  #  fX*: orxFLOAT              ## First coordinate in the cartesian space
  #  fRho*: orxFLOAT            ## First coordinate in the spherical space
  #  fR*: orxFLOAT              ## First coordinate in the RGB color space
  #  fH*: orxFLOAT              ## First coordinate in the HSL/HSV color spaces

  #INNER_C_UNION_orxVector_80* {.bycopy, union.} = object
  #  fY*: orxFLOAT              ## Second coordinate in the cartesian space
  #  fTheta*: orxFLOAT          ## Second coordinate in the spherical space
  #  fG*: orxFLOAT              ## Second coordinate in the RGB color space
  #  fS*: orxFLOAT              ## Second coordinate in the HSL/HSV color spaces

  #INNER_C_UNION_orxVector_88* {.bycopy, union.} = object
  #  fZ*: orxFLOAT              ## Third coordinate in the cartesian space
  #  fPhi*: orxFLOAT            ## Third coordinate in the spherical space
  #  fB*: orxFLOAT              ## Third coordinate in the RGB color space
  #  fL*: orxFLOAT              ## Third coordinate in the HSL color space
  #  fV*: orxFLOAT              ## Third coordinate in the HSV color space

  #orxVECTOR* {.bycopy.} = object
  #  ano_orxVector_76*: INNER_C_UNION_orxVector_72 ## * Coordinates : 12
  #  ano_orxVector_84*: INNER_C_UNION_orxVector_80
  #  ano_orxVector_93*: INNER_C_UNION_orxVector_88

  orxVECTOR* {.bycopy.} = tuple[fX: orxFLOAT, fY: orxFLOAT, fZ: orxFLOAT]
  orxSPVECTOR* {.bycopy.} = tuple[fRho: orxFLOAT, fTheta: orxFLOAT, fPhi: orxFLOAT]
  orxRGBVECTOR* {.bycopy.} = tuple[fR: orxFLOAT, fG: orxFLOAT, fB: orxFLOAT]
  orxHSLVECTOR* {.bycopy.} = tuple[fH: orxFLOAT, fS: orxFLOAT, fL: orxFLOAT]
  orxHSVVECTOR* {.bycopy.} = tuple[fH: orxFLOAT, fS: orxFLOAT, fV: orxFLOAT]


proc set*(pvVec: ptr orxVECTOR; fX: orxFLOAT; fY: orxFLOAT; fZ: orxFLOAT): ptr orxVECTOR {.
    inline, discardable, cdecl.} =
  ## Sets vector XYZ values (also work for other coordinate system)
  ##  @param[in]   _pvVec                        Concerned vector
  ##  @param[in]   _fX                           First coordinate value
  ##  @param[in]   _fY                           Second coordinate value
  ##  @param[in]   _fZ                           Third coordinate value
  ##  @return      Vector
  ##  Checks
  assert(pvVec != nil)
  ##  Stores values
  pvVec.fX = fX
  pvVec.fY = fY
  pvVec.fZ = fZ
  ##  Done !
  return pvVec

proc setAll*(pvVec: ptr orxVECTOR; fValue: orxFLOAT): ptr orxVECTOR {.inline,
    cdecl.} =
  ## Sets all the vector coordinates with the given value
  ##  @param[in]   _pvVec                        Concerned vector
  ##  @param[in]   _fValue                       Value to set
  ##  @return      Vector
  ##  Done !
  return set(pvVec, fValue, fValue, fValue)

proc copy*(pvDst: ptr orxVECTOR; pvSrc: ptr orxVECTOR): ptr orxVECTOR {.inline, discardable,
    cdecl.} =
  ## Copies a vector onto another one
  ##  @param[in]   _pvDst                        Vector to copy to (destination)
  ##  @param[in]   _pvSrc                        Vector to copy from (source)
  ##  @return      Destination vector
  ##  Checks
  assert(pvDst != nil)
  assert(pvSrc != nil)
  ##  Copies it
  discard memory.copy(pvDst, pvSrc, sizeof((orxVECTOR)).orxU32)
  ##  Done!
  return pvDst

proc add*(pvRes: ptr orxVECTOR; pvOp1: ptr orxVECTOR; pvOp2: ptr orxVECTOR): ptr orxVECTOR {.
    inline, discardable, cdecl.} =
  ## Adds vectors and stores result in a third one
  ##  @param[out]  _pvRes                        Vector where to store result (can be one of the two operands)
  ##  @param[in]   _pvOp1                        First operand
  ##  @param[in]   _pvOp2                        Second operand
  ##  @return      Resulting vector (Op1 + Op2)
  ##  Checks
  assert(pvRes != nil)
  assert(pvOp1 != nil)
  assert(pvOp2 != nil)
  ##  Adds all
  pvRes.fX = pvOp1.fX + pvOp2.fX
  pvRes.fY = pvOp1.fY + pvOp2.fY
  pvRes.fZ = pvOp1.fZ + pvOp2.fZ
  ##  Done!
  return pvRes

proc sub*(pvRes: ptr orxVECTOR; pvOp1: ptr orxVECTOR; pvOp2: ptr orxVECTOR): ptr orxVECTOR {.
    inline, discardable, cdecl.} =
  ## Substracts vectors and stores result in a third one
  ##  @param[out]  _pvRes                        Vector where to store result (can be one of the two operands)
  ##  @param[in]   _pvOp1                        First operand
  ##  @param[in]   _pvOp2                        Second operand
  ##  @return      Resulting vector (Op1 - Op2)
  ##  Checks
  assert(pvRes != nil)
  assert(pvOp1 != nil)
  assert(pvOp2 != nil)
  ##  Adds all
  pvRes.fX = pvOp1.fX - pvOp2.fX
  pvRes.fY = pvOp1.fY - pvOp2.fY
  pvRes.fZ = pvOp1.fZ - pvOp2.fZ
  ##  Done!
  return pvRes

proc mulf*(pvRes: ptr orxVECTOR; pvOp1: ptr orxVECTOR; fOp2: orxFLOAT): ptr orxVECTOR {.
    inline, discardable, cdecl.} =
  ## Multiplies a vector by an orxFLOAT and stores result in another one
  ##  @param[out]  _pvRes                        Vector where to store result (can be the operand)
  ##  @param[in]   _pvOp1                        First operand
  ##  @param[in]   _fOp2                         Second operand
  ##  @return      Resulting vector
  ##  Checks
  assert(pvRes != nil)
  assert(pvOp1 != nil)
  ##  Muls all
  pvRes.fX = pvOp1.fX * fOp2
  pvRes.fY = pvOp1.fY * fOp2
  pvRes.fZ = pvOp1.fZ * fOp2
  ##  Done!
  return pvRes

proc mul*(pvRes: ptr orxVECTOR; pvOp1: ptr orxVECTOR; pvOp2: ptr orxVECTOR): ptr orxVECTOR {.
    inline, cdecl.} =
  ## Multiplies a vector by another vector and stores result in a third one
  ##  @param[out]  _pvRes                        Vector where to store result (can be one of the two operands)
  ##  @param[in]   _pvOp1                        First operand
  ##  @param[in]   _pvOp2                        Second operand
  ##  @return      Resulting vector (Op1 * Op2)
  ##  Checks
  assert(pvRes != nil)
  assert(pvOp1 != nil)
  assert(pvOp2 != nil)
  ##  Muls all
  pvRes.fX = pvOp1.fX * pvOp2.fX
  pvRes.fY = pvOp1.fY * pvOp2.fY
  pvRes.fZ = pvOp1.fZ * pvOp2.fZ
  ##  Done!
  return pvRes

proc divf*(pvRes: ptr orxVECTOR; pvOp1: ptr orxVECTOR; fOp2: orxFLOAT): ptr orxVECTOR {.
    inline, cdecl.} =
  ## Divides a vector by an orxFLOAT and stores result in another one
  ##  @param[out]  _pvRes                        Vector where to store result (can be the operand)
  ##  @param[in]   _pvOp1                        First operand
  ##  @param[in]   _fOp2                         Second operand
  ##  @return      Resulting vector
  var fRecCoef: orxFLOAT
  ##  Checks
  assert(pvRes != nil)
  assert(pvOp1 != nil)
  assert(fOp2 != orxFLOAT_0)
  ##  Gets reciprocal coef
  fRecCoef = orxFLOAT_1 / fOp2
  ##  Muls all
  pvRes.fX = pvOp1.fX * fRecCoef
  pvRes.fY = pvOp1.fY * fRecCoef
  pvRes.fZ = pvOp1.fZ * fRecCoef
  ##  Done!
  return pvRes

proc divv*(pvRes: ptr orxVECTOR; pvOp1: ptr orxVECTOR; pvOp2: ptr orxVECTOR): ptr orxVECTOR {.
    inline, cdecl.} =
  ## Divides a vector by another vector and stores result in a third one
  ##  @param[out]  _pvRes                        Vector where to store result (can be one of the two operands)
  ##  @param[in]   _pvOp1                        First operand
  ##  @param[in]   _pvOp2                        Second operand
  ##  @return      Resulting vector (Op1 / Op2)
  ##  Checks
  assert(pvRes != nil)
  assert(pvOp1 != nil)
  assert(pvOp2 != nil)
  ##  Divs all
  pvRes.fX = pvOp1.fX / pvOp2.fX
  pvRes.fY = pvOp1.fY / pvOp2.fY
  pvRes.fZ = pvOp1.fZ / pvOp2.fZ
  ##  Done!
  return pvRes

proc lerp*(pvRes: ptr orxVECTOR; pvOp1: ptr orxVECTOR; pvOp2: ptr orxVECTOR;
                    fOp: orxFLOAT): ptr orxVECTOR {.inline, cdecl.} =
  ## Lerps from one vector to another one using a coefficient
  ##  @param[out]  _pvRes                        Vector where to store result (can be one of the two operands)
  ##  @param[in]   _pvOp1                        First operand
  ##  @param[in]   _pvOp2                        Second operand
  ##  @param[in]   _fOp                          Lerp coefficient parameter
  ##  @return      Resulting vector
  ##  Checks
  assert(pvRes != nil)
  assert(pvOp1 != nil)
  assert(pvOp2 != nil)
  assert(fOp >= orxFLOAT_0)
  ##  Lerps all
  pvRes.fX = orxMath.lerp(pvOp1.fX, pvOp2.fX, fOp)
  pvRes.fY = orxMath.lerp(pvOp1.fY, pvOp2.fY, fOp)
  pvRes.fZ = orxMath.lerp(pvOp1.fZ, pvOp2.fZ, fOp)
  ##  Done!
  return pvRes

proc min*(pvRes: ptr orxVECTOR; pvOp1: ptr orxVECTOR; pvOp2: ptr orxVECTOR): ptr orxVECTOR {.
    inline, cdecl.} =
  ## Gets minimum between two vectors
  ##  @param[out]  _pvRes                        Vector where to store result (can be one of the two operands)
  ##  @param[in]   _pvOp1                        First operand
  ##  @param[in]   _pvOp2                        Second operand
  ##  @return      Resulting vector MIN(Op1, Op2)
  ##  Checks
  assert(pvRes != nil)
  assert(pvOp1 != nil)
  assert(pvOp2 != nil)
  ##  Gets all mins
  pvRes.fX = min(pvOp1.fX, pvOp2.fX)
  pvRes.fY = min(pvOp1.fY, pvOp2.fY)
  pvRes.fZ = min(pvOp1.fZ, pvOp2.fZ)
  ##  Done!
  return pvRes

proc max*(pvRes: ptr orxVECTOR; pvOp1: ptr orxVECTOR; pvOp2: ptr orxVECTOR): ptr orxVECTOR {.
    inline, cdecl.} =
  ## Gets maximum between two vectors
  ##  @param[out]  _pvRes                        Vector where to store result (can be one of the two operands)
  ##  @param[in]   _pvOp1                        First operand
  ##  @param[in]   _pvOp2                        Second operand
  ##  @return      Resulting vector MAX(Op1, Op2)
  ##  Checks
  assert(pvRes != nil)
  assert(pvOp1 != nil)
  assert(pvOp2 != nil)
  ##  Gets all maxs
  pvRes.fX = max(pvOp1.fX, pvOp2.fX)
  pvRes.fY = max(pvOp1.fY, pvOp2.fY)
  pvRes.fZ = max(pvOp1.fZ, pvOp2.fZ)
  ##  Done!
  return pvRes

proc clamp*(pvRes: ptr orxVECTOR; pvOp: ptr orxVECTOR; pvMin: ptr orxVECTOR;
                     pvMax: ptr orxVECTOR): ptr orxVECTOR {.inline, discardable, cdecl.} =
  ## Clamps a vector between two others
  ##  @param[out]  _pvRes                        Vector where to store result (can be the operand)
  ##  @param[in]   _pvOp                         Vector to clamp
  ##  @param[in]   _pvMin                        Minimum boundary
  ##  @param[in]   _pvMax                        Maximum boundary
  ##  @return      Resulting vector CLAMP(Op, MIN, MAX)
  ##  Checks
  assert(pvRes != nil)
  assert(pvOp != nil)
  assert(pvMin != nil)
  assert(pvMax != nil)
  ##  Gets all clamped values
  pvRes.fX = clamp(pvOp.fX, pvMin.fX, pvMax.fX)
  pvRes.fY = clamp(pvOp.fY, pvMin.fY, pvMax.fY)
  pvRes.fZ = clamp(pvOp.fZ, pvMin.fZ, pvMax.fZ)
  ##  Done!
  return pvRes

proc neg*(pvRes: ptr orxVECTOR; pvOp: ptr orxVECTOR): ptr orxVECTOR {.inline,
    cdecl.} =
  ## Negates a vector and stores result in another one
  ##  @param[out]  _pvRes                        Vector where to store result (can be the operand)
  ##  @param[in]   _pvOp                         Vector to negates
  ##  @return      Resulting vector (-Op)
  ##  Checks
  assert(pvRes != nil)
  assert(pvOp != nil)
  ##  Negates all
  pvRes.fX = -(pvOp.fX)
  pvRes.fY = -(pvOp.fY)
  pvRes.fZ = -(pvOp.fZ)
  ##  Done!
  return pvRes

proc rec*(pvRes: ptr orxVECTOR; pvOp: ptr orxVECTOR): ptr orxVECTOR {.inline,
    cdecl.} =
  ## Gets reciprocal (1.0 /) vector and stores the result in another one
  ##  @param[out]  _pvRes                        Vector where to store result (can be the operand)
  ##  @param[in]   _pvOp                         Input value
  ##  @return      Resulting vector (1 / Op)
  ##  Checks
  assert(pvRes != nil)
  assert(pvOp != nil)
  ##  Reverts all
  pvRes.fX = orxFLOAT_1 / pvOp.fX
  pvRes.fY = orxFLOAT_1 / pvOp.fY
  pvRes.fZ = orxFLOAT_1 / pvOp.fZ
  ##  Done!
  return pvRes

proc floor*(pvRes: ptr orxVECTOR; pvOp: ptr orxVECTOR): ptr orxVECTOR {.inline,
    cdecl.} =
  ## Gets floored vector and stores the result in another one
  ##  @param[out]  _pvRes                        Vector where to store result (can be the operand)
  ##  @param[in]   _pvOp                         Input value
  ##  @return      Resulting vector Floor(Op)
  ##  Checks
  assert(pvRes != nil)
  assert(pvOp != nil)
  ##  Reverts all
  pvRes.fX = floor(pvOp.fX)
  pvRes.fY = floor(pvOp.fY)
  pvRes.fZ = floor(pvOp.fZ)
  ##  Done!
  return pvRes

proc round*(pvRes: ptr orxVECTOR; pvOp: ptr orxVECTOR): ptr orxVECTOR {.inline,
    cdecl.} =
  ## Gets rounded vector and stores the result in another one
  ##  @param[out]  _pvRes                        Vector where to store result (can be the operand)
  ##  @param[in]   _pvOp                         Input value
  ##  @return      Resulting vector Round(Op)
  ##  Checks
  assert(pvRes != nil)
  assert(pvOp != nil)
  ##  Reverts all
  pvRes.fX = orxMath.round(pvOp.fX)
  pvRes.fY = orxMath.round(pvOp.fY)
  pvRes.fZ = orxMath.round(pvOp.fZ)
  ##  Done!
  return pvRes

proc getSquareSize*(pvOp: ptr orxVECTOR): orxFLOAT {.inline, cdecl.} =
  ## Gets vector squared size
  ##  @param[in]   _pvOp                         Input vector
  ##  @return      Vector's squared size
  var fResult: orxFLOAT
  ##  Checks
  assert(pvOp != nil)
  ##  Updates result
  fResult = (pvOp.fX * pvOp.fX) + (pvOp.fY * pvOp.fY) + (pvOp.fZ * pvOp.fZ)
  ##  Done!
  return fResult

proc getSize*(pvOp: ptr orxVECTOR): orxFLOAT {.inline, cdecl.} =
  ## Gets vector size
  ##  @param[in]   _pvOp                         Input vector
  ##  @return      Vector's size
  var fResult: orxFLOAT
  ##  Checks
  assert(pvOp != nil)
  ##  Updates result
  fResult = sqrt((pvOp.fX * pvOp.fX) + (pvOp.fY * pvOp.fY) + (pvOp.fZ * pvOp.fZ))
  ##  Done!
  return fResult

proc getSquareDistance*(pvOp1: ptr orxVECTOR; pvOp2: ptr orxVECTOR): orxFLOAT {.
    inline, cdecl.} =
  ## Gets squared distance between 2 positions
  ##  @param[in]   _pvOp1                        First position
  ##  @param[in]   _pvOp2                        Second position
  ##  @return      Squared distance
  var vTemp: orxVECTOR
  var fResult: orxFLOAT
  ##  Checks
  assert(pvOp1 != nil)
  assert(pvOp2 != nil)
  ##  Gets distance vector
  discard sub(addr(vTemp), pvOp2, pvOp1)
  ##  Updates result
  fResult = getSquareSize(addr(vTemp))
  ##  Done!
  return fResult

proc getDistance*(pvOp1: ptr orxVECTOR; pvOp2: ptr orxVECTOR): orxFLOAT {.
    inline, cdecl.} =
  ## Gets distance between 2 positions
  ##  @param[in]   _pvOp1                        First position
  ##  @param[in]   _pvOp2                        Second position
  ##  @return      Distance
  var vTemp: orxVECTOR
  var fResult: orxFLOAT
  ##  Checks
  assert(pvOp1 != nil)
  assert(pvOp2 != nil)
  ##  Gets distance vector
  discard sub(addr(vTemp), pvOp2, pvOp1)
  ##  Updates result
  fResult = getSize(addr(vTemp))
  ##  Done!
  return fResult

proc normalize*(pvRes: ptr orxVECTOR; pvOp: ptr orxVECTOR): ptr orxVECTOR {.
    inline, cdecl.} =
  ## Normalizes a vector
  ##  @param[out]  _pvRes                        Vector where to store result (can be the operand)
  ##  @param[in]   _pvOp                         Vector to normalize
  ##  @return      Normalized vector
  var fOp: orxFLOAT
  ##  Checks
  assert(pvRes != nil)
  assert(pvOp != nil)
  ##  Gets squared size
  fOp = (pvOp.fX * pvOp.fX) + (pvOp.fY * pvOp.fY) + (pvOp.fZ * pvOp.fZ)
  ##  Gets reciprocal size
  fOp = orxFLOAT_1 / (orxMATH_KF_TINY_EPSILON + sqrt(fOp))
  ##  Updates result
  pvRes.fX = fOp * pvOp.fX
  pvRes.fY = fOp * pvOp.fY
  pvRes.fZ = fOp * pvOp.fZ
  ##  Done!
  return pvRes

proc twoDrotate*(pvRes: ptr orxVECTOR; pvOp: ptr orxVECTOR; fAngle: orxFLOAT): ptr orxVECTOR {.
    inline, cdecl.} =
  ## Rotates a 2D vector (along Z-axis)
  ##  @param[out]  _pvRes                        Vector where to store result (can be the operand)
  ##  @param[in]   _pvOp                         Vector to rotate
  ##  @param[in]   _fAngle                       Angle of rotation (radians)
  ##  @return      Rotated vector
  ##  Checks
  assert(pvRes != nil)
  assert(pvOp != nil)
  ##  PI/2?
  if fAngle == orxMATH_KF_PI_BY_2:
    ##  Updates result
    discard set(pvRes, -pvOp.fY, pvOp.fX, pvOp.fZ)
  elif fAngle == -orxMATH_KF_PI_BY_2: ##  Any other angle
    ##  Updates result
    discard set(pvRes, pvOp.fY, -pvOp.fX, pvOp.fZ)
  else:
    var
      fSin: orxFLOAT
      fCos: orxFLOAT
    ##  Gets cos & sin of angle
    fCos = cos(fAngle)
    fSin = sin(fAngle)
    ##  Updates result
    discard set(pvRes, (fCos * pvOp.fX) - (fSin * pvOp.fY),
                  (fSin * pvOp.fX) + (fCos * pvOp.fY), pvOp.fZ)
  ##  Done!
  return pvRes

proc isNull*(pvOp: ptr orxVECTOR): orxBOOL {.inline, cdecl.} =
  ## Is vector null?
  ##  @param[in]   _pvOp                         Vector to test
  ##  @return      orxTRUE if vector's null, orxFALSE otherwise
  var bResult: orxBOOL
  ##  Checks
  assert(pvOp != nil)
  ##  Updates result
  bResult = if ((pvOp.fX == orxFLOAT_0) and (pvOp.fY == orxFLOAT_0) and
      (pvOp.fZ == orxFLOAT_0)): orxTRUE else: orxFALSE
  ##  Done!
  return bResult

proc areEqual*(pvOp1: ptr orxVECTOR; pvOp2: ptr orxVECTOR): orxBOOL {.inline,
    cdecl.} =
  ## Are vectors equal?
  ##  @param[in]   _pvOp1                        First vector to compare
  ##  @param[in]   _pvOp2                        Second vector to compare
  ##  @return      orxTRUE if both vectors are equal, orxFALSE otherwise
  var bResult: orxBOOL
  ##  Checks
  assert(pvOp1 != nil)
  assert(pvOp2 != nil)
  ##  Updates result
  bResult = if ((pvOp1.fX == pvOp2.fX) and (pvOp1.fY == pvOp2.fY) and
      (pvOp1.fZ == pvOp2.fZ)): orxTRUE else: orxFALSE
  ##  Done!
  return bResult

proc fromCartesianToSpherical*(pvRes: ptr orxSPVECTOR; pvOp: ptr orxVECTOR): ptr orxSPVECTOR {.
    inline, cdecl.} =
  ## Transforms a cartesian vector into a spherical one
  ##  @param[out]  _pvRes                        Vector where to store result (can be the operand)
  ##  @param[in]   _pvOp                         Vector to transform
  ##  @return      Transformed vector
  ##  Checks
  assert(pvRes != nil)
  assert(pvOp != nil)
  ##  Is operand vector null?
  if (pvOp.fX == orxFLOAT_0) and (pvOp.fY == orxFLOAT_0) and (pvOp.fZ == orxFLOAT_0):
    ##  Updates result vector
    pvRes.fRho = orxFLOAT_0
    pvRes.fTheta = orxFLOAT_0
    pvRes.fPhi = orxFLOAT_0
  else:
    var
      fRho: orxFLOAT
      fTheta: orxFLOAT
      fPhi: orxFLOAT
    ##  Z = 0?
    if pvOp.fZ == orxFLOAT_0:
      ##  X = 0?
      if pvOp.fX == orxFLOAT_0:
        ##  Gets absolute value
        fRho = abs(pvOp.fY)
      elif pvOp.fY == orxFLOAT_0: ##  X != 0 and Y != 0
        ##  Gets absolute value
        fRho = abs(pvOp.fX)
      else:
        ##  Computes rho
        fRho = sqrt((pvOp.fX * pvOp.fX) + (pvOp.fY * pvOp.fY))
      ##  Sets phi
      fPhi = orxMATH_KF_PI_BY_2
    else:
      ##  X = 0 and Y = 0?
      if (pvOp.fX == orxFLOAT_0) and (pvOp.fY == orxFLOAT_0):
        ##  Z < 0?
        if pvOp.fZ < orxFLOAT_0:
          ##  Gets absolute value
          fRho = abs(pvOp.fZ)
          ##  Sets phi
          fPhi = orxMATH_KF_PI
        else:
          ##  Sets rho
          fRho = pvOp.fZ
          ##  Sets phi
          fPhi = orxFLOAT_0
      else:
        ##  Computes rho
        fRho = sqrt(getSquareSize(pvOp))
        ##  Computes phi
        fPhi = arccos(pvOp.fZ / fRho)
    ##  Computes theta
    fTheta = arctan2(pvOp.fY, pvOp.fX)
    ##  Updates result
    pvRes.fRho = fRho
    pvRes.fTheta = fTheta
    pvRes.fPhi = fPhi
  ##  Done!
  return pvRes

proc fromSphericalToCartesian*(pvRes: ptr orxVECTOR; pvOp: ptr orxSPVECTOR): ptr orxVECTOR {.
    inline, cdecl.} =
  ## Transforms a spherical vector into a cartesian one
  ##  @param[out]  _pvRes                        Vector where to store result (can be the operand)
  ##  @param[in]   _pvOp                         Vector to transform
  ##  @return      Transformed vector
  var
    fSinPhi: orxFLOAT
    fCosPhi: orxFLOAT
    fSinTheta: orxFLOAT
    fCosTheta: orxFLOAT
    fRho: orxFLOAT
  ##  Checks
  assert(pvRes != nil)
  assert(pvOp != nil)
  ##  Stores rho
  fRho = pvOp.fRho
  ##  Gets sine & cosine
  fSinTheta = sin(pvOp.fTheta)
  fCosTheta = cos(pvOp.fTheta)
  fSinPhi = sin(pvOp.fPhi)
  fCosPhi = cos(pvOp.fPhi)
  if abs(fSinTheta) < orxMATH_KF_EPSILON:
    fSinTheta = orxFLOAT_0
  if abs(fCosTheta) < orxMATH_KF_EPSILON:
    fCosTheta = orxFLOAT_0
  if abs(fSinPhi) < orxMATH_KF_EPSILON:
    fSinPhi = orxFLOAT_0
  if abs(fCosPhi) < orxMATH_KF_EPSILON:
    fCosPhi = orxFLOAT_0
  pvRes.fX = fRho * fCosTheta * fSinPhi
  pvRes.fY = fRho * fSinTheta * fSinPhi
  pvRes.fZ = fRho * fCosPhi
  ##  Done!
  return pvRes

proc dot*(pvOp1: ptr orxVECTOR; pvOp2: ptr orxVECTOR): orxFLOAT {.inline, cdecl.} =
  ## Gets dot product of two vectors
  ##  @param[in]   _pvOp1                      First operand
  ##  @param[in]   _pvOp2                      Second operand
  ##  @return      Dot product
  var fResult: orxFLOAT
  ##  Checks
  assert(pvOp1 != nil)
  assert(pvOp2 != nil)
  ##  Updates result
  fResult = (pvOp1.fX * pvOp2.fX) + (pvOp1.fY * pvOp2.fY) + (pvOp1.fZ * pvOp2.fZ)
  ##  Done!
  return fResult

proc twoDDot*(pvOp1: ptr orxVECTOR; pvOp2: ptr orxVECTOR): orxFLOAT {.inline,
    cdecl.} =
  ## Gets 2D dot product of two vectors
  ##  @param[in]   _pvOp1                      First operand
  ##  @param[in]   _pvOp2                      Second operand
  ##  @return      2D dot product
  var fResult: orxFLOAT
  ##  Checks
  assert(pvOp1 != nil)
  assert(pvOp2 != nil)
  ##  Updates result
  fResult = (pvOp1.fX * pvOp2.fX) + (pvOp1.fY * pvOp2.fY)
  ##  Done!
  return fResult

proc cross*(pvRes: ptr orxVECTOR; pvOp1: ptr orxVECTOR; pvOp2: ptr orxVECTOR): ptr orxVECTOR {.
    inline, cdecl.} =
  ## Gets cross product of two vectors
  ##  @param[out]  _pvRes                       Vector where to store result
  ##  @param[in]   _pvOp1                      First operand
  ##  @param[in]   _pvOp2                      Second operand
  ##  @return      Cross product orxVECTOR / nil
  var
    fTemp1: orxFLOAT
    fTemp2: orxFLOAT
  ##  Checks
  assert(pvRes != nil)
  assert(pvOp1 != nil)
  assert(pvOp2 != nil)
  ##  Computes cross product
  fTemp1 = (pvOp1.fY * pvOp2.fZ) - (pvOp1.fZ * pvOp2.fY)
  fTemp2 = (pvOp1.fZ * pvOp2.fX) - (pvOp1.fX * pvOp2.fZ)
  pvRes.fZ = (pvOp1.fX * pvOp2.fY) - (pvOp1.fY * pvOp2.fX)
  pvRes.fY = fTemp2
  pvRes.fX = fTemp1
  ##  Done!
  return pvRes

proc bezier*(pvRes: ptr orxVECTOR; pvPoint1: ptr orxVECTOR;
                      pvPoint2: ptr orxVECTOR; pvPoint3: ptr orxVECTOR;
                      pvPoint4: ptr orxVECTOR; fT: orxFLOAT): ptr orxVECTOR {.cdecl,
    importc: "orxVector_Bezier", dynlib: libORX.}
  ##  *** Vector functions ***
  ## Computes an interpolated point on a cubic Bezier curve segment for a given parameter
  ##  @param[out]  _pvRes                      Vector where to store result
  ##  @param[in]   _pvPoint1                   First point for this curve segment
  ##  @param[in]   _pvPoint2                   First control point for this curve segment
  ##  @param[in]   _pvPoint3                   Second control point for this curve segment
  ##  @param[in]   _pvPoint4                   Last point for this curve segment
  ##  @param[in]   _fT                         Interpolation parameter in [0.0, 1.0]
  ##  @return      Interpolated point on the cubic Bezier curve segment

proc catmullRom*(pvRes: ptr orxVECTOR; pvPoint1: ptr orxVECTOR;
                          pvPoint2: ptr orxVECTOR; pvPoint3: ptr orxVECTOR;
                          pvPoint4: ptr orxVECTOR; fT: orxFLOAT): ptr orxVECTOR {.
    cdecl, importc: "orxVector_CatmullRom", dynlib: libORX.}
  ## Computes an interpolated point on a Catmull-Rom curve segment for a given parameter
  ##  @param[out]  _pvRes                      Vector where to store result
  ##  @param[in]   _pvPoint1                   First control point for this curve segment
  ##  @param[in]   _pvPoint2                   Second control point for this curve segment
  ##  @param[in]   _pvPoint3                   Third control point for this curve segment
  ##  @param[in]   _pvPoint4                   Fourth control point for this curve segment
  ##  @param[in]   _fT                         Interpolation parameter in [0.0, 1.0]
  ##  @return      Interpolated point on the Catmull-Rom curve segment

## Vector constants

var orxVECTOR_X* {.importc: "orxVECTOR_X", dynlib: libORX.}: orxVECTOR

## < X-Axis unit vector

var orxVECTOR_Y* {.importc: "orxVECTOR_Y", dynlib: libORX.}: orxVECTOR

## < Y-Axis unit vector

var orxVECTOR_Z* {.importc: "orxVECTOR_Z", dynlib: libORX.}: orxVECTOR

## Z-Axis unit vector

var orxVECTOR_0* {.importc: "orxVECTOR_0", dynlib: libORX.}: orxVECTOR

## Null vector

var orxVECTOR_1* {.importc: "orxVECTOR_1", dynlib: libORX.}: orxVECTOR

## Vector filled with 1s

var orxVECTOR_RED* {.importc: "orxVECTOR_RED", dynlib: libORX.}: orxVECTOR

## Red color vector

var orxVECTOR_GREEN* {.importc: "orxVECTOR_GREEN", dynlib: libORX.}: orxVECTOR

## Green color vector

var orxVECTOR_BLUE* {.importc: "orxVECTOR_BLUE", dynlib: libORX.}: orxVECTOR

## Blue color vector

var orxVECTOR_YELLOW* {.importc: "orxVECTOR_YELLOW", dynlib: libORX.}: orxVECTOR

## Yellow color vector

var orxVECTOR_CYAN* {.importc: "orxVECTOR_CYAN", dynlib: libORX.}: orxVECTOR

## Cyan color vector

var orxVECTOR_MAGENTA* {.importc: "orxVECTOR_MAGENTA", dynlib: libORX.}: orxVECTOR

## Magenta color vector

var orxVECTOR_BLACK* {.importc: "orxVECTOR_BLACK", dynlib: libORX.}: orxVECTOR

## Black color vector

var orxVECTOR_WHITE* {.importc: "orxVECTOR_WHITE", dynlib: libORX.}: orxVECTOR

## White color vector
