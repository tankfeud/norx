import wrapper

when defined(processAnnotations):
  import annotation
  static: processAnnotations(currentSourcePath())

## @copy orx/code/include/math/orxMath.nim:"##  Lerps between two values given a parameter T [0, 1]":81:f3586f5b5bd823aed9dfa0389c8a1993
##  Lerps between two values given a parameter T [0, 1]
##  @param[in]   A                               First value (will be selected for T = 0)
##  @param[in]   B                               Second value (will be selected for T = 1)
##  @param[in]   T                               Lerp coefficient parameter [0, 1]
##  @return      Lerped value
##

template orxLERP*(A, B, T: untyped): untyped =
  ((A) + ((T) * ((B) - (A))))

##  Remaps a value from one interval to another one
##  @param[in]   A1                              First interval's low boundary
##  @param[in]   B1                              First interval's high boundary
##  @param[in]   A2                              Second interval's low boundary
##  @param[in]   B2                              Second interval's high boundary
##  @param[in]   V                               Value to remap from the first interval to the second one
##  @return      Remaped value
##

template orxREMAP*(A1, B1, A2, B2, V: untyped): untyped =
  (((V) - (A1)) div ((B1) - (A1)) * ((B2) - (A2)) + (A2))

##  Gets minimum between two values
##  @param[in]   A                               First value
##  @param[in]   B                               Second value
##  @return      Minimum between A & B
##

template orxMIN*(A, B: untyped): untyped =
  (if ((A) > (B)): (B) else: (A))

##  Gets maximum between two values
##  @param[in]   A                               First value
##  @param[in]   B                               Second value
##  @return      Maximum between A & B
##

template orxMAX*(A, B: untyped): untyped =
  (if ((A) < (B)): (B) else: (A))

##  Gets clamped value between two boundaries
##  @param[in]   V                               Value to clamp
##  @param[in]   MIN                             Minimum boundary
##  @param[in]   MAX                             Maximum boundary
##  @return      Clamped value between MIN & MAX
##

template orxCLAMP*(V, MIN, MAX: untyped): untyped =
  orxMAX(orxMIN(V, MAX), MIN)

##  Converts an orxFLOAT to an orxU32
##  @param[in]   V                               Value to convert
##  @return      Converted value
##

template orxF2U*(V: untyped): untyped =
  ((orxU32)(V))

##  Converts an orxFLOAT to an orxS32
##  @param[in]   V                               Value to convert
##  @return      Converted value
##

template orxF2S*(V: untyped): untyped =
  ((orxS32)(V))

##  Converts an orxU32 to an orxFLOAT
##  @param[in]   V                               Value to convert
##  @return      Converted value
##

template orxU2F*(V: untyped): untyped =
  ((orxFLOAT)(V))

##  Converts an orxS32 to an orxFLOAT
##  @param[in]   V                               Value to convert
##  @return      Converted value
##

template orxS2F*(V: untyped): untyped =
  ((orxFLOAT)(V))


## @copy orx/code/include/math/orxMath.nim:"proc GetBitCount*(u32Value: orxU32): orxU32 {.inline, cdecl.} =":292:e4512b48dbf676d954b3265ff27e7fb6
proc GetBitCount*(u32Value: orxU32): orxU32 {.inline, cdecl.} =
  ## * Inlined functions ***
  ##  Gets the count of bit in an orxU32
  ##  @param[in]   _u32Value                       Value to process
  ##  @return      Number of bits that are set in the value
  ##
  var u32Result: orxU32
  when defined(MSVC):
    ##  Uses intrinsic
    u32Result = popcnt(u32Value)
  else:
    ##  Uses intrinsic
    u32Result = cast[orxU32](builtin_popcount(u32Value))
  ##  Done!
  return u32Result

proc GetTrailingZeroCount*(u32Value: orxU32): orxU32 {.inline, cdecl.} =
  ##  Gets the count of trailing zeros in an orxU32
  ##  @param[in]   _u32Value                       Value to process
  ##  @return      Number of trailing zeros
  ##
  var u32Result: orxU32
  ##  Checks
  orxASSERT(u32Value != 0)
  when defined(MSVC):
    ##  Uses intrinsic
    BitScanForward(cast[ptr culong](addr(u32Result)), u32Value)
  else:
    ##  Uses intrinsic
    u32Result = cast[orxU32](builtin_ctz(u32Value))
  ##  Done!
  return u32Result

