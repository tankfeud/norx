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

import incl, clock, camera, shaderPointer, display, texture, AABox

## * Viewport flags
##

const
  orxVIEWPORT_KU32_FLAG_ALIGN_CENTER* = 0x00000000
  orxVIEWPORT_KU32_FLAG_ALIGN_LEFT* = 0x10000000
  orxVIEWPORT_KU32_FLAG_ALIGN_RIGHT* = 0x20000000
  orxVIEWPORT_KU32_FLAG_ALIGN_TOP* = 0x40000000
  orxVIEWPORT_KU32_FLAG_ALIGN_BOTTOM* = 0x80000000
  orxVIEWPORT_KU32_FLAG_NO_DEBUG* = 0x01000000

## * Misc defined
##

const
  orxVIEWPORT_KU32_MAX_TEXTURE_NUMBER* = 8

## * Internal Viewport structure

type orxVIEWPORT* = object
## * Event enum
##

type
  orxVIEWPORT_EVENT* {.size: sizeof(cint).} = enum
    orxVIEWPORT_EVENT_RESIZE = 0, ## *< Event sent when a viewport has been resized
    orxVIEWPORT_EVENT_NUMBER, orxVIEWPORT_EVENT_NONE = orxENUM_NONE


## * Viewport module setup
##

proc orxViewport_Setup*() {.cdecl, importc: "orxViewport_Setup", dynlib: libORX.}
## * Inits the viewport module
##

proc orxViewport_Init*(): orxSTATUS {.cdecl, importc: "orxViewport_Init",
                                   dynlib: libORX.}
## * Exits from the viewport module
##

proc orxViewport_Exit*() {.cdecl, importc: "orxViewport_Exit", dynlib: libORX.}
## * Creates a viewport
##  @return      Created orxVIEWPORT / nil
##

proc orxViewport_Create*(): ptr orxVIEWPORT {.cdecl, importc: "orxViewport_Create",
    dynlib: libORX.}

## * Creates a viewport from config
##  @param[in]   _zConfigID    Config ID
##  @ return orxVIEWPORT / nil
##
proc orxViewport_CreateFromConfig*(zConfigID: cstring): ptr orxVIEWPORT {.cdecl,
    importc: "orxViewport_CreateFromConfig", dynlib: libORX.}

## * Deletes a viewport
##  @param[in]   _pstViewport    Viewport to delete
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##
proc orxViewport_Delete*(pstViewport: ptr orxVIEWPORT): orxSTATUS {.cdecl,
    importc: "orxViewport_Delete", dynlib: libORX.}

## * Sets a viewport texture list
##  @param[in]   _pstViewport    Concerned viewport
##  @param[in]   _u32TextureNumber Number of textures to associate with the viewport
##  @param[in]   _apstTextureList List of textures to associate with the viewport
##
proc orxViewport_SetTextureList*(pstViewport: ptr orxVIEWPORT;
                                u32TextureNumber: orxU32;
                                apstTextureList: ptr ptr orxTEXTURE) {.cdecl,
    importc: "orxViewport_SetTextureList", dynlib: libORX.}
## * Gets a viewport texture list
##  @param[in]   _pstViewport    Concerned viewport
##  @param[in]   _u32TextureNumber Number of textures to be retrieved
##  @param[out]  _apstTextureList List of textures associated with the viewport
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxViewport_GetTextureList*(pstViewport: ptr orxVIEWPORT;
                                u32TextureNumber: orxU32;
                                apstTextureList: ptr ptr orxTEXTURE): orxSTATUS {.
    cdecl, importc: "orxViewport_GetTextureList", dynlib: libORX.}
## * Gets a viewport texture count
##  @param[in]   _pstViewport    Concerned viewport
##  @return      Number of textures associated with the viewport
##

proc orxViewport_GetTextureCount*(pstViewport: ptr orxVIEWPORT): orxU32 {.cdecl,
    importc: "orxViewport_GetTextureCount", dynlib: libORX.}
## * Sets a viewport background color
##  @param[in]   _pstViewport    Concerned viewport
##  @param[in]   _pstColor        Color to use for background
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxViewport_SetBackgroundColor*(pstViewport: ptr orxVIEWPORT;
                                    pstColor: ptr orxCOLOR): orxSTATUS {.cdecl,
    importc: "orxViewport_SetBackgroundColor", dynlib: libORX.}
## * Clears viewport background color
##  @param[in]   _pstViewport    Concerned viewport
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxViewport_ClearBackgroundColor*(pstViewport: ptr orxVIEWPORT): orxSTATUS {.
    cdecl, importc: "orxViewport_ClearBackgroundColor", dynlib: libORX.}
