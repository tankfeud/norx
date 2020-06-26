##  Orx - Portable Game Engine
##
##  Copyright (c) 2008-2020 Orx-Project
##
##  This software is provided 'as-is', without any express or implied
##  warranty. In no event will the authors be held liable for any damages
##  arising from the use of this software.
##
##  Permission is granted to anyone to use this software for any purpose,
##  including commercial applications, and to alter it and redistribute it
##  freely, subject to the following restrictions:
##
##     1. The origin of this software must not be misrepresented; you must not
##     claim that you wrote the original software. If you use this software
##     in a product, an acknowledgment in the product documentation would be
##     appreciated but is not required.
##
##     2. Altered source versions must be plainly marked as such, and must not be
##     misrepresented as being the original software.
##
##     3. This notice may not be removed or altered from any source
##     distribution.


import lib, typ, math, memory

## * Public structure definition
##

type
  #INNER_C_UNION_orxVector_72* {.bycopy.} = object {.union.}
  #  fX*: orxFLOAT              ## *< First coordinate in the cartesian space
  #  fRho*: orxFLOAT            ## *< First coordinate in the spherical space
  #  fR*: orxFLOAT              ## *< First coordinate in the RGB color space
  #  fH*: orxFLOAT              ## *< First coordinate in the HSL/HSV color spaces

  #INNER_C_UNION_orxVector_80* {.bycopy.} = object {.union.}
  #  fY*: orxFLOAT              ## *< Second coordinate in the cartesian space
  #  fTheta*: orxFLOAT          ## *< Second coordinate in the spherical space
  #  fG*: orxFLOAT              ## *< Second coordinate in the RGB color space
  #  fS*: orxFLOAT              ## *< Second coordinate in the HSL/HSV color spaces

  #INNER_C_UNION_orxVector_88* {.bycopy.} = object {.union.}
  #  fZ*: orxFLOAT              ## *< Third coordinate in the cartesian space
  #  fPhi*: orxFLOAT            ## *< Third coordinate in the spherical space
  #  fB*: orxFLOAT              ## *< Third coordinate in the RGB color space
  #  fL*: orxFLOAT              ## *< Third coordinate in the HSL color space
  #  fV*: orxFLOAT              ## *< Third coordinate in the HSV color space

  #orxVECTOR* {.bycopy.} = object
  #  ano_orxVector_76*: INNER_C_UNION_orxVector_72 ## * Coordinates : 12
  #  ano_orxVector_84*: INNER_C_UNION_orxVector_80
  #  ano_orxVector_93*: INNER_C_UNION_orxVector_88

  orxVECTOR* {.bycopy.} = tuple[fX: orxFLOAT, fY: orxFLOAT, fZ: orxFLOAT]
  orxSPVECTOR* {.bycopy.} = tuple[fRho: orxFLOAT, fTheta: orxFLOAT, fPhi: orxFLOAT]
  orxRGBVECTOR* {.bycopy.} = tuple[fR: orxFLOAT, fG: orxFLOAT, fB: orxFLOAT]
  orxHSLVECTOR* {.bycopy.} = tuple[fH: orxFLOAT, fS: orxFLOAT, fL: orxFLOAT]
  orxHSVVECTOR* {.bycopy.} = tuple[fH: orxFLOAT, fS: orxFLOAT, fV: orxFLOAT]


##  *** Vector inlined functions ***
## * Sets vector XYZ values (also work for other coordinate system)
##  @param[in]   _pvVec                        Concerned vector
##  @param[in]   _fX                           First coordinate value
##  @param[in]   _fY                           Second coordinate value
##  @param[in]   _fZ                           Third coordinate value
##  @return      Vector
##

proc orxVector_Set*(pvVec: ptr orxVECTOR; fX: orxFLOAT; fY: orxFLOAT; fZ: orxFLOAT): ptr orxVECTOR {.
    inline, discardable, cdecl.} =
  ##  Checks
  assert(pvVec != nil)
  ##  Stores values
  pvVec.fX = fX
  pvVec.fY = fY
  pvVec.fZ = fZ
  ##  Done !
  return pvVec

