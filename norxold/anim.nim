import incl, structure

const
  ## Anim flags
  orxANIM_KU32_FLAG_NONE* = 0x00000000
  orxANIM_KU32_FLAG_2D* = 0x00000001
  orxANIM_KU32_MASK_USER_ALL* = 0x0000000F
  orxANIM_KU32_MASK_ALL* = 0xFFFFFFFF

const
  orxANIM_KU32_KEY_MAX_NUMBER* = 65535
  orxANIM_KU32_EVENT_MAX_NUMBER* = 65535


type orxANIM* = object
  ## Internal Anim structure

type
  orxANIM_EVENT* {.size: sizeof(cint).} = enum
    ## Event enum
    orxANIM_EVENT_START = 0,    ## Event sent when an animation starts
    orxANIM_EVENT_STOP,       ## Event sent when an animation stops
    orxANIM_EVENT_CUT,        ## Event sent when an animation is cut
    orxANIM_EVENT_LOOP,       ## Event sent when an animation has looped
    orxANIM_EVENT_UPDATE,     ## Event sent when an animation has been updated (current key)
    orxANIM_EVENT_CUSTOM_EVENT, ## Event sent when a custom event is reached
    orxANIM_EVENT_NUMBER, orxANIM_EVENT_NONE = orxENUM_NONE

type
  INNER_C_STRUCT_orxAnim_115* {.bycopy.} = object
    u32Count*: orxU32          ## Loop count : 12

  INNER_C_STRUCT_orxAnim_121* {.bycopy.} = object
    fTime*: orxFLOAT           ## Anim time when cut: 12

  INNER_C_STRUCT_orxAnim_127* {.bycopy.} = object
    zName*: cstring         ## Custom event name : 12
    fValue*: orxFLOAT          ## Custom event value : 16
    fTime*: orxFLOAT           ## Custom event time : 20

  INNER_C_UNION_orxAnim_113* {.bycopy, union.} = object
    stLoop*: INNER_C_STRUCT_orxAnim_115 ##  Loop event
    ##  Cut event
    stCut*: INNER_C_STRUCT_orxAnim_121 ##  Custom event
    stCustom*: INNER_C_STRUCT_orxAnim_127

  orxANIM_EVENT_PAYLOAD* {.bycopy.} = object
    ## Anim event payload
    pstAnim*: ptr orxANIM       ## Animation reference : 4
    zAnimName*: cstring     ## Animation name : 8
    ano_orxAnim_131*: INNER_C_UNION_orxAnim_113

type
  orxANIM_CUSTOM_EVENT* {.bycopy.} = object
    ## Anim custom event
    zName*: cstring         ## Event name : 4
    fValue*: orxFLOAT          ## Event value : 8
    fTimeStamp*: orxFLOAT      ## Timestamp : 12


proc animSetup*() {.cdecl, importc: "orxAnim_Setup", dynlib: libORX.}
  ## Anim module setup

proc animInit*(): orxSTATUS {.cdecl, importc: "orxAnim_Init", dynlib: libORX.}
  ## Inits the Anim module

proc animExit*() {.cdecl, importc: "orxAnim_Exit", dynlib: libORX.}
  ## Exits from the Anim module

proc animCreate*(u32Flags: orxU32; u32KeyNumber: orxU32; u32EventNumber: orxU32): ptr orxANIM {.
    cdecl, importc: "orxAnim_Create", dynlib: libORX.}
  ## Creates an empty animation
  ##  @param[in]   _u32Flags       Flags for created animation
  ##  @param[in]   _u32KeyNumber   Number of keys for this animation
  ##  @param[in]   _u32EventNumber Number of events for this animation
  ##  @return      Created orxANIM / nil

