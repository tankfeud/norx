import
  incl, soundSystem, vector


## * Misc defines
##

const
  orxSOUND_KZ_RESOURCE_GROUP* = "Sound"
  orxSOUND_KZ_MASTER_BUS* = "master"

## * Sound status enum
##

type
  orxSOUND_STATUS* {.size: sizeof(cint).} = enum
    orxSOUND_STATUS_PLAY = 0, orxSOUND_STATUS_PAUSE, orxSOUND_STATUS_STOP,
    orxSOUND_STATUS_NUMBER, orxSOUND_STATUS_NONE = orxENUM_NONE


## * Internal Sound structure
##

type orxSOUND* = object
## * Event enum
##

type
  orxSOUND_EVENT* {.size: sizeof(cint).} = enum
    orxSOUND_EVENT_START = 0,   ## *< Event sent when a sound starts
    orxSOUND_EVENT_STOP,      ## *< Event sent when a sound stops
    orxSOUND_EVENT_ADD,       ## *< Event sent when a sound is added
    orxSOUND_EVENT_REMOVE,    ## *< Event sent when a sound is removed
    orxSOUND_EVENT_PACKET,    ## *< Event sent when a sound packet is streamed. IMPORTANT: this event can be sent from a worker thread, do not call any orx API when handling it
    orxSOUND_EVENT_RECORDING_START, ## *< Event sent when recording starts
    orxSOUND_EVENT_RECORDING_STOP, ## *< Event sent when recording stops
    orxSOUND_EVENT_RECORDING_PACKET, ## *< Event sent when a packet has been recorded
    orxSOUND_EVENT_NUMBER, orxSOUND_EVENT_NONE = orxENUM_NONE


## * Sound stream info
##

type
  orxSOUND_STREAM_INFO* {.bycopy.} = object
    u32SampleRate*: orxU32     ## *< The sample rate, e.g. 44100 Hertz : 4
    u32ChannelNumber*: orxU32  ## *< Number of channels, either mono (1) or stereo (2) : 8


## * Sound recording packet
##

type
  orxSOUND_STREAM_PACKET* {.bycopy.} = object
    u32SampleNumber*: orxU32   ## *< Number of samples contained in this packet : 4
    as16SampleList*: ptr orxS16 ## *< List of samples for this packet : 8
    bDiscard*: orxBOOL         ## *< Write/play the packet? : 12
    fTimeStamp*: orxFLOAT      ## *< Packet's timestamp : 16
    s32ID*: orxS32             ## *< Packet's ID : 20
    fTime*: orxFLOAT           ## *< Packet's time (cursor/play position): 24


## * Sound event payload
##

type
  INNER_C_STRUCT_orxSound_139* {.bycopy.} = object
    zSoundName*: cstring    ## *< Sound name : 4
    stInfo*: orxSOUND_STREAM_INFO ## *< Sound record info : 12
    stPacket*: orxSOUND_STREAM_PACKET ## *< Sound record packet : 32

  INNER_C_UNION_orxSound_135* {.bycopy, union.} = object
    pstSound*: ptr orxSOUND     ## *< Sound reference : 4
    stStream*: INNER_C_STRUCT_orxSound_139

  orxSOUND_EVENT_PAYLOAD* {.bycopy.} = object
    ano_orxSound_143*: INNER_C_UNION_orxSound_135


proc soundSetup*() {.cdecl, importc: "orxSound_Setup", dynlib: libORX.}
  ## Sound module setup

proc soundInit*(): orxSTATUS {.cdecl, importc: "orxSound_Init",
                                dynlib: libORX.}
  ## Initializes the sound module
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc soundExit*() {.cdecl, importc: "orxSound_Exit", dynlib: libORX.}
  ## Exits from the sound module

proc soundCreate*(): ptr orxSOUND {.cdecl, importc: "orxSound_Create",
                                    dynlib: libORX.}
  ## Creates an empty sound
  ##  @return      Created orxSOUND / nil

proc soundCreateFromConfig*(zConfigID: cstring): ptr orxSOUND {.cdecl,
    importc: "orxSound_CreateFromConfig", dynlib: libORX.}
  ## Creates sound from config
  ##  @param[in]   _zConfigID    Config ID
  ##  @ return orxSOUND / nil

proc createWithEmptyStream*(u32ChannelNumber: orxU32;
                                    u32SampleRate: orxU32; zName: cstring): ptr orxSOUND {.
    cdecl, importc: "orxSound_CreateWithEmptyStream", dynlib: libORX.}
  ## Creates a sound with an empty stream (ie. you'll need to provide actual sound data for each packet sent to the sound card using the event system)
  ##  @param[in] _u32ChannelNumber Number of channels of the stream
  ##  @param[in] _u32SampleRate    Sampling rate of the stream (ie. number of frames per second)
  ##  @param[in] _zName            Name to associate with this sound
  ##  @return orxSOUND / nil

