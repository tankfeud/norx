import pure/math, lib, typ, system

template lerp*(a, b, t: untyped): untyped =
  ## Lerps between two values given a coefficient t [0, 1]
  ## For t = 1 the result is b and for t = 0 the result is a.  
  a + (t * (b - a))

template clamp*(v, mn, mx: untyped): untyped =
  ## Gets clamped value between two boundaries
  max(min(v, mx), mn)

## ** Module functions ***

proc initRandom*(u32Seed: orxU32) {.cdecl, importc: "orxMath_InitRandom",
    dynlib: libORX.}
  ## Inits the random seed
  ##  @param[in]   _u32Seed                        Value to use as seed for random number generation

proc getRandomFloat*(fMin: orxFLOAT; fMax: orxFLOAT): orxFLOAT {.cdecl,
    importc: "orxMath_GetRandomFloat", dynlib: libORX.}
  ## Gets a random orxFLOAT value
  ##  @param[in]   _fMin                           Minimum boundary (inclusive)
  ##  @param[in]   _fMax                           Maximum boundary (exclusive)
  ##  @return      Random value

proc getSteppedRandomFloat*(fMin: orxFLOAT; fMax: orxFLOAT; fStep: orxFLOAT): orxFLOAT {.
    cdecl, importc: "orxMath_GetSteppedRandomFloat", dynlib: libORX.}
  ## Gets a random orxFLOAT value using step increments
  ##  @param[in]   _fMin                           Minimum boundary (inclusive)
  ##  @param[in]   _fMax                           Maximum boundary (exclusive)
  ##  @param[in]   _fStep                          Step value, must be strictly positive
  ##  @return      Random value

proc getRandomU32*(u32Min: orxU32; u32Max: orxU32): orxU32 {.cdecl,
    importc: "orxMath_GetRandomU32", dynlib: libORX.}
  ## Gets a random orxU32 value
  ##  @param[in]   _u32Min                         Minimum boundary (inclusive)
  ##  @param[in]   _u32Max                         Maximum boundary (inclusive)
  ##  @return      Random value

proc getSteppedRandomU32*(u32Min: orxU32; u32Max: orxU32; u32Step: orxU32): orxU32 {.
    cdecl, importc: "orxMath_GetSteppedRandomU32", dynlib: libORX.}
  ## Gets a random U32 value using step increments
  ##  @param[in]   _u32Min                         Minimum boundary (inclusive)
  ##  @param[in]   _u32Max                         Maximum boundary (inclusive)
  ##  @param[in]   _u32Step                        Step value, must be strictly positive
  ##  @return      Random value

proc getRandomS32*(s32Min: orxS32; s32Max: orxS32): orxS32 {.cdecl,
    importc: "orxMath_GetRandomS32", dynlib: libORX.}
  ## Gets a random orxS32 value
  ##  @param[in]   _s32Min                         Minimum boundary (inclusive)
  ##  @param[in]   _s32Max                         Maximum boundary (inclusive)
  ##  @return      Random value

proc getSteppedRandomS32*(s32Min: orxS32; s32Max: orxS32; s32Step: orxS32): orxS32 {.
    cdecl, importc: "orxMath_GetSteppedRandomS32", dynlib: libORX.}
  ## Gets a random S32 value using step increments
  ##  @param[in]   _s32Min                         Minimum boundary (inclusive)
  ##  @param[in]   _s32Max                         Maximum boundary (inclusive)
  ##  @param[in]   _s32Step                        Step value, must be strictly positive
  ##  @return      Random value

proc getRandomU64*(u64Min: orxU64; u64Max: orxU64): orxU64 {.cdecl,
    importc: "orxMath_GetRandomU64", dynlib: libORX.}
  ## Gets a random orxU64 value
  ##  @param[in]   _u64Min                         Minimum boundary (inclusive)
  ##  @param[in]   _u64Max                         Maximum boundary (inclusive)
  ##  @return      Random value

proc getSteppedRandomU64*(u64Min: orxU64; u64Max: orxU64; u64Step: orxU64): orxU64 {.
    cdecl, importc: "orxMath_GetSteppedRandomU64", dynlib: libORX.}
  ## Gets a random U64 value using step increments
  ##  @param[in]   _u64Min                         Minimum boundary (inclusive)
  ##  @param[in]   _u64Max                         Maximum boundary (inclusive)
  ##  @param[in]   _u64Step                        Step value, must be strictly positive
  ##  @return      Random value

proc getRandomS64*(s64Min: orxS64; s64Max: orxS64): orxS64 {.cdecl,
    importc: "orxMath_GetRandomS64", dynlib: libORX.}
  ## Gets a random orxS64 value
  ##  @param[in]   _s64Min                         Minimum boundary (inclusive)
  ##  @param[in]   _s64Max                         Maximum boundary (inclusive)
  ##  @return      Random value

