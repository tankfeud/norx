import
  incl, sound, structure


## * Misc defines
##

const
  orxSOUNDPOINTER_KU32_SOUND_NUMBER* = 4

## * Internal SoundPointer structure

type orxSOUNDPOINTER* = object

proc soundPointerSetup*() {.cdecl, importc: "orxSoundPointer_Setup",
                              dynlib: libORX.}
  ## SoundPointer module setup

proc soundPointerInit*(): orxSTATUS {.cdecl, importc: "orxSoundPointer_Init",
                                       dynlib: libORX.}
  ## Inits the SoundPointer module
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc soundPointerExit*() {.cdecl, importc: "orxSoundPointer_Exit",
                             dynlib: libORX.}
  ## Exits from the SoundPointer module

proc soundPointerCreate*(): ptr orxSOUNDPOINTER {.cdecl,
    importc: "orxSoundPointer_Create", dynlib: libORX.}
  ## Creates an empty SoundPointer
  ##  @return orxSOUNDPOINTER / nil

proc delete*(pstSoundPointer: ptr orxSOUNDPOINTER): orxSTATUS {.
    cdecl, importc: "orxSoundPointer_Delete", dynlib: libORX.}
  ## Deletes a SoundPointer
  ##  @param[in] _pstSoundPointer      Concerned SoundPointer
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc enable*(pstSoundPointer: ptr orxSOUNDPOINTER; bEnable: orxBOOL) {.
    cdecl, importc: "orxSoundPointer_Enable", dynlib: libORX.}
  ## Enables/disables a SoundPointer
  ##  @param[in]   _pstSoundPointer    Concerned SoundPointer
  ##  @param[in]   _bEnable        Enable / disable

proc isEnabled*(pstSoundPointer: ptr orxSOUNDPOINTER): orxBOOL {.
    cdecl, importc: "orxSoundPointer_IsEnabled", dynlib: libORX.}
  ## Is SoundPointer enabled?
  ##  @param[in]   _pstSoundPointer    Concerned SoundPointer
  ##  @return      orxTRUE if enabled, orxFALSE otherwise

proc setVolume*(pstSoundPointer: ptr orxSOUNDPOINTER;
                               fVolume: orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxSoundPointer_SetVolume", dynlib: libORX.}
  ## Sets volume of all related sounds
  ##  @param[in] _pstSoundPointer      Concerned SoundPointer
  ##  @param[in] _fVolume        Desired volume (0.0 - 1.0)
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setPitch*(pstSoundPointer: ptr orxSOUNDPOINTER;
                              fPitch: orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxSoundPointer_SetPitch", dynlib: libORX.}
  ## Sets pitch of all related sounds
  ##  @param[in] _pstSoundPointer      Concerned SoundPointer
  ##  @param[in] _fPitch         Desired pitch
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc play*(pstSoundPointer: ptr orxSOUNDPOINTER): orxSTATUS {.cdecl,
    importc: "orxSoundPointer_Play", dynlib: libORX.}
  ## Plays all related sounds
  ##  @param[in] _pstSoundPointer      Concerned SoundPointer
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc pause*(pstSoundPointer: ptr orxSOUNDPOINTER): orxSTATUS {.cdecl,
    importc: "orxSoundPointer_Pause", dynlib: libORX.}
  ## Pauses all related sounds
  ##  @param[in] _pstSoundPointer      Concerned SoundPointer
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc stop*(pstSoundPointer: ptr orxSOUNDPOINTER): orxSTATUS {.cdecl,
    importc: "orxSoundPointer_Stop", dynlib: libORX.}
  ## Stops all related sounds
  ##  @param[in] _pstSoundPointer      Concerned SoundPointer
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc addSound*(pstSoundPointer: ptr orxSOUNDPOINTER;
                              pstSound: ptr orxSOUND): orxSTATUS {.cdecl,
    importc: "orxSoundPointer_AddSound", dynlib: libORX.}
  ## Adds a sound
  ##  @param[in]   _pstSoundPointer    Concerned SoundPointer
  ##  @param[in]   _pstSound           Sound to add
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc removeSound*(pstSoundPointer: ptr orxSOUNDPOINTER;
                                 pstSound: ptr orxSOUND): orxSTATUS {.cdecl,
    importc: "orxSoundPointer_RemoveSound", dynlib: libORX.}
  ## Removes a sound
  ##  @param[in]   _pstSoundPointer    Concerned SoundPointer
  ##  @param[in]   _pstSound           Sound to remove
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc removeAllSounds*(pstSoundPointer: ptr orxSOUNDPOINTER): orxSTATUS {.
    cdecl, importc: "orxSoundPointer_RemoveAllSounds", dynlib: libORX.}
  ## Removes all sounds
  ##  @param[in]   _pstSoundPointer    Concerned SoundPointer
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc addSoundFromConfig*(pstSoundPointer: ptr orxSOUNDPOINTER;
                                        zSoundConfigID: cstring): orxSTATUS {.
    cdecl, importc: "orxSoundPointer_AddSoundFromConfig", dynlib: libORX.}
  ## Adds a sound using its config ID
  ##  @param[in]   _pstSoundPointer    Concerned SoundPointer
  ##  @param[in]   _zSoundConfigID     Config ID of the sound to add
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc removeSoundFromConfig*(pstSoundPointer: ptr orxSOUNDPOINTER;
    zSoundConfigID: cstring): orxSTATUS {.cdecl,
    importc: "orxSoundPointer_RemoveSoundFromConfig", dynlib: libORX.}
  ## Removes a sound using its config ID
  ##  @param[in]   _pstSoundPointer    Concerned SoundPointer
  ##  @param[in]   _zSoundConfigID     Config ID of the sound to remove
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getLastAddedSound*(pstSoundPointer: ptr orxSOUNDPOINTER): ptr orxSOUND {.
    cdecl, importc: "orxSoundPointer_GetLastAddedSound", dynlib: libORX.}
  ## Gets last added sound (Do *NOT* destroy it directly before removing it!!!)
  ##  @param[in]   _pstSoundPointer    Concerned SoundPointer
  ##  @return      orxSOUND / nil

proc getCount*(pstSoundPointer: ptr orxSOUNDPOINTER): orxU32 {.cdecl,
    importc: "orxSoundPointer_GetCount", dynlib: libORX.}
  ## Gets how many sounds are currently in use
  ##  @param[in]   _pstSoundPointer    Concerned SoundPointer
  ##  @return      orxU32

