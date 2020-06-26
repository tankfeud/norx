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
  incl, sound, structure


## * Misc defines
##

const
  orxSOUNDPOINTER_KU32_SOUND_NUMBER* = 4

## * Internal SoundPointer structure

type orxSOUNDPOINTER* = object
## * SoundPointer module setup
##

proc orxSoundPointer_Setup*() {.cdecl, importc: "orxSoundPointer_Setup",
                              dynlib: libORX.}
## * Inits the SoundPointer module
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxSoundPointer_Init*(): orxSTATUS {.cdecl, importc: "orxSoundPointer_Init",
                                       dynlib: libORX.}
## * Exits from the SoundPointer module
##

proc orxSoundPointer_Exit*() {.cdecl, importc: "orxSoundPointer_Exit",
                             dynlib: libORX.}
## * Creates an empty SoundPointer
##  @return orxSOUNDPOINTER / nil
##

proc orxSoundPointer_Create*(): ptr orxSOUNDPOINTER {.cdecl,
    importc: "orxSoundPointer_Create", dynlib: libORX.}
## * Deletes a SoundPointer
##  @param[in] _pstSoundPointer      Concerned SoundPointer
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxSoundPointer_Delete*(pstSoundPointer: ptr orxSOUNDPOINTER): orxSTATUS {.
    cdecl, importc: "orxSoundPointer_Delete", dynlib: libORX.}
## * Enables/disables a SoundPointer
##  @param[in]   _pstSoundPointer    Concerned SoundPointer
##  @param[in]   _bEnable        Enable / disable
##

proc orxSoundPointer_Enable*(pstSoundPointer: ptr orxSOUNDPOINTER; bEnable: orxBOOL) {.
    cdecl, importc: "orxSoundPointer_Enable", dynlib: libORX.}
## * Is SoundPointer enabled?
##  @param[in]   _pstSoundPointer    Concerned SoundPointer
##  @return      orxTRUE if enabled, orxFALSE otherwise
##

proc orxSoundPointer_IsEnabled*(pstSoundPointer: ptr orxSOUNDPOINTER): orxBOOL {.
    cdecl, importc: "orxSoundPointer_IsEnabled", dynlib: libORX.}
## * Sets volume of all related sounds
##  @param[in] _pstSoundPointer      Concerned SoundPointer
##  @param[in] _fVolume        Desired volume (0.0 - 1.0)
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxSoundPointer_SetVolume*(pstSoundPointer: ptr orxSOUNDPOINTER;
                               fVolume: orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxSoundPointer_SetVolume", dynlib: libORX.}
## * Sets pitch of all related sounds
##  @param[in] _pstSoundPointer      Concerned SoundPointer
##  @param[in] _fPitch         Desired pitch
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxSoundPointer_SetPitch*(pstSoundPointer: ptr orxSOUNDPOINTER;
                              fPitch: orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxSoundPointer_SetPitch", dynlib: libORX.}
## * Plays all related sounds
##  @param[in] _pstSoundPointer      Concerned SoundPointer
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxSoundPointer_Play*(pstSoundPointer: ptr orxSOUNDPOINTER): orxSTATUS {.cdecl,
    importc: "orxSoundPointer_Play", dynlib: libORX.}
## * Pauses all related sounds
##  @param[in] _pstSoundPointer      Concerned SoundPointer
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxSoundPointer_Pause*(pstSoundPointer: ptr orxSOUNDPOINTER): orxSTATUS {.cdecl,
    importc: "orxSoundPointer_Pause", dynlib: libORX.}
## * Stops all related sounds
##  @param[in] _pstSoundPointer      Concerned SoundPointer
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxSoundPointer_Stop*(pstSoundPointer: ptr orxSOUNDPOINTER): orxSTATUS {.cdecl,
    importc: "orxSoundPointer_Stop", dynlib: libORX.}
## * Adds a sound
##  @param[in]   _pstSoundPointer    Concerned SoundPointer
##  @param[in]   _pstSound           Sound to add
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxSoundPointer_AddSound*(pstSoundPointer: ptr orxSOUNDPOINTER;
                              pstSound: ptr orxSOUND): orxSTATUS {.cdecl,
    importc: "orxSoundPointer_AddSound", dynlib: libORX.}
## * Removes a sound
##  @param[in]   _pstSoundPointer    Concerned SoundPointer
##  @param[in]   _pstSound           Sound to remove
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxSoundPointer_RemoveSound*(pstSoundPointer: ptr orxSOUNDPOINTER;
                                 pstSound: ptr orxSOUND): orxSTATUS {.cdecl,
    importc: "orxSoundPointer_RemoveSound", dynlib: libORX.}
## * Removes all sounds
##  @param[in]   _pstSoundPointer    Concerned SoundPointer
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxSoundPointer_RemoveAllSounds*(pstSoundPointer: ptr orxSOUNDPOINTER): orxSTATUS {.
    cdecl, importc: "orxSoundPointer_RemoveAllSounds", dynlib: libORX.}
## * Adds a sound using its config ID
##  @param[in]   _pstSoundPointer    Concerned SoundPointer
##  @param[in]   _zSoundConfigID     Config ID of the sound to add
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxSoundPointer_AddSoundFromConfig*(pstSoundPointer: ptr orxSOUNDPOINTER;
                                        zSoundConfigID: cstring): orxSTATUS {.
    cdecl, importc: "orxSoundPointer_AddSoundFromConfig", dynlib: libORX.}
## * Removes a sound using its config ID
##  @param[in]   _pstSoundPointer    Concerned SoundPointer
##  @param[in]   _zSoundConfigID     Config ID of the sound to remove
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxSoundPointer_RemoveSoundFromConfig*(pstSoundPointer: ptr orxSOUNDPOINTER;
    zSoundConfigID: cstring): orxSTATUS {.cdecl,
    importc: "orxSoundPointer_RemoveSoundFromConfig", dynlib: libORX.}
## * Gets last added sound (Do *NOT* destroy it directly before removing it!!!)
##  @param[in]   _pstSoundPointer    Concerned SoundPointer
##  @return      orxSOUND / nil
##

proc orxSoundPointer_GetLastAddedSound*(pstSoundPointer: ptr orxSOUNDPOINTER): ptr orxSOUND {.
    cdecl, importc: "orxSoundPointer_GetLastAddedSound", dynlib: libORX.}
## * Gets how many sounds are currently in use
##  @param[in]   _pstSoundPointer    Concerned SoundPointer
##  @return      orxU32
##

proc orxSoundPointer_GetCount*(pstSoundPointer: ptr orxSOUNDPOINTER): orxU32 {.cdecl,
    importc: "orxSoundPointer_GetCount", dynlib: libORX.}
## * @}
