
import
  incl, vector


## **************************************************************************
##  Structure declaration                                                   *
## *************************************************************************
## * Abstract sound structures
##

type orxSOUNDSYSTEM_SOUND* = object
type orxSOUNDSYSTEM_SAMPLE* = object
## * Sound system status enum
##

type
  orxSOUNDSYSTEM_STATUS* {.size: sizeof(cint).} = enum
    orxSOUNDSYSTEM_STATUS_PLAY = 0, orxSOUNDSYSTEM_STATUS_PAUSE,
    orxSOUNDSYSTEM_STATUS_STOP, orxSOUNDSYSTEM_STATUS_NUMBER,
    orxSOUNDSYSTEM_STATUS_NONE = orxENUM_NONE


## * Config defines
##

const
  orxSOUNDSYSTEM_KZ_CONFIG_SECTION* = "SoundSystem"
  orxSOUNDSYSTEM_KZ_CONFIG_RATIO* = "DimensionRatio"
  orxSOUNDSYSTEM_KZ_CONFIG_STREAM_BUFFER_SIZE* = "StreamBufferSize"
  orxSOUNDSYSTEM_KZ_CONFIG_STREAM_BUFFER_NUMBER* = "StreamBufferNumber"

## **************************************************************************
##  Functions directly implemented by orx core
## *************************************************************************

proc soundSystemSetup*() {.cdecl, importc: "orxSoundSystem_Setup",
                             dynlib: libORX.}
  ## Sound system module setup

## **************************************************************************
##  Functions extended by plugins
## *************************************************************************

proc soundSystemInit*(): orxSTATUS {.cdecl, importc: "orxSoundSystem_Init",
                                      dynlib: libORX.}
  ## Inits the sound system module
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc soundSystemExit*() {.cdecl, importc: "orxSoundSystem_Exit",
                            dynlib: libORX.}
  ## Exits from the sound system module

proc createSample*(u32ChannelNumber: orxU32; u32FrameNumber: orxU32;
                                 u32SampleRate: orxU32): ptr orxSOUNDSYSTEM_SAMPLE {.
    cdecl, importc: "orxSoundSystem_CreateSample", dynlib: libORX.}
  ## Creates an empty sample
  ##  @param[in]   _u32ChannelNumber                     Number of channels of the sample
  ##  @param[in]   _u32FrameNumber                       Number of frame of the sample (number of "samples" = number of frames * number of channels)
  ##  @param[in]   _u32SampleRate                        Sampling rate of the sample (ie. number of frames per second)
  ##  @return orxSOUNDSYSTEM_SAMPLE / nil

proc loadSample*(zFilename: cstring): ptr orxSOUNDSYSTEM_SAMPLE {.
    cdecl, importc: "orxSoundSystem_LoadSample", dynlib: libORX.}
  ## Loads a sound sample from file (cannot be played directly)
  ##  @param[in]   _zFilename                            Name of the file to load as a sample (completely loaded in memory, useful for sound effects)
  ##  @return orxSOUNDSYSTEM_SAMPLE / nil