proc getSteppedRandomS64*(s64Min: orxS64; s64Max: orxS64; s64Step: orxS64): orxS64 {.
    cdecl, importc: "orxMath_GetSteppedRandomS64", dynlib: libORX.}
  ## Gets a random S64 value using step increments
  ##  @param[in]   _s64Min                         Minimum boundary (inclusive)
  ##  @param[in]   _s64Max                         Maximum boundary (inclusive)
  ##  @param[in]   _s64Step                        Step value, must be strictly positive
  ##  @return      Random value

proc getRandomSeeds*(au32Seeds: array[4, orxU32]) {.cdecl,
    importc: "orxMath_GetRandomSeeds", dynlib: libORX.}
  ## Gets the current random seeds
  ##  @param[out]  _au32Seeds                      Current seeds

proc setRandomSeeds*(au32Seeds: array[4, orxU32]) {.cdecl,
    importc: "orxMath_SetRandomSeeds", dynlib: libORX.}
  ## Sets (replaces) the current random seeds
  ##  @param[in]   _au32Seeds                      Seeds to set

proc getBitCount*(u32Value: orxU32): orxU32 {.inline, cdecl.} =
  ## ** Inlined functions ***
  ## Gets the count of bit in an orxU32
  ##  @param[in]   _u32Value                       Value to process
  ##  @return      Number of bits that are set in the value
  {.emit"return(orxU32)__builtin_popcount(u32Value);".}

proc getTrailingZeroCount*(u32Value: orxU32): orxU32 {.inline, cdecl.} =
  ## Gets the count of trailing zeros in an orxU32
  ##  @param[in]   _u32Value                       Value to process
  ##  @return      Number of trailing zeros
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

proc getTrailingZeroCount64*(u64Value: orxU64): orxU32 {.inline, cdecl.} =
  ## Gets the count of trailing zeros in an orxU64
  ##  @param[in]   _u64Value                       Value to process
  ##  @return      Number of trailing zeros
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

proc isPowerOfTwo*(u32Value: orxU32): orxBOOL {.inline, cdecl.} =
  ## Is value a power of two?
  ##  @param[in]   _u32Value                       Value to test
  ##  @return      orxTRUE / orxFALSE
  var bResult: orxBOOL
  ##  Updates result
  bResult = if ((u32Value and (u32Value - 1)) == 0): orxTRUE else: orxFALSE
  ##  Done!
  return bResult

proc getNextPowerOfTwo*(u32Value: orxU32): orxU32 {.inline, cdecl.} =
  ## Gets next power of two of an orxU32
  ##  @param[in]   _u32Value                       Value to process
  ##  @return      If _u32Value is already a power of two, returns it, otherwise the next power of two
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

proc smoothStep*(fMin: orxFLOAT; fMax: orxFLOAT; fValue: orxFLOAT): orxFLOAT {.
    inline, cdecl.} =
  ## Gets smooth stepped value between two extrema
  ##  @param[in]   _fMin                           Minimum value
  ##  @param[in]   _fMax                           Maximum value
  ##  @param[in]   _fValue                         Value to process
  ##  @return      0.0 if _fValue <= _fMin, 1.0 if _fValue >= _fMax, smoothed value between 0.0 & 1.0 otherwise
  var
    fTemp: orxFLOAT
    fResult: orxFLOAT
  ##  Gets normalized and clamped value
  fTemp = (fValue - fMin) / (fMax - fMin)
  fTemp = clamp(fTemp, orxFLOAT_0, orxFLOAT_1)
  ##  Gets smoothed result
  fResult = fTemp * fTemp * (orx2F(3.0) - (orx2F(2.0) * fTemp))
  ##  Done!
  return fResult

proc smootherStep*(fMin: orxFLOAT; fMax: orxFLOAT; fValue: orxFLOAT): orxFLOAT {.
    inline, cdecl.} =
  ## Gets smoother stepped value between two extrema
  ##  @param[in]   _fMin                           Minimum value
  ##  @param[in]   _fMax                           Maximum value
  ##  @param[in]   _fValue                         Value to process
  ##  @return      0.0 if _fValue <= _fMin, 1.0 if _fValue >= _fMax, smooth(er)ed value between 0.0 & 1.0 otherwise
  var
    fTemp: orxFLOAT
    fResult: orxFLOAT
  ##  Gets normalized and clamped value
  fTemp = (fValue - fMin) / (fMax - fMin)
  fTemp = clamp(fTemp, orxFLOAT_0, orxFLOAT_1)
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




proc round*(fOp: orxFLOAT): orxFLOAT {.inline, cdecl.} =
  ## Gets a rounded value
  ##  @param[in]   _fOp                            Input value
  ##  @return      Rounded value
  var fResult: orxFLOAT
  when defined(MSVC):
    ##  Updates result
    fResult = floorf(fOp + orx2F(0.5))
  else:
    ##  Updates result
    fResult = round(fOp)
  ##  Done!
  return fResult