## * Sets all the vector coordinates with the given value
##  @param[in]   _pvVec                        Concerned vector
##  @param[in]   _fValue                       Value to set
##  @return      Vector
##

proc orxVector_SetAll*(pvVec: ptr orxVECTOR; fValue: orxFLOAT): ptr orxVECTOR {.inline,
    cdecl.} =
  ##  Done !
  return orxVector_Set(pvVec, fValue, fValue, fValue)

## * Copies a vector onto another one
##  @param[in]   _pvDst                        Vector to copy to (destination)
##  @param[in]   _pvSrc                        Vector to copy from (source)
##  @return      Destination vector
##

proc orxVector_Copy*(pvDst: ptr orxVECTOR; pvSrc: ptr orxVECTOR): ptr orxVECTOR {.inline, discardable,
    cdecl.} =
  ##  Checks
  assert(pvDst != nil)
  assert(pvSrc != nil)
  ##  Copies it
  discard orxMemory_Copy(pvDst, pvSrc, sizeof((orxVECTOR)).orxU32)
  ##  Done!
  return pvDst

## * Adds vectors and stores result in a third one
##  @param[out]  _pvRes                        Vector where to store result (can be one of the two operands)
##  @param[in]   _pvOp1                        First operand
##  @param[in]   _pvOp2                        Second operand
##  @return      Resulting vector (Op1 + Op2)
##

proc orxVector_Add*(pvRes: ptr orxVECTOR; pvOp1: ptr orxVECTOR; pvOp2: ptr orxVECTOR): ptr orxVECTOR {.
    inline, discardable, cdecl.} =
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

## * Substracts vectors and stores result in a third one
##  @param[out]  _pvRes                        Vector where to store result (can be one of the two operands)
##  @param[in]   _pvOp1                        First operand
##  @param[in]   _pvOp2                        Second operand
##  @return      Resulting vector (Op1 - Op2)
##

proc orxVector_Sub*(pvRes: ptr orxVECTOR; pvOp1: ptr orxVECTOR; pvOp2: ptr orxVECTOR): ptr orxVECTOR {.
    inline, discardable, cdecl.} =
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

## * Multiplies a vector by an orxFLOAT and stores result in another one
##  @param[out]  _pvRes                        Vector where to store result (can be the operand)
##  @param[in]   _pvOp1                        First operand
##  @param[in]   _fOp2                         Second operand
##  @return      Resulting vector
##

proc orxVector_Mulf*(pvRes: ptr orxVECTOR; pvOp1: ptr orxVECTOR; fOp2: orxFLOAT): ptr orxVECTOR {.
    inline, discardable, cdecl.} =
  ##  Checks
  assert(pvRes != nil)
  assert(pvOp1 != nil)
  ##  Muls all
  pvRes.fX = pvOp1.fX * fOp2
  pvRes.fY = pvOp1.fY * fOp2
  pvRes.fZ = pvOp1.fZ * fOp2
  ##  Done!
  return pvRes

## * Multiplies a vector by another vector and stores result in a third one
##  @param[out]  _pvRes                        Vector where to store result (can be one of the two operands)
##  @param[in]   _pvOp1                        First operand
##  @param[in]   _pvOp2                        Second operand
##  @return      Resulting vector (Op1 * Op2)
##

proc orxVector_Mul*(pvRes: ptr orxVECTOR; pvOp1: ptr orxVECTOR; pvOp2: ptr orxVECTOR): ptr orxVECTOR {.
    inline, cdecl.} =
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

## * Divides a vector by an orxFLOAT and stores result in another one
##  @param[out]  _pvRes                        Vector where to store result (can be the operand)
##  @param[in]   _pvOp1                        First operand
##  @param[in]   _fOp2                         Second operand
##  @return      Resulting vector
##

