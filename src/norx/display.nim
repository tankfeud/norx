import
  incl, vector, OBox, bank, memory, hashTable, linkList

## Misc defines

type
  #INNER_C_STRUCT_orxDisplay_68* {.bycopy.} = object
  #  u8R*: orxU8
  #  u8G*: orxU8
  #  u8B*: orxU8
  #  u8A*: orxU8
  #
  #INNER_C_UNION_orxDisplay_66* {.bycopy, union.} = object
  #  ano_orxDisplay_69*: INNER_C_STRUCT_orxDisplay_68
  #  u32RGBA*: orxU32

  # TODO: Skipped union member u32RGBA*: orxU32 for now
  orxRGBA* {.bycopy.} = object
    u8R*: orxU8
    u8G*: orxU8
    u8B*: orxU8
    u8A*: orxU8

template orx2RGBA*(R, G, B, A: untyped): untyped =
  orxRGBA_Set((orxU8)(R), (orxU8)(G), (orxU8)(B), (orxU8)(A))

template orxRGBA_R*(RGBA: untyped): untyped =
  RGBA.u8R

template orxRGBA_G*(RGBA: untyped): untyped =
  RGBA.u8G

template orxRGBA_B*(RGBA: untyped): untyped =
  RGBA.u8B

template orxRGBA_A*(RGBA: untyped): untyped =
  RGBA.u8A

const orxCOLOR_NORMALIZER* = (orx2F(1.0 / 255.0))
const
  orxCOLOR_DENORMALIZER* = (orx2F(255.0))

type orxBITMAP* = object


type
  orxDISPLAY_VERTEX* {.bycopy.} = object
    ## Vertex info structure
    fX*: orxFLOAT
    fY*: orxFLOAT
    fU*: orxFLOAT
    fV*: orxFLOAT
    stRGBA*: orxRGBA

type
  orxDISPLAY_TRANSFORM* {.bycopy.} = object
    ## Transform structure
    fSrcX*: orxFLOAT
    fSrcY*: orxFLOAT
    fDstX*: orxFLOAT
    fDstY*: orxFLOAT
    fRepeatX*: orxFLOAT
    fRepeatY*: orxFLOAT
    fScaleX*: orxFLOAT
    fScaleY*: orxFLOAT
    fRotation*: orxFLOAT

type
  orxDISPLAY_PRIMITIVE* {.size: sizeof(cint).} = enum
    ## Primitive enum
    orxDISPLAY_PRIMITIVE_POINTS = 0, orxDISPLAY_PRIMITIVE_LINES,
    orxDISPLAY_PRIMITIVE_LINE_LOOP, orxDISPLAY_PRIMITIVE_LINE_STRIP,
    orxDISPLAY_PRIMITIVE_TRIANGLES, orxDISPLAY_PRIMITIVE_TRIANGLE_STRIP,
    orxDISPLAY_PRIMITIVE_TRIANGLE_FAN, orxDISPLAY_PRIMITIVE_NUMBER,
    orxDISPLAY_PRIMITIVE_NONE = orxENUM_NONE


## * Mesh structure
##

type
  orxDISPLAY_MESH* {.bycopy.} = object
    astVertexList*: ptr orxDISPLAY_VERTEX
    au16IndexList*: ptr orxU16
    u32VertexNumber*: orxU32
    u32IndexNumber*: orxU32
    ePrimitive*: orxDISPLAY_PRIMITIVE


## * Video mode structure
##

type
  orxDISPLAY_VIDEO_MODE* {.bycopy.} = object
    u32Width*: orxU32
    u32Height*: orxU32
    u32Depth*: orxU32
    u32RefreshRate*: orxU32
    bFullScreen*: orxBOOL


## * Character glyph structure
##

type
  orxCHARACTER_GLYPH* {.bycopy.} = object
    fX*: orxFLOAT
    fY*: orxFLOAT
    fWidth*: orxFLOAT


## * Character map structure
##

type
  orxCHARACTER_MAP* {.bycopy.} = object
    fCharacterHeight*: orxFLOAT
    pstCharacterBank*: ptr orxBANK
    pstCharacterTable*: ptr orxHASHTABLE


## * Bitmap smoothing enum
##

type
  orxDISPLAY_SMOOTHING* {.size: sizeof(cint).} = enum
    orxDISPLAY_SMOOTHING_DEFAULT = 0, orxDISPLAY_SMOOTHING_ON,
    orxDISPLAY_SMOOTHING_OFF, orxDISPLAY_SMOOTHING_NUMBER,
    orxDISPLAY_SMOOTHING_NONE = orxENUM_NONE


## * Bitmap blend enum
##

type
  orxDISPLAY_BLEND_MODE* {.size: sizeof(cint).} = enum
    orxDISPLAY_BLEND_MODE_ALPHA = 0, orxDISPLAY_BLEND_MODE_MULTIPLY,
    orxDISPLAY_BLEND_MODE_ADD, orxDISPLAY_BLEND_MODE_PREMUL,
    orxDISPLAY_BLEND_MODE_NUMBER, orxDISPLAY_BLEND_MODE_NONE = orxENUM_NONE


## * Color structure
##

type
  orxCOLOR* {.bycopy.} = tuple[vRGB: orxRGBVECTOR, fAlpha: orxFLOAT]
  orxHSLCOLOR* {.bycopy.} = tuple[vHSL: orxHSLVECTOR, fAlpha: orxFLOAT]
  orxHSVCOLOR* {.bycopy.} = tuple[vHSV: orxHSVVECTOR, fAlpha: orxFLOAT]

## * Config parameters
##