proc deleteSample*(pstSample: ptr orxSOUNDSYSTEM_SAMPLE): orxSTATUS {.
    cdecl, importc: "orxSoundSystem_DeleteSample", dynlib: libORX.}
  ## Deletes a sound sample
  ##  @param[in]   _pstSample                            Concerned sample
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getSampleInfo*(pstSample: ptr orxSOUNDSYSTEM_SAMPLE;
                                  pu32ChannelNumber: ptr orxU32;
                                  pu32FrameNumber: ptr orxU32;
                                  pu32SampleRate: ptr orxU32): orxSTATUS {.cdecl,
    importc: "orxSoundSystem_GetSampleInfo", dynlib: libORX.}
  ## Gets sample info
  ##  @param[in]   _pstSample                            Concerned sample
  ##  @param[in]   _pu32ChannelNumber                    Number of channels of the sample
  ##  @param[in]   _pu32FrameNumber                      Number of frame of the sample (number of "samples" = number of frames * number of channels)
  ##  @param[in]   _pu32SampleRate                       Sampling rate of the sample (ie. number of frames per second)
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setSampleData*(pstSample: ptr orxSOUNDSYSTEM_SAMPLE;
                                  as16Data: ptr orxS16; u32SampleNumber: orxU32): orxSTATUS {.
    cdecl, importc: "orxSoundSystem_SetSampleData", dynlib: libORX.}
  ## Sets sample data
  ##  @param[in]   _pstSample                            Concerned sample
  ##  @param[in]   _as16Data                             Data to set
  ##  @param[in]   _u32SampleNumber                      Number of samples in the data array
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc createFromSample*(pstSample: ptr orxSOUNDSYSTEM_SAMPLE): ptr orxSOUNDSYSTEM_SOUND {.
    cdecl, importc: "orxSoundSystem_CreateFromSample", dynlib: libORX.}
  ## Creates a sound from preloaded sample (can be played directly)
  ##  @param[in]   _pstSample                            Concerned sample
  ##  @return orxSOUNDSYSTEM_SOUND / nil

proc createStream*(u32ChannelNumber: orxU32; u32SampleRate: orxU32;
                                 zReference: cstring): ptr orxSOUNDSYSTEM_SOUND {.
    cdecl, importc: "orxSoundSystem_CreateStream", dynlib: libORX.}
  ## Creates an empty stream
  ##  @param[in]   _u32ChannelNumber                     Number of channels for the stream
  ##  @param[in]   _u32SampleRate                        Sampling rate of the stream (ie. number of frames per second)
  ##  @param[in]   _zReference                           Reference name used for streaming events (usually the corresponding config ID)
  ##  @return orxSOUNDSYSTEM_SOUND / nil

proc createStreamFromFile*(zFilename: cstring;
    zReference: cstring): ptr orxSOUNDSYSTEM_SOUND {.cdecl,
    importc: "orxSoundSystem_CreateStreamFromFile", dynlib: libORX.}
  ## Creates a streamed sound from file (can be played directly)
  ##  @param[in]   _zFilename                            Name of the file to load as a stream (won't be completely loaded in memory, useful for musics)
  ##  @param[in]   _zReference                           Reference name used for streaming events (usually the corresponding config ID)
  ##  @return orxSOUNDSYSTEM_SOUND / nil

proc delete*(pstSound: ptr orxSOUNDSYSTEM_SOUND): orxSTATUS {.cdecl,
    importc: "orxSoundSystem_Delete", dynlib: libORX.}
  ## Deletes a sound
  ##  @param[in]   _pstSound                             Concerned sound

proc play*(pstSound: ptr orxSOUNDSYSTEM_SOUND): orxSTATUS {.cdecl,
    importc: "orxSoundSystem_Play", dynlib: libORX.}
  ## Plays a sound
  ##  @param[in]   _pstSound                             Concerned sound
  ##  @return orxSTATUS_SUCCESS / orxSTATSUS_FAILURE

proc pause*(pstSound: ptr orxSOUNDSYSTEM_SOUND): orxSTATUS {.cdecl,
    importc: "orxSoundSystem_Pause", dynlib: libORX.}
  ## Pauses a sound
  ##  @param[in]   _pstSound                             Concerned sound
  ##  @return orxSTATUS_SUCCESS / orxSTATSUS_FAILURE

proc stop*(pstSound: ptr orxSOUNDSYSTEM_SOUND): orxSTATUS {.cdecl,
    importc: "orxSoundSystem_Stop", dynlib: libORX.}
  ## Stops a sound
  ##  @param[in]   _pstSound                             Concerned sound
  ##  @return orxSTATUS_SUCCESS / orxSTATSUS_FAILURE