proc orxVector_Divf*(pvRes: ptr orxVECTOR; pvOp1: ptr orxVECTOR; fOp2: orxFLOAT): ptr orxVECTOR {.
    inline, cdecl.} =
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

## * Divides a vector by another vector and stores result in a third one
##  @param[out]  _pvRes                        Vector where to store result (can be one of the two operands)
##  @param[in]   _pvOp1                        First operand
##  @param[in]   _pvOp2                        Second operand
##  @return      Resulting vector (Op1 / Op2)
##

proc orxVector_Div*(pvRes: ptr orxVECTOR; pvOp1: ptr orxVECTOR; pvOp2: ptr orxVECTOR): ptr orxVECTOR {.
    inline, cdecl.} =
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

## * Lerps from one vector to another one using a coefficient
##  @param[out]  _pvRes                        Vector where to store result (can be one of the two operands)
##  @param[in]   _pvOp1                        First operand
##  @param[in]   _pvOp2                        Second operand
##  @param[in]   _fOp                          Lerp coefficient parameter
##  @return      Resulting vector
##

proc orxVector_Lerp*(pvRes: ptr orxVECTOR; pvOp1: ptr orxVECTOR; pvOp2: ptr orxVECTOR;
                    fOp: orxFLOAT): ptr orxVECTOR {.inline, cdecl.} =
  ##  Checks
  assert(pvRes != nil)
  assert(pvOp1 != nil)
  assert(pvOp2 != nil)
  assert(fOp >= orxFLOAT_0)
  ##  Lerps all
  pvRes.fX = orxLERP(pvOp1.fX, pvOp2.fX, fOp)
  pvRes.fY = orxLERP(pvOp1.fY, pvOp2.fY, fOp)
  pvRes.fZ = orxLERP(pvOp1.fZ, pvOp2.fZ, fOp)
  ##  Done!
  return pvRes

## * Gets minimum between two vectors
##  @param[out]  _pvRes                        Vector where to store result (can be one of the two operands)
##  @param[in]   _pvOp1                        First operand
##  @param[in]   _pvOp2                        Second operand
##  @return      Resulting vector MIN(Op1, Op2)
##

proc orxVector_Min*(pvRes: ptr orxVECTOR; pvOp1: ptr orxVECTOR; pvOp2: ptr orxVECTOR): ptr orxVECTOR {.
    inline, cdecl.} =
  ##  Checks
  assert(pvRes != nil)
  assert(pvOp1 != nil)
  assert(pvOp2 != nil)
  ##  Gets all mins
  pvRes.fX = orxMIN(pvOp1.fX, pvOp2.fX)
  pvRes.fY = orxMIN(pvOp1.fY, pvOp2.fY)
  pvRes.fZ = orxMIN(pvOp1.fZ, pvOp2.fZ)
  ##  Done!
  return pvRes

## * Gets maximum between two vectors
##  @param[out]  _pvRes                        Vector where to store result (can be one of the two operands)
##  @param[in]   _pvOp1                        First operand
##  @param[in]   _pvOp2                        Second operand
##  @return      Resulting vector MAX(Op1, Op2)
##

proc orxVector_Max*(pvRes: ptr orxVECTOR; pvOp1: ptr orxVECTOR; pvOp2: ptr orxVECTOR): ptr orxVECTOR {.
    inline, cdecl.} =
  ##  Checks
  assert(pvRes != nil)
  assert(pvOp1 != nil)
  assert(pvOp2 != nil)
  ##  Gets all maxs
  pvRes.fX = orxMAX(pvOp1.fX, pvOp2.fX)
  pvRes.fY = orxMAX(pvOp1.fY, pvOp2.fY)
  pvRes.fZ = orxMAX(pvOp1.fZ, pvOp2.fZ)
  ##  Done!
  return pvRes

## * Clamps a vector between two others
##  @param[out]  _pvRes                        Vector where to store result (can be the operand)
##  @param[in]   _pvOp                         Vector to clamp
##  @param[in]   _pvMin                        Minimum boundary
##  @param[in]   _pvMax                        Maximum boundary
##  @return      Resulting vector CLAMP(Op, MIN, MAX)
##