const
  orxDISPLAY_KZ_CONFIG_SECTION* = "Display"
  orxDISPLAY_KZ_CONFIG_WIDTH* = "ScreenWidth"
  orxDISPLAY_KZ_CONFIG_HEIGHT* = "ScreenHeight"
  orxDISPLAY_KZ_CONFIG_DEPTH* = "ScreenDepth"
  orxDISPLAY_KZ_CONFIG_POSITION* = "ScreenPosition"
  orxDISPLAY_KZ_CONFIG_REFRESH_RATE* = "RefreshRate"
  orxDISPLAY_KZ_CONFIG_FULLSCREEN* = "FullScreen"
  orxDISPLAY_KZ_CONFIG_ALLOW_RESIZE* = "AllowResize"
  orxDISPLAY_KZ_CONFIG_DECORATION* = "Decoration"
  orxDISPLAY_KZ_CONFIG_TITLE* = "Title"
  orxDISPLAY_KZ_CONFIG_SMOOTH* = "Smoothing"
  orxDISPLAY_KZ_CONFIG_VSYNC* = "VSync"
  orxDISPLAY_KZ_CONFIG_DEPTHBUFFER* = "DepthBuffer"
  orxDISPLAY_KZ_CONFIG_SHADER_VERSION* = "ShaderVersion"
  orxDISPLAY_KZ_CONFIG_SHADER_EXTENSION_LIST* = "ShaderExtensionList"
  orxDISPLAY_KZ_CONFIG_MONITOR* = "Monitor"
  orxDISPLAY_KZ_CONFIG_CURSOR* = "Cursor"
  orxDISPLAY_KZ_CONFIG_ICON_LIST* = "IconList"
  orxDISPLAY_KZ_CONFIG_FRAMEBUFFER_SIZE* = "FramebufferSize"
  orxDISPLAY_KZ_CONFIG_TEXTURE_UNIT_NUMBER* = "TextureUnitNumber"
  orxDISPLAY_KZ_CONFIG_DRAW_BUFFER_NUMBER* = "DrawBufferNumber"
  orxCOLOR_KZ_CONFIG_SECTION* = "Color"

## * Shader texture suffixes
##

const
  orxDISPLAY_KZ_SHADER_SUFFIX_TOP* = "_top"
  orxDISPLAY_KZ_SHADER_SUFFIX_LEFT* = "_left"
  orxDISPLAY_KZ_SHADER_SUFFIX_BOTTOM* = "_bottom"
  orxDISPLAY_KZ_SHADER_SUFFIX_RIGHT* = "_right"

## * Shader extension actions
##

const
  orxDISPLAY_KC_SHADER_EXTENSION_ADD* = '+'
  orxDISPLAY_KC_SHADER_EXTENSION_REMOVE* = '-'

## * Event enum
##

type
  orxDISPLAY_EVENT* {.size: sizeof(cint).} = enum
    orxDISPLAY_EVENT_SET_VIDEO_MODE = 0, orxDISPLAY_EVENT_LOAD_BITMAP,
    orxDISPLAY_EVENT_NUMBER, orxDISPLAY_EVENT_NONE = orxENUM_NONE


## * Display event payload
##

type
  INNER_C_STRUCT_orxDisplay_284* {.bycopy.} = object
    u32Width*: orxU32          ## Screen width : 4
    u32Height*: orxU32         ## Screen height : 8
    u32Depth*: orxU32          ## Screen depth : 12
    u32RefreshRate*: orxU32    ## Refresh rate: 16
    u32PreviousWidth*: orxU32  ## Previous screen width : 20
    u32PreviousHeight*: orxU32 ## Previous screen height : 24
    u32PreviousDepth*: orxU32  ## Previous screen depth : 28
    u32PreviousRefreshRate*: orxU32 ## Previous refresh rate : 32
    bFullScreen*: orxBOOL      ## FullScreen? : 36

  INNER_C_STRUCT_orxDisplay_298* {.bycopy.} = object
    zLocation*: cstring     ## File location : 40
    stFilenameID*: orxSTRINGID ## File name ID : 44
    u32ID*: orxU32             ## Bitmap (hardware texture) ID : 48

  INNER_C_UNION_orxDisplay_282* {.bycopy, union.} = object
    stVideoMode*: INNER_C_STRUCT_orxDisplay_284
    stBitmap*: INNER_C_STRUCT_orxDisplay_298

  orxDISPLAY_EVENT_PAYLOAD* {.bycopy.} = object
    ano_orxDisplay_303*: INNER_C_UNION_orxDisplay_282


## **************************************************************************
##  Functions directly implemented by orx core
## *************************************************************************

proc displaySetup*() {.cdecl, importc: "orxDisplay_Setup", dynlib: libORX.}
  ## Display module setup

## * Sets all components of an orxRGBA
##  @param[in]   _u8R            Red value to set
##  @param[in]   _u8G            Green value to set
##  @param[in]   _u8B            Blue value to set
##  @param[in]   _u8A            Alpha value to set
##  @return      orxRGBA
##

proc orxRGBA_Set*(u8R: orxU8; u8G: orxU8; u8B: orxU8; u8A: orxU8): orxRGBA {.inline, cdecl.} =
  var stResult: orxRGBA
  ##  Updates result
  stResult.u8R = u8R
  stResult.u8G = u8G
  stResult.u8B = u8B
  stResult.u8A = u8A
  ##  Done!
  return stResult

