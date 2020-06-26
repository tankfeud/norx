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

import incl, vector

## * Frame flags
##

const
  orxFRAME_KU32_FLAG_NONE* = 0x00000000
  orxFRAME_KU32_FLAG_SCROLL_X* = 0x00000001
  orxFRAME_KU32_FLAG_SCROLL_Y* = 0x00000002
  orxFRAME_KU32_MASK_SCROLL_BOTH* = 0x00000003
  orxFRAME_KU32_FLAG_DEPTH_SCALE* = 0x00000004
  orxFRAME_KU32_FLAG_FLIP_X* = 0x00000010
  orxFRAME_KU32_FLAG_FLIP_Y* = 0x00000020
  orxFRAME_KU32_MASK_FLIP_BOTH* = 0x00000030
  orxFRAME_KU32_FLAG_IGNORE_NONE* = 0x00000000
  orxFRAME_KU32_FLAG_IGNORE_ROTATION* = 0x00000100
  orxFRAME_KU32_FLAG_IGNORE_SCALE_X* = 0x00000200
  orxFRAME_KU32_FLAG_IGNORE_SCALE_Y* = 0x00000400
  orxFRAME_KU32_FLAG_IGNORE_SCALE_Z* = 0x00000800
  orxFRAME_KU32_MASK_IGNORE_SCALE* = 0x00000E00
  orxFRAME_KU32_FLAG_IGNORE_POSITION_ROTATION* = 0x00001000
  orxFRAME_KU32_FLAG_IGNORE_POSITION_SCALE_X* = 0x00002000
  orxFRAME_KU32_FLAG_IGNORE_POSITION_SCALE_Y* = 0x00004000
  orxFRAME_KU32_FLAG_IGNORE_POSITION_SCALE_Z* = 0x00008000
  orxFRAME_KU32_MASK_IGNORE_POSITION_SCALE* = 0x0000E000
  orxFRAME_KU32_FLAG_IGNORE_POSITION_POSITION_X* = 0x00010000
  orxFRAME_KU32_FLAG_IGNORE_POSITION_POSITION_Y* = 0x00020000
  orxFRAME_KU32_FLAG_IGNORE_POSITION_POSITION_Z* = 0x00040000
  orxFRAME_KU32_MASK_IGNORE_POSITION_POSITION* = 0x00070000
  orxFRAME_KU32_MASK_IGNORE_POSITION* = 0x0007F000
  orxFRAME_KU32_MASK_IGNORE_ALL* = 0x0007FF00
  orxFRAME_KU32_MASK_USER_ALL* = 0x0007FFFF

## * Frame space enum
##

type
  orxFRAME_SPACE* {.size: sizeof(cint).} = enum
    orxFRAME_SPACE_GLOBAL = 0, orxFRAME_SPACE_LOCAL, orxFRAME_SPACE_NUMBER,
    orxFRAME_SPACE_NONE = orxENUM_NONE


## * Internal Frame structure
##

type orxFRAME* = object
## * Get ignore flag values
##  @param[in]   _zFlags         Literal ignore flags
##  @return Ignore flags
##

proc orxFrame_GetIgnoreFlagValues*(zFlags: cstring): orxU32 {.cdecl,
    importc: "orxFrame_GetIgnoreFlagValues", dynlib: libORX.}
## * Get ignore flag names (beware: result won't persist from one call to the other)
##  @param[in]   _zFlags         Literal ignore flags
##  @return Ignore flags names
##

proc orxFrame_GetIgnoreFlagNames*(u32Flags: orxU32): cstring {.cdecl,
    importc: "orxFrame_GetIgnoreFlagNames", dynlib: libORX.}
## * Setups the frame module
##

proc orxFrame_Setup*() {.cdecl, importc: "orxFrame_Setup", dynlib: libORX.}
## * Inits the frame module
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxFrame_Init*(): orxSTATUS {.cdecl, importc: "orxFrame_Init",
                                dynlib: libORX.}
## * Exits from the frame module
##

proc orxFrame_Exit*() {.cdecl, importc: "orxFrame_Exit", dynlib: libORX.}
## * Creates a frame
##  @param[in]   _u32Flags       Flags for created animation
##  @return      Created orxFRAME / nil
##

proc orxFrame_Create*(u32Flags: orxU32): ptr orxFRAME {.cdecl,
    importc: "orxFrame_Create", dynlib: libORX.}
## * Deletes a frame
##  @param[in]   _pstFrame       Frame to delete
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxFrame_Delete*(pstFrame: ptr orxFRAME): orxSTATUS {.cdecl,
    importc: "orxFrame_Delete", dynlib: libORX.}
## * Sets frame parent
##  @param[in]   _pstFrame       Concerned frame
##  @param[in]   _pstParent      Parent frame to set
##

proc orxFrame_SetParent*(pstFrame: ptr orxFRAME; pstParent: ptr orxFRAME) {.cdecl,
    importc: "orxFrame_SetParent", dynlib: libORX.}
## * Get frame parent
##  @param[in]   _pstFrame       Concerned frame
##  @return orxFRAME / nil
##

proc orxFrame_GetParent*(pstFrame: ptr orxFRAME): ptr orxFRAME {.cdecl,
    importc: "orxFrame_GetParent", dynlib: libORX.}
## * Gets frame first child
##  @param[in]   _pstFrame       Concerned frame
##  @return orxFRAME / nil
##

