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

import pure/math, lib, typ, system

## * Lerps between two values given a parameter T [0, 1]
##  @param[in]   A                               First value (will be selected for T = 0)
##  @param[in]   B                               Second value (will be selected for T = 1)
##  @param[in]   T                               Lerp coefficient parameter [0, 1]
##  @return      Lerped value
##

template orxLERP*(A, B, T: untyped): untyped =
  ((A) + ((T) * ((B) - (A))))

## * Gets minimum between two values
##  @param[in]   A                               First value
##  @param[in]   B                               Second value
##  @return      Minimum between A & B
##

template orxMIN*(A, B: untyped): untyped =
  (if ((A) > (B)): (B) else: (A))

## * Gets maximum between two values
##  @param[in]   A                               First value
##  @param[in]   B                               Second value
##  @return      Maximum between A & B
##

template orxMAX*(A, B: untyped): untyped =
  (if ((A) < (B)): (B) else: (A))

## * Gets clamped value between two boundaries
##  @param[in]   V                               Value to clamp
##  @param[in]   MIN                             Minimum boundary
##  @param[in]   MAX                             Maximum boundary
##  @return      Clamped value between MIN & MAX
##

template orxCLAMP*(V, MIN, MAX: untyped): untyped =
  orxMAX(orxMIN(V, MAX), MIN)

## * Converts an orxFLOAT to an orxU32
##  @param[in]   V                               Value to convert
##  @return      Converted value
##

template orxF2U*(V: untyped): untyped =
  ((orxU32)(V))

## * Converts an orxFLOAT to an orxS32
##  @param[in]   V                               Value to convert
##  @return      Converted value
##

template orxF2S*(V: untyped): untyped =
  ((orxS32)(V))

## * Converts an orxU32 to an orxFLOAT
##  @param[in]   V                               Value to convert
##  @return      Converted value
##

template orxU2F*(V: untyped): untyped =
  ((orxFLOAT)(V))

## * Converts an orxS32 to an orxFLOAT
##  @param[in]   V                               Value to convert
##  @return      Converted value
##

template orxS2F*(V: untyped): untyped =
  ((orxFLOAT)(V))

## ** Module functions ***
## * Inits the random seed
##  @param[in]   _u32Seed                        Value to use as seed for random number generation
##

proc orxMath_InitRandom*(u32Seed: orxU32) {.cdecl, importc: "orxMath_InitRandom",
    dynlib: libORX.}
## * Gets a random orxFLOAT value
##  @param[in]   _fMin                           Minimum boundary (inclusive)
##  @param[in]   _fMax                           Maximum boundary (exclusive)
##  @return      Random value
##

proc orxMath_GetRandomFloat*(fMin: orxFLOAT; fMax: orxFLOAT): orxFLOAT {.cdecl,
    importc: "orxMath_GetRandomFloat", dynlib: libORX.}
## * Gets a random orxFLOAT value using step increments
##  @param[in]   _fMin                           Minimum boundary (inclusive)
##  @param[in]   _fMax                           Maximum boundary (exclusive)
##  @param[in]   _fStep                          Step value, must be strictly positive
##  @return      Random value
##

proc orxMath_GetSteppedRandomFloat*(fMin: orxFLOAT; fMax: orxFLOAT; fStep: orxFLOAT): orxFLOAT {.
    cdecl, importc: "orxMath_GetSteppedRandomFloat", dynlib: libORX.}
## * Gets a random orxU32 value
##  @param[in]   _u32Min                         Minimum boundary (inclusive)
##  @param[in]   _u32Max                         Maximum boundary (inclusive)
##  @return      Random value
##

proc orxMath_GetRandomU32*(u32Min: orxU32; u32Max: orxU32): orxU32 {.cdecl,
    importc: "orxMath_GetRandomU32", dynlib: libORX.}
## * Gets a random U32 value using step increments
##  @param[in]   _u32Min                         Minimum boundary (inclusive)
##  @param[in]   _u32Max                         Maximum boundary (inclusive)
##  @param[in]   _u32Step                        Step value, must be strictly positive
##  @return      Random value
##

proc orxMath_GetSteppedRandomU32*(u32Min: orxU32; u32Max: orxU32; u32Step: orxU32): orxU32 {.
    cdecl, importc: "orxMath_GetSteppedRandomU32", dynlib: libORX.}
## * Gets a random orxS32 value
##  @param[in]   _s32Min                         Minimum boundary (inclusive)
##  @param[in]   _s32Max                         Maximum boundary (inclusive)
##  @return      Random value
##

proc orxMath_GetRandomS32*(s32Min: orxS32; s32Max: orxS32): orxS32 {.cdecl,
    importc: "orxMath_GetRandomS32", dynlib: libORX.}