proc delete*(pstSound: ptr orxSOUND): orxSTATUS {.cdecl,
    importc: "orxSound_Delete", dynlib: libORX.}
  ## Deletes sound
  ##  @param[in] _pstSound       Concerned Sound
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc clearCache*(): orxSTATUS {.cdecl, importc: "orxSound_ClearCache",
                                      dynlib: libORX.}
  ## Clears cache (if any sound sample is still in active use, it'll remain in memory until not referenced anymore)
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc createSample*(u32ChannelNumber: orxU32; u32FrameNumber: orxU32;
                           u32SampleRate: orxU32; zName: cstring): ptr orxSOUNDSYSTEM_SAMPLE {.
    cdecl, importc: "orxSound_CreateSample", dynlib: libORX.}
  ## Creates a sample
  ##  @param[in] _u32ChannelNumber Number of channels of the sample
  ##  @param[in] _u32FrameNumber   Number of frame of the sample (number of "samples" = number of frames * number of channels)
  ##  @param[in] _u32SampleRate    Sampling rate of the sample (ie. number of frames per second)
  ##  @param[in] _zName            Name to associate with the sample
  ##  @return orxSOUNDSYSTEM_SAMPLE / nil

proc getSample*(zName: cstring): ptr orxSOUNDSYSTEM_SAMPLE {.cdecl,
    importc: "orxSound_GetSample", dynlib: libORX.}
  ## Gets a sample
  ##  @param[in] _zName            Sample's name
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc deleteSample*(zName: cstring): orxSTATUS {.cdecl,
    importc: "orxSound_DeleteSample", dynlib: libORX.}
  ## Deletes a sample
  ##  @param[in] _zName            Sample's name
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc linkSample*(pstSound: ptr orxSOUND; zSampleName: cstring): orxSTATUS {.
    cdecl, importc: "orxSound_LinkSample", dynlib: libORX.}
  ## Links a sample
  ##  @param[in]   _pstSound     Concerned sound
  ##  @param[in]   _zSampleName  Name of the sample to link (must already be loaded/created)
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc unlinkSample*(pstSound: ptr orxSOUND): orxSTATUS {.cdecl,
    importc: "orxSound_UnlinkSample", dynlib: libORX.}
  ## Unlinks (and deletes if not used anymore) a sample
  ##  @param[in]   _pstSound     Concerned sound
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc isStream*(pstSound: ptr orxSOUND): orxBOOL {.cdecl,
    importc: "orxSound_IsStream", dynlib: libORX.}
  ## Is a stream (ie. music)?
  ##  @param[in] _pstSound       Concerned Sound
  ##  @return orxTRUE / orxFALSE

proc play*(pstSound: ptr orxSOUND): orxSTATUS {.cdecl,
    importc: "orxSound_Play", dynlib: libORX.}
  ## Plays sound
  ##  @param[in] _pstSound       Concerned Sound
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc pause*(pstSound: ptr orxSOUND): orxSTATUS {.cdecl,
    importc: "orxSound_Pause", dynlib: libORX.}
  ## Pauses sound
  ##  @param[in] _pstSound       Concerned Sound
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc stop*(pstSound: ptr orxSOUND): orxSTATUS {.cdecl,
    importc: "orxSound_Stop", dynlib: libORX.}
  ## Stops sound
  ##  @param[in] _pstSound       Concerned Sound
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc startRecording*(zName: cstring; bWriteToFile: orxBOOL;
                             u32SampleRate: orxU32; u32ChannelNumber: orxU32): orxSTATUS {.
    cdecl, importc: "orxSound_StartRecording", dynlib: libORX.}
  ## Starts recording
  ##  @param[in] _zName             Name for the recorded sound/file
  ##  @param[in] _bWriteToFile      Should write to file?
  ##  @param[in] _u32SampleRate     Sample rate, 0 for default rate (44100Hz)
  ##  @param[in] _u32ChannelNumber  Channel number, 0 for default mono channel
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc stopRecording*(): orxSTATUS {.cdecl,
    importc: "orxSound_StopRecording", dynlib: libORX.}
  ## Stops recording
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc hasRecordingSupport*(): orxBOOL {.cdecl,
    importc: "orxSound_HasRecordingSupport", dynlib: libORX.}
  ## Is recording possible on the current system?
  ##  @return orxTRUE / orxFALSE