proc orxVector_Clamp*(pvRes: ptr orxVECTOR; pvOp: ptr orxVECTOR; pvMin: ptr orxVECTOR;
                     pvMax: ptr orxVECTOR): ptr orxVECTOR {.inline, discardable, cdecl.} =
  ##  Checks
  assert(pvRes != nil)
  assert(pvOp != nil)
  assert(pvMin != nil)
  assert(pvMax != nil)
  ##  Gets all clamped values
  pvRes.fX = orxCLAMP(pvOp.fX, pvMin.fX, pvMax.fX)
  pvRes.fY = orxCLAMP(pvOp.fY, pvMin.fY, pvMax.fY)
  pvRes.fZ = orxCLAMP(pvOp.fZ, pvMin.fZ, pvMax.fZ)
  ##  Done!
  return pvRes

## * Negates a vector and stores result in another one
##  @param[out]  _pvRes                        Vector where to store result (can be the operand)
##  @param[in]   _pvOp                         Vector to negates
##  @return      Resulting vector (-Op)
##

proc orxVector_Neg*(pvRes: ptr orxVECTOR; pvOp: ptr orxVECTOR): ptr orxVECTOR {.inline,
    cdecl.} =
  ##  Checks
  assert(pvRes != nil)
  assert(pvOp != nil)
  ##  Negates all
  pvRes.fX = -(pvOp.fX)
  pvRes.fY = -(pvOp.fY)
  pvRes.fZ = -(pvOp.fZ)
  ##  Done!
  return pvRes

## * Gets reciprocal (1.0 /) vector and stores the result in another one
##  @param[out]  _pvRes                        Vector where to store result (can be the operand)
##  @param[in]   _pvOp                         Input value
##  @return      Resulting vector (1 / Op)
##

proc orxVector_Rec*(pvRes: ptr orxVECTOR; pvOp: ptr orxVECTOR): ptr orxVECTOR {.inline,
    cdecl.} =
  ##  Checks
  assert(pvRes != nil)
  assert(pvOp != nil)
  ##  Reverts all
  pvRes.fX = orxFLOAT_1 / pvOp.fX
  pvRes.fY = orxFLOAT_1 / pvOp.fY
  pvRes.fZ = orxFLOAT_1 / pvOp.fZ
  ##  Done!
  return pvRes

## * Gets floored vector and stores the result in another one
##  @param[out]  _pvRes                        Vector where to store result (can be the operand)
##  @param[in]   _pvOp                         Input value
##  @return      Resulting vector Floor(Op)
##

proc orxVector_Floor*(pvRes: ptr orxVECTOR; pvOp: ptr orxVECTOR): ptr orxVECTOR {.inline,
    cdecl.} =
  ##  Checks
  assert(pvRes != nil)
  assert(pvOp != nil)
  ##  Reverts all
  pvRes.fX = orxMath_Floor(pvOp.fX)
  pvRes.fY = orxMath_Floor(pvOp.fY)
  pvRes.fZ = orxMath_Floor(pvOp.fZ)
  ##  Done!
  return pvRes

## * Gets rounded vector and stores the result in another one
##  @param[out]  _pvRes                        Vector where to store result (can be the operand)
##  @param[in]   _pvOp                         Input value
##  @return      Resulting vector Round(Op)
##

proc orxVector_Round*(pvRes: ptr orxVECTOR; pvOp: ptr orxVECTOR): ptr orxVECTOR {.inline,
    cdecl.} =
  ##  Checks
  assert(pvRes != nil)
  assert(pvOp != nil)
  ##  Reverts all
  pvRes.fX = orxMath_Round(pvOp.fX)
  pvRes.fY = orxMath_Round(pvOp.fY)
  pvRes.fZ = orxMath_Round(pvOp.fZ)
  ##  Done!
  return pvRes