proc GetTrailingZeroCount64*(u64Value: orxU64): orxU32 {.inline, cdecl.} =
  ##  Gets the count of trailing zeros in an orxU64
  ##  @param[in]   _u64Value                       Value to process
  ##  @return      Number of trailing zeros
  ##
  var u32Result: orxU32
  ##  Checks
  assert(u64Value != 0)
  when defined(MSVC):
    when defined(orx64):
      ##  Uses intrinsic
      BitScanForward64(cast[ptr culong](addr(u32Result)), u64Value)
    else:
      ##  Updates result
      u32Result = if ((u64Value and 0xFFFFFFFF) == 0): GetTrailingZeroCount(
          (orxU32)(u64Value shr 32)) + 32 else: GetTrailingZeroCount(
          cast[orxU32](u64Value))
  else:
    ##  Uses intrinsic
    u32Result = cast[orxU32](builtin_ctzll(u64Value))
  ##  Done!
  return u32Result

proc IsPowerOfTwo*(u32Value: orxU32): orxBOOL {.inline, cdecl.} =
  ##  Is value a power of two?
  ##  @param[in]   _u32Value                       Value to test
  ##  @return      orxTRUE / orxFALSE
  ##
  var bResult: orxBOOL
  ##  Updates result
  bResult = if ((u32Value and (u32Value - 1)) == 0): orxTRUE else: orxFALSE
  ##  Done!
  return bResult

proc GetNextPowerOfTwo*(u32Value: orxU32): orxU32 {.inline, cdecl.} =
  ##  Gets next power of two of an orxU32
  ##  @param[in]   _u32Value                       Value to process
  ##  @return      If _u32Value is already a power of two, returns it, otherwise the next power of two
  ##
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

proc SmoothStep*(fMin: orxFLOAT; fMax: orxFLOAT; fValue: orxFLOAT): orxFLOAT {.inline,
    cdecl.} =
  ##  Gets smooth stepped value between two extrema
  ##  @param[in]   _fMin                           Minimum value
  ##  @param[in]   _fMax                           Maximum value
  ##  @param[in]   _fValue                         Value to process
  ##  @return      0.0 if _fValue <= _fMin, 1.0 if _fValue >= _fMax, smoothed value between 0.0 & 1.0 otherwise
  ##
  var
    fTemp: orxFLOAT
    fResult: orxFLOAT
  ##  Gets normalized and clamped value
  fTemp = (fValue - fMin) div (fMax - fMin)
  fTemp = orxCLAMP(fTemp, orxFLOAT_0, orxFLOAT_1)
  ##  Gets smoothed result
  fResult = fTemp * fTemp * (orx2F(3.0f) - (orx2F(2.0f) * fTemp))
  ##  Done!
  return fResult

proc SmootherStep*(fMin: orxFLOAT; fMax: orxFLOAT; fValue: orxFLOAT): orxFLOAT {.inline,
    cdecl.} =
  ##  Gets smoother stepped value between two extrema
  ##  @param[in]   _fMin                           Minimum value
  ##  @param[in]   _fMax                           Maximum value
  ##  @param[in]   _fValue                         Value to process
  ##  @return      0.0 if _fValue <= _fMin, 1.0 if _fValue >= _fMax, smooth(er)ed value between 0.0 & 1.0 otherwise
  ##
  var
    fTemp: orxFLOAT
    fResult: orxFLOAT
  ##  Gets normalized and clamped value
  fTemp = (fValue - fMin) div (fMax - fMin)
  fTemp = orxCLAMP(fTemp, orxFLOAT_0, orxFLOAT_1)
  ##  Gets smoothed result
  fResult = fTemp * fTemp * fTemp *
      (fTemp * ((fTemp * orx2F(6.0f)) - orx2F(15.0f)) + orx2F(10.0f))
  ##  Done!
  return fResult

const
  orxMATH_KF_SQRT_2* = orx2F(1.414213562f) ## * Math Definitions **
  ## < Sqrt(2) constant
  orxMATH_KF_EPSILON* = orx2F(0.0001f) ## < Epsilon constant
  orxMATH_KF_TINY_EPSILON* = orx2F(1.0e-037f) ## < Tiny epsilon
  orxMATH_KF_MAX* = orx2F(3.402823466e+38F) ## < Max constant
  orxMATH_KF_2_PI* = orx2F(6.283185307f) ## < 2 PI constant
  orxMATH_KF_PI* = orx2F(3.141592654f) ## < PI constant
  orxMATH_KF_PI_BY_2* = orx2F(1.570796327f) ## < PI / 2 constant
  orxMATH_KF_PI_BY_4* = orx2F(0.785398163f) ## < PI / 4 constant
  orxMATH_KF_DEG_TO_RAD* = orx2F(3.141592654f div 180.0f) ## < Degree to radian conversion constant
  orxMATH_KF_RAD_TO_DEG* = orx2F(180.0f div 3.141592654f) ## < Radian to degree conversion constant

proc Sin*(fOp: orxFLOAT): orxFLOAT {.inline, cdecl.} =
  ## * Trigonometric function **
  ##  Gets a sine
  ##  @param[in]   _fOp                            Input radian angle value
  ##  @return      Sine of the given angle
  ##
  var fResult: orxFLOAT
  ##  Updates result
  fResult = sinf(fOp)
  ##  Done!
  return fResult

