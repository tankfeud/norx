import incl, structure, FX

## * Misc defines
##

const
  orxFXPOINTER_KU32_FX_NUMBER* = 8

## * Internal FXPointer structure

type orxFXPOINTER* = object

proc FXPointerSetup*() {.cdecl, importc: "orxFXPointer_Setup",
                           dynlib: libORX.}
  ## FXPointer module setup

proc FXPointerInit*(): orxSTATUS {.cdecl, importc: "orxFXPointer_Init",
                                    dynlib: libORX.}
  ## Inits the FXPointer module
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc FXPointerExit*() {.cdecl, importc: "orxFXPointer_Exit", dynlib: libORX.}
  ## Exits from the FXPointer module

proc FXPointerCreate*(): ptr orxFXPOINTER {.cdecl,
    importc: "orxFXPointer_Create", dynlib: libORX.}
  ## Creates an empty FXPointer
  ##  @return orxFXPOINTER / nil

proc delete*(pstFXPointer: ptr orxFXPOINTER): orxSTATUS {.cdecl,
    importc: "orxFXPointer_Delete", dynlib: libORX.}
  ## Deletes an FXPointer
  ##  @param[in] _pstFXPointer     Concerned FXPointer
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc enable*(pstFXPointer: ptr orxFXPOINTER; bEnable: orxBOOL) {.cdecl,
    importc: "orxFXPointer_Enable", dynlib: libORX.}
  ## Enables/disables an FXPointer
  ##  @param[in]   _pstFXPointer   Concerned FXPointer
  ##  @param[in]   _bEnable        Enable / disable

proc isEnabled*(pstFXPointer: ptr orxFXPOINTER): orxBOOL {.cdecl,
    importc: "orxFXPointer_IsEnabled", dynlib: libORX.}
  ## Is FXPointer enabled?
  ##  @param[in]   _pstFXPointer   Concerned FXPointer
  ##  @return      orxTRUE if enabled, orxFALSE otherwise

proc addFX*(pstFXPointer: ptr orxFXPOINTER; pstFX: ptr orxFX): orxSTATUS {.
    cdecl, importc: "orxFXPointer_AddFX", dynlib: libORX.}
  ## Adds an FX
  ##  @param[in]   _pstFXPointer Concerned FXPointer
  ##  @param[in]   _pstFX        FX to add
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc addDelayedFX*(pstFXPointer: ptr orxFXPOINTER; pstFX: ptr orxFX;
                               fDelay: orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxFXPointer_AddDelayedFX", dynlib: libORX.}
  ## Adds a delayed FX
  ##  @param[in]   _pstFXPointer Concerned FXPointer
  ##  @param[in]   _pstFX        FX to add
  ##  @param[in]   _fDelay       Delay time
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc removeFX*(pstFXPointer: ptr orxFXPOINTER; pstFX: ptr orxFX): orxSTATUS {.
    cdecl, importc: "orxFXPointer_RemoveFX", dynlib: libORX.}
  ## Removes an FX
  ##  @param[in]   _pstFXPointer Concerned FXPointer
  ##  @param[in]   _pstFX        FX to remove
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc removeAllFXs*(pstFXPointer: ptr orxFXPOINTER): orxSTATUS {.
    cdecl, importc: "orxFXPointer_RemoveAllFXs", dynlib: libORX.}
  ## Removes all FXs
  ##  @param[in]   _pstFXPointer Concerned FXPointer
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc addFXFromConfig*(pstFXPointer: ptr orxFXPOINTER;
                                  zFXConfigID: cstring): orxSTATUS {.cdecl,
    importc: "orxFXPointer_AddFXFromConfig", dynlib: libORX.}
  ## Adds an FX using its config ID
  ##  @param[in]   _pstFXPointer Concerned FXPointer
  ##  @param[in]   _zFXConfigID  Config ID of the FX to add
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc addUniqueFXFromConfig*(pstFXPointer: ptr orxFXPOINTER;
                                        zFXConfigID: cstring): orxSTATUS {.
    cdecl, importc: "orxFXPointer_AddUniqueFXFromConfig", dynlib: libORX.}
  ## Adds a unique FX using its config ID
  ##  @param[in]   _pstFXPointer Concerned FXPointer
  ##  @param[in]   _zFXConfigID  Config ID of the FX to add
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc addDelayedFXFromConfig*(pstFXPointer: ptr orxFXPOINTER;
    zFXConfigID: cstring; fDelay: orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxFXPointer_AddDelayedFXFromConfig", dynlib: libORX.}
  ## Adds a delayed FX using its config ID
  ##  @param[in]   _pstFXPointer Concerned FXPointer
  ##  @param[in]   _zFXConfigID  Config ID of the FX to add
  ##  @param[in]   _fDelay       Delay time
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc addUniqueDelayedFXFromConfig*(pstFXPointer: ptr orxFXPOINTER;
    zFXConfigID: cstring; fDelay: orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxFXPointer_AddUniqueDelayedFXFromConfig", dynlib: libORX.}
  ## Adds a unique delayed FX using its config ID
  ##  @param[in]   _pstFXPointer Concerned FXPointer
  ##  @param[in]   _zFXConfigID  Config ID of the FX to add
  ##  @param[in]   _fDelay       Delay time
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc removeFXFromConfig*(pstFXPointer: ptr orxFXPOINTER;
                                     zFXConfigID: cstring): orxSTATUS {.cdecl,
    importc: "orxFXPointer_RemoveFXFromConfig", dynlib: libORX.}
  ## Removes an FX using its config ID
  ##  @param[in]   _pstFXPointer Concerned FXPointer
  ##  @param[in]   _zFXConfigID  Config ID of the FX to remove
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc synchronize*(pstFXPointer: ptr orxFXPOINTER;
                              pstModel: ptr orxFXPOINTER): orxSTATUS {.cdecl,
    importc: "orxFXPointer_Synchronize", dynlib: libORX.}
  ## Synchronizes FX times with an other orxFXPointer if they share common FXs
  ##  @param[in]   _pstFXPointer Concerned FXPointer
  ##  @param[in]   _pstModel     Model FX pointer to use for synchronization
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getTime*(pstFXPointer: ptr orxFXPOINTER): orxFLOAT {.cdecl,
    importc: "orxFXPointer_GetTime", dynlib: libORX.}
  ## FXPointer time get accessor
  ##  @param[in]   _pstFXPointer Concerned FXPointer
  ##  @return      orxFLOAT

proc getCount*(pstFXPointer: ptr orxFXPOINTER): orxU32 {.cdecl,
    importc: "orxFXPointer_GetCount", dynlib: libORX.}
  ## Gets how many FXs are currently in use
  ##  @param[in]   _pstFXPointer Concerned FXPointer
  ##  @return      orxU32

proc setTime*(pstFXPointer: ptr orxFXPOINTER; fTime: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxFXPointer_SetTime", dynlib: libORX.}
  ## FXPointer time set accessor
  ##  @param[in]   _pstFXPointer Concerned FXPointer
  ##  @param[in]   _fTime        Time to set
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