## * Gets vector squared size
##  @param[in]   _pvOp                         Input vector
##  @return      Vector's squared size
##

proc orxVector_GetSquareSize*(pvOp: ptr orxVECTOR): orxFLOAT {.inline, cdecl.} =
  var fResult: orxFLOAT
  ##  Checks
  assert(pvOp != nil)
  ##  Updates result
  fResult = (pvOp.fX * pvOp.fX) + (pvOp.fY * pvOp.fY) + (pvOp.fZ * pvOp.fZ)
  ##  Done!
  return fResult

## * Gets vector size
##  @param[in]   _pvOp                         Input vector
##  @return      Vector's size
##

proc orxVector_GetSize*(pvOp: ptr orxVECTOR): orxFLOAT {.inline, cdecl.} =
  var fResult: orxFLOAT
  ##  Checks
  assert(pvOp != nil)
  ##  Updates result
  fResult = orxMath_Sqrt((pvOp.fX * pvOp.fX) + (pvOp.fY * pvOp.fY) + (pvOp.fZ * pvOp.fZ))
  ##  Done!
  return fResult

## * Gets squared distance between 2 positions
##  @param[in]   _pvOp1                        First position
##  @param[in]   _pvOp2                        Second position
##  @return      Squared distance
##

proc orxVector_GetSquareDistance*(pvOp1: ptr orxVECTOR; pvOp2: ptr orxVECTOR): orxFLOAT {.
    inline, cdecl.} =
  var vTemp: orxVECTOR
  var fResult: orxFLOAT
  ##  Checks
  assert(pvOp1 != nil)
  assert(pvOp2 != nil)
  ##  Gets distance vector
  discard orxVector_Sub(addr(vTemp), pvOp2, pvOp1)
  ##  Updates result
  fResult = orxVector_GetSquareSize(addr(vTemp))
  ##  Done!
  return fResult

## * Gets distance between 2 positions
##  @param[in]   _pvOp1                        First position
##  @param[in]   _pvOp2                        Second position
##  @return      Distance
##

proc orxVector_GetDistance*(pvOp1: ptr orxVECTOR; pvOp2: ptr orxVECTOR): orxFLOAT {.
    inline, cdecl.} =
  var vTemp: orxVECTOR
  var fResult: orxFLOAT
  ##  Checks
  assert(pvOp1 != nil)
  assert(pvOp2 != nil)
  ##  Gets distance vector
  discard orxVector_Sub(addr(vTemp), pvOp2, pvOp1)
  ##  Updates result
  fResult = orxVector_GetSize(addr(vTemp))
  ##  Done!
  return fResult

## * Normalizes a vector
##  @param[out]  _pvRes                        Vector where to store result (can be the operand)
##  @param[in]   _pvOp                         Vector to normalize
##  @return      Normalized vector
##

proc orxVector_Normalize*(pvRes: ptr orxVECTOR; pvOp: ptr orxVECTOR): ptr orxVECTOR {.
    inline, cdecl.} =
  var fOp: orxFLOAT
  ##  Checks
  assert(pvRes != nil)
  assert(pvOp != nil)
  ##  Gets squared size
  fOp = (pvOp.fX * pvOp.fX) + (pvOp.fY * pvOp.fY) + (pvOp.fZ * pvOp.fZ)
  ##  Gets reciprocal size
  fOp = orxFLOAT_1 / (orxMATH_KF_TINY_EPSILON + orxMath_Sqrt(fOp))
  ##  Updates result
  pvRes.fX = fOp * pvOp.fX
  pvRes.fY = fOp * pvOp.fY
  pvRes.fZ = fOp * pvOp.fZ
  ##  Done!
  return pvRes

## * Rotates a 2D vector (along Z-axis)
##  @param[out]  _pvRes                        Vector where to store result (can be the operand)
##  @param[in]   _pvOp                         Vector to rotate
##  @param[in]   _fAngle                       Angle of rotation (radians)
##  @return      Rotated vector
##

