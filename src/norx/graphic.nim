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
## * Graphic module setup
##

proc orxGraphic_Setup*() {.cdecl, importc: "orxGraphic_Setup", dynlib: libORX.}
## * Inits the Graphic module
##

proc orxGraphic_Init*(): orxSTATUS {.cdecl, importc: "orxGraphic_Init",
                                  dynlib: libORX.}
## * Exits from the Graphic module
##

proc orxGraphic_Exit*() {.cdecl, importc: "orxGraphic_Exit", dynlib: libORX.}
## * Creates an empty graphic
##  @return      Created orxGRAPHIC / nil
##

proc orxGraphic_Create*(): ptr orxGRAPHIC {.cdecl, importc: "orxGraphic_Create",
                                        dynlib: libORX.}
## * Creates a graphic from config
##  @param[in]   _zConfigID      Config ID
##  @ return orxGRAPHIC / nil
##

proc orxGraphic_CreateFromConfig*(zConfigID: cstring): ptr orxGRAPHIC {.cdecl,
    importc: "orxGraphic_CreateFromConfig", dynlib: libORX.}
## * Deletes a graphic
##  @param[in]   _pstGraphic     Graphic to delete
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxGraphic_Delete*(pstGraphic: ptr orxGRAPHIC): orxSTATUS {.cdecl,
    importc: "orxGraphic_Delete", dynlib: libORX.}
## * Gets graphic config name
##  @param[in]   _pstGraphic     Concerned graphic
##  @return      orxSTRING / orxSTRING_EMPTY
##

proc orxGraphic_GetName*(pstGraphic: ptr orxGRAPHIC): cstring {.cdecl,
    importc: "orxGraphic_GetName", dynlib: libORX.}
## * Sets graphic data
##  @param[in]   _pstGraphic     Concerned graphic
##  @param[in]   _pstData        Data structure to set / nil
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxGraphic_SetData*(pstGraphic: ptr orxGRAPHIC; pstData: ptr orxSTRUCTURE): orxSTATUS {.
    cdecl, importc: "orxGraphic_SetData", dynlib: libORX.}
## * Gets graphic data
##  @param[in]   _pstGraphic     Concerned graphic
##  @return      OrxSTRUCTURE / nil
##

proc orxGraphic_GetData*(pstGraphic: ptr orxGRAPHIC): ptr orxSTRUCTURE {.cdecl,
    importc: "orxGraphic_GetData", dynlib: libORX.}
## * Sets graphic flipping
##  @param[in]   _pstGraphic     Concerned graphic
##  @param[in]   _bFlipX         Flip it on X axis
##  @param[in]   _bFlipY         Flip it on Y axis
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxGraphic_SetFlip*(pstGraphic: ptr orxGRAPHIC; bFlipX: orxBOOL; bFlipY: orxBOOL): orxSTATUS {.
    cdecl, importc: "orxGraphic_SetFlip", dynlib: libORX.}
## * Gets graphic flipping
##  @param[in]   _pstGraphic     Concerned graphic
##  @param[in]   _pbFlipX        X axis flipping
##  @param[in]   _pbFlipY        Y axis flipping
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxGraphic_GetFlip*(pstGraphic: ptr orxGRAPHIC; pbFlipX: ptr orxBOOL;
                        pbFlipY: ptr orxBOOL): orxSTATUS {.cdecl,
    importc: "orxGraphic_GetFlip", dynlib: libORX.}
