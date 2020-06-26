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

import
  incl, structure, frame, vector

## * Spawner flags
##

const
  orxSPAWNER_KU32_FLAG_NONE* = 0x00000000
  orxSPAWNER_KU32_FLAG_AUTO_DELETE* = 0x00000001
  orxSPAWNER_KU32_FLAG_AUTO_RESET* = 0x00000002
  orxSPAWNER_KU32_FLAG_USE_ALPHA* = 0x00000004
  orxSPAWNER_KU32_FLAG_USE_COLOR* = 0x00000008
  orxSPAWNER_KU32_FLAG_USE_ROTATION* = 0x00000010
  orxSPAWNER_KU32_FLAG_USE_SCALE* = 0x00000020
  orxSPAWNER_KU32_FLAG_USE_RELATIVE_SPEED* = 0x00000040
  orxSPAWNER_KU32_FLAG_USE_SELF_AS_PARENT* = 0x00000080
  orxSPAWNER_KU32_FLAG_CLEAN_ON_DELETE* = 0x00000100
  orxSPAWNER_KU32_FLAG_INTERPOLATE* = 0x00000200
  orxSPAWNER_KU32_MASK_USER_ALL* = 0x000000FF

## * Event enum
##

type
  orxSPAWNER_EVENT* {.size: sizeof(cint).} = enum
    orxSPAWNER_EVENT_SPAWN = 0, orxSPAWNER_EVENT_CREATE, orxSPAWNER_EVENT_DELETE,
    orxSPAWNER_EVENT_RESET, orxSPAWNER_EVENT_EMPTY, orxSPAWNER_EVENT_WAVE_START,
    orxSPAWNER_EVENT_WAVE_STOP, orxSPAWNER_EVENT_NUMBER,
    orxSPAWNER_EVENT_NONE = orxENUM_NONE


## * Internal spawner structure

type orxSPAWNER* = object
## * Spawner module setup
##

proc orxSpawner_Setup*() {.cdecl, importc: "orxSpawner_Setup", dynlib: libORX.}
## * Inits the spawner module
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxSpawner_Init*(): orxSTATUS {.cdecl, importc: "orxSpawner_Init",
                                  dynlib: libORX.}
## * Exits from the spawner module
##

proc orxSpawner_Exit*() {.cdecl, importc: "orxSpawner_Exit", dynlib: libORX.}
## * Creates an empty spawner
##  @return orxSPAWNER / nil
##

proc orxSpawner_Create*(): ptr orxSPAWNER {.cdecl, importc: "orxSpawner_Create",
                                        dynlib: libORX.}
## * Creates a spawner from config
##  @param[in]   _zConfigID    Config ID
##  @ return orxSPAWNER / nil
##

proc orxSpawner_CreateFromConfig*(zConfigID: cstring): ptr orxSPAWNER {.cdecl,
    importc: "orxSpawner_CreateFromConfig", dynlib: libORX.}
## * Deletes a spawner
##  @param[in] _pstSpawner       Concerned spawner
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxSpawner_Delete*(pstSpawner: ptr orxSPAWNER): orxSTATUS {.cdecl,
    importc: "orxSpawner_Delete", dynlib: libORX.}
## * Enables/disables a spawner
##  @param[in]   _pstSpawner     Concerned spawner
##  @param[in]   _bEnable      Enable / disable
##

proc orxSpawner_Enable*(pstSpawner: ptr orxSPAWNER; bEnable: orxBOOL) {.cdecl,
    importc: "orxSpawner_Enable", dynlib: libORX.}
## * Is spawner enabled?
##  @param[in]   _pstSpawner     Concerned spawner
##  @return      orxTRUE if enabled, orxFALSE otherwise
##

proc orxSpawner_IsEnabled*(pstSpawner: ptr orxSPAWNER): orxBOOL {.cdecl,
    importc: "orxSpawner_IsEnabled", dynlib: libORX.}
## * Resets (and disables) a spawner
##  @param[in]   _pstSpawner     Concerned spawner
##

proc orxSpawner_Reset*(pstSpawner: ptr orxSPAWNER) {.cdecl,
    importc: "orxSpawner_Reset", dynlib: libORX.}
## * Sets spawner total object limit
##  @param[in]   _pstSpawner     Concerned spawner
##  @param[in]   _u32TotalObjectLimit Total object limit, 0 for unlimited
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxSpawner_SetTotalObjectLimit*(pstSpawner: ptr orxSPAWNER;
                                    u32TotalObjectLimit: orxU32): orxSTATUS {.
    cdecl, importc: "orxSpawner_SetTotalObjectLimit", dynlib: libORX.}
