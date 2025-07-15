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
  orxSPAWNER_KU32_FLAG_USE_RELATIVE_SPEED_OBJECT* = 0x00000040
  orxSPAWNER_KU32_FLAG_USE_RELATIVE_SPEED_SPAWNER* = 0x00000080
  orxSPAWNER_KU32_MASK_USE_RELATIVE_SPEED* = 0x000000C0
  orxSPAWNER_KU32_FLAG_USE_SELF_AS_PARENT* = 0x00000100
  orxSPAWNER_KU32_FLAG_CLEAN_ON_DELETE* = 0x00000200
  orxSPAWNER_KU32_FLAG_INTERPOLATE* = 0x00000400
  orxSPAWNER_KU32_MASK_USER_ALL* = 0x000004FF

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

proc spawnerSetup*() {.cdecl, importc: "orxSpawner_Setup", dynlib: libORX.}
  ## Spawner module setup

proc spawnerInit*(): orxSTATUS {.cdecl, importc: "orxSpawner_Init",
                                  dynlib: libORX.}
  ## Inits the spawner module
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc spawnerExit*() {.cdecl, importc: "orxSpawner_Exit", dynlib: libORX.}
  ## Exits from the spawner module

proc spawnerCreate*(): ptr orxSPAWNER {.cdecl, importc: "orxSpawner_Create",
                                        dynlib: libORX.}
  ## Creates an empty spawner
  ##  @return orxSPAWNER / nil

proc spawnerCreateFromConfig*(zConfigID: cstring): ptr orxSPAWNER {.cdecl,
    importc: "orxSpawner_CreateFromConfig", dynlib: libORX.}
  ## Creates a spawner from config
  ##  @param[in]   _zConfigID    Config ID
  ##  @ return orxSPAWNER / nil

proc delete*(pstSpawner: ptr orxSPAWNER): orxSTATUS {.cdecl,
    importc: "orxSpawner_Delete", dynlib: libORX.}
  ## Deletes a spawner
  ##  @param[in] _pstSpawner       Concerned spawner
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc enable*(pstSpawner: ptr orxSPAWNER; bEnable: orxBOOL) {.cdecl,
    importc: "orxSpawner_Enable", dynlib: libORX.}
  ## Enables/disables a spawner
  ##  @param[in]   _pstSpawner     Concerned spawner
  ##  @param[in]   _bEnable      Enable / disable

proc isEnabled*(pstSpawner: ptr orxSPAWNER): orxBOOL {.cdecl,
    importc: "orxSpawner_IsEnabled", dynlib: libORX.}
  ## Is spawner enabled?
  ##  @param[in]   _pstSpawner     Concerned spawner
  ##  @return      orxTRUE if enabled, orxFALSE otherwise

proc reset*(pstSpawner: ptr orxSPAWNER) {.cdecl,
    importc: "orxSpawner_Reset", dynlib: libORX.}
  ## Resets (and disables) a spawner
  ##  @param[in]   _pstSpawner     Concerned spawner

proc setTotalObjectLimit*(pstSpawner: ptr orxSPAWNER;
                                    u32TotalObjectLimit: orxU32): orxSTATUS {.
    cdecl, importc: "orxSpawner_SetTotalObjectLimit", dynlib: libORX.}
  ## Sets spawner total object limit
  ##  @param[in]   _pstSpawner     Concerned spawner
  ##  @param[in]   _u32TotalObjectLimit Total object limit, 0 for unlimited
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setActiveObjectLimit*(pstSpawner: ptr orxSPAWNER;
                                     u32ActiveObjectLimit: orxU32): orxSTATUS {.
    cdecl, importc: "orxSpawner_SetActiveObjectLimit", dynlib: libORX.}
  ## Sets spawner active object limit
  ##  @param[in]   _pstSpawner     Concerned spawner
  ##  @param[in]   _u32ActiveObjectLimit Active object limit, 0 for unlimited
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getTotalObjectLimit*(pstSpawner: ptr orxSPAWNER): orxU32 {.cdecl,
    importc: "orxSpawner_GetTotalObjectLimit", dynlib: libORX.}
  ## Gets spawner total object limit
  ##  @param[in]   _pstSpawner     Concerned spawner
  ##  @return      Total object limit, 0 for unlimited

proc getActiveObjectLimit*(pstSpawner: ptr orxSPAWNER): orxU32 {.cdecl,
    importc: "orxSpawner_GetActiveObjectLimit", dynlib: libORX.}
  ## Gets spawner active object limit
  ##  @param[in]   _pstSpawner     Concerned spawner
  ##  @return      Active object limit, 0 for unlimited