proc setRGBA*(pstColor: ptr orxCOLOR; stRGBA: orxRGBA) {.inline,
    cdecl.} =
  ## Sets all components from an orxRGBA
  ##  @param[in]   _pstColor       Concerned color
  ##  @param[in]   _stRGBA         RGBA values to set
  ##  @return      orxCOLOR
  ##  Checks
  assert(pstColor != nil)
  ##  Stores RGB
  #let v: orxVECTOR = cast[orxVECTOR](pstColor.vRGB)
  pstColor.vRGB.fR = orxCOLOR_NORMALIZER * orxRGBA_R(stRGBA).orxFLOAT
  pstColor.vRGB.fG = orxCOLOR_NORMALIZER * orxRGBA_G(stRGBA).orxFLOAT
  pstColor.vRGB.fB = orxCOLOR_NORMALIZER * orxRGBA_B(stRGBA).orxFLOAT
  #set(unsafeaddr(v),
  #              orxCOLOR_NORMALIZER * orxRGBA_R(stRGBA).orxFLOAT,
  #              orxCOLOR_NORMALIZER * orxRGBA_G(stRGBA).orxFLOAT,
  #              orxCOLOR_NORMALIZER * orxRGBA_B(stRGBA).orxFLOAT)
  ##  Stores alpha
  pstColor.fAlpha = orxCOLOR_NORMALIZER * orxRGBA_A(stRGBA).orxFLOAT

proc set*(pstColor: ptr orxCOLOR; pvRGB: ptr orxVECTOR; fAlpha: orxFLOAT) {.
    inline, cdecl.} =
  ## Sets all components
  ##  @param[in]   _pstColor       Concerned color
  ##  @param[in]   _pvRGB          RGB components
  ##  @param[in]   _fAlpha         Normalized alpha component
  assert(pstColor != nil)
  assert(pvRGB != nil)
  ##  Stores RGB
  pstColor.vRGB = cast[orxRGBVECTOR](pvRGB[])
  ##  Stores alpha
  pstColor.fAlpha = fAlpha

proc setRGB*(pstColor: ptr orxCOLOR; pvRGB: ptr orxVECTOR) {.
    inline, cdecl.} =
  ## Sets RGB components
  ##  @param[in]   _pstColor       Concerned color
  ##  @param[in]   _pvRGB          RGB components
  ##  Checks
  assert(pstColor != nil)
  assert(pvRGB != nil)
  ##  Stores RGB
  pstColor.vRGB = cast[orxRGBVECTOR](pvRGB[])

proc setAlpha*(pstColor: ptr orxCOLOR; fAlpha: orxFLOAT) {.
    inline, cdecl.} =
  ## Sets alpha component
  ##  @param[in]   _pstColor       Concerned color
  ##  @param[in]   _fAlpha         Normalized alpha component
  ##  Checks
  assert(pstColor != nil)
  ##  Stores it
  pstColor.fAlpha = fAlpha

proc toRGBA*(pstColor: ptr orxCOLOR): orxRGBA {.inline, cdecl.} =
  ## Gets orxRGBA from an orxCOLOR
  ##  @param[in]   _pstColor       Concerned color
  ##  @return      orxRGBA
  var vColor: orxVECTOR
  var fAlpha: orxFLOAT
  ##  Checks
  assert(pstColor != nil)
  ##  Clamps RGB components
  let v: orxVECTOR = cast[orxVECTOR](pstColor.vRGB)
  clamp(addr(vColor), unsafeaddr(v), addr(orxVECTOR_BLACK),
                  addr(orxVECTOR_WHITE))
  ##  De-normalizes vector
  mulf(addr(vColor), addr(vColor), orxCOLOR_DENORMALIZER)
  ##  Clamps alpha
  fAlpha = clamp(pstColor.fAlpha, orxFLOAT_0, orxFLOAT_1)
  ##  Updates result
  return orx2RGBA(vColor.fX.orxU32, vColor.fY.orxU32, vColor.fZ.orxU32, (orxCOLOR_DENORMALIZER * fAlpha).orxU32)

proc copy*(pstDst: ptr orxCOLOR; pstSrc: ptr orxCOLOR): ptr orxCOLOR {.inline,
    cdecl.} =
  ## Copies an orxCOLOR into another one
  ##  @param[in]   _pstDst         Destination color
  ##  @param[in]   _pstSrc         Source color
  ##  @return      orxCOLOR
  ##  Checks
  assert(pstDst != nil)
  assert(pstSrc != nil)
  ##  Copies it
  copy(pstDst, pstSrc, sizeof((orxCOLOR)).orxU32)
  ##  Done!
  return pstDst