proc orxVector_2DRotate*(pvRes: ptr orxVECTOR; pvOp: ptr orxVECTOR; fAngle: orxFLOAT): ptr orxVECTOR {.
    inline, cdecl.} =
  ##  Checks
  assert(pvRes != nil)
  assert(pvOp != nil)
  ##  PI/2?
  if fAngle == orxMATH_KF_PI_BY_2:
    ##  Updates result
    discard orxVector_Set(pvRes, -pvOp.fY, pvOp.fX, pvOp.fZ)
  elif fAngle == -orxMATH_KF_PI_BY_2: ##  Any other angle
    ##  Updates result
    discard orxVector_Set(pvRes, pvOp.fY, -pvOp.fX, pvOp.fZ)
  else:
    var
      fSin: orxFLOAT
      fCos: orxFLOAT
    ##  Gets cos & sin of angle
    fCos = orxMath_Cos(fAngle)
    fSin = orxMath_Sin(fAngle)
    ##  Updates result
    discard orxVector_Set(pvRes, (fCos * pvOp.fX) - (fSin * pvOp.fY),
                  (fSin * pvOp.fX) + (fCos * pvOp.fY), pvOp.fZ)
  ##  Done!
  return pvRes

## * Is vector null?
##  @param[in]   _pvOp                         Vector to test
##  @return      orxTRUE if vector's null, orxFALSE otherwise
##

proc orxVector_IsNull*(pvOp: ptr orxVECTOR): orxBOOL {.inline, cdecl.} =
  var bResult: orxBOOL
  ##  Checks
  assert(pvOp != nil)
  ##  Updates result
  bResult = if ((pvOp.fX == orxFLOAT_0) and (pvOp.fY == orxFLOAT_0) and
      (pvOp.fZ == orxFLOAT_0)): orxTRUE else: orxFALSE
  ##  Done!
  return bResult

## * Are vectors equal?
##  @param[in]   _pvOp1                        First vector to compare
##  @param[in]   _pvOp2                        Second vector to compare
##  @return      orxTRUE if both vectors are equal, orxFALSE otherwise
##

proc orxVector_AreEqual*(pvOp1: ptr orxVECTOR; pvOp2: ptr orxVECTOR): orxBOOL {.inline,
    cdecl.} =
  var bResult: orxBOOL
  ##  Checks
  assert(pvOp1 != nil)
  assert(pvOp2 != nil)
  ##  Updates result
  bResult = if ((pvOp1.fX == pvOp2.fX) and (pvOp1.fY == pvOp2.fY) and
      (pvOp1.fZ == pvOp2.fZ)): orxTRUE else: orxFALSE
  ##  Done!
  return bResult

## * Transforms a cartesian vector into a spherical one
##  @param[out]  _pvRes                        Vector where to store result (can be the operand)
##  @param[in]   _pvOp                         Vector to transform
##  @return      Transformed vector
##

proc orxVector_FromCartesianToSpherical*(pvRes: ptr orxSPVECTOR; pvOp: ptr orxVECTOR): ptr orxSPVECTOR {.
    inline, cdecl.} =
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
        fRho = orxMath_Abs(pvOp.fY)
      elif pvOp.fY == orxFLOAT_0: ##  X != 0 and Y != 0
        ##  Gets absolute value
        fRho = orxMath_Abs(pvOp.fX)
      else:
        ##  Computes rho
        fRho = orxMath_Sqrt((pvOp.fX * pvOp.fX) + (pvOp.fY * pvOp.fY))
      ##  Sets phi
      fPhi = orxMATH_KF_PI_BY_2
    else:
      ##  X = 0 and Y = 0?
      if (pvOp.fX == orxFLOAT_0) and (pvOp.fY == orxFLOAT_0):
        ##  Z < 0?
        if pvOp.fZ < orxFLOAT_0:
          ##  Gets absolute value
          fRho = orxMath_Abs(pvOp.fZ)
          ##  Sets phi
          fPhi = orxMATH_KF_PI
        else:
          ##  Sets rho
          fRho = pvOp.fZ
          ##  Sets phi
          fPhi = orxFLOAT_0
      else:
        ##  Computes rho
        fRho = orxMath_Sqrt(orxVector_GetSquareSize(pvOp))
        ##  Computes phi
        fPhi = orxMath_ACos(pvOp.fZ / fRho)
    ##  Computes theta
    fTheta = orxMath_ATan(pvOp.fY, pvOp.fX)
    ##  Updates result
    pvRes.fRho = fRho
    pvRes.fTheta = fTheta
    pvRes.fPhi = fPhi
  ##  Done!
  return pvRes

