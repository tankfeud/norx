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

import incl, texture, vector, isplay

## * Misc defines
##

const
  orxFONT_KZ_DEFAULT_FONT_NAME* = "default"

## * Internal font structure

type orxFONT* = object
## * Setups the font module
##

proc orxFont_Setup*() {.cdecl, importc: "orxFont_Setup", dynlib: libORX.}
## * Inits the font module
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxFont_Init*(): orxSTATUS {.cdecl, importc: "orxFont_Init", dynlib: libORX.}
## * Exits from the font module
##

proc orxFont_Exit*() {.cdecl, importc: "orxFont_Exit", dynlib: libORX.}
## * Creates an empty font
##  @return      orxFONT / nil
##

proc orxFont_Create*(): ptr orxFONT {.cdecl, importc: "orxFont_Create",
                                  dynlib: libORX.}
## * Creates a font from config
##  @param[in]   _zConfigID    Config ID
##  @return      orxFONT / nil
##

proc orxFont_CreateFromConfig*(zConfigID: cstring): ptr orxFONT {.cdecl,
    importc: "orxFont_CreateFromConfig", dynlib: libORX.}
## * Deletes a font
##  @param[in]   _pstFont      Concerned font
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxFont_Delete*(pstFont: ptr orxFONT): orxSTATUS {.cdecl,
    importc: "orxFont_Delete", dynlib: libORX.}
## * Gets default font
##  @return      Default font / nil
##

proc orxFont_GetDefaultFont*(): ptr orxFONT {.cdecl,
    importc: "orxFont_GetDefaultFont", dynlib: libORX.}
## * Sets font's texture
##  @param[in]   _pstFont      Concerned font
##  @param[in]   _pstTexture   Texture to set
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxFont_SetTexture*(pstFont: ptr orxFONT; pstTexture: ptr orxTEXTURE): orxSTATUS {.
    cdecl, importc: "orxFont_SetTexture", dynlib: libORX.}
## * Sets font's character list
##  @param[in]   _pstFont      Concerned font
##  @param[in]   _zList        Character list
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxFont_SetCharacterList*(pstFont: ptr orxFONT; zList: cstring): orxSTATUS {.
    cdecl, importc: "orxFont_SetCharacterList", dynlib: libORX.}
## * Sets font's character height
##  @param[in]   _pstFont              Concerned font
##  @param[in]   _fCharacterHeight     Character's height
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxFont_SetCharacterHeight*(pstFont: ptr orxFONT; fCharacterHeight: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxFont_SetCharacterHeight", dynlib: libORX.}
## * Sets font's character width list
##  @param[in]   _pstFont              Concerned font
##  @param[in]   _u32CharacterNumber   Character's number
##  @param[in]   _afCharacterWidthList List of widths for all the characters
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxFont_SetCharacterWidthList*(pstFont: ptr orxFONT;
                                   u32CharacterNumber: orxU32;
                                   afCharacterWidthList: ptr orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxFont_SetCharacterWidthList", dynlib: libORX.}
## * Sets font's character spacing
##  @param[in]   _pstFont      Concerned font
##  @param[in]   _pvSpacing    Character's spacing
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxFont_SetCharacterSpacing*(pstFont: ptr orxFONT; pvSpacing: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxFont_SetCharacterSpacing", dynlib: libORX.}
## * Sets font's origin
##  @param[in]   _pstFont      Concerned font
##  @param[in]   _pvOrigin     Font's origin
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxFont_SetOrigin*(pstFont: ptr orxFONT; pvOrigin: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxFont_SetOrigin", dynlib: libORX.}
## * Sets font's size
##  @param[in]   _pstFont      Concerned font
##  @param[in]   _pvSize       Font's size
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxFont_SetSize*(pstFont: ptr orxFONT; pvSize: ptr orxVECTOR): orxSTATUS {.cdecl,
    importc: "orxFont_SetSize", dynlib: libORX.}
## * Gets font's texture
##  @param[in]   _pstFont      Concerned font
##  @return      Font texture / nil
##

proc orxFont_GetTexture*(pstFont: ptr orxFONT): ptr orxTEXTURE {.cdecl,
    importc: "orxFont_GetTexture", dynlib: libORX.}
## * Gets font's character list
##  @param[in]   _pstFont      Concerned font
##  @return      Font's character list / nil
##

proc orxFont_GetCharacterList*(pstFont: ptr orxFONT): cstring {.cdecl,
    importc: "orxFont_GetCharacterList", dynlib: libORX.}
## * Gets font's character height
##  @param[in]   _pstFont                Concerned font
##  @return      orxFLOAT
##

proc orxFont_GetCharacterHeight*(pstFont: ptr orxFONT): orxFLOAT {.cdecl,
    importc: "orxFont_GetCharacterHeight", dynlib: libORX.}
## * Gets font's character width
##  @param[in]   _pstFont                Concerned font
##  @param[in]   _u32CharacterCodePoint  Character code point
##  @return      orxFLOAT
##

proc orxFont_GetCharacterWidth*(pstFont: ptr orxFONT; u32CharacterCodePoint: orxU32): orxFLOAT {.
    cdecl, importc: "orxFont_GetCharacterWidth", dynlib: libORX.}
## * Gets font's character spacing
##  @param[in]   _pstFont      Concerned font
##  @param[out]  _pvSpacing    Character's spacing
##  @return      orxVECTOR / nil
##

proc orxFont_GetCharacterSpacing*(pstFont: ptr orxFONT; pvSpacing: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxFont_GetCharacterSpacing", dynlib: libORX.}
## * Gets font's origin
##  @param[in]   _pstFont      Concerned font
##  @param[out]  _pvOrigin     Font's origin
##  @return      orxVECTOR / nil
##

proc orxFont_GetOrigin*(pstFont: ptr orxFONT; pvOrigin: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxFont_GetOrigin", dynlib: libORX.}
## * Gets font's size
##  @param[in]   _pstFont      Concerned font
##  @param[out]  _pvSize       Font's size
##  @return      orxVECTOR / nil
##

proc orxFont_GetSize*(pstFont: ptr orxFONT; pvSize: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxFont_GetSize", dynlib: libORX.}
## * Gets font's map
##  @param[in]   _pstFont      Concerned font
##  @return      orxCHARACTER_MAP / nil
##

proc orxFont_GetMap*(pstFont: ptr orxFONT): ptr orxCHARACTER_MAP {.cdecl,
    importc: "orxFont_GetMap", dynlib: libORX.}
## * Gets font name
##  @param[in]   _pstFont      Concerned font
##  @return      Font name / orxSTRING_EMPTY
##

proc orxFont_GetName*(pstFont: ptr orxFONT): cstring {.cdecl,
    importc: "orxFont_GetName", dynlib: libORX.}
## * @}
