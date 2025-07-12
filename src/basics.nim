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


## @file orx/code/include/display/orxDisplay.h:"#define orx2RGBA(R, G, B, A)":10:1aaa54d3a45275ae7f0b700b1e9faec7
template orx2RGBA*(r, g, b, a: untyped): orxRGBA =
  ## Creates RGBA color value from components  
  result.anon0.anon0.u8R = orxU8(r)
  result.anon0.anon0.u8G = orxU8(g)
  result.anon0.anon0.u8B = orxU8(b)
  result.anon0.anon0.u8A = orxU8(a)

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




## @file orx/code/include/base/orxDecl.h:"#define orxFLAG_TEST(X, F)":15:188929753103752d202743776aee3429
template flagTest*(x, f: untyped): bool =
  ## Tests any flags
  ((x) and (f)) != 0

template flagTestAll*(x, f: untyped): bool =
  ## Tests all flags
  ((x) and (f)) == (f)

template flagGet*(x, m: untyped): untyped =
  ## Gets masked flags
  ((x) and (m))

template flagSet*(x, a, r: untyped): untyped =
  ## Sets/unsets flags
  ((x) or (a)) and (not (r))

template flagSwap*(x, s: untyped): untyped =
  ## Swaps flags
  ((x) xor (s))

template align*(value, blockSize: untyped): untyped =
  ## Memory alignment
  (((value) + (blockSize) - 1) and (not ((blockSize) - 1)))

template arrayGetItemCount*(arr: untyped): int =
  ## Gets array element count
  (sizeof(arr) div sizeof(arr[0]))


## @file orx/code/include/utils/orxTree.h:"/** Gets a node tree":90:005429c555f2327224e897d719506f79
proc getTree*(node: ptr orxTREE_NODE): ptr orxTREE {.inline.} =
  ## Gets node's tree
  if node != nil: node.pstTree else: nil

proc getParent*(node: ptr orxTREE_NODE): ptr orxTREE_NODE {.inline.} =
  ## Gets parent node
  if node != nil and node.pstTree != nil: node.pstParent else: nil

proc getChild*(node: ptr orxTREE_NODE): ptr orxTREE_NODE {.inline.} =
  ## Gets first child node
  if node != nil and node.pstTree != nil: node.pstChild else: nil

proc getSibling*(node: ptr orxTREE_NODE): ptr orxTREE_NODE {.inline.} =
  ## Gets next sibling node
  if node != nil and node.pstTree != nil: node.pstSibling else: nil

proc getPrevious*(node: ptr orxTREE_NODE): ptr orxTREE_NODE {.inline.} =
  ## Gets previous sibling node
  if node != nil and node.pstTree != nil: node.pstPrevious else: nil

proc getRoot*(tree: ptr orxTREE): ptr orxTREE_NODE {.inline.} =
  ## Gets tree root node
  if tree != nil: tree.pstRoot else: nil

proc getCount*(tree: ptr orxTREE): orxU32 {.inline.} =
  ## Gets tree node count
  if tree != nil: tree.u32Count else: 0


## @file orx/code/include/utils/orxLinkList.h:"/** Gets a node list":78:39b5eec5116416ef99a14620fbf1ec5a
proc getList*(node: ptr orxLINKLIST_NODE): ptr orxLINKLIST {.inline.} =
  ## Gets node's list
  if node != nil: node.pstList else: nil

proc getPrevious*(node: ptr orxLINKLIST_NODE): ptr orxLINKLIST_NODE {.inline.} =
  ## Gets previous node
  if node != nil and node.pstList != nil: node.pstPrevious else: nil

proc getNext*(node: ptr orxLINKLIST_NODE): ptr orxLINKLIST_NODE {.inline.} =
  ## Gets next node
  if node != nil and node.pstList != nil: node.pstNext else: nil

proc getFirst*(list: ptr orxLINKLIST): ptr orxLINKLIST_NODE {.inline.} =
  ## Gets first node in list
  if list != nil: list.pstFirst else: nil

proc getLast*(list: ptr orxLINKLIST): ptr orxLINKLIST_NODE {.inline.} =
  ## Gets last node in list
  if list != nil: list.pstLast else: nil

proc getCount*(list: ptr orxLINKLIST): orxU32 {.inline.} =
  ## Gets list node count
  if list != nil: list.u32Count else: 0