## * Transforms a spherical vector into a cartesian one
##  @param[out]  _pvRes                        Vector where to store result (can be the operand)
##  @param[in]   _pvOp                         Vector to transform
##  @return      Transformed vector
##

proc orxVector_FromSphericalToCartesian*(pvRes: ptr orxVECTOR; pvOp: ptr orxSPVECTOR): ptr orxVECTOR {.
    inline, cdecl.} =
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
  fSinTheta = orxMath_Sin(pvOp.fTheta)
  fCosTheta = orxMath_Cos(pvOp.fTheta)
  fSinPhi = orxMath_Sin(pvOp.fPhi)
  fCosPhi = orxMath_Cos(pvOp.fPhi)
  if orxMath_Abs(fSinTheta) < orxMATH_KF_EPSILON:
    fSinTheta = orxFLOAT_0
  if orxMath_Abs(fCosTheta) < orxMATH_KF_EPSILON:
    fCosTheta = orxFLOAT_0
  if orxMath_Abs(fSinPhi) < orxMATH_KF_EPSILON:
    fSinPhi = orxFLOAT_0
  if orxMath_Abs(fCosPhi) < orxMATH_KF_EPSILON:
    fCosPhi = orxFLOAT_0
  pvRes.fX = fRho * fCosTheta * fSinPhi
  pvRes.fY = fRho * fSinTheta * fSinPhi
  pvRes.fZ = fRho * fCosPhi
  ##  Done!
  return pvRes

## * Gets dot product of two vectors
##  @param[in]   _pvOp1                      First operand
##  @param[in]   _pvOp2                      Second operand
##  @return      Dot product
##

proc orxVector_Dot*(pvOp1: ptr orxVECTOR; pvOp2: ptr orxVECTOR): orxFLOAT {.inline, cdecl.} =
  var fResult: orxFLOAT
  ##  Checks
  assert(pvOp1 != nil)
  assert(pvOp2 != nil)
  ##  Updates result
  fResult = (pvOp1.fX * pvOp2.fX) + (pvOp1.fY * pvOp2.fY) + (pvOp1.fZ * pvOp2.fZ)
  ##  Done!
  return fResult

## * Gets 2D dot product of two vectors
##  @param[in]   _pvOp1                      First operand
##  @param[in]   _pvOp2                      Second operand
##  @return      2D dot product
##

proc orxVector_2DDot*(pvOp1: ptr orxVECTOR; pvOp2: ptr orxVECTOR): orxFLOAT {.inline,
    cdecl.} =
  var fResult: orxFLOAT
  ##  Checks
  assert(pvOp1 != nil)
  assert(pvOp2 != nil)
  ##  Updates result
  fResult = (pvOp1.fX * pvOp2.fX) + (pvOp1.fY * pvOp2.fY)
  ##  Done!
  return fResult

## * Gets cross product of two vectors
##  @param[out]  _pvRes                       Vector where to store result
##  @param[in]   _pvOp1                      First operand
##  @param[in]   _pvOp2                      Second operand
##  @return      Cross product orxVECTOR / nil
##

proc orxVector_Cross*(pvRes: ptr orxVECTOR; pvOp1: ptr orxVECTOR; pvOp2: ptr orxVECTOR): ptr orxVECTOR {.
    inline, cdecl.} =
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