proc setVolume*(pstSound: ptr orxSOUND; fVolume: orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxSound_SetVolume", dynlib: libORX.}
  ## Sets sound volume
  ##  @param[in] _pstSound       Concerned Sound
  ##  @param[in] _fVolume        Desired volume (0.0 - 1.0)
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setPitch*(pstSound: ptr orxSOUND; fPitch: orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxSound_SetPitch", dynlib: libORX.}
  ## Sets sound pitch
  ##  @param[in] _pstSound       Concerned Sound
  ##  @param[in] _fPitch         Desired pitch
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setTime*(pstSound: ptr orxSOUND; fTime: orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxSound_SetTime", dynlib: libORX.}
  ## Sets a sound time (ie. cursor/play position from beginning)
  ##  @param[in]   _pstSound                             Concerned sound
  ##  @param[in]   _fTime                                Time, in seconds
  ##  @return orxSTATUS_SUCCESS / orxSTATSUS_FAILURE

proc setPosition*(pstSound: ptr orxSOUND; pvPosition: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxSound_SetPosition", dynlib: libORX.}
  ## Sets sound position
  ##  @param[in] _pstSound       Concerned Sound
  ##  @param[in] _pvPosition     Desired position
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setAttenuation*(pstSound: ptr orxSOUND; fAttenuation: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxSound_SetAttenuation", dynlib: libORX.}
  ## Sets sound attenuation
  ##  @param[in] _pstSound       Concerned Sound
  ##  @param[in] _fAttenuation   Desired attenuation
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setReferenceDistance*(pstSound: ptr orxSOUND; fDistance: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxSound_SetReferenceDistance", dynlib: libORX.}
  ## Sets sound reference distance
  ##  @param[in] _pstSound       Concerned Sound
  ##  @param[in] _fDistance      Within this distance, sound is perceived at its maximum volume
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc loop*(pstSound: ptr orxSOUND; bLoop: orxBOOL): orxSTATUS {.cdecl,
    importc: "orxSound_Loop", dynlib: libORX.}
  ## Loops sound
  ##  @param[in] _pstSound       Concerned Sound
  ##  @param[in] _bLoop          orxTRUE / orxFALSE
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getVolume*(pstSound: ptr orxSOUND): orxFLOAT {.cdecl,
    importc: "orxSound_GetVolume", dynlib: libORX.}
  ## Gets sound volume
  ##  @param[in] _pstSound       Concerned Sound
  ##  @return orxFLOAT

proc getPitch*(pstSound: ptr orxSOUND): orxFLOAT {.cdecl,
    importc: "orxSound_GetPitch", dynlib: libORX.}
  ## Gets sound pitch
  ##  @param[in] _pstSound       Concerned Sound
  ##  @return orxFLOAT

proc getTime*(pstSound: ptr orxSOUND): orxFLOAT {.cdecl,
    importc: "orxSound_GetTime", dynlib: libORX.}
  ## Gets a sound's time (ie. cursor/play position from beginning)
  ##  @param[in]   _pstSound                             Concerned sound
  ##  @return Sound's time (cursor/play position), in seconds

proc getPosition*(pstSound: ptr orxSOUND; pvPosition: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxSound_GetPosition", dynlib: libORX.}
  ## Gets sound position
  ##  @param[in]  _pstSound      Concerned Sound
  ##  @param[out] _pvPosition    Sound's position
  ##  @return orxVECTOR / nil

proc getAttenuation*(pstSound: ptr orxSOUND): orxFLOAT {.cdecl,
    importc: "orxSound_GetAttenuation", dynlib: libORX.}
  ## Gets sound attenuation
  ##  @param[in] _pstSound       Concerned Sound
  ##  @return orxFLOAT

proc getReferenceDistance*(pstSound: ptr orxSOUND): orxFLOAT {.cdecl,
    importc: "orxSound_GetReferenceDistance", dynlib: libORX.}
  ## Gets sound reference distance
  ##  @param[in] _pstSound       Concerned Sound
  ##  @return orxFLOAT

proc isLooping*(pstSound: ptr orxSOUND): orxBOOL {.cdecl,
    importc: "orxSound_IsLooping", dynlib: libORX.}
  ## Is sound looping?
  ##  @param[in] _pstSound       Concerned Sound
  ##  @return orxTRUE / orxFALSE

proc getDuration*(pstSound: ptr orxSOUND): orxFLOAT {.cdecl,
    importc: "orxSound_GetDuration", dynlib: libORX.}
  ## Gets sound duration
  ##  @param[in] _pstSound       Concerned Sound
  ##  @return orxFLOAT

proc getStatus*(pstSound: ptr orxSOUND): orxSOUND_STATUS {.cdecl,
    importc: "orxSound_GetStatus", dynlib: libORX.}
  ## Gets sound status
  ##  @param[in] _pstSound       Concerned Sound
  ##  @return orxSOUND_STATUS

proc getName*(pstSound: ptr orxSOUND): cstring {.cdecl,
    importc: "orxSound_GetName", dynlib: libORX.}
  ## Gets sound config name
  ##  @param[in]   _pstSound     Concerned sound
  ##  @return      orxSTRING / orxSTRING_EMPTY

proc getMasterBusID*(): orxSTRINGID {.cdecl,
    importc: "orxSound_GetMasterBusID", dynlib: libORX.}
  ## Gets master bus ID
  ##  @return      Master bus ID

proc getBusID*(pstSound: ptr orxSOUND): orxSTRINGID {.cdecl,
    importc: "orxSound_GetBusID", dynlib: libORX.}
  ## Gets sound's bus ID
  ##  @param[in]   _pstSound     Concerned sound
  ##  @return      Sound's bus ID

proc setBusID*(pstSound: ptr orxSOUND; stBusID: orxSTRINGID): orxSTATUS {.
    cdecl, importc: "orxSound_SetBusID", dynlib: libORX.}
  ## Sets sound's bus ID
  ##  @param[in]   _pstSound     Concerned sound
  ##  @param[in]   _stBusID      Bus ID to set
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getNext*(pstSound: ptr orxSOUND; stBusID: orxSTRINGID): ptr orxSOUND {.
    cdecl, importc: "orxSound_GetNext", dynlib: libORX.}
  ## Gets next sound in bus
  ##  @param[in]   _pstSound     Concerned sound, nil to get the first one
  ##  @param[in]   _stBusID      Bus ID to consider, orxSTRINGID_UNDEFINED for all
  ##  @return      orxSOUND / nil

proc getBusParent*(stBusID: orxSTRINGID): orxSTRINGID {.cdecl,
    importc: "orxSound_GetBusParent", dynlib: libORX.}
  ## Gets bus parent
  ##  @param[in]   _stBusID      Concerned bus ID
  ##  @return      Parent bus ID / orxSTRINGID_UNDEFINED

proc getBusChild*(stBusID: orxSTRINGID): orxSTRINGID {.cdecl,
    importc: "orxSound_GetBusChild", dynlib: libORX.}
  ## Gets bus child
  ##  @param[in]   _stBusID      Concerned bus ID
  ##  @return      Child bus ID / orxSTRINGID_UNDEFINED

proc getBusSibling*(stBusID: orxSTRINGID): orxSTRINGID {.cdecl,
    importc: "orxSound_GetBusSibling", dynlib: libORX.}
  ## Gets bus sibling
  ##  @param[in]   _stBusID      Concerned bus ID
  ##  @return      Sibling bus ID / orxSTRINGID_UNDEFINED

proc setBusParent*(stBusID: orxSTRINGID; stParentBusID: orxSTRINGID): orxSTATUS {.
    cdecl, importc: "orxSound_SetBusParent", dynlib: libORX.}
  ## Sets a bus parent
  ##  @param[in]   _stBusID      Concerned bus ID, will create it if not already existing
  ##  @param[in]   _stParentBusID  ID of the bus to use as parent, will create it if not already existing
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getBusVolume*(stBusID: orxSTRINGID): orxFLOAT {.cdecl,
    importc: "orxSound_GetBusVolume", dynlib: libORX.}
  ## Gets bus volume (local, ie. unaffected by the whole bus hierarchy)
  ##  @param[in]   _stBusID      Concerned bus ID
  ##  @return      orxFLOAT

proc getBusPitch*(stBusID: orxSTRINGID): orxFLOAT {.cdecl,
    importc: "orxSound_GetBusPitch", dynlib: libORX.}
  ## Gets bus pitch (local, ie. unaffected by the whole bus hierarchy)
  ##  @param[in]   _stBusID      Concerned bus ID
  ##  @return      orxFLOAT

proc setBusVolume*(stBusID: orxSTRINGID; fVolume: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxSound_SetBusVolume", dynlib: libORX.}
  ## Sets bus volume
  ##  @param[in]   _stBusID      Concerned bus ID, will create it if not already existing
  ##  @param[in]   _fVolume      Desired volume (0.0 - 1.0)
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setBusPitch*(stBusID: orxSTRINGID; fPitch: orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxSound_SetBusPitch", dynlib: libORX.}
  ## Sets bus pitch
  ##  @param[in]   _stBusID      Concerned bus ID, will create it if not already existing
  ##  @param[in]   _fPitch       Desired pitch
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getBusGlobalVolume*(stBusID: orxSTRINGID): orxFLOAT {.cdecl,
    importc: "orxSound_GetBusGlobalVolume", dynlib: libORX.}
  ## Gets bus global volume, ie. taking into account the whole bus hierarchy
  ##  @param[in]   _stBusID      Concerned bus ID
  ##  @return      orxFLOAT

proc getBusGlobalPitch*(stBusID: orxSTRINGID): orxFLOAT {.cdecl,
    importc: "orxSound_GetBusGlobalPitch", dynlib: libORX.}
  ## Gets bus global pitch, ie. taking into account the whole bus hierarchy
  ##  @param[in]   _stBusID      Concerned bus ID
  ##  @return      orxFLOAT