proc getTotalObjectCount*(pstSpawner: ptr orxSPAWNER): orxU32 {.cdecl,
    importc: "orxSpawner_GetTotalObjectCount", dynlib: libORX.}
  ## Gets spawner total object count
  ##  @param[in]   _pstSpawner     Concerned spawner
  ##  @return      Total object count

proc getActiveObjectCount*(pstSpawner: ptr orxSPAWNER): orxU32 {.cdecl,
    importc: "orxSpawner_GetActiveObjectCount", dynlib: libORX.}
  ## Gets spawner active object count
  ##  @param[in]   _pstSpawner     Concerned spawner
  ##  @return      Active object count

proc setWaveSize*(pstSpawner: ptr orxSPAWNER; u32WaveSize: orxU32): orxSTATUS {.
    cdecl, importc: "orxSpawner_SetWaveSize", dynlib: libORX.}
  ## Sets spawner wave size
  ##  @param[in]   _pstSpawner     Concerned spawner
  ##  @param[in]   _u32WaveSize    Number of objects to spawn in a wave / 0 for deactivating wave mode
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setWaveDelay*(pstSpawner: ptr orxSPAWNER; fWaveDelay: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxSpawner_SetWaveDelay", dynlib: libORX.}
  ## Sets spawner wave delay
  ##  @param[in]   _pstSpawner     Concerned spawner
  ##  @param[in]   _fWaveDelay     Delay between two waves / -1 for deactivating wave mode
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setNextWaveDelay*(pstSpawner: ptr orxSPAWNER; fWaveDelay: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxSpawner_SetNextWaveDelay", dynlib: libORX.}
  ## Sets spawner next wave delay (without affecting the normal wave delay)
  ##  @param[in]   _pstSpawner     Concerned spawner
  ##  @param[in]   _fWaveDelay     Delay before next wave / -1 for the current full wave delay
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getWaveSize*(pstSpawner: ptr orxSPAWNER): orxU32 {.cdecl,
    importc: "orxSpawner_GetWaveSize", dynlib: libORX.}
  ## Gets spawner wave size
  ##  @param[in]   _pstSpawner     Concerned spawner
  ##  @return      Number of objects spawned in a wave / 0 if not in wave mode

proc getWaveDelay*(pstSpawner: ptr orxSPAWNER): orxFLOAT {.cdecl,
    importc: "orxSpawner_GetWaveDelay", dynlib: libORX.}
  ## Gets spawner wave delay
  ##  @param[in]   _pstSpawner     Concerned spawner
  ##  @return      Delay between two waves / -1 if not in wave mode

proc getNextWaveDelay*(pstSpawner: ptr orxSPAWNER): orxFLOAT {.cdecl,
    importc: "orxSpawner_GetNextWaveDelay", dynlib: libORX.}
  ## Gets spawner next wave delay
  ##  @param[in]   _pstSpawner     Concerned spawner
  ##  @return      Delay before next wave is spawned / -1 if not in wave mode

proc setObjectSpeed*(pstSpawner: ptr orxSPAWNER;
                               pvObjectSpeed: ptr orxVECTOR): orxSTATUS {.cdecl,
    importc: "orxSpawner_SetObjectSpeed", dynlib: libORX.}
  ## Sets spawner object speed
  ##  @param[in]   _pstSpawner     Concerned spawner
  ##  @param[in]   _pvObjectSpeed  Speed to apply to every spawned object / nil to not apply any speed
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getObjectSpeed*(pstSpawner: ptr orxSPAWNER;
                               pvObjectSpeed: ptr orxVECTOR): ptr orxVECTOR {.cdecl,
    importc: "orxSpawner_GetObjectSpeed", dynlib: libORX.}
  ## Gets spawner object speed
  ##  @param[in]   _pstSpawner     Concerned spawner
  ##  @param[in]   _pvObjectSpeed  Speed applied to every spawned object
  ##  @return      Speed applied to every spawned object / nil if none is applied

proc spawn*(pstSpawner: ptr orxSPAWNER; u32Number: orxU32): orxU32 {.cdecl,
    importc: "orxSpawner_Spawn", dynlib: libORX.}
  ## Spawns items
  ##  @param[in]   _pstSpawner     Concerned spawner
  ##  @param[in]   _u32Number      Number of items to spawn
  ##  @return      Number of spawned items

proc getFrame*(pstSpawner: ptr orxSPAWNER): ptr orxFRAME {.cdecl,
    importc: "orxSpawner_GetFrame", dynlib: libORX.}
  ## Gets spawner frame
  ##  @param[in]   _pstSpawner     Concerned spawner
  ##  @return      orxFRAME

proc setPosition*(pstSpawner: ptr orxSPAWNER; pvPosition: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxSpawner_SetPosition", dynlib: libORX.}
  ## Sets spawner position
  ##  @param[in]   _pstSpawner     Concerned spawner
  ##  @param[in]   _pvPosition     Spawner position
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setRotation*(pstSpawner: ptr orxSPAWNER; fRotation: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxSpawner_SetRotation", dynlib: libORX.}
  ## Sets spawner rotation
  ##  @param[in]   _pstSpawner     Concerned spawner
  ##  @param[in]   _fRotation      Spawner rotation (radians)
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setScale*(pstSpawner: ptr orxSPAWNER; pvScale: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxSpawner_SetScale", dynlib: libORX.}
  ## Sets spawner scale
  ##  @param[in]   _pstSpawner     Concerned spawner
  ##  @param[in]   _pvScale        Spawner scale vector
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getPosition*(pstSpawner: ptr orxSPAWNER; pvPosition: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxSpawner_GetPosition", dynlib: libORX.}
  ## Get spawner position
  ##  @param[in]   _pstSpawner     Concerned spawner
  ##  @param[out]  _pvPosition     Spawner position
  ##  @return      orxVECTOR / nil

proc getWorldPosition*(pstSpawner: ptr orxSPAWNER;
                                 pvPosition: ptr orxVECTOR): ptr orxVECTOR {.cdecl,
    importc: "orxSpawner_GetWorldPosition", dynlib: libORX.}
  ## Get spawner world position
  ##  @param[in]   _pstSpawner     Concerned spawner
  ##  @param[out]  _pvPosition     Spawner world position
  ##  @return      orxVECTOR / nil

proc getRotation*(pstSpawner: ptr orxSPAWNER): orxFLOAT {.cdecl,
    importc: "orxSpawner_GetRotation", dynlib: libORX.}
  ## Get spawner rotation
  ##  @param[in]   _pstSpawner     Concerned spawner
  ##  @return      orxFLOAT (radians)

proc getWorldRotation*(pstSpawner: ptr orxSPAWNER): orxFLOAT {.cdecl,
    importc: "orxSpawner_GetWorldRotation", dynlib: libORX.}
  ## Get spawner world rotation
  ##  @param[in]   _pstSpawner     Concerned spawner
  ##  @return      orxFLOAT (radians)

proc getScale*(pstSpawner: ptr orxSPAWNER; pvScale: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxSpawner_GetScale", dynlib: libORX.}
  ## Get spawner scale
  ##  @param[in]   _pstSpawner     Concerned spawner
  ##  @param[out]  _pvScale        Spawner scale vector
  ##  @return      Scale vector

proc getWorldScale*(pstSpawner: ptr orxSPAWNER; pvScale: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxSpawner_GetWorldScale", dynlib: libORX.}
  ## Gets spawner world scale
  ##  @param[in]   _pstSpawner     Concerned spawner
  ##  @param[out]  _pvScale        Spawner world scale
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setParent*(pstSpawner: ptr orxSPAWNER; pParent: pointer): orxSTATUS {.
    cdecl, importc: "orxSpawner_SetParent", dynlib: libORX.}
  ## Sets spawner parent
  ##  @param[in]   _pstSpawner     Concerned spawner
  ##  @param[in]   _pParent        Parent structure to set (object, spawner, camera or frame) / nil
  ##  @return      orsSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getParent*(pstSpawner: ptr orxSPAWNER): ptr orxSTRUCTURE {.cdecl,
    importc: "orxSpawner_GetParent", dynlib: libORX.}
  ## Gets spawner parent
  ##  @param[in]   _pstSpawner Concerned spawner
  ##  @return      Parent (object, spawner, camera or frame) / nil

proc getName*(pstSpawner: ptr orxSPAWNER): cstring {.cdecl,
    importc: "orxSpawner_GetName", dynlib: libORX.}
  ## Gets spawner name
  ##  @param[in]   _pstSpawner     Concerned spawner
  ##  @return      orxSTRING / orxSTRING_EMPTY