proc fromRGBToHSL*(pstDst: ptr orxCOLOR; pstSrc: ptr orxCOLOR): ptr orxCOLOR {.
    cdecl.} =
  ## Converts from RGB color space to HSL one
  ##  @param[in]   _pstDst         Destination color
  ##  @param[in]   _pstSrc         Source color
  ##  @return      orxCOLOR
  var pstResult: ptr orxHSLCOLOR
  var
    fMin: orxFLOAT
    fMax: orxFLOAT
    fDelta: orxFLOAT
    fR: orxFLOAT
    fG: orxFLOAT
    fB: orxFLOAT
  ##  Checks
  assert(pstDst != nil)
  assert(pstSrc != nil)
  ##  Gets source red, blue and green components
  fR = pstSrc.vRGB.fR
  fG = pstSrc.vRGB.fG
  fB = pstSrc.vRGB.fB
  ##  Gets min, max & delta values
  fMin = min(fR, min(fG, fB))
  fMax = max(fR, max(fG, fB))
  fDelta = fMax - fMin
  ##  Stores lightness
  pstResult.vHSL.fL = orx2F(0.5) * (fMax + fMin)
  ##  Gray?
  if fDelta == orxFLOAT_0:
    ##  Gets hue & saturation
    pstResult.vHSL.fH = orxFLOAT_0
    pstResult.vHSL.fS = orxFLOAT_0
  else:
    ##  Updates saturation
    pstResult.vHSL.fS = if (pstResult.vHSL.fL < orx2F(0.5)): fDelta /
        (fMax + fMin) else: fDelta / (orx2F(2.0) - fMax - fMin)
    ##  Red tone?
    if fR == fMax:
      ##  Updates hue
      pstResult.vHSL.fH = orx2F(1.0 / 6.0) * (fG - fB) / fDelta
    elif fG == fMax:             ##  Blue tone
      ##  Updates hue
      pstResult.vHSL.fH = orx2F(1.0 / 3.0) +
          (orx2F(1.0 / 6.0) * (fB - fR) / fDelta)
    else:
      ##  Updates hue
      pstResult.vHSL.fH = orx2F(2.0 / 3.0) +
          (orx2F(1.0 / 6.0) * (fR - fG) / fDelta)
    ##  Clamps hue
    if pstResult.vHSL.fH < orxFLOAT_0:
      pstResult.vHSL.fH += orxFLOAT_1
    elif pstResult.vHSL.fH > orxFLOAT_1:
      pstResult.vHSL.fH -= orxFLOAT_1
  ##  Updates alpha
  pstResult.fAlpha = pstSrc.fAlpha
  ##  Done!
  return cast[ptr orxCOLOR](pstResult)

proc fromHSLToRGB*(pstDst: ptr orxCOLOR; pstSrc: ptr orxCOLOR): ptr orxCOLOR {.
    cdecl.} =
  ## Converts from HSL color space to RGB one
  ##  @param[in]   _pstDst         Destination color
  ##  @param[in]   _pstSrc         Source color
  ##  @return      orxCOLOR
  # TODO: Fix these too!
  #[
  var pstResult: ptr orxCOLOR
  var
    fH: orxFLOAT
    fS: orxFLOAT
    fL: orxFLOAT
  template orxCOLOR_GET_RGB_COMPONENT(RESULT, ALT, CHROMA, HUE: untyped): void =
    while true:
      if HUE < orx2F(1.0 / 6.0):
        RESULT = ALT + (orx2F(6.0) * HUE * (CHROMA - ALT))
      elif HUE < orx2F(1.0 / 2.0):
        RESULT = CHROMA
      elif HUE < orx2F(2.0 / 3.0):
        RESULT = ALT + (orx2F(6.0) * (CHROMA - ALT) * (orx2F(2.0 / 3.0) - HUE))
      else:
        RESULT = ALT
      if RESULT < orxMATH_KF_EPSILON:
        RESULT = orxFLOAT_0
      elif RESULT > orxFLOAT_1 - orxMATH_KF_EPSILON:
        RESULT = orxFLOAT_1
      if not orxFALSE:
        break

  ##  Checks
  assert(pstDst != nil)
  assert(pstSrc != nil)
  ##  Gets source hue, saturation and lightness components
  fH = pstSrc.vRGB.fR
  fS = pstSrc.vRGB.fG
  fL = pstSrc.vRGB.fB
  ##  Gray?
  if fS == orxFLOAT_0:
    ##  Updates result
    orxVector_SetAll(addr((pstResult.vRGB)), fL)
  else:
    var
      fChroma: orxFLOAT
      fIntermediate: orxFLOAT
    ##  Gets chroma
    fChroma = if (fL < orx2F(0.5)): fL + (fL * fS) else: fL + fS - (fL * fS)
    ##  Gets intermediate value
    fIntermediate = (orx2F(2.0) * fL) - fChroma
    ##  Gets RGB components
    if fH > orx2F(2.0 / 3.0):
      orxCOLOR_GET_RGB_COMPONENT(pstResult.vRGB.fR, fIntermediate, fChroma,
                                 (fH - orx2F(2.0 / 3.0)))
    else:
      orxCOLOR_GET_RGB_COMPONENT(pstResult.vRGB.fR, fIntermediate, fChroma,
                                 (fH + orx2F(1.0 / 3.0)))
    orxCOLOR_GET_RGB_COMPONENT(pstResult.vRGB.fG, fIntermediate, fChroma, fH)
    if fH < orx2F(1.0 / 3.0):
      orxCOLOR_GET_RGB_COMPONENT(pstResult.vRGB.fB, fIntermediate, fChroma,
                                 (fH + orx2F(2.0 / 3.0)))
    else:
      orxCOLOR_GET_RGB_COMPONENT(pstResult.vRGB.fB, fIntermediate, fChroma,
                                 (fH - orx2F(1.0 / 3.0)))
  ##  Updates alpha
  pstResult.fAlpha = pstSrc.fAlpha
  ##  Done!
  return pstResult

