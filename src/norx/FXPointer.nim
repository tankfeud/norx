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

import incl, structure, FX

## * Misc defines
##

const
  orxFXPOINTER_KU32_FX_NUMBER* = 8

## * Internal FXPointer structure

type orxFXPOINTER* = object
## * FXPointer module setup
##

proc orxFXPointer_Setup*() {.cdecl, importc: "orxFXPointer_Setup",
                           dynlib: libORX.}
## * Inits the FXPointer module
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxFXPointer_Init*(): orxSTATUS {.cdecl, importc: "orxFXPointer_Init",
                                    dynlib: libORX.}
## * Exits from the FXPointer module
##

proc orxFXPointer_Exit*() {.cdecl, importc: "orxFXPointer_Exit", dynlib: libORX.}
## * Creates an empty FXPointer
##  @return orxFXPOINTER / nil
##

proc orxFXPointer_Create*(): ptr orxFXPOINTER {.cdecl,
    importc: "orxFXPointer_Create", dynlib: libORX.}
## * Deletes an FXPointer
##  @param[in] _pstFXPointer     Concerned FXPointer
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxFXPointer_Delete*(pstFXPointer: ptr orxFXPOINTER): orxSTATUS {.cdecl,
    importc: "orxFXPointer_Delete", dynlib: libORX.}
## * Enables/disables an FXPointer
##  @param[in]   _pstFXPointer   Concerned FXPointer
##  @param[in]   _bEnable        Enable / disable
##

proc orxFXPointer_Enable*(pstFXPointer: ptr orxFXPOINTER; bEnable: orxBOOL) {.cdecl,
    importc: "orxFXPointer_Enable", dynlib: libORX.}
## * Is FXPointer enabled?
##  @param[in]   _pstFXPointer   Concerned FXPointer
##  @return      orxTRUE if enabled, orxFALSE otherwise
##

proc orxFXPointer_IsEnabled*(pstFXPointer: ptr orxFXPOINTER): orxBOOL {.cdecl,
    importc: "orxFXPointer_IsEnabled", dynlib: libORX.}
## * Adds an FX
##  @param[in]   _pstFXPointer Concerned FXPointer
##  @param[in]   _pstFX        FX to add
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxFXPointer_AddFX*(pstFXPointer: ptr orxFXPOINTER; pstFX: ptr orxFX): orxSTATUS {.
    cdecl, importc: "orxFXPointer_AddFX", dynlib: libORX.}
## * Adds a delayed FX
##  @param[in]   _pstFXPointer Concerned FXPointer
##  @param[in]   _pstFX        FX to add
##  @param[in]   _fDelay       Delay time
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxFXPointer_AddDelayedFX*(pstFXPointer: ptr orxFXPOINTER; pstFX: ptr orxFX;
                               fDelay: orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxFXPointer_AddDelayedFX", dynlib: libORX.}
## * Removes an FX
##  @param[in]   _pstFXPointer Concerned FXPointer
##  @param[in]   _pstFX        FX to remove
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxFXPointer_RemoveFX*(pstFXPointer: ptr orxFXPOINTER; pstFX: ptr orxFX): orxSTATUS {.
    cdecl, importc: "orxFXPointer_RemoveFX", dynlib: libORX.}
## * Adds an FX using its config ID
##  @param[in]   _pstFXPointer Concerned FXPointer
##  @param[in]   _zFXConfigID  Config ID of the FX to add
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxFXPointer_AddFXFromConfig*(pstFXPointer: ptr orxFXPOINTER;
                                  zFXConfigID: cstring): orxSTATUS {.cdecl,
    importc: "orxFXPointer_AddFXFromConfig", dynlib: libORX.}
## * Adds a unique FX using its config ID
##  @param[in]   _pstFXPointer Concerned FXPointer
##  @param[in]   _zFXConfigID  Config ID of the FX to add
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxFXPointer_AddUniqueFXFromConfig*(pstFXPointer: ptr orxFXPOINTER;
                                        zFXConfigID: cstring): orxSTATUS {.
    cdecl, importc: "orxFXPointer_AddUniqueFXFromConfig", dynlib: libORX.}
## * Adds a delayed FX using its config ID
##  @param[in]   _pstFXPointer Concerned FXPointer
##  @param[in]   _zFXConfigID  Config ID of the FX to add
##  @param[in]   _fDelay       Delay time
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxFXPointer_AddDelayedFXFromConfig*(pstFXPointer: ptr orxFXPOINTER;
    zFXConfigID: cstring; fDelay: orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxFXPointer_AddDelayedFXFromConfig", dynlib: libORX.}
## * Adds a unique delayed FX using its config ID
##  @param[in]   _pstFXPointer Concerned FXPointer
##  @param[in]   _zFXConfigID  Config ID of the FX to add
##  @param[in]   _fDelay       Delay time
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxFXPointer_AddUniqueDelayedFXFromConfig*(pstFXPointer: ptr orxFXPOINTER;
    zFXConfigID: cstring; fDelay: orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxFXPointer_AddUniqueDelayedFXFromConfig", dynlib: libORX.}
## * Removes an FX using its config ID
##  @param[in]   _pstFXPointer Concerned FXPointer
##  @param[in]   _zFXConfigID  Config ID of the FX to remove
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxFXPointer_RemoveFXFromConfig*(pstFXPointer: ptr orxFXPOINTER;
                                     zFXConfigID: cstring): orxSTATUS {.cdecl,
    importc: "orxFXPointer_RemoveFXFromConfig", dynlib: libORX.}
## * Synchronizes FX times with an other orxFXPointer if they share common FXs
##  @param[in]   _pstFXPointer Concerned FXPointer
##  @param[in]   _pstModel     Model FX pointer to use for synchronization
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxFXPointer_Synchronize*(pstFXPointer: ptr orxFXPOINTER;
                              pstModel: ptr orxFXPOINTER): orxSTATUS {.cdecl,
    importc: "orxFXPointer_Synchronize", dynlib: libORX.}
## * FXPointer time get accessor
##  @param[in]   _pstFXPointer Concerned FXPointer
##  @return      orxFLOAT
##

proc orxFXPointer_GetTime*(pstFXPointer: ptr orxFXPOINTER): orxFLOAT {.cdecl,
    importc: "orxFXPointer_GetTime", dynlib: libORX.}
## * Gets how many FXs are currently in use
##  @param[in]   _pstFXPointer Concerned FXPointer
##  @return      orxU32
##

proc orxFXPointer_GetCount*(pstFXPointer: ptr orxFXPOINTER): orxU32 {.cdecl,
    importc: "orxFXPointer_GetCount", dynlib: libORX.}
## * FXPointer time set accessor
##  @param[in]   _pstFXPointer Concerned FXPointer
##  @param[in]   _fTime        Time to set
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxFXPointer_SetTime*(pstFXPointer: ptr orxFXPOINTER; fTime: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxFXPointer_SetTime", dynlib: libORX.}
## * @}
