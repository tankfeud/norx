import incl, structure, display, vector


## * Graphic flags
##

const
  orxGRAPHIC_KU32_FLAG_NONE* = 0x00000000
  orxGRAPHIC_KU32_FLAG_2D* = 0x00000001
  orxGRAPHIC_KU32_FLAG_TEXT* = 0x00000002
  orxGRAPHIC_KU32_MASK_TYPE* = 0x00000003
  orxGRAPHIC_KU32_FLAG_FLIP_X* = 0x00000004
  orxGRAPHIC_KU32_FLAG_FLIP_Y* = 0x00000008
  orxGRAPHIC_KU32_MASK_FLIP_BOTH* = 0x0000000C
  orxGRAPHIC_KU32_FLAG_ALIGN_CENTER* = 0x00000000
  orxGRAPHIC_KU32_FLAG_ALIGN_LEFT* = 0x00000010
  orxGRAPHIC_KU32_FLAG_ALIGN_RIGHT* = 0x00000020
  orxGRAPHIC_KU32_FLAG_ALIGN_TOP* = 0x00000040
  orxGRAPHIC_KU32_FLAG_ALIGN_BOTTOM* = 0x00000080
  orxGRAPHIC_KU32_FLAG_ALIGN_TRUNCATE* = 0x00000100
  orxGRAPHIC_KU32_FLAG_ALIGN_ROUND* = 0x00000200
  orxGRAPHIC_KU32_MASK_USER_ALL* = 0x00000FFF

## * Misc defines
##

const
  orxGRAPHIC_KZ_CONFIG_TEXTURE_NAME* = "Texture"
  orxGRAPHIC_KZ_CONFIG_TEXTURE_ORIGIN* = "TextureOrigin"
  orxGRAPHIC_KZ_CONFIG_TEXTURE_SIZE* = "TextureSize"
  orxGRAPHIC_KZ_CONFIG_TEXT_NAME* = "Text"
  orxGRAPHIC_KZ_CONFIG_PIVOT* = "Pivot"
  orxGRAPHIC_KZ_CONFIG_COLOR* = "Color"
  orxGRAPHIC_KZ_CONFIG_ALPHA* = "Alpha"
  orxGRAPHIC_KZ_CONFIG_RGB* = "RGB"
  orxGRAPHIC_KZ_CONFIG_HSL* = "HSL"
  orxGRAPHIC_KZ_CONFIG_HSV* = "HSV"
  orxGRAPHIC_KZ_CONFIG_FLIP* = "Flip"
  orxGRAPHIC_KZ_CONFIG_REPEAT* = "Repeat"
  orxGRAPHIC_KZ_CONFIG_SMOOTHING* = "Smoothing"
  orxGRAPHIC_KZ_CONFIG_BLEND_MODE* = "BlendMode"
  orxGRAPHIC_KZ_CONFIG_KEEP_IN_CACHE* = "KeepInCache"

## * Internal Graphic structure
##

type orxGRAPHIC* = object

proc graphicSetup*() {.cdecl, importc: "orxGraphic_Setup", dynlib: libORX.}
  ## Graphic module setup

proc graphicInit*(): orxSTATUS {.cdecl, importc: "orxGraphic_Init",
                                  dynlib: libORX.}
  ## Inits the Graphic module

proc graphicExit*() {.cdecl, importc: "orxGraphic_Exit", dynlib: libORX.}
  ## Exits from the Graphic module

proc graphicCreate*(): ptr orxGRAPHIC {.cdecl, importc: "orxGraphic_Create",
                                        dynlib: libORX.}
  ## Creates an empty graphic
  ##  @return      Created orxGRAPHIC / nil

proc graphicCreateFromConfig*(zConfigID: cstring): ptr orxGRAPHIC {.cdecl,
    importc: "orxGraphic_CreateFromConfig", dynlib: libORX.}
  ## Creates a graphic from config
  ##  @param[in]   _zConfigID      Config ID
  ##  @ return orxGRAPHIC / nil

proc delete*(pstGraphic: ptr orxGRAPHIC): orxSTATUS {.cdecl,
    importc: "orxGraphic_Delete", dynlib: libORX.}
  ## Deletes a graphic
  ##  @param[in]   _pstGraphic     Graphic to delete
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getName*(pstGraphic: ptr orxGRAPHIC): cstring {.cdecl,
    importc: "orxGraphic_GetName", dynlib: libORX.}
  ## Gets graphic config name
  ##  @param[in]   _pstGraphic     Concerned graphic
  ##  @return      orxSTRING / orxSTRING_EMPTY