## * Viewport has background color accessor
##  @param[in]   _pstViewport    Concerned viewport
##  @return      orxTRUE / orxFALSE
##

proc orxViewport_HasBackgroundColor*(pstViewport: ptr orxVIEWPORT): orxBOOL {.cdecl,
    importc: "orxViewport_HasBackgroundColor", dynlib: libORX.}
## * Gets a viewport background color
##  @param[in]   _pstViewport    Concerned viewport
##  @param[out]  _pstColor       Viewport's color
##  @return      Current background color
##

proc orxViewport_GetBackgroundColor*(pstViewport: ptr orxVIEWPORT;
                                    pstColor: ptr orxCOLOR): ptr orxCOLOR {.cdecl,
    importc: "orxViewport_GetBackgroundColor", dynlib: libORX.}
## * Enables / disables a viewport
##  @param[in]   _pstViewport    Concerned viewport
##  @param[in]   _bEnable        Enable / disable
##

proc orxViewport_Enable*(pstViewport: ptr orxVIEWPORT; bEnable: orxBOOL) {.cdecl,
    importc: "orxViewport_Enable", dynlib: libORX.}
## * Is a viewport enabled?
##  @param[in]   _pstViewport    Concerned viewport
##  @return      orxTRUE / orxFALSE
##

proc orxViewport_IsEnabled*(pstViewport: ptr orxVIEWPORT): orxBOOL {.cdecl,
    importc: "orxViewport_IsEnabled", dynlib: libORX.}
## * Sets a viewport camera
##  @param[in]   _pstViewport    Concerned viewport
##  @param[in]   _pstCamera      Associated camera
##

proc orxViewport_SetCamera*(pstViewport: ptr orxVIEWPORT; pstCamera: ptr orxCAMERA) {.
    cdecl, importc: "orxViewport_SetCamera", dynlib: libORX.}
## * Gets a viewport camera
##  @param[in]   _pstViewport    Concerned viewport
##  @return      Associated camera / nil
##

proc orxViewport_GetCamera*(pstViewport: ptr orxVIEWPORT): ptr orxCAMERA {.cdecl,
    importc: "orxViewport_GetCamera", dynlib: libORX.}
## * Adds a shader to a viewport using its config ID
##  @param[in]   _pstViewport      Concerned viewport
##  @param[in]   _zShaderConfigID  Config ID of the shader to add
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxViewport_AddShader*(pstViewport: ptr orxVIEWPORT;
                           zShaderConfigID: cstring): orxSTATUS {.cdecl,
    importc: "orxViewport_AddShader", dynlib: libORX.}
## * Removes a shader using its config ID
##  @param[in]   _pstViewport      Concerned viewport
##  @param[in]   _zShaderConfigID Config ID of the shader to remove
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxViewport_RemoveShader*(pstViewport: ptr orxVIEWPORT;
                              zShaderConfigID: cstring): orxSTATUS {.cdecl,
    importc: "orxViewport_RemoveShader", dynlib: libORX.}
## * Enables a viewport's shader
##  @param[in]   _pstViewport      Concerned viewport
##  @param[in]   _bEnable          Enable / disable
##

proc orxViewport_EnableShader*(pstViewport: ptr orxVIEWPORT; bEnable: orxBOOL) {.
    cdecl, importc: "orxViewport_EnableShader", dynlib: libORX.}
## * Is a viewport's shader enabled?
##  @param[in]   _pstViewport      Concerned viewport
##  @return      orxTRUE if enabled, orxFALSE otherwise
##

proc orxViewport_IsShaderEnabled*(pstViewport: ptr orxVIEWPORT): orxBOOL {.cdecl,
    importc: "orxViewport_IsShaderEnabled", dynlib: libORX.}
## * Gets a viewport's shader pointer
##  @param[in]   _pstViewport      Concerned viewport
##  @return      orxSHADERPOINTER / nil
##

proc orxViewport_GetShaderPointer*(pstViewport: ptr orxVIEWPORT): ptr orxSHADERPOINTER {.
    cdecl, importc: "orxViewport_GetShaderPointer", dynlib: libORX.}
## * Sets a viewport blend mode (only used when has active shaders attached)
##  @param[in]   _pstViewport    Concerned viewport
##  @param[in]   _eBlendMode     Blend mode to set
##

proc orxViewport_SetBlendMode*(pstViewport: ptr orxVIEWPORT;
                              eBlendMode: orxDISPLAY_BLEND_MODE): orxSTATUS {.
    cdecl, importc: "orxViewport_SetBlendMode", dynlib: libORX.}
## * Gets a viewport blend mode
##  @param[in]   _pstViewport    Concerned viewport
##  @return orxDISPLAY_BLEND_MODE
##