## * Gets a random S32 value using step increments
##  @param[in]   _s32Min                         Minimum boundary (inclusive)
##  @param[in]   _s32Max                         Maximum boundary (inclusive)
##  @param[in]   _s32Step                        Step value, must be strictly positive
##  @return      Random value
##

proc orxMath_GetSteppedRandomS32*(s32Min: orxS32; s32Max: orxS32; s32Step: orxS32): orxS32 {.
    cdecl, importc: "orxMath_GetSteppedRandomS32", dynlib: libORX.}
## * Gets a random orxU64 value
##  @param[in]   _u64Min                         Minimum boundary (inclusive)
##  @param[in]   _u64Max                         Maximum boundary (inclusive)
##  @return      Random value
##

proc orxMath_GetRandomU64*(u64Min: orxU64; u64Max: orxU64): orxU64 {.cdecl,
    importc: "orxMath_GetRandomU64", dynlib: libORX.}
## * Gets a random U64 value using step increments
##  @param[in]   _u64Min                         Minimum boundary (inclusive)
##  @param[in]   _u64Max                         Maximum boundary (inclusive)
##  @param[in]   _u64Step                        Step value, must be strictly positive
##  @return      Random value
##

proc orxMath_GetSteppedRandomU64*(u64Min: orxU64; u64Max: orxU64; u64Step: orxU64): orxU64 {.
    cdecl, importc: "orxMath_GetSteppedRandomU64", dynlib: libORX.}
## * Gets a random orxS64 value
##  @param[in]   _s64Min                         Minimum boundary (inclusive)
##  @param[in]   _s64Max                         Maximum boundary (inclusive)
##  @return      Random value
##

proc orxMath_GetRandomS64*(s64Min: orxS64; s64Max: orxS64): orxS64 {.cdecl,
    importc: "orxMath_GetRandomS64", dynlib: libORX.}
## * Gets a random S64 value using step increments
##  @param[in]   _s64Min                         Minimum boundary (inclusive)
##  @param[in]   _s64Max                         Maximum boundary (inclusive)
##  @param[in]   _s64Step                        Step value, must be strictly positive
##  @return      Random value
##

proc orxMath_GetSteppedRandomS64*(s64Min: orxS64; s64Max: orxS64; s64Step: orxS64): orxS64 {.
    cdecl, importc: "orxMath_GetSteppedRandomS64", dynlib: libORX.}
## * Gets the current random seeds
##  @param[out]  _au32Seeds                      Current seeds
##

proc orxMath_GetRandomSeeds*(au32Seeds: array[4, orxU32]) {.cdecl,
    importc: "orxMath_GetRandomSeeds", dynlib: libORX.}
## * Sets (replaces) the current random seeds
##  @param[in]   _au32Seeds                      Seeds to set
##

proc orxMath_SetRandomSeeds*(au32Seeds: array[4, orxU32]) {.cdecl,
    importc: "orxMath_SetRandomSeeds", dynlib: libORX.}
## ** Inlined functions ***
## * Gets the count of bit in an orxU32
##  @param[in]   _u32Value                       Value to process
##  @return      Number of bits that are set in the value
##

proc orxMath_GetBitCount*(u32Value: orxU32): orxU32 {.inline, cdecl.} =
  {.emit"return(orxU32)__builtin_popcount(u32Value);".}

## * Gets the count of trailing zeros in an orxU32
##  @param[in]   _u32Value                       Value to process
##  @return      Number of trailing zeros
##

proc orxMath_GetTrailingZeroCount*(u32Value: orxU32): orxU32 {.inline, cdecl.} =
  var u32Result: orxU32
  ##  Checks
  assert(u32Value != 0)
  when defined(MSVC):
    ##  Uses intrinsic
    BitScanForward(cast[ptr culong](addr(u32Result)), u32Value)
  else:
    ##  Uses intrinsic
    {.emit"u32Result = (orxU32)__builtin_ctz(u32Value);".}
  ##  Done!
  return u32Result

## * Gets the count of trailing zeros in an orxU64
##  @param[in]   _u64Value                       Value to process
##  @return      Number of trailing zeros
##

proc orxMath_GetTrailingZeroCount64*(u64Value: orxU64): orxU32 {.inline, cdecl.} =
  var u32Result: orxU32
  ##  Checks
  assert(u64Value != 0)
  when defined(MSVC):
    when defined(orx64):
      ##  Uses intrinsic
      BitScanForward64(cast[ptr culong](addr(u32Result)), u64Value)
    else:
      ##  Updates result
      u32Result = if ((u64Value and 0xFFFFFFFF) == 0): orxMath_GetTrailingZeroCount(
          (orxU32)(u64Value shr 32)) + 32 else: orxMath_GetTrailingZeroCount(
          cast[orxU32](u64Value))
  else:
    ##  Uses intrinsic
    {.emit"u32Result = (orxU32)__builtin_ctzll(u64Value);".}
  ##  Done!
  return u32Result