proc setData*(pstGraphic: ptr orxGRAPHIC; pstData: ptr orxSTRUCTURE): orxSTATUS {.
    cdecl, importc: "orxGraphic_SetData", dynlib: libORX.}
  ## Sets graphic data
  ##  @param[in]   _pstGraphic     Concerned graphic
  ##  @param[in]   _pstData        Data structure to set / nil
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getData*(pstGraphic: ptr orxGRAPHIC): ptr orxSTRUCTURE {.cdecl,
    importc: "orxGraphic_GetData", dynlib: libORX.}
  ## Gets graphic data
  ##  @param[in]   _pstGraphic     Concerned graphic
  ##  @return      OrxSTRUCTURE / nil

proc setFlip*(pstGraphic: ptr orxGRAPHIC; bFlipX: orxBOOL; bFlipY: orxBOOL): orxSTATUS {.
    cdecl, importc: "orxGraphic_SetFlip", dynlib: libORX.}
  ## Sets graphic flipping
  ##  @param[in]   _pstGraphic     Concerned graphic
  ##  @param[in]   _bFlipX         Flip it on X axis
  ##  @param[in]   _bFlipY         Flip it on Y axis
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getFlip*(pstGraphic: ptr orxGRAPHIC; pbFlipX: ptr orxBOOL;
                        pbFlipY: ptr orxBOOL): orxSTATUS {.cdecl,
    importc: "orxGraphic_GetFlip", dynlib: libORX.}
  ## Gets graphic flipping
  ##  @param[in]   _pstGraphic     Concerned graphic
  ##  @param[in]   _pbFlipX        X axis flipping
  ##  @param[in]   _pbFlipY        Y axis flipping
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setPivot*(pstGraphic: ptr orxGRAPHIC; pvPivot: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxGraphic_SetPivot", dynlib: libORX.}
  ## Sets graphic pivot
  ##  @param[in]   _pstGraphic     Concerned graphic
  ##  @param[in]   _pvPivot        Pivot to set
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setRelativePivot*(pstGraphic: ptr orxGRAPHIC; u32AlignFlags: orxU32): orxSTATUS {.
    cdecl, importc: "orxGraphic_SetRelativePivot", dynlib: libORX.}
  ## Sets relative graphic pivot
  ##  @param[in]   _pstGraphic     Concerned graphic
  ##  @param[in]   _u32AlignFlags  Alignment flags
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getPivot*(pstGraphic: ptr orxGRAPHIC; pvPivot: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxGraphic_GetPivot", dynlib: libORX.}
  ## Gets graphic pivot
  ##  @param[in]   _pstGraphic     Concerned graphic
  ##  @param[out]  _pvPivot        Graphic pivot
  ##  @return      orxPIVOT / nil

proc setSize*(pstGraphic: ptr orxGRAPHIC; pvSize: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxGraphic_SetSize", dynlib: libORX.}
  ## Sets graphic size
  ##  @param[in]   _pstGraphic     Concerned graphic
  ##  @param[in]   _pvSize         Size to set
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getSize*(pstGraphic: ptr orxGRAPHIC; pvSize: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxGraphic_GetSize", dynlib: libORX.}
  ## Gets graphic size
  ##  @param[in]   _pstGraphic     Concerned graphic
  ##  @param[out]  _pvSize         Object's size
  ##  @return      orxVECTOR / nil

proc setColor*(pstGraphic: ptr orxGRAPHIC; pstColor: ptr orxCOLOR): orxSTATUS {.
    cdecl, importc: "orxGraphic_SetColor", dynlib: libORX.}
  ## Sets graphic color
  ##  @param[in]   _pstGraphic     Concerned graphic
  ##  @param[in]   _pstColor       Color to set
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setRepeat*(pstGraphic: ptr orxGRAPHIC; fRepeatX: orxFLOAT;
                          fRepeatY: orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxGraphic_SetRepeat", dynlib: libORX.}
  ## Sets graphic repeat (wrap) value
  ##  @param[in]   _pstGraphic     Concerned graphic
  ##  @param[in]   _fRepeatX       X-axis repeat value
  ##  @param[in]   _fRepeatY       Y-axis repeat value
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc clearColor*(pstGraphic: ptr orxGRAPHIC): orxSTATUS {.cdecl,
    importc: "orxGraphic_ClearColor", dynlib: libORX.}
  ## Clears graphic color
  ##  @param[in]   _pstGraphic     Concerned graphic
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc hasColor*(pstGraphic: ptr orxGRAPHIC): orxBOOL {.cdecl,
    importc: "orxGraphic_HasColor", dynlib: libORX.}
  ## Graphic has color accessor
  ##  @param[in]   _pstGraphic     Concerned graphic
  ##  @return      orxTRUE / orxFALSE

proc getColor*(pstGraphic: ptr orxGRAPHIC; pstColor: ptr orxCOLOR): ptr orxCOLOR {.
    cdecl, importc: "orxGraphic_GetColor", dynlib: libORX.}
  ## Gets graphic color
  ##  @param[in]   _pstGraphic     Concerned graphic
  ##  @param[out]  _pstColor       Object's color
  ##  @return      orxCOLOR / nil

proc getRepeat*(pstGraphic: ptr orxGRAPHIC; pfRepeatX: ptr orxFLOAT;
                          pfRepeatY: ptr orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxGraphic_GetRepeat", dynlib: libORX.}
  ## Gets graphic repeat (wrap) values
  ##  @param[in]   _pstGraphic     Concerned graphic
  ##  @param[out]  _pfRepeatX      X-axis repeat value
  ##  @param[out]  _pfRepeatY      Y-axis repeat value
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setOrigin*(pstGraphic: ptr orxGRAPHIC; pvOrigin: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxGraphic_SetOrigin", dynlib: libORX.}
  ## Sets graphic origin
  ##  @param[in]   _pstGraphic     Concerned graphic
  ##  @param[in]   _pvOrigin       Origin coordinates
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getOrigin*(pstGraphic: ptr orxGRAPHIC; pvOrigin: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxGraphic_GetOrigin", dynlib: libORX.}
  ## Gets graphic origin
  ##  @param[in]   _pstGraphic     Concerned graphic
  ##  @param[out]  _pvOrigin       Origin coordinates
  ##  @return      Origin coordinates

proc updateSize*(pstGraphic: ptr orxGRAPHIC): orxSTATUS {.cdecl,
    importc: "orxGraphic_UpdateSize", dynlib: libORX.}
  ## Updates graphic size (recompute)
  ##  @param[in]   _pstGraphic     Concerned graphic
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setSmoothing*(pstGraphic: ptr orxGRAPHIC;
                             eSmoothing: orxDISPLAY_SMOOTHING): orxSTATUS {.cdecl,
    importc: "orxGraphic_SetSmoothing", dynlib: libORX.}
  ## Sets graphic smoothing
  ##  @param[in]   _pstGraphic     Concerned graphic
  ##  @param[in]   _eSmoothing     Smoothing type (enabled, default or none)
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getSmoothing*(pstGraphic: ptr orxGRAPHIC): orxDISPLAY_SMOOTHING {.
    cdecl, importc: "orxGraphic_GetSmoothing", dynlib: libORX.}
  ## Gets graphic smoothing
  ##  @param[in]   _pstGraphic     Concerned graphic
  ##  @return Smoothing type (enabled, default or none)

proc setBlendMode*(pstGraphic: ptr orxGRAPHIC;
                             eBlendMode: orxDISPLAY_BLEND_MODE): orxSTATUS {.cdecl,
    importc: "orxGraphic_SetBlendMode", dynlib: libORX.}
  ## Sets object blend mode
  ##  @param[in]   _pstGraphic     Concerned graphic
  ##  @param[in]   _eBlendMode     Blend mode (alpha, multiply, add or none)
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc clearBlendMode*(pstGraphic: ptr orxGRAPHIC): orxSTATUS {.cdecl,
    importc: "orxGraphic_ClearBlendMode", dynlib: libORX.}
  ## Clears graphic blend mode
  ##  @param[in]   _pstGraphic     Concerned graphic
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc hasBlendMode*(pstGraphic: ptr orxGRAPHIC): orxBOOL {.cdecl,
    importc: "orxGraphic_HasBlendMode", dynlib: libORX.}
  ## Graphic has blend mode accessor
  ##  @param[in]   _pstGraphic     Concerned graphic
  ##  @return      orxTRUE / orxFALSE

proc getBlendMode*(pstGraphic: ptr orxGRAPHIC): orxDISPLAY_BLEND_MODE {.
    cdecl, importc: "orxGraphic_GetBlendMode", dynlib: libORX.}
  ## Gets graphic blend mode
  ##  @param[in]   _pstGraphic     Concerned graphic
  ##  @return Blend mode (alpha, multiply, add or none)