proc orxFrame_GetChild*(pstFrame: ptr orxFRAME): ptr orxFRAME {.cdecl,
    importc: "orxFrame_GetChild", dynlib: libORX.}
## * Gets frame next sibling
##  @param[in]   _pstFrame       Concerned frame
##  @return orxFRAME / nil
##

proc orxFrame_GetSibling*(pstFrame: ptr orxFRAME): ptr orxFRAME {.cdecl,
    importc: "orxFrame_GetSibling", dynlib: libORX.}
## * Is a root child?
##  @param[in]   _pstFrame       Concerned frame
##  @return orxTRUE if its parent is root, orxFALSE otherwise
##

proc orxFrame_IsRootChild*(pstFrame: ptr orxFRAME): orxBOOL {.cdecl,
    importc: "orxFrame_IsRootChild", dynlib: libORX.}
## * Sets frame position
##  @param[in]   _pstFrame       Concerned frame
##  @param[in]   _eSpace         Coordinate space system to use
##  @param[in]   _pvPos          Position to set
##

proc orxFrame_SetPosition*(pstFrame: ptr orxFRAME; eSpace: orxFRAME_SPACE;
                          pvPos: ptr orxVECTOR) {.cdecl,
    importc: "orxFrame_SetPosition", dynlib: libORX.}
## * Sets frame rotation
##  @param[in]   _pstFrame       Concerned frame
##  @param[in]   _eSpace         Coordinate space system to use
##  @param[in]   _fRotation      Rotation angle to set (radians)
##

proc orxFrame_SetRotation*(pstFrame: ptr orxFRAME; eSpace: orxFRAME_SPACE;
                          fRotation: orxFLOAT) {.cdecl,
    importc: "orxFrame_SetRotation", dynlib: libORX.}
## * Sets frame scale
##  @param[in]   _pstFrame       Concerned frame
##  @param[in]   _eSpace         Coordinate space system to use
##  @param[in]   _pvScale        Scale to set
##

proc orxFrame_SetScale*(pstFrame: ptr orxFRAME; eSpace: orxFRAME_SPACE;
                       pvScale: ptr orxVECTOR) {.cdecl,
    importc: "orxFrame_SetScale", dynlib: libORX.}
## * Gets frame position
##  @param[in]   _pstFrame       Concerned frame
##  @param[in]   _eSpace         Coordinate space system to use
##  @param[out]  _pvPos          Position of the given frame
##  @return orxVECTOR / nil
##

proc orxFrame_GetPosition*(pstFrame: ptr orxFRAME; eSpace: orxFRAME_SPACE;
                          pvPos: ptr orxVECTOR): ptr orxVECTOR {.cdecl,
    importc: "orxFrame_GetPosition", dynlib: libORX.}
## * Gets frame rotation
##  @param[in]   _pstFrame       Concerned frame
##  @param[in]   _eSpace         Coordinate space system to use
##  @return Rotation of the given frame (radians)
##

proc orxFrame_GetRotation*(pstFrame: ptr orxFRAME; eSpace: orxFRAME_SPACE): orxFLOAT {.
    cdecl, importc: "orxFrame_GetRotation", dynlib: libORX.}
## * Gets frame scale
##  @param[in]   _pstFrame       Concerned frame
##  @param[in]   _eSpace         Coordinate space system to use
##  @param[out]  _pvScale        Scale
##  @return      orxVECTOR / nil
##

proc orxFrame_GetScale*(pstFrame: ptr orxFRAME; eSpace: orxFRAME_SPACE;
                       pvScale: ptr orxVECTOR): ptr orxVECTOR {.cdecl,
    importc: "orxFrame_GetScale", dynlib: libORX.}
## * Transforms a position given its input space (local -> global or global -> local)
##  @param[in]   _pstFrame       Concerned frame
##  @param[in]   _eSpace         Input coordinate space system to use
##  @param[out]  _pvPos          Concerned position
##  @return orxVECTOR / nil
##

proc orxFrame_TransformPosition*(pstFrame: ptr orxFRAME; eSpace: orxFRAME_SPACE;
                                pvPos: ptr orxVECTOR): ptr orxVECTOR {.cdecl,
    importc: "orxFrame_TransformPosition", dynlib: libORX.}
## * Transforms a rotation given its input space (local -> global or global -> local)
##  @param[in]   _pstFrame       Concerned frame
##  @param[in]   _eSpace         Input coordinate space system to use
##  @param[out]  _fRotation      Concerned rotation
##  @return Transformed rotation (radians)
##

proc orxFrame_TransformRotation*(pstFrame: ptr orxFRAME; eSpace: orxFRAME_SPACE;
                                fRotation: orxFLOAT): orxFLOAT {.cdecl,
    importc: "orxFrame_TransformRotation", dynlib: libORX.}
## * Transforms a scale given its input space (local -> global or global -> local)
##  @param[in]   _pstFrame       Concerned frame
##  @param[in]   _eSpace         Input coordinate space system to use
##  @param[out]  _pvScale        Concerned scale
##  @return      orxVECTOR / nil
##

proc orxFrame_TransformScale*(pstFrame: ptr orxFRAME; eSpace: orxFRAME_SPACE;
                             pvScale: ptr orxVECTOR): ptr orxVECTOR {.cdecl,
    importc: "orxFrame_TransformScale", dynlib: libORX.}
## * @}