proc delete*(pstAnim: ptr orxANIM): orxSTATUS {.cdecl,
    importc: "orxAnim_Delete", dynlib: libORX.}
  ## Deletes an animation
  ##  @param[in]   _pstAnim        Anim to delete
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc addKey*(pstAnim: ptr orxANIM; pstData: ptr orxSTRUCTURE;
                    fTimeStamp: orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxAnim_AddKey", dynlib: libORX.}
  ## Adds a key to an animation
  ##  @param[in]   _pstAnim        Concerned animation
  ##  @param[in]   _pstData        Key data to add
  ##  @param[in]   _fTimeStamp     Timestamp for this key
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc removeLastKey*(pstAnim: ptr orxANIM): orxSTATUS {.cdecl,
    importc: "orxAnim_RemoveLastKey", dynlib: libORX.}
  ## Removes last added key from an animation
  ##  @param[in]   _pstAnim        Concerned animation
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc removeAllKeys*(pstAnim: ptr orxANIM) {.cdecl,
    importc: "orxAnim_RemoveAllKeys", dynlib: libORX.}
  ## Removes all keys from an animation
  ##  @param[in]   _pstAnim        Concerned animation

proc addEvent*(pstAnim: ptr orxANIM; zEventName: cstring;
                      fTimeStamp: orxFLOAT; fValue: orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxAnim_AddEvent", dynlib: libORX.}
  ## Adds an event to an animation
  ##  @param[in]   _pstAnim        Concerned animation
  ##  @param[in]   _zEventName     Event name to add
  ##  @param[in]   _fTimeStamp     Timestamp for this event
  ##  @param[in]   _fValue         Value for this event
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc removeLastEvent*(pstAnim: ptr orxANIM): orxSTATUS {.cdecl,
    importc: "orxAnim_RemoveLastEvent", dynlib: libORX.}
  ## Removes last added event from an animation
  ##  @param[in]   _pstAnim        Concerned animation
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc removeAllEvents*(pstAnim: ptr orxANIM) {.cdecl,
    importc: "orxAnim_RemoveAllEvents", dynlib: libORX.}
  ## Removes all events from an animation
  ##  @param[in]   _pstAnim        Concerned animation

proc getNextEvent*(pstAnim: ptr orxANIM; fTimeStamp: orxFLOAT): ptr orxANIM_CUSTOM_EVENT {.
    cdecl, importc: "orxAnim_GetNextEvent", dynlib: libORX.}
  ## Gets next event after given timestamp
  ##  @param[in]   _pstAnim        Concerned animation
  ##  @param[in]   _fTimeStamp     Time stamp, excluded
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getKey*(pstAnim: ptr orxANIM; fTimeStamp: orxFLOAT): orxU32 {.cdecl,
    importc: "orxAnim_GetKey", dynlib: libORX.}
  ## Gets animation's key index from a time stamp
  ##  @param[in]   _pstAnim        Concerned animation
  ##  @param[in]   _fTimeStamp     TimeStamp of the desired animation key
  ##  @return      Animation key index / orxU32_UNDEFINED

proc getKeyData*(pstAnim: ptr orxANIM; u32Index: orxU32): ptr orxSTRUCTURE {.
    cdecl, importc: "orxAnim_GetKeyData", dynlib: libORX.}
  ## Anim key data accessor
  ##  @param[in]   _pstAnim        Concerned animation
  ##  @param[in]   _u32Index       Index of desired key data
  ##  @return      Desired orxSTRUCTURE / nil

proc getKeyStorageSize*(pstAnim: ptr orxANIM): orxU32 {.cdecl,
    importc: "orxAnim_GetKeyStorageSize", dynlib: libORX.}
  ## Anim key storage size accessor
  ##  @param[in]   _pstAnim        Concerned animation
  ##  @return      Anim key storage size

proc getKeyCount*(pstAnim: ptr orxANIM): orxU32 {.cdecl,
    importc: "orxAnim_GetKeyCount", dynlib: libORX.}
  ## Anim key count accessor
  ##  @param[in]   _pstAnim        Concerned animation
  ##  @return      Anim key count

proc getEventStorageSize*(pstAnim: ptr orxANIM): orxU32 {.cdecl,
    importc: "orxAnim_GetEventStorageSize", dynlib: libORX.}
  ## Anim event storage size accessor
  ##  @param[in]   _pstAnim        Concerned animation
  ##  @return      Anim event storage size

proc getEventCount*(pstAnim: ptr orxANIM): orxU32 {.cdecl,
    importc: "orxAnim_GetEventCount", dynlib: libORX.}
  ## Anim event count accessor
  ##  @param[in]   _pstAnim        Concerned animation
  ##  @return      Anim event count

proc getLength*(pstAnim: ptr orxANIM): orxFLOAT {.cdecl,
    importc: "orxAnim_GetLength", dynlib: libORX.}
  ## Anim time length accessor
  ##  @param[in]   _pstAnim        Concerned animation
  ##  @return      Anim time length

proc getName*(pstAnim: ptr orxANIM): cstring {.cdecl,
    importc: "orxAnim_GetName", dynlib: libORX.}
  ## Anim name get accessor
  ##  @param[in]   _pstAnim        Concerned animation
  ##  @return      orxSTRING / orxSTRING_EMPTY