proc fromRGBToHSV*(pstDst: ptr orxCOLOR; pstSrc: ptr orxCOLOR): ptr orxCOLOR {.
    cdecl.} =
  ## Converts from RGB color space to HSV one
  ##  @param[in]   _pstDst         Destination color
  ##  @param[in]   _pstSrc         Source color
  ##  @return      orxCOLOR
  var pstResult: ptr orxCOLOR
  var
    fMin: orxFLOAT
    fMax: orxFLOAT
    fDelta: orxFLOAT
    fR: orxFLOAT
    fG: orxFLOAT
    fB: orxFLOAT
  ##  Checks
  assert(pstDst != nil)
  assert(pstSrc != nil)
  ##  Gets source red, blue and green components
  fR = pstSrc.vRGB.fR
  fG = pstSrc.vRGB.fG
  fB = pstSrc.vRGB.fB
  ##  Gets min, max & delta values
  fMin = orxMIN(fR, orxMIN(fG, fB))
  fMax = orxMAX(fR, orxMAX(fG, fB))
  fDelta = fMax - fMin
  ##  Stores value
  pstResult.vHSL.fV = fMax
  ##  Gray?
  if fDelta == orxFLOAT_0:
    ##  Gets hue & saturation
    pstResult.vHSL.fH = orxFLOAT_0
    pstResult.vHSL.fS = orxFLOAT_0
  else:
    ##  Updates saturation
    pstResult.vHSL.fS = fDelta / fMax
    ##  Red tone?
    if fR == fMax:
      ##  Updates hue
      pstResult.vHSL.fH = orx2F(1.0 / 6.0) * (fG - fB) / fDelta
    elif fG == fMax:             ##  Blue tone
      ##  Updates hue
      pstResult.vHSL.fH = orx2F(1.0 / 3.0) +
          (orx2F(1.0 / 6.0) * (fB - fR) / fDelta)
    else:
      ##  Updates hue
      pstResult.vHSL.fH = orx2F(2.0 / 3.0) +
          (orx2F(1.0 / 6.0) * (fR - fG) / fDelta)
    ##  Clamps hue
    if pstResult.vHSL.fH < orxFLOAT_0:
      inc(pstResult.vHSL.fH, orxFLOAT_1)
    elif pstResult.vHSL.fH > orxFLOAT_1:
      dec(pstResult.vHSL.fH, orxFLOAT_1)
  ##  Updates alpha
  pstResult.fAlpha = pstSrc.fAlpha
  ##  Done!
  return pstResult
]#

proc fromHSVToRGB*(pstDst: ptr orxCOLOR; pstSrc: ptr orxCOLOR): ptr orxCOLOR {.
    cdecl.} =
  ## Converts from HSV color space to RGB one
  ##  @param[in]   _pstDst         Destination color
  ##  @param[in]   _pstSrc         Source color
  ##  @return      orxCOLOR
  discard

proc getBlendModeFromString*(zBlendMode: cstring): orxDISPLAY_BLEND_MODE {.
    cdecl, importc: "orxDisplay_GetBlendModeFromString", dynlib: libORX.}
  ## Gets blend mode from a string
  ##  @param[in]    _zBlendMode                          String to evaluate
  ##  @return orxDISPLAY_BLEND_MODE

proc displayInit*(): orxSTATUS {.cdecl, importc: "orxDisplay_Init",
                                  dynlib: libORX.}
  ## **************************************************************************
  ##  Functions extended by plugins
  ## *************************************************************************
  ## Inits the display module
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc displayExit*() {.cdecl, importc: "orxDisplay_Exit", dynlib: libORX.}
  ## Exits from the display module

proc swap*(): orxSTATUS {.cdecl, importc: "orxDisplay_Swap",
                                  dynlib: libORX.}
  ## Swaps/flips bufers (display on screen the current frame)
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getScreenBitmap*(): ptr orxBITMAP {.cdecl,
    importc: "orxDisplay_GetScreenBitmap", dynlib: libORX.}
  ## Gets screen bitmap
  ##  @return orxBITMAP / nil