##  *** Vector functions ***
## * Computes an interpolated point on a cubic Bezier curve segment for a given parameter
##  @param[out]  _pvRes                      Vector where to store result
##  @param[in]   _pvPoint1                   First point for this curve segment
##  @param[in]   _pvPoint2                   First control point for this curve segment
##  @param[in]   _pvPoint3                   Second control point for this curve segment
##  @param[in]   _pvPoint4                   Last point for this curve segment
##  @param[in]   _fT                         Interpolation parameter in [0.0, 1.0]
##  @return      Interpolated point on the cubic Bezier curve segment
##

proc orxVector_Bezier*(pvRes: ptr orxVECTOR; pvPoint1: ptr orxVECTOR;
                      pvPoint2: ptr orxVECTOR; pvPoint3: ptr orxVECTOR;
                      pvPoint4: ptr orxVECTOR; fT: orxFLOAT): ptr orxVECTOR {.cdecl,
    importc: "orxVector_Bezier", dynlib: libORX.}
## * Computes an interpolated point on a Catmull-Rom curve segment for a given parameter
##  @param[out]  _pvRes                      Vector where to store result
##  @param[in]   _pvPoint1                   First control point for this curve segment
##  @param[in]   _pvPoint2                   Second control point for this curve segment
##  @param[in]   _pvPoint3                   Third control point for this curve segment
##  @param[in]   _pvPoint4                   Fourth control point for this curve segment
##  @param[in]   _fT                         Interpolation parameter in [0.0, 1.0]
##  @return      Interpolated point on the Catmull-Rom curve segment
##

proc orxVector_CatmullRom*(pvRes: ptr orxVECTOR; pvPoint1: ptr orxVECTOR;
                          pvPoint2: ptr orxVECTOR; pvPoint3: ptr orxVECTOR;
                          pvPoint4: ptr orxVECTOR; fT: orxFLOAT): ptr orxVECTOR {.
    cdecl, importc: "orxVector_CatmullRom", dynlib: libORX.}
##  *** Vector constants ***

var orxVECTOR_X* {.importc: "orxVECTOR_X", dynlib: libORX.}: orxVECTOR

## *< X-Axis unit vector

var orxVECTOR_Y* {.importc: "orxVECTOR_Y", dynlib: libORX.}: orxVECTOR

## *< Y-Axis unit vector

var orxVECTOR_Z* {.importc: "orxVECTOR_Z", dynlib: libORX.}: orxVECTOR

## *< Z-Axis unit vector

var orxVECTOR_0* {.importc: "orxVECTOR_0", dynlib: libORX.}: orxVECTOR

## *< Null vector

var orxVECTOR_1* {.importc: "orxVECTOR_1", dynlib: libORX.}: orxVECTOR

## *< Vector filled with 1s

var orxVECTOR_RED* {.importc: "orxVECTOR_RED", dynlib: libORX.}: orxVECTOR

## *< Red color vector

var orxVECTOR_GREEN* {.importc: "orxVECTOR_GREEN", dynlib: libORX.}: orxVECTOR

## *< Green color vector

var orxVECTOR_BLUE* {.importc: "orxVECTOR_BLUE", dynlib: libORX.}: orxVECTOR

## *< Blue color vector

var orxVECTOR_YELLOW* {.importc: "orxVECTOR_YELLOW", dynlib: libORX.}: orxVECTOR

## *< Yellow color vector

var orxVECTOR_CYAN* {.importc: "orxVECTOR_CYAN", dynlib: libORX.}: orxVECTOR

## *< Cyan color vector

var orxVECTOR_MAGENTA* {.importc: "orxVECTOR_MAGENTA", dynlib: libORX.}: orxVECTOR

## *< Magenta color vector

var orxVECTOR_BLACK* {.importc: "orxVECTOR_BLACK", dynlib: libORX.}: orxVECTOR

## *< Black color vector

var orxVECTOR_WHITE* {.importc: "orxVECTOR_WHITE", dynlib: libORX.}: orxVECTOR

## *< White color vector

## * @}
