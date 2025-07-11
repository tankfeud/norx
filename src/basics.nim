import wrapper
export wrapper

when defined(processAnnotations):
  import annotation

  static: processAnnotations(currentSourcePath())

# Hack to get orxLOG to compile
proc orxLOG*(s: string) =
  echo(s)

## Boolean constants
const
  orxFALSE* = 0.orxBOOL
  orxTRUE* = 1.orxBOOL

converter toFloat32*(x: orxFLOAT): float32 = float32(x)

converter fromFloat32*(x: float32): orxFLOAT = orxFLOAT(x)

converter toBool*(x: orxBOOL): bool = cint(x) != 0
  ## Converts orxBOOL to bool

converter toOrxBOOL*(x: bool): orxBOOL = orxBOOL(if x: 1 else: 0)
  ## Converts bool to orxBOOL

converter toCstring*(x: string): cstring = x.cstring

converter fromCstring*(x: cstring): string = $x


## @file orx/code/include/math/orxMath.h:"/** Lerps between two":18:680b439acca9c9c662595407a702b823

template lerp*(a, b, t: untyped): untyped =
  ## Lerps between two values given a coefficient t [0, 1]
  ## For t = 1 the result is b and for t = 0 the result is a.
  a + (t * (b - a))

template remap*(A1, B1, A2, B2, V: untyped): untyped =
  ##  Remaps a value from one interval to another one
  ##  @param[in]   A1                              First interval's low boundary
  ##  @param[in]   B1                              First interval's high boundary
  ##  @param[in]   A2                              Second interval's low boundary
  ##  @param[in]   B2                              Second interval's high boundary
  ##  @param[in]   V                               Value to remap from the first interval to the second one
  ##  @return      Remaped value
  (((V) - (A1)) / ((B1) - (A1)) * ((B2) - (A2)) + (A2))

## Math constants
## @file orx/code/include/math/orxMath.h:"/*** Math Definitions ***/":14:bde650962dd25e8c65265ee07a174eb5
const
  PI* = 3.141592654'f32
  PI2* = 6.283185307'f32           # 2 * PI
  PI_BY_2* = 1.570796327'f32       # PI / 2
  PI_BY_4* = 0.785398163'f32       # PI / 4
  SQRT_2* = 1.414213562'f32        # Sqrt(2)
  EPSILON* = 0.0001'f32            # Epsilon constant
  TINY_EPSILON* = 1.0e-037'f32     # Tiny epsilon
  DEG_TO_RAD* = 0.017453293'f32    # PI / 180
  RAD_TO_DEG* = 57.29577951'f32    # 180 / PI