proc getScreenSize*(pfWidth: ptr orxFLOAT; pfHeight: ptr orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxDisplay_GetScreenSize", dynlib: libORX.}
  ## Gets screen size
  ##  @param[out]   _pfWidth                             Screen width
  ##  @param[out]   _pfHeight                            Screen height
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc createBitmap*(u32Width: orxU32; u32Height: orxU32): ptr orxBITMAP {.
    cdecl, importc: "orxDisplay_CreateBitmap", dynlib: libORX.}
  ## Creates a bitmap
  ##  @param[in]   _u32Width                             Bitmap width
  ##  @param[in]   _u32Height                            Bitmap height
  ##  @return orxBITMAP / nil

proc deleteBitmap*(pstBitmap: ptr orxBITMAP) {.cdecl,
    importc: "orxDisplay_DeleteBitmap", dynlib: libORX.}
  ## Deletes a bitmap
  ##  @param[in]   _pstBitmap                            Concerned bitmap

proc loadBitmap*(zFileName: cstring): ptr orxBITMAP {.cdecl,
    importc: "orxDisplay_LoadBitmap", dynlib: libORX.}
  ## Loads a bitmap from file (an event of ID orxDISPLAY_EVENT_BITMAP_LOAD will be sent upon completion, whether the loading is asynchronous or not)
  ##  @param[in]   _zFileName                            Name of the file to load
  ##  @return orxBITMAP * / nil

proc saveBitmap*(pstBitmap: ptr orxBITMAP; zFileName: cstring): orxSTATUS {.
    cdecl, importc: "orxDisplay_SaveBitmap", dynlib: libORX.}
  ## Saves a bitmap to file
  ##  @param[in]   _pstBitmap                            Concerned bitmap
  ##  @param[in]   _zFileName                            Name of the file where to store the bitmap
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setTempBitmap*(pstBitmap: ptr orxBITMAP): orxSTATUS {.cdecl,
    importc: "orxDisplay_SetTempBitmap", dynlib: libORX.}
  ## Sets temp bitmap, if a valid temp bitmap is given, load operations will be asynchronous
  ##  @param[in]   _pstBitmap                            Concerned bitmap, nil for forcing synchronous load operations
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getTempBitmap*(): ptr orxBITMAP {.cdecl,
    importc: "orxDisplay_GetTempBitmap", dynlib: libORX.}
  ## Gets current temp bitmap
  ##  @return orxBITMAP, if non-null, load operations are currently asynchronous, otherwise they're synchronous

proc setDestinationBitmaps*(apstBitmapList: ptr ptr orxBITMAP;
                                      u32Number: orxU32): orxSTATUS {.cdecl,
    importc: "orxDisplay_SetDestinationBitmaps", dynlib: libORX.}
  ## Sets destination bitmaps
  ##  @param[in]   _apstBitmapList                       Destination bitmap list
  ##  @param[in]   _u32Number                            Number of destination bitmaps
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc clearBitmap*(pstBitmap: ptr orxBITMAP; stColor: orxRGBA): orxSTATUS {.
    cdecl, importc: "orxDisplay_ClearBitmap", dynlib: libORX.}
  ## Clears a bitmap
  ##  @param[in]   _pstBitmap                            Concerned bitmap, if nil all the current destination bitmaps will be cleared instead
  ##  @param[in]   _stColor                              Color to clear the bitmap with
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setBlendMode*(eBlendMode: orxDISPLAY_BLEND_MODE): orxSTATUS {.cdecl,
    importc: "orxDisplay_SetBlendMode", dynlib: libORX.}
  ## Sets current blend mode
  ##  @param[in]   _eBlendMode                           Blend mode to set
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setBitmapClipping*(pstBitmap: ptr orxBITMAP; u32TLX: orxU32;
                                  u32TLY: orxU32; u32BRX: orxU32; u32BRY: orxU32): orxSTATUS {.
    cdecl, importc: "orxDisplay_SetBitmapClipping", dynlib: libORX.}
  ## Sets a bitmap clipping for blitting (both as source and destination)
  ##  @param[in]   _pstBitmap                            Concerned bitmap, nil to target the first destination bitmap
  ##  @param[in]   _u32TLX                               Top left X coord in pixels
  ##  @param[in]   _u32TLY                               Top left Y coord in pixels
  ##  @param[in]   _u32BRX                               Bottom right X coord in pixels
  ##  @param[in]   _u32BRY                               Bottom right Y coord in pixels
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setBitmapData*(pstBitmap: ptr orxBITMAP; au8Data: ptr orxU8;
                              u32ByteNumber: orxU32): orxSTATUS {.cdecl,
    importc: "orxDisplay_SetBitmapData", dynlib: libORX.}
  ## Sets a bitmap data (RGBA memory format)
  ##  @param[in]   _pstBitmap                            Concerned bitmap
  ##  @param[in]   _au8Data                              Data (4 channels, RGBA)
  ##  @param[in]   _u32ByteNumber                        Number of bytes
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getBitmapData*(pstBitmap: ptr orxBITMAP; au8Data: ptr orxU8;
                              u32ByteNumber: orxU32): orxSTATUS {.cdecl,
    importc: "orxDisplay_GetBitmapData", dynlib: libORX.}
  ## Gets a bitmap data (RGBA memory format)
  ##  @param[in]   _pstBitmap                            Concerned bitmap
  ##  @param[in]   _au8Data                              Output buffer (4 channels, RGBA)
  ##  @param[in]   _u32ByteNumber                        Number of bytes of the buffer
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setPartialBitmapData*(pstBitmap: ptr orxBITMAP; au8Data: ptr orxU8;
                                     u32X: orxU32; u32Y: orxU32; u32Width: orxU32;
                                     u32Height: orxU32): orxSTATUS {.cdecl,
    importc: "orxDisplay_SetPartialBitmapData", dynlib: libORX.}
  ## Sets a partial (rectangle) bitmap data (RGBA memory format)
  ##  @param[in]   _pstBitmap                            Concerned bitmap
  ##  @param[in]   _au8Data                              Data (4 channels, RGBA)
  ##  @param[in]   _u32X                                 Origin's X coord of the rectangle area to set
  ##  @param[in]   _u32Y                                 Origin's Y coord of the rectangle area to set
  ##  @param[in]   _u32Width                             Width of the rectangle area to set
  ##  @param[in]   _u32Height                            Height of the rectangle area to set
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getBitmapSize*(pstBitmap: ptr orxBITMAP; pfWidth: ptr orxFLOAT;
                              pfHeight: ptr orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxDisplay_GetBitmapSize", dynlib: libORX.}
  ## Gets a bitmap size
  ##  @param[in]   _pstBitmap                            Concerned bitmap
  ##  @param[out]  _pfWidth                              Bitmap width
  ##  @param[out]  _pfHeight                             Bitmap height
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getBitmapID*(pstBitmap: ptr orxBITMAP): orxU32 {.cdecl,
    importc: "orxDisplay_GetBitmapID", dynlib: libORX.}
  ## Gets a bitmap (internal) ID
  ##  @param[in]   _pstBitmap                            Concerned bitmap
  ##  @return orxU32

proc transformBitmap*(pstSrc: ptr orxBITMAP;
                                pstTransform: ptr orxDISPLAY_TRANSFORM;
                                stColor: orxRGBA;
                                eSmoothing: orxDISPLAY_SMOOTHING;
                                eBlendMode: orxDISPLAY_BLEND_MODE): orxSTATUS {.
    cdecl, importc: "orxDisplay_TransformBitmap", dynlib: libORX.}
  ## Transforms (and blits onto another) a bitmap
  ##  @param[in]   _pstSrc                               Bitmap to transform and draw
  ##  @param[in]   _pstTransform                         Transformation info (position, scale, rotation, ...)
  ##  @param[in]   _stColor                              Color
  ##  @param[in]   _eSmoothing                           Bitmap smoothing type
  ##  @param[in]   _eBlendMode                           Blend mode
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc transformText*(zString: cstring; pstFont: ptr orxBITMAP;
                              pstMap: ptr orxCHARACTER_MAP;
                              pstTransform: ptr orxDISPLAY_TRANSFORM;
                              stColor: orxRGBA; eSmoothing: orxDISPLAY_SMOOTHING;
                              eBlendMode: orxDISPLAY_BLEND_MODE): orxSTATUS {.
    cdecl, importc: "orxDisplay_TransformText", dynlib: libORX.}
  ## Transforms a text (onto a bitmap)
  ##  @param[in]   _zString                              String to display
  ##  @param[in]   _pstFont                              Font bitmap
  ##  @param[in]   _pstMap                               Character map
  ##  @param[in]   _pstTransform                         Transformation info (position, scale, rotation, ...)
  ##  @param[in]   _stColor                              Color
  ##  @param[in]   _eSmoothing                           Bitmap smoothing type
  ##  @param[in]   _eBlendMode                           Blend mode
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc drawLine*(pvStart: ptr orxVECTOR; pvEnd: ptr orxVECTOR;
                         stColor: orxRGBA): orxSTATUS {.cdecl,
    importc: "orxDisplay_DrawLine", dynlib: libORX.}
  ## Draws a line
  ##  @param[in]   _pvStart                              Start point
  ##  @param[in]   _pvEnd                                End point
  ##  @param[in]   _stColor                              Color
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc drawPolyline*(avVertexList: ptr orxVECTOR; u32VertexNumber: orxU32;
                             stColor: orxRGBA): orxSTATUS {.cdecl,
    importc: "orxDisplay_DrawPolyline", dynlib: libORX.}
  ## Draws a polyline (aka open polygon)
  ##  @param[in]   _avVertexList                         List of vertices
  ##  @param[in]   _u32VertexNumber                      Number of vertices in the list
  ##  @param[in]   _stColor                              Color
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc drawPolygon*(avVertexList: ptr orxVECTOR; u32VertexNumber: orxU32;
                            stColor: orxRGBA; bFill: orxBOOL): orxSTATUS {.cdecl,
    importc: "orxDisplay_DrawPolygon", dynlib: libORX.}
  ## Draws a (closed) polygon; filled polygons *need* to be either convex or star-shaped concave with the first vertex part of the polygon's kernel
  ##  @param[in]   _avVertexList                         List of vertices
  ##  @param[in]   _u32VertexNumber                      Number of vertices in the list
  ##  @param[in]   _stColor                              Color
  ##  @param[in]   _bFill                                If true, the polygon will be filled otherwise only its outline will be drawn
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc drawCircle*(pvCenter: ptr orxVECTOR; fRadius: orxFLOAT;
                           stColor: orxRGBA; bFill: orxBOOL): orxSTATUS {.cdecl,
    importc: "orxDisplay_DrawCircle", dynlib: libORX.}
  ## Draws a circle
  ##  @param[in]   _pvCenter                             Center
  ##  @param[in]   _fRadius                              Radius
  ##  @param[in]   _stColor                              Color
  ##  @param[in]   _bFill                                If true, the polygon will be filled otherwise only its outline will be drawn
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc drawOBox*(pstBox: ptr orxOBOX; stColor: orxRGBA; bFill: orxBOOL): orxSTATUS {.
    cdecl, importc: "orxDisplay_DrawOBox", dynlib: libORX.}
  ## Draws an oriented box
  ##  @param[in]   _pstBox                               Box to draw
  ##  @param[in]   _stColor                              Color
  ##  @param[in]   _bFill                                If true, the polygon will be filled otherwise only its outline will be drawn
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc drawMesh*(pstMesh: ptr orxDISPLAY_MESH; pstBitmap: ptr orxBITMAP;
                         eSmoothing: orxDISPLAY_SMOOTHING;
                         eBlendMode: orxDISPLAY_BLEND_MODE): orxSTATUS {.cdecl,
    importc: "orxDisplay_DrawMesh", dynlib: libORX.}
  ## Draws a textured mesh
  ##  @param[in]   _pstMesh                              Mesh to draw, if no primitive and no index buffer is given, separate quads arrangement will be assumed
  ##  @param[in]   _pstBitmap                            Bitmap to use for texturing, nil to use the current one
  ##  @param[in]   _eSmoothing                           Bitmap smoothing type
  ##  @param[in]   _eBlendMode                           Blend mode
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc hasShaderSupport*(): orxBOOL {.cdecl,
    importc: "orxDisplay_HasShaderSupport", dynlib: libORX.}
  ## Has shader support?
  ##  @return orxTRUE / orxFALSE

proc createShader*(azCodeList: cstringArray; u32Size: orxU32;
                             pstParamList: ptr orxLINKLIST;
                             bUseCustomParam: orxBOOL): orxHANDLE {.cdecl,
    importc: "orxDisplay_CreateShader", dynlib: libORX.}
  ## Creates (compiles) a shader
  ##  @param[in]   _azCodeList                           List of shader code to compile, in order
  ##  @param[in]   _u32Size                              Size of the shader code list
  ##  @param[in]   _pstParamList                         Shader parameters (should be a link list of orxSHADER_PARAM)
  ##  @param[in]   _bUseCustomParam                      Shader uses custom parameters
  ##  @return orxHANDLE of the compiled shader is successful, orxHANDLE_UNDEFINED otherwise

proc deleteShader*(hShader: orxHANDLE) {.cdecl,
    importc: "orxDisplay_DeleteShader", dynlib: libORX.}
  ## Deletes a compiled shader
  ##  @param[in]   _hShader                              Shader to delete

proc startShader*(hShader: orxHANDLE): orxSTATUS {.cdecl,
    importc: "orxDisplay_StartShader", dynlib: libORX.}
  ## Starts a shader rendering
  ##  @param[in]   _hShader                              Shader to start
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc stopShader*(hShader: orxHANDLE): orxSTATUS {.cdecl,
    importc: "orxDisplay_StopShader", dynlib: libORX.}
  ## Stops a shader rendering
  ##  @param[in]   _hShader                              Shader to stop
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getParameterID*(hShader: orxHANDLE; zParam: cstring;
                               s32Index: orxS32; bIsTexture: orxBOOL): orxS32 {.
    cdecl, importc: "orxDisplay_GetParameterID", dynlib: libORX.}
  ## Gets a shader parameter's ID
  ##  @param[in]   _hShader                              Concerned shader
  ##  @param[in]   _zParam                               Parameter name
  ##  @param[in]   _s32Index                             Parameter index, -1 for non-array types
  ##  @param[in]   _bIsTexture                           Is parameter a texture?
  ##  @return Parameter ID

proc setShaderBitmap*(hShader: orxHANDLE; s32ID: orxS32;
                                pstValue: ptr orxBITMAP): orxSTATUS {.cdecl,
    importc: "orxDisplay_SetShaderBitmap", dynlib: libORX.}
  ## Sets a shader parameter (orxBITMAP)
  ##  @param[in]   _hShader                              Concerned shader
  ##  @param[in]   _s32ID                                ID of parameter to set
  ##  @param[in]   _pstValue                             Value (orxBITMAP) for this parameter
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setShaderFloat*(hShader: orxHANDLE; s32ID: orxS32; fValue: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxDisplay_SetShaderFloat", dynlib: libORX.}
  ## Sets a shader parameter (orxFLOAT)
  ##  @param[in]   _hShader                              Concerned shader
  ##  @param[in]   _s32ID                                ID of parameter to set
  ##  @param[in]   _fValue                               Value (orxFLOAT) for this parameter
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setShaderVector*(hShader: orxHANDLE; s32ID: orxS32;
                                pvValue: ptr orxVECTOR): orxSTATUS {.cdecl,
    importc: "orxDisplay_SetShaderVector", dynlib: libORX.}
  ## Sets a shader parameter (orxVECTOR)
  ##  @param[in]   _hShader                              Concerned shader
  ##  @param[in]   _s32ID                                ID of parameter to set
  ##  @param[in]   _pvValue                              Value (orxVECTOR) for this parameter
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getShaderID*(hShader: orxHANDLE): orxU32 {.cdecl,
    importc: "orxDisplay_GetShaderID", dynlib: libORX.}
  ## Gets a shader (internal) ID
  ##  @param[in]   _hShader                              Concerned bitmap
  ##  @return orxU32

proc enableVSync*(bEnable: orxBOOL): orxSTATUS {.cdecl,
    importc: "orxDisplay_EnableVSync", dynlib: libORX.}
  ## Enables / disables vertical synchro
  ##  @param[in]   _bEnable                              Enable / disable
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc isVSyncEnabled*(): orxBOOL {.cdecl,
    importc: "orxDisplay_IsVSyncEnabled", dynlib: libORX.}
  ## Is vertical synchro enabled?
  ##  @return orxTRUE if enabled, orxFALSE otherwise

proc setFullScreen*(bFullScreen: orxBOOL): orxSTATUS {.cdecl,
    importc: "orxDisplay_SetFullScreen", dynlib: libORX.}
  ## Sets full screen mode
  ##  @param[in]   _bFullScreen                          orxTRUE / orxFALSE
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc isFullScreen*(): orxBOOL {.cdecl,
                                        importc: "orxDisplay_IsFullScreen",
                                        dynlib: libORX.}
  ## Is in full screen mode?
  ##  @return orxTRUE if full screen, orxFALSE otherwise

proc getVideoModeCount*(): orxU32 {.cdecl,
    importc: "orxDisplay_GetVideoModeCount", dynlib: libORX.}
  ## Gets available video mode count
  ##  @return Available video mode count

proc getVideoMode*(u32Index: orxU32;
                             pstVideoMode: ptr orxDISPLAY_VIDEO_MODE): ptr orxDISPLAY_VIDEO_MODE {.
    cdecl, importc: "orxDisplay_GetVideoMode", dynlib: libORX.}
  ## Gets an available video mode
  ##  @param[in]   _u32Index                             Video mode index, pass _u32Index < orxDisplay_GetVideoModeCount() for an available listed mode, orxU32_UNDEFINED for the the default (desktop) mode and any other value for current mode
  ##  @param[out]  _pstVideoMode                         Storage for the video mode
  ##  @return orxDISPLAY_VIDEO_MODE / nil if invalid

proc setVideoMode*(pstVideoMode: ptr orxDISPLAY_VIDEO_MODE): orxSTATUS {.
    cdecl, importc: "orxDisplay_SetVideoMode", dynlib: libORX.}
  ## Gets an available video mode
  ##  @param[in]  _pstVideoMode                          Video mode to set
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc isVideoModeAvailable*(pstVideoMode: ptr orxDISPLAY_VIDEO_MODE): orxBOOL {.
    cdecl, importc: "orxDisplay_IsVideoModeAvailable", dynlib: libORX.}
  ## Is video mode available
  ##  @param[in]  _pstVideoMode                          Video mode to test
  ##  @return orxTRUE is available, orxFALSE otherwise