## * Is value a power of two?
##  @param[in]   _u32Value                       Value to test
##  @return      orxTRUE / orxFALSE
##

proc orxMath_IsPowerOfTwo*(u32Value: orxU32): orxBOOL {.inline, cdecl.} =
  var bResult: orxBOOL
  ##  Updates result
  bResult = if ((u32Value and (u32Value - 1)) == 0): orxTRUE else: orxFALSE
  ##  Done!
  return bResult

## * Gets next power of two of an orxU32
##  @param[in]   _u32Value                       Value to process
##  @return      If _u32Value is already a power of two, returns it, otherwise the next power of two
##

proc orxMath_GetNextPowerOfTwo*(u32Value: orxU32): orxU32 {.inline, cdecl.} =
  var u32Result: orxU32
  ##  Non-zero?
  if u32Value != 0:
    ##  Updates result
    u32Result = u32Value - 1
    u32Result = u32Result or (u32Result shr 1)
    u32Result = u32Result or (u32Result shr 2)
    u32Result = u32Result or (u32Result shr 4)
    u32Result = u32Result or (u32Result shr 8)
    u32Result = u32Result or (u32Result shr 16)
    inc(u32Result)
  else:
    ##  Updates result
    u32Result = 1
  ##  Done!
  return u32Result

## * Gets smooth stepped value between two extrema
##  @param[in]   _fMin                           Minimum value
##  @param[in]   _fMax                           Maximum value
##  @param[in]   _fValue                         Value to process
##  @return      0.0 if _fValue <= _fMin, 1.0 if _fValue >= _fMax, smoothed value between 0.0 & 1.0 otherwise
##

proc orxMath_SmoothStep*(fMin: orxFLOAT; fMax: orxFLOAT; fValue: orxFLOAT): orxFLOAT {.
    inline, cdecl.} =
  var
    fTemp: orxFLOAT
    fResult: orxFLOAT
  ##  Gets normalized and clamped value
  fTemp = (fValue - fMin) / (fMax - fMin)
  fTemp = orxCLAMP(fTemp, orxFLOAT_0, orxFLOAT_1)
  ##  Gets smoothed result
  fResult = fTemp * fTemp * (orx2F(3.0) - (orx2F(2.0) * fTemp))
  ##  Done!
  return fResult

## * Gets smoother stepped value between two extrema
##  @param[in]   _fMin                           Minimum value
##  @param[in]   _fMax                           Maximum value
##  @param[in]   _fValue                         Value to process
##  @return      0.0 if _fValue <= _fMin, 1.0 if _fValue >= _fMax, smooth(er)ed value between 0.0 & 1.0 otherwise
##

proc orxMath_SmootherStep*(fMin: orxFLOAT; fMax: orxFLOAT; fValue: orxFLOAT): orxFLOAT {.
    inline, cdecl.} =
  var
    fTemp: orxFLOAT
    fResult: orxFLOAT
  ##  Gets normalized and clamped value
  fTemp = (fValue - fMin) / (fMax - fMin)
  fTemp = orxCLAMP(fTemp, orxFLOAT_0, orxFLOAT_1)
  ##  Gets smoothed result
  fResult = fTemp * fTemp * fTemp *
      (fTemp * ((fTemp * orx2F(6.0)) - orx2F(15.0)) + orx2F(10.0))
  ##  Done!
  return fResult

## ** Math Definitions **

const
  orxMATH_KF_SQRT_2* = orx2F(1.414213562) ## *< Sqrt(2) constant
  orxMATH_KF_EPSILON* = orx2F(0.0001) ## *< Epsilon constant
  orxMATH_KF_TINY_EPSILON* = orx2F(1e-37) ## *< Tiny epsilon
  orxMATH_KF_2_PI* = orx2F(6.283185307) ## *< 2 PI constant
  orxMATH_KF_PI* = orx2F(3.141592654) ## *< PI constant
  orxMATH_KF_PI_BY_2* = orx2F(1.570796327) ## *< PI / 2 constant
  orxMATH_KF_PI_BY_4* = orx2F(0.785398163) ## *< PI / 4 constant

const
  orxMATH_KF_DEG_TO_RAD* = orx2F(3.141592654 / 180.0) ## *< Degree to radian conversion constant
  orxMATH_KF_RAD_TO_DEG* = orx2F(180.0 / 3.141592654) ## *< Radian to degree conversion constant
## ** Trigonometric function **
## * Gets a sine
##  @param[in]   _fOp                            Input radian angle value
##  @return      Sine of the given angle
##

proc orxMath_Sin*(fOp: orxFLOAT): orxFLOAT {.inline, cdecl.} =
  var fResult: orxFLOAT
  ##  Updates result
  fResult = sin(fOp)
  ##  Done!
  return fResult