## * Sets spawner active object limit
##  @param[in]   _pstSpawner     Concerned spawner
##  @param[in]   _u32ActiveObjectLimit Active object limit, 0 for unlimited
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxSpawner_SetActiveObjectLimit*(pstSpawner: ptr orxSPAWNER;
                                     u32ActiveObjectLimit: orxU32): orxSTATUS {.
    cdecl, importc: "orxSpawner_SetActiveObjectLimit", dynlib: libORX.}
## * Gets spawner total object limit
##  @param[in]   _pstSpawner     Concerned spawner
##  @return      Total object limit, 0 for unlimited
##

proc orxSpawner_GetTotalObjectLimit*(pstSpawner: ptr orxSPAWNER): orxU32 {.cdecl,
    importc: "orxSpawner_GetTotalObjectLimit", dynlib: libORX.}
## * Gets spawner active object limit
##  @param[in]   _pstSpawner     Concerned spawner
##  @return      Active object limit, 0 for unlimited
##

proc orxSpawner_GetActiveObjectLimit*(pstSpawner: ptr orxSPAWNER): orxU32 {.cdecl,
    importc: "orxSpawner_GetActiveObjectLimit", dynlib: libORX.}
## * Gets spawner total object count
##  @param[in]   _pstSpawner     Concerned spawner
##  @return      Total object count
##

proc orxSpawner_GetTotalObjectCount*(pstSpawner: ptr orxSPAWNER): orxU32 {.cdecl,
    importc: "orxSpawner_GetTotalObjectCount", dynlib: libORX.}
## * Gets spawner active object count
##  @param[in]   _pstSpawner     Concerned spawner
##  @return      Active object count
##

proc orxSpawner_GetActiveObjectCount*(pstSpawner: ptr orxSPAWNER): orxU32 {.cdecl,
    importc: "orxSpawner_GetActiveObjectCount", dynlib: libORX.}
## * Sets spawner wave size
##  @param[in]   _pstSpawner     Concerned spawner
##  @param[in]   _u32WaveSize    Number of objects to spawn in a wave / 0 for deactivating wave mode
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxSpawner_SetWaveSize*(pstSpawner: ptr orxSPAWNER; u32WaveSize: orxU32): orxSTATUS {.
    cdecl, importc: "orxSpawner_SetWaveSize", dynlib: libORX.}
