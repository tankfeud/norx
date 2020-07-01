import incl, animSet, structure


## * Internal AnimPointer structure
##

type orxANIMPOINTER* = object
proc animPointerSetup*() {.cdecl, importc: "orxAnimPointer_Setup",
                             dynlib: libORX.}
  ## AnimPointer module setup

proc animPointerInit*(): orxSTATUS {.cdecl, importc: "orxAnimPointer_Init",
                                      dynlib: libORX.}
  ## Inits the AnimPointer module
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc animPointerExit*() {.cdecl, importc: "orxAnimPointer_Exit",
                            dynlib: libORX.}
  ## Exits from the AnimPointer module

proc animPointerCreate*(pstAnimSet: ptr orxANIMSET): ptr orxANIMPOINTER {.cdecl,
    importc: "orxAnimPointer_Create", dynlib: libORX.}
  ## Creates an empty AnimPointer
  ##  @param[in]   _pstAnimSet                   AnimSet reference
  ##  @return      orxANIMPOINTER / nil

proc animPointerCreateFromConfig*(zConfigID: cstring): ptr orxANIMPOINTER {.
    cdecl, importc: "orxAnimPointer_CreateFromConfig", dynlib: libORX.}
  ## Creates an animation pointer from config
  ##  @param[in]   _zConfigID                    Config ID
  ##  @return      orxANIMPOINTER / nil

proc delete*(pstAnimPointer: ptr orxANIMPOINTER): orxSTATUS {.cdecl,
    importc: "orxAnimPointer_Delete", dynlib: libORX.}
  ## Deletes an AnimPointer
  ##  @param[in]   _pstAnimPointer               AnimPointer to delete
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getAnimSet*(pstAnimPointer: ptr orxANIMPOINTER): ptr orxANIMSET {.
    cdecl, importc: "orxAnimPointer_GetAnimSet", dynlib: libORX.}
  ## Gets the referenced AnimSet
  ##  @param[in]   _pstAnimPointer               Concerned AnimPointer
  ##  @return      Referenced orxANIMSET

proc getCurrentAnim*(pstAnimPointer: ptr orxANIMPOINTER): orxU32 {.
    cdecl, importc: "orxAnimPointer_GetCurrentAnim", dynlib: libORX.}
  ## AnimPointer current Animation get accessor
  ##  @param[in]   _pstAnimPointer               Concerned AnimPointer
  ##  @return      Current Animation ID

proc getTargetAnim*(pstAnimPointer: ptr orxANIMPOINTER): orxU32 {.
    cdecl, importc: "orxAnimPointer_GetTargetAnim", dynlib: libORX.}
  ## AnimPointer target Animation get accessor
  ##  @param[in]   _pstAnimPointer               Concerned AnimPointer
  ##  @return      Target Animation ID

proc getCurrentAnimName*(pstAnimPointer: ptr orxANIMPOINTER): cstring {.
    cdecl, importc: "orxAnimPointer_GetCurrentAnimName", dynlib: libORX.}
  ## AnimPointer current Animation name get accessor
  ##  @param[in]   _pstAnimPointer               Concerned AnimPointer
  ##  @return      Current Animation name / orxSTRING_EMPTY

proc getTargetAnimName*(pstAnimPointer: ptr orxANIMPOINTER): cstring {.
    cdecl, importc: "orxAnimPointer_GetTargetAnimName", dynlib: libORX.}
  ## AnimPointer target Animation ID get accessor
  ##  @param[in]   _pstAnimPointer               Concerned AnimPointer
  ##  @return      Target Animation name / orxSTRING_EMPTY

proc getCurrentAnimData*(pstAnimPointer: ptr orxANIMPOINTER): ptr orxSTRUCTURE {.
    cdecl, importc: "orxAnimPointer_GetCurrentAnimData", dynlib: libORX.}
  ## AnimPointer current anim data get accessor
  ##  @param[in]   _pstAnimPointer               Concerned AnimPointer
  ##  @return      Current anim data / nil

proc getTime*(pstAnimPointer: ptr orxANIMPOINTER): orxFLOAT {.cdecl,
    importc: "orxAnimPointer_GetTime", dynlib: libORX.}
  ## AnimPointer time get accessor
  ##  @param[in]   _pstAnimPointer               Concerned AnimPointer
  ##  @return      Current time

proc getFrequency*(pstAnimPointer: ptr orxANIMPOINTER): orxFLOAT {.
    cdecl, importc: "orxAnimPointer_GetFrequency", dynlib: libORX.}
  ## AnimPointer frequency get accessor
  ##  @param[in]   _pstAnimPointer               Concerned AnimPointer
  ##  @return      AnimPointer frequency

proc setCurrentAnim*(pstAnimPointer: ptr orxANIMPOINTER;
                                   u32AnimID: orxU32): orxSTATUS {.cdecl,
    importc: "orxAnimPointer_SetCurrentAnim", dynlib: libORX.}
  ## AnimPointer current Animation set accessor
  ##  @param[in]   _pstAnimPointer               Concerned AnimPointer
  ##  @param[in]   _u32AnimID                    Animation ID to set
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setTargetAnim*(pstAnimPointer: ptr orxANIMPOINTER;
                                  u32AnimID: orxU32): orxSTATUS {.cdecl,
    importc: "orxAnimPointer_SetTargetAnim", dynlib: libORX.}
  ## AnimPointer target Animation set accessor
  ##  @param[in]   _pstAnimPointer               Concerned AnimPointer
  ##  @param[in]   _u32AnimID                    Animation ID to set / orxU32_UNDEFINED
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setCurrentAnimFromName*(pstAnimPointer: ptr orxANIMPOINTER;
    zAnimName: cstring): orxSTATUS {.cdecl, importc: "orxAnimPointer_SetCurrentAnimFromName",
                                     dynlib: libORX.}
  ## AnimPointer current Animation set accessor using name
  ##  @param[in]   _pstAnimPointer               Concerned AnimPointer
  ##  @param[in]   _zAnimName                    Animation name (config's name) to set
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setTargetAnimFromName*(pstAnimPointer: ptr orxANIMPOINTER;
    zAnimName: cstring): orxSTATUS {.cdecl, importc: "orxAnimPointer_SetTargetAnimFromName",
                                     dynlib: libORX.}
  ## AnimPointer target Animation set accessor using name
  ##  @param[in]   _pstAnimPointer               Concerned AnimPointer
  ##  @param[in]   _zAnimName                    Animation name (config's name) to set / nil
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setTime*(pstAnimPointer: ptr orxANIMPOINTER; fTime: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxAnimPointer_SetTime", dynlib: libORX.}
  ## AnimPointer current time set accessor
  ##  @param[in]   _pstAnimPointer               Concerned AnimPointer
  ##  @param[in]   _fTime                        Time to set
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setFrequency*(pstAnimPointer: ptr orxANIMPOINTER;
                                 fFrequency: orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxAnimPointer_SetFrequency", dynlib: libORX.}
  ## AnimPointer frequency set accessor
  ##  @param[in]   _pstAnimPointer               Concerned AnimPointer
  ##  @param[in]   _fFrequency                   Frequency to set
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc pause*(pstAnimPointer: ptr orxANIMPOINTER; bPause: orxBOOL): orxSTATUS {.
    cdecl, importc: "orxAnimPointer_Pause", dynlib: libORX.}
  ## AnimPointer pause accessor
  ##  @param[in]   _pstAnimPointer               Concerned AnimPointer
  ##  @param[in]   _bPause                       Pause / Unpause
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