proc Cos*(fOp: orxFLOAT): orxFLOAT {.inline, cdecl.} =
  ##  Gets a cosine
  ##  @param[in]   _fOp                            Input radian angle value
  ##  @return      Cosine of the given angle
  ##
  var fResult: orxFLOAT
  ##  Updates result
  fResult = cosf(fOp)
  ##  Done!
  return fResult

proc Tan*(fOp: orxFLOAT): orxFLOAT {.inline, cdecl.} =
  ##  Gets a tangent
  ##  @param[in]   _fOp                            Input radian angle value
  ##  @return      Tangent of the given angle
  ##
  var fResult: orxFLOAT
  ##  Updates result
  fResult = tanf(fOp)
  ##  Done!
  return fResult

proc ACos*(fOp: orxFLOAT): orxFLOAT {.inline, cdecl.} =
  ##  Gets an arccosine
  ##  @param[in]   _fOp                            Input radian angle value
  ##  @return      Arccosine of the given angle
  ##
  var fResult: orxFLOAT
  ##  Updates result
  fResult = acosf(fOp)
  ##  Done!
  return fResult

proc ASin*(fOp: orxFLOAT): orxFLOAT {.inline, cdecl.} =
  ##  Gets an arcsine
  ##  @param[in]   _fOp                            Input radian angle value
  ##  @return      Arcsine of the given angle
  ##
  var fResult: orxFLOAT
  ##  Updates result
  fResult = asinf(fOp)
  ##  Done!
  return fResult

proc ATan*(fOp1: orxFLOAT; fOp2: orxFLOAT): orxFLOAT {.inline, cdecl.} =
  ##  Gets an arctangent
  ##  @param[in]   _fOp1                           First operand
  ##  @param[in]   _fOp2                           Second operand
  ##  @return      Arctangent of the given angle
  ##
  var fResult: orxFLOAT
  ##  Updates result
  fResult = atan2f(fOp1, fOp2)
  ##  Done!
  return fResult

proc Sqrt*(fOp: orxFLOAT): orxFLOAT {.inline, cdecl.} =
  ## * Misc functions **
  ##  Gets a square root
  ##  @param[in]   _fOp                            Input value
  ##  @return      Square root of the given value
  ##
  var fResult: orxFLOAT
  ##  Updates result
  fResult = sqrtf(fOp)
  ##  Done!
  return fResult

proc Floor*(fOp: orxFLOAT): orxFLOAT {.inline, cdecl.} =
  ##  Gets a floored value
  ##  @param[in]   _fOp                            Input value
  ##  @return      Floored value
  ##
  var fResult: orxFLOAT
  ##  Updates result
  fResult = floorf(fOp)
  ##  Done!
  return fResult

proc Ceil*(fOp: orxFLOAT): orxFLOAT {.inline, cdecl.} =
  ##  Gets a ceiled value
  ##  @param[in]   _fOp                            Input value
  ##  @return      Ceiled value
  ##
  var fResult: orxFLOAT
  ##  Updates result
  fResult = ceilf(fOp)
  ##  Done!
  return fResult

proc Round*(fOp: orxFLOAT): orxFLOAT {.inline, cdecl.} =
  ##  Gets a rounded value
  ##  @param[in]   _fOp                            Input value
  ##  @return      Rounded value
  ##
  var fResult: orxFLOAT
  when defined(MSVC):
    ##  Updates result
    fResult = floorf(fOp + orx2F(0.5f))
  else:
    ##  Updates result
    fResult = rintf(fOp)
  ##  Done!
  return fResult

proc Mod*(fOp1: orxFLOAT; fOp2: orxFLOAT): orxFLOAT {.inline, cdecl.} =
  ##  Gets a modulo value
  ##  @param[in]   _fOp1                           Input value
  ##  @param[in]   _fOp2                           Modulo value
  ##  @return      Modulo value
  ##
  var fResult: orxFLOAT
  ##  Updates result
  fResult = fmodf(fOp1, fOp2)
  ##  Done!
  return fResult

proc Pow*(fOp: orxFLOAT; fExp: orxFLOAT): orxFLOAT {.inline, cdecl.} =
  ##  Gets a powed value
  ##  @param[in]   _fOp                            Input value
  ##  @param[in]   _fExp                           Exponent value
  ##  @return      Powed value
  ##
  var fResult: orxFLOAT
  ##  Updates result
  fResult = powf(fOp, fExp)
  ##  Done!
  return fResult

proc Abs*(fOp: orxFLOAT): orxFLOAT {.inline, cdecl.} =
  ##  Gets an absolute value
  ##  @param[in]   _fOp                            Input value
  ##  @return      Absolute value
  ##
  var fResult: orxFLOAT
  ##  Updates result
  fResult = fabsf(fOp)
  ##  Done!
  return fResult