## * Sets spawner wave delay
##  @param[in]   _pstSpawner     Concerned spawner
##  @param[in]   _fWaveDelay     Delay between two waves / -1 for deactivating wave mode
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxSpawner_SetWaveDelay*(pstSpawner: ptr orxSPAWNER; fWaveDelay: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxSpawner_SetWaveDelay", dynlib: libORX.}
## * Gets spawner wave size
##  @param[in]   _pstSpawner     Concerned spawner
##  @return      Number of objects spawned in a wave / 0 if not in wave mode
##

proc orxSpawner_GetWaveSize*(pstSpawner: ptr orxSPAWNER): orxU32 {.cdecl,
    importc: "orxSpawner_GetWaveSize", dynlib: libORX.}
## * Gets spawner wave delay
##  @param[in]   _pstSpawner     Concerned spawner
##  @return      Delay between two waves / -1 if not in wave mode
##

proc orxSpawner_GetWaveDelay*(pstSpawner: ptr orxSPAWNER): orxFLOAT {.cdecl,
    importc: "orxSpawner_GetWaveDelay", dynlib: libORX.}
## * Gets spawner next wave delay
##  @param[in]   _pstSpawner     Concerned spawner
##  @return      Delay before next wave is spawned / -1 if not in wave mode
##

proc orxSpawner_GetNextWaveDelay*(pstSpawner: ptr orxSPAWNER): orxFLOAT {.cdecl,
    importc: "orxSpawner_GetNextWaveDelay", dynlib: libORX.}
## * Sets spawner object speed
##  @param[in]   _pstSpawner     Concerned spawner
##  @param[in]   _pvObjectSpeed  Speed to apply to every spawned object / nil to not apply any speed
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxSpawner_SetObjectSpeed*(pstSpawner: ptr orxSPAWNER;
                               pvObjectSpeed: ptr orxVECTOR): orxSTATUS {.cdecl,
    importc: "orxSpawner_SetObjectSpeed", dynlib: libORX.}
## * Gets spawner object speed
##  @param[in]   _pstSpawner     Concerned spawner
##  @param[in]   _pvObjectSpeed  Speed applied to every spawned object
##  @return      Speed applied to every spawned object / nil if none is applied
##

proc orxSpawner_GetObjectSpeed*(pstSpawner: ptr orxSPAWNER;
                               pvObjectSpeed: ptr orxVECTOR): ptr orxVECTOR {.cdecl,
    importc: "orxSpawner_GetObjectSpeed", dynlib: libORX.}
## * Spawns items
##  @param[in]   _pstSpawner     Concerned spawner
##  @param[in]   _u32Number      Number of items to spawn
##  @return      Number of spawned items
##

proc orxSpawner_Spawn*(pstSpawner: ptr orxSPAWNER; u32Number: orxU32): orxU32 {.cdecl,
    importc: "orxSpawner_Spawn", dynlib: libORX.}
## * Gets spawner frame
##  @param[in]   _pstSpawner     Concerned spawner
##  @return      orxFRAME
##

proc orxSpawner_GetFrame*(pstSpawner: ptr orxSPAWNER): ptr orxFRAME {.cdecl,
    importc: "orxSpawner_GetFrame", dynlib: libORX.}
## * Sets spawner position
##  @param[in]   _pstSpawner     Concerned spawner
##  @param[in]   _pvPosition     Spawner position
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxSpawner_SetPosition*(pstSpawner: ptr orxSPAWNER; pvPosition: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxSpawner_SetPosition", dynlib: libORX.}
## * Sets spawner rotation
##  @param[in]   _pstSpawner     Concerned spawner
##  @param[in]   _fRotation      Spawner rotation (radians)
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxSpawner_SetRotation*(pstSpawner: ptr orxSPAWNER; fRotation: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxSpawner_SetRotation", dynlib: libORX.}
## * Sets spawner scale
##  @param[in]   _pstSpawner     Concerned spawner
##  @param[in]   _pvScale        Spawner scale vector
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxSpawner_SetScale*(pstSpawner: ptr orxSPAWNER; pvScale: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxSpawner_SetScale", dynlib: libORX.}
## * Get spawner position
##  @param[in]   _pstSpawner     Concerned spawner
##  @param[out]  _pvPosition     Spawner position
##  @return      orxVECTOR / nil
##

proc orxSpawner_GetPosition*(pstSpawner: ptr orxSPAWNER; pvPosition: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxSpawner_GetPosition", dynlib: libORX.}
## * Get spawner world position
##  @param[in]   _pstSpawner     Concerned spawner
##  @param[out]  _pvPosition     Spawner world position
##  @return      orxVECTOR / nil
##

proc orxSpawner_GetWorldPosition*(pstSpawner: ptr orxSPAWNER;
                                 pvPosition: ptr orxVECTOR): ptr orxVECTOR {.cdecl,
    importc: "orxSpawner_GetWorldPosition", dynlib: libORX.}
## * Get spawner rotation
##  @param[in]   _pstSpawner     Concerned spawner
##  @return      orxFLOAT (radians)
##

proc orxSpawner_GetRotation*(pstSpawner: ptr orxSPAWNER): orxFLOAT {.cdecl,
    importc: "orxSpawner_GetRotation", dynlib: libORX.}
## * Get spawner world rotation
##  @param[in]   _pstSpawner     Concerned spawner
##  @return      orxFLOAT (radians)
##

proc orxSpawner_GetWorldRotation*(pstSpawner: ptr orxSPAWNER): orxFLOAT {.cdecl,
    importc: "orxSpawner_GetWorldRotation", dynlib: libORX.}
## * Get spawner scale
##  @param[in]   _pstSpawner     Concerned spawner
##  @param[out]  _pvScale        Spawner scale vector
##  @return      Scale vector
##

proc orxSpawner_GetScale*(pstSpawner: ptr orxSPAWNER; pvScale: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxSpawner_GetScale", dynlib: libORX.}
## * Gets spawner world scale
##  @param[in]   _pstSpawner     Concerned spawner
##  @param[out]  _pvScale        Spawner world scale
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxSpawner_GetWorldScale*(pstSpawner: ptr orxSPAWNER; pvScale: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxSpawner_GetWorldScale", dynlib: libORX.}
## * Sets spawner parent
##  @param[in]   _pstSpawner     Concerned spawner
##  @param[in]   _pParent        Parent structure to set (object, spawner, camera or frame) / nil
##  @return      orsSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxSpawner_SetParent*(pstSpawner: ptr orxSPAWNER; pParent: pointer): orxSTATUS {.
    cdecl, importc: "orxSpawner_SetParent", dynlib: libORX.}
## * Gets spawner parent
##  @param[in]   _pstSpawner Concerned spawner
##  @return      Parent (object, spawner, camera or frame) / nil
##

proc orxSpawner_GetParent*(pstSpawner: ptr orxSPAWNER): ptr orxSTRUCTURE {.cdecl,
    importc: "orxSpawner_GetParent", dynlib: libORX.}
## * Gets spawner name
##  @param[in]   _pstSpawner     Concerned spawner
##  @return      orxSTRING / orxSTRING_EMPTY
##

proc orxSpawner_GetName*(pstSpawner: ptr orxSPAWNER): cstring {.cdecl,
    importc: "orxSpawner_GetName", dynlib: libORX.}
## * @}
