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


import incl,font

## * Internal text structure

type orxTEXT* = object
## * Setups the text module
##

proc orxText_Setup*() {.cdecl, importc: "orxText_Setup", dynlib: libORX.}
## * Inits the text module
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxText_Init*(): orxSTATUS {.cdecl, importc: "orxText_Init", dynlib: libORX.}
## * Exits from the text module
##

proc orxText_Exit*() {.cdecl, importc: "orxText_Exit", dynlib: libORX.}
## * Creates an empty text
##  @return      orxTEXT / nil
##

proc orxText_Create*(): ptr orxTEXT {.cdecl, importc: "orxText_Create",
                                  dynlib: libORX.}
## * Creates a text from config
##  @param[in]   _zConfigID    Config ID
##  @return      orxTEXT / nil
##

proc orxText_CreateFromConfig*(zConfigID: cstring): ptr orxTEXT {.cdecl,
    importc: "orxText_CreateFromConfig", dynlib: libORX.}
## * Deletes a text
##  @param[in]   _pstText      Concerned text
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxText_Delete*(pstText: ptr orxTEXT): orxSTATUS {.cdecl,
    importc: "orxText_Delete", dynlib: libORX.}
## * Gets text name
##  @param[in]   _pstText      Concerned text
##  @return      Text name / nil
##

proc orxText_GetName*(pstText: ptr orxTEXT): cstring {.cdecl,
    importc: "orxText_GetName", dynlib: libORX.}
## * Gets text's line count
##  @param[in]   _pstText      Concerned text
##  @return      orxU32
##

proc orxText_GetLineCount*(pstText: ptr orxTEXT): orxU32 {.cdecl,
    importc: "orxText_GetLineCount", dynlib: libORX.}
## * Gets text's line size
##  @param[in]   _pstText      Concerned text
##  @param[out]  _u32Line      Line index
##  @param[out]  _pfWidth      Line's width
##  @param[out]  _pfHeight     Line's height
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxText_GetLineSize*(pstText: ptr orxTEXT; u32Line: orxU32;
                         pfWidth: ptr orxFLOAT; pfHeight: ptr orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxText_GetLineSize", dynlib: libORX.}
## * Is text's size fixed? (ie. manually constrained with orxText_SetSize())
##  @param[in]   _pstText      Concerned text
##  @return      orxTRUE / orxFALSE
##

proc orxText_IsFixedSize*(pstText: ptr orxTEXT): orxBOOL {.cdecl,
    importc: "orxText_IsFixedSize", dynlib: libORX.}
## * Gets text size
##  @param[in]   _pstText      Concerned text
##  @param[out]  _pfWidth      Text's width
##  @param[out]  _pfHeight     Text's height
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxText_GetSize*(pstText: ptr orxTEXT; pfWidth: ptr orxFLOAT;
                     pfHeight: ptr orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxText_GetSize", dynlib: libORX.}
## * Gets text string
##  @param[in]   _pstText      Concerned text
##  @return      Text string / orxSTRING_EMPTY
##

proc orxText_GetString*(pstText: ptr orxTEXT): cstring {.cdecl,
    importc: "orxText_GetString", dynlib: libORX.}
## * Gets text font
##  @param[in]   _pstText      Concerned text
##  @return      Text font / nil
##

proc orxText_GetFont*(pstText: ptr orxTEXT): ptr orxFONT {.cdecl,
    importc: "orxText_GetFont", dynlib: libORX.}
## * Sets text's size, will lead to reformatting if text doesn't fit (pass width = -1.0f to restore text's original size, ie. unconstrained)
##  @param[in]   _pstText      Concerned text
##  @param[in]   _fWidth       Max width for the text, remove any size constraint if negative
##  @param[in]   _fHeight      Max height for the text, ignored if negative (ie. unconstrained height)
##  @param[in]   _pzExtra      Text that wouldn't fit inside the box if height is provided, orxSTRING_EMPTY if no extra, nil to ignore
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxText_SetSize*(pstText: ptr orxTEXT; fWidth: orxFLOAT; fHeight: orxFLOAT;
                     pzExtra: cstringArray): orxSTATUS {.cdecl,
    importc: "orxText_SetSize", dynlib: libORX.}
## * Sets text string
##  @param[in]   _pstText      Concerned text
##  @param[in]   _zString      String to contain
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxText_SetString*(pstText: ptr orxTEXT; zString: cstring): orxSTATUS {.cdecl,
    importc: "orxText_SetString", dynlib: libORX.}
## * Sets text font
##  @param[in]   _pstText      Concerned text
##  @param[in]   _pstFont      Font / nil to use default
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxText_SetFont*(pstText: ptr orxTEXT; pstFont: ptr orxFONT): orxSTATUS {.cdecl,
    importc: "orxText_SetFont", dynlib: libORX.}
## * @}