proc startRecording*(zName: cstring; bWriteToFile: orxBOOL;
                                   u32SampleRate: orxU32; u32ChannelNumber: orxU32): orxSTATUS {.
    cdecl, importc: "orxSoundSystem_StartRecording", dynlib: libORX.}
  ## Starts recording
  ##  @param[in]   _zName                                Name for the recorded sound/file
  ##  @param[in]   _bWriteToFile                         Should write to file?
  ##  @param[in]   _u32SampleRate                        Sample rate, 0 for default rate (44100Hz)
  ##  @param[in]   _u32ChannelNumber                     Channel number, 0 for default mono channel
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc stopRecording*(): orxSTATUS {.cdecl,
    importc: "orxSoundSystem_StopRecording", dynlib: libORX.}
  ## Stops recording
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc hasRecordingSupport*(): orxBOOL {.cdecl,
    importc: "orxSoundSystem_HasRecordingSupport", dynlib: libORX.}
  ## Is recording possible on the current system?
  ##  @return orxTRUE / orxFALSE

proc setVolume*(pstSound: ptr orxSOUNDSYSTEM_SOUND; fVolume: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxSoundSystem_SetVolume", dynlib: libORX.}
  ## Sets a sound volume
  ##  @param[in]   _pstSound                             Concerned sound
  ##  @param[in]   _fVolume                              Volume to set [0, 1]
  ##  @return orxSTATUS_SUCCESS / orxSTATSUS_FAILURE

proc setPitch*(pstSound: ptr orxSOUNDSYSTEM_SOUND; fPitch: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxSoundSystem_SetPitch", dynlib: libORX.}
  ## Sets a sound pitch
  ##  @param[in]   _pstSound                             Concerned sound
  ##  @param[in]   _fPitch                               Pitch to set
  ##  @return orxSTATUS_SUCCESS / orxSTATSUS_FAILURE

proc setTime*(pstSound: ptr orxSOUNDSYSTEM_SOUND; fTime: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxSoundSystem_SetTime", dynlib: libORX.}
  ## Sets a sound time (ie. cursor/play position from beginning)
  ##  @param[in]   _pstSound                             Concerned sound
  ##  @param[in]   _fTime                                Time, in seconds
  ##  @return orxSTATUS_SUCCESS / orxSTATSUS_FAILURE

proc setPosition*(pstSound: ptr orxSOUNDSYSTEM_SOUND;
                                pvPosition: ptr orxVECTOR): orxSTATUS {.cdecl,
    importc: "orxSoundSystem_SetPosition", dynlib: libORX.}
  ## Sets a sound position
  ##  @param[in]   _pstSound                             Concerned sound
  ##  @param[in]   _pvPosition                           Position to set
  ##  @return orxSTATUS_SUCCESS / orxSTATSUS_FAILURE

proc setAttenuation*(pstSound: ptr orxSOUNDSYSTEM_SOUND;
                                   fAttenuation: orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxSoundSystem_SetAttenuation", dynlib: libORX.}
  ## Sets a sound attenuation
  ##  @param[in] _pstSound                               Concerned Sound
  ##  @param[in] _fAttenuation                           Desired attenuation
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setReferenceDistance*(pstSound: ptr orxSOUNDSYSTEM_SOUND;
    fDistance: orxFLOAT): orxSTATUS {.cdecl, importc: "orxSoundSystem_SetReferenceDistance",
                                   dynlib: libORX.}
  ## Sets a sound reference distance
  ##  @param[in] _pstSound                               Concerned Sound
  ##  @param[in] _fDistance                              Within this distance, sound is perceived at its maximum volume
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc loop*(pstSound: ptr orxSOUNDSYSTEM_SOUND; bLoop: orxBOOL): orxSTATUS {.
    cdecl, importc: "orxSoundSystem_Loop", dynlib: libORX.}
  ## Loops a sound
  ##  @param[in]   _pstSound                             Concerned sound
  ##  @param[in]   _bLoop                                Loop / no loop
  ##  @return orxSTATUS_SUCCESS / orxSTATSUS_FAILURE

proc getVolume*(pstSound: ptr orxSOUNDSYSTEM_SOUND): orxFLOAT {.cdecl,
    importc: "orxSoundSystem_GetVolume", dynlib: libORX.}
  ## Gets a sound volume
  ##  @param[in]   _pstSound                             Concerned sound
  ##  @return Sound's volume

proc getPitch*(pstSound: ptr orxSOUNDSYSTEM_SOUND): orxFLOAT {.cdecl,
    importc: "orxSoundSystem_GetPitch", dynlib: libORX.}
  ## Gets a sound pitch
  ##  @param[in]   _pstSound                             Concerned sound
  ##  @return Sound's pitch

proc getTime*(pstSound: ptr orxSOUNDSYSTEM_SOUND): orxFLOAT {.cdecl,
    importc: "orxSoundSystem_GetTime", dynlib: libORX.}
  ## Gets a sound's time (ie. cursor/play position from beginning)
  ##  @param[in]   _pstSound                             Concerned sound
  ##  @return Sound's time (cursor/play position), in seconds

proc getPosition*(pstSound: ptr orxSOUNDSYSTEM_SOUND;
                                pvPosition: ptr orxVECTOR): ptr orxVECTOR {.cdecl,
    importc: "orxSoundSystem_GetPosition", dynlib: libORX.}
  ## Gets a sound position
  ##  @param[in]   _pstSound                             Concerned sound
  ##  @param[out]  _pvPosition                           Position to get
  ##  @return Sound's position

proc getAttenuation*(pstSound: ptr orxSOUNDSYSTEM_SOUND): orxFLOAT {.
    cdecl, importc: "orxSoundSystem_GetAttenuation", dynlib: libORX.}
  ## Gets a sound attenuation
  ##  @param[in] _pstSound                               Concerned Sound
  ##  @return Sound's attenuation

proc getReferenceDistance*(pstSound: ptr orxSOUNDSYSTEM_SOUND): orxFLOAT {.
    cdecl, importc: "orxSoundSystem_GetReferenceDistance", dynlib: libORX.}
  ## Gets a sound reference distance
  ##  @param[in] _pstSound                               Concerned Sound
  ##  @return Sound's reference distance

proc isLooping*(pstSound: ptr orxSOUNDSYSTEM_SOUND): orxBOOL {.cdecl,
    importc: "orxSoundSystem_IsLooping", dynlib: libORX.}
  ## Is sound looping?
  ##  @param[in]   _pstSound                             Concerned sound
  ##  @return orxTRUE if looping, orxFALSE otherwise

proc getDuration*(pstSound: ptr orxSOUNDSYSTEM_SOUND): orxFLOAT {.
    cdecl, importc: "orxSoundSystem_GetDuration", dynlib: libORX.}
  ## Gets a sound duration
  ##  @param[in]   _pstSound                             Concerned sound
  ##  @return Sound's duration (seconds)

proc getStatus*(pstSound: ptr orxSOUNDSYSTEM_SOUND): orxSOUNDSYSTEM_STATUS {.
    cdecl, importc: "orxSoundSystem_GetStatus", dynlib: libORX.}
  ## Gets a sound status (play/pause/stop)
  ##  @param[in]   _pstSound                             Concerned sound
  ##  @return orxSOUNDSYSTEM_STATUS

proc setGlobalVolume*(fGlobalVolume: orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxSoundSystem_SetGlobalVolume", dynlib: libORX.}
  ## Sets global volume
  ##  @param[in] _fGlobalVolume                          Global volume to set
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getGlobalVolume*(): orxFLOAT {.cdecl,
    importc: "orxSoundSystem_GetGlobalVolume", dynlib: libORX.}
  ## Gets global volume
  ##  @return Gobal volume

proc setListenerPosition*(pvPosition: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxSoundSystem_SetListenerPosition", dynlib: libORX.}
  ## Sets listener position
  ##  @param[in] _pvPosition                             Desired position
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getListenerPosition*(pvPosition: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxSoundSystem_GetListenerPosition", dynlib: libORX.}
  ## Gets listener position
  ##  @param[out] _pvPosition                            Listener's position
  ##  @return orxVECTOR / nil