## * Gets a cosine
##  @param[in]   _fOp                            Input radian angle value
##  @return      Cosine of the given angle
##

proc orxMath_Cos*(fOp: orxFLOAT): orxFLOAT {.inline, cdecl.} =
  var fResult: orxFLOAT
  ##  Updates result
  fResult = cos(fOp)
  ##  Done!
  return fResult

## * Gets a tangent
##  @param[in]   _fOp                            Input radian angle value
##  @return      Tangent of the given angle
##

proc orxMath_Tan*(fOp: orxFLOAT): orxFLOAT {.inline, cdecl.} =
  var fResult: orxFLOAT
  ##  Updates result
  fResult = tan(fOp)
  ##  Done!
  return fResult

## * Gets an arccosine
##  @param[in]   _fOp                            Input radian angle value
##  @return      Arccosine of the given angle
##

proc orxMath_ACos*(fOp: orxFLOAT): orxFLOAT {.inline, cdecl.} =
  var fResult: orxFLOAT
  ##  Updates result
  fResult = arccos(fOp)
  ##  Done!
  return fResult

## * Gets an arcsine
##  @param[in]   _fOp                            Input radian angle value
##  @return      Arcsine of the given angle
##

proc orxMath_ASin*(fOp: orxFLOAT): orxFLOAT {.inline, cdecl.} =
  var fResult: orxFLOAT
  ##  Updates result
  fResult = arcsin(fOp)
  ##  Done!
  return fResult

## * Gets an arctangent
##  @param[in]   _fOp1                           First operand
##  @param[in]   _fOp2                           Second operand
##  @return      Arctangent of the given angle
##

proc orxMath_ATan*(fOp1: orxFLOAT; fOp2: orxFLOAT): orxFLOAT {.inline, cdecl.} =
  var fResult: orxFLOAT
  ##  Updates result
  fResult = arctan2(fOp1, fOp2)
  ##  Done!
  return fResult

## ** Misc functions **
## * Gets a square root
##  @param[in]   _fOp                            Input value
##  @return      Square root of the given value
##

proc orxMath_Sqrt*(fOp: orxFLOAT): orxFLOAT {.inline, cdecl.} =
  var fResult: orxFLOAT
  ##  Updates result
  fResult = sqrt(fOp)
  ##  Done!
  return fResult

## * Gets a floored value
##  @param[in]   _fOp                            Input value
##  @return      Floored value
##

proc orxMath_Floor*(fOp: orxFLOAT): orxFLOAT {.inline, cdecl.} =
  var fResult: orxFLOAT
  ##  Updates result
  fResult = floor(fOp)
  ##  Done!
  return fResult

## * Gets a ceiled value
##  @param[in]   _fOp                            Input value
##  @return      Ceiled value
##

proc orxMath_Ceil*(fOp: orxFLOAT): orxFLOAT {.inline, cdecl.} =
  var fResult: orxFLOAT
  ##  Updates result
  fResult = ceil(fOp)
  ##  Done!
  return fResult

## * Gets a rounded value
##  @param[in]   _fOp                            Input value
##  @return      Rounded value
##

proc orxMath_Round*(fOp: orxFLOAT): orxFLOAT {.inline, cdecl.} =
  var fResult: orxFLOAT
  when defined(MSVC):
    ##  Updates result
    fResult = floorf(fOp + orx2F(0.5))
  else:
    ##  Updates result
    fResult = round(fOp)
  ##  Done!
  return fResult

## * Gets a modulo value
##  @param[in]   _fOp1                           Input value
##  @param[in]   _fOp2                           Modulo value
##  @return      Modulo value
##

proc orxMath_Mod*(fOp1: orxFLOAT; fOp2: orxFLOAT): orxFLOAT {.inline, cdecl.} =
  var fResult: orxFLOAT
  ##  Updates result
  fResult = fmod(fOp1, fOp2)
  ##  Done!
  return fResult

## * Gets a powed value
##  @param[in]   _fOp                            Input value
##  @param[in]   _fExp                           Exponent value
##  @return      Powed value
##

proc orxMath_Pow*(fOp: orxFLOAT; fExp: orxFLOAT): orxFLOAT {.inline, cdecl.} =
  var fResult: orxFLOAT
  ##  Updates result
  fResult = pow(fOp, fExp)
  ##  Done!
  return fResult

## * Gets an absolute value
##  @param[in]   _fOp                            Input value
##  @return      Absolute value
##

proc orxMath_Abs*(fOp: orxFLOAT): orxFLOAT {.inline, cdecl.} =
  var fResult: orxFLOAT
  ##  Updates result
  fResult = abs(fOp)
  ##  Done!
  return fResult

## * @}