proc orxViewport_GetBlendMode*(pstViewport: ptr orxVIEWPORT): orxDISPLAY_BLEND_MODE {.
    cdecl, importc: "orxViewport_GetBlendMode", dynlib: libORX.}
## * Sets a viewport position
##  @param[in]   _pstViewport    Concerned viewport
##  @param[in]   _fX             X axis position (top left corner)
##  @param[in]   _fY             Y axis position (top left corner)
##

proc orxViewport_SetPosition*(pstViewport: ptr orxVIEWPORT; fX: orxFLOAT; fY: orxFLOAT) {.
    cdecl, importc: "orxViewport_SetPosition", dynlib: libORX.}
## * Sets a viewport relative position
##  @param[in]   _pstViewport    Concerned viewport
##  @param[in]   _u32AlignFlags  Alignment flags
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxViewport_SetRelativePosition*(pstViewport: ptr orxVIEWPORT;
                                     u32AlignFlags: orxU32): orxSTATUS {.cdecl,
    importc: "orxViewport_SetRelativePosition", dynlib: libORX.}
## * Gets a viewport position
##  @param[in]   _pstViewport    Concerned viewport
##  @param[out]  _pfX            X axis position (top left corner)
##  @param[out]  _pfY            Y axis position (top left corner)
##

proc orxViewport_GetPosition*(pstViewport: ptr orxVIEWPORT; pfX: ptr orxFLOAT;
                             pfY: ptr orxFLOAT) {.cdecl,
    importc: "orxViewport_GetPosition", dynlib: libORX.}
## * Sets a viewport size
##  @param[in]   _pstViewport    Concerned viewport
##  @param[in]   _fWidth         Width
##  @param[in]   _fHeight        Height
##

proc orxViewport_SetSize*(pstViewport: ptr orxVIEWPORT; fWidth: orxFLOAT;
                         fHeight: orxFLOAT) {.cdecl,
    importc: "orxViewport_SetSize", dynlib: libORX.}
## * Sets a viewport relative size
##  @param[in]   _pstViewport    Concerned viewport
##  @param[in]   _fWidth         Relative width (0.0f - 1.0f)
##  @param[in]   _fHeight        Relative height (0.0f - 1.0f)
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxViewport_SetRelativeSize*(pstViewport: ptr orxVIEWPORT; fWidth: orxFLOAT;
                                 fHeight: orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxViewport_SetRelativeSize", dynlib: libORX.}
## * Gets a viewport size
##  @param[in]   _pstViewport    Concerned viewport
##  @param[out]  _pfWidth        Width
##  @param[out]  _pfHeight       Height
##

proc orxViewport_GetSize*(pstViewport: ptr orxVIEWPORT; pfWidth: ptr orxFLOAT;
                         pfHeight: ptr orxFLOAT) {.cdecl,
    importc: "orxViewport_GetSize", dynlib: libORX.}
## * Gets a viewport relative size
##  @param[in]   _pstViewport    Concerned viewport
##  @param[out]  _pfWidth        Relative width
##  @param[out]  _pfHeight       Relative height
##

proc orxViewport_GetRelativeSize*(pstViewport: ptr orxVIEWPORT;
                                 pfWidth: ptr orxFLOAT; pfHeight: ptr orxFLOAT) {.
    cdecl, importc: "orxViewport_GetRelativeSize", dynlib: libORX.}
## * Gets an axis aligned box of viewport
##  @param[in]   _pstViewport    Concerned viewport
##  @param[out]  _pstBox         Output box
##  @return orxAABOX / nil
##

proc orxViewport_GetBox*(pstViewport: ptr orxVIEWPORT; pstBox: ptr orxAABOX): ptr orxAABOX {.
    cdecl, importc: "orxViewport_GetBox", dynlib: libORX.}
## * Get viewport correction ratio
##  @param[in]   _pstViewport  Concerned viewport
##  @return      Correction ratio value
##

proc orxViewport_GetCorrectionRatio*(pstViewport: ptr orxVIEWPORT): orxFLOAT {.cdecl,
    importc: "orxViewport_GetCorrectionRatio", dynlib: libORX.}
## * Gets viewport config name
##  @param[in]   _pstViewport    Concerned viewport
##  @return      orxSTRING / orxSTRING_EMPTY
##

proc orxViewport_GetName*(pstViewport: ptr orxVIEWPORT): cstring {.cdecl,
    importc: "orxViewport_GetName", dynlib: libORX.}
## * Gets viewport given its name
##  @param[in]   _zName          Camera name
##  @return      orxVIEWPORT / nil
##

proc orxViewport_Get*(zName: cstring): ptr orxVIEWPORT {.cdecl,
    importc: "orxViewport_Get", dynlib: libORX.}
## * @}