## * Sets graphic pivot
##  @param[in]   _pstGraphic     Concerned graphic
##  @param[in]   _pvPivot        Pivot to set
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxGraphic_SetPivot*(pstGraphic: ptr orxGRAPHIC; pvPivot: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxGraphic_SetPivot", dynlib: libORX.}
## * Sets relative graphic pivot
##  @param[in]   _pstGraphic     Concerned graphic
##  @param[in]   _u32AlignFlags  Alignment flags
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxGraphic_SetRelativePivot*(pstGraphic: ptr orxGRAPHIC; u32AlignFlags: orxU32): orxSTATUS {.
    cdecl, importc: "orxGraphic_SetRelativePivot", dynlib: libORX.}
## * Gets graphic pivot
##  @param[in]   _pstGraphic     Concerned graphic
##  @param[out]  _pvPivot        Graphic pivot
##  @return      orxPIVOT / nil
##

proc orxGraphic_GetPivot*(pstGraphic: ptr orxGRAPHIC; pvPivot: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxGraphic_GetPivot", dynlib: libORX.}
## * Sets graphic size
##  @param[in]   _pstGraphic     Concerned graphic
##  @param[in]   _pvSize         Size to set
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxGraphic_SetSize*(pstGraphic: ptr orxGRAPHIC; pvSize: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxGraphic_SetSize", dynlib: libORX.}
## * Gets graphic size
##  @param[in]   _pstGraphic     Concerned graphic
##  @param[out]  _pvSize         Object's size
##  @return      orxVECTOR / nil
##

proc orxGraphic_GetSize*(pstGraphic: ptr orxGRAPHIC; pvSize: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxGraphic_GetSize", dynlib: libORX.}
## * Sets graphic color
##  @param[in]   _pstGraphic     Concerned graphic
##  @param[in]   _pstColor       Color to set
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxGraphic_SetColor*(pstGraphic: ptr orxGRAPHIC; pstColor: ptr orxCOLOR): orxSTATUS {.
    cdecl, importc: "orxGraphic_SetColor", dynlib: libORX.}
## * Sets graphic repeat (wrap) value
##  @param[in]   _pstGraphic     Concerned graphic
##  @param[in]   _fRepeatX       X-axis repeat value
##  @param[in]   _fRepeatY       Y-axis repeat value
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxGraphic_SetRepeat*(pstGraphic: ptr orxGRAPHIC; fRepeatX: orxFLOAT;
                          fRepeatY: orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxGraphic_SetRepeat", dynlib: libORX.}
## * Clears graphic color
##  @param[in]   _pstGraphic     Concerned graphic
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxGraphic_ClearColor*(pstGraphic: ptr orxGRAPHIC): orxSTATUS {.cdecl,
    importc: "orxGraphic_ClearColor", dynlib: libORX.}
## * Graphic has color accessor
##  @param[in]   _pstGraphic     Concerned graphic
##  @return      orxTRUE / orxFALSE
##

proc orxGraphic_HasColor*(pstGraphic: ptr orxGRAPHIC): orxBOOL {.cdecl,
    importc: "orxGraphic_HasColor", dynlib: libORX.}
## * Gets graphic color
##  @param[in]   _pstGraphic     Concerned graphic
##  @param[out]  _pstColor       Object's color
##  @return      orxCOLOR / nil
##

proc orxGraphic_GetColor*(pstGraphic: ptr orxGRAPHIC; pstColor: ptr orxCOLOR): ptr orxCOLOR {.
    cdecl, importc: "orxGraphic_GetColor", dynlib: libORX.}
## * Gets graphic repeat (wrap) values
##  @param[in]   _pstGraphic     Concerned graphic
##  @param[out]  _pfRepeatX      X-axis repeat value
##  @param[out]  _pfRepeatY      Y-axis repeat value
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxGraphic_GetRepeat*(pstGraphic: ptr orxGRAPHIC; pfRepeatX: ptr orxFLOAT;
                          pfRepeatY: ptr orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxGraphic_GetRepeat", dynlib: libORX.}
## * Sets graphic origin
##  @param[in]   _pstGraphic     Concerned graphic
##  @param[in]   _pvOrigin       Origin coordinates
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxGraphic_SetOrigin*(pstGraphic: ptr orxGRAPHIC; pvOrigin: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxGraphic_SetOrigin", dynlib: libORX.}
## * Gets graphic origin
##  @param[in]   _pstGraphic     Concerned graphic
##  @param[out]  _pvOrigin       Origin coordinates
##  @return      Origin coordinates
##

proc orxGraphic_GetOrigin*(pstGraphic: ptr orxGRAPHIC; pvOrigin: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxGraphic_GetOrigin", dynlib: libORX.}
## * Updates graphic size (recompute)
##  @param[in]   _pstGraphic     Concerned graphic
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxGraphic_UpdateSize*(pstGraphic: ptr orxGRAPHIC): orxSTATUS {.cdecl,
    importc: "orxGraphic_UpdateSize", dynlib: libORX.}
## * Sets graphic smoothing
##  @param[in]   _pstGraphic     Concerned graphic
##  @param[in]   _eSmoothing     Smoothing type (enabled, default or none)
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxGraphic_SetSmoothing*(pstGraphic: ptr orxGRAPHIC;
                             eSmoothing: orxDISPLAY_SMOOTHING): orxSTATUS {.cdecl,
    importc: "orxGraphic_SetSmoothing", dynlib: libORX.}
## * Gets graphic smoothing
##  @param[in]   _pstGraphic     Concerned graphic
##  @return Smoothing type (enabled, default or none)
##

proc orxGraphic_GetSmoothing*(pstGraphic: ptr orxGRAPHIC): orxDISPLAY_SMOOTHING {.
    cdecl, importc: "orxGraphic_GetSmoothing", dynlib: libORX.}
## * Sets object blend mode
##  @param[in]   _pstGraphic     Concerned graphic
##  @param[in]   _eBlendMode     Blend mode (alpha, multiply, add or none)
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxGraphic_SetBlendMode*(pstGraphic: ptr orxGRAPHIC;
                             eBlendMode: orxDISPLAY_BLEND_MODE): orxSTATUS {.cdecl,
    importc: "orxGraphic_SetBlendMode", dynlib: libORX.}
## * Clears graphic blend mode
##  @param[in]   _pstGraphic     Concerned graphic
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxGraphic_ClearBlendMode*(pstGraphic: ptr orxGRAPHIC): orxSTATUS {.cdecl,
    importc: "orxGraphic_ClearBlendMode", dynlib: libORX.}
## * Graphic has blend mode accessor
##  @param[in]   _pstGraphic     Concerned graphic
##  @return      orxTRUE / orxFALSE
##

proc orxGraphic_HasBlendMode*(pstGraphic: ptr orxGRAPHIC): orxBOOL {.cdecl,
    importc: "orxGraphic_HasBlendMode", dynlib: libORX.}
## * Gets graphic blend mode
##  @param[in]   _pstGraphic     Concerned graphic
##  @return Blend mode (alpha, multiply, add or none)
##

proc orxGraphic_GetBlendMode*(pstGraphic: ptr orxGRAPHIC): orxDISPLAY_BLEND_MODE {.
    cdecl, importc: "orxGraphic_GetBlendMode", dynlib: libORX.}
## * @}
