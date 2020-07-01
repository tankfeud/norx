import lib, typ, vector, version

## * Event enum
##

type
  orxSYSTEM_EVENT* {.size: sizeof(cint).} = enum
    orxSYSTEM_EVENT_CLOSE = 0, orxSYSTEM_EVENT_FOCUS_GAINED,
    orxSYSTEM_EVENT_FOCUS_LOST, orxSYSTEM_EVENT_BACKGROUND,
    orxSYSTEM_EVENT_FOREGROUND, orxSYSTEM_EVENT_GAME_LOOP_START,
    orxSYSTEM_EVENT_GAME_LOOP_STOP, orxSYSTEM_EVENT_TOUCH_BEGIN,
    orxSYSTEM_EVENT_TOUCH_MOVE, orxSYSTEM_EVENT_TOUCH_END,
    orxSYSTEM_EVENT_ACCELERATE, orxSYSTEM_EVENT_MOTION_SHAKE,
    orxSYSTEM_EVENT_DROP, orxSYSTEM_EVENT_CLIPBOARD, orxSYSTEM_EVENT_NUMBER,
    orxSYSTEM_EVENT_NONE = orxENUM_NONE


## * System event payload
##

type
  INNER_C_STRUCT_orxSystem_94* {.bycopy.} = object
    dTime*: orxDOUBLE
    u32ID*: orxU32
    fX*: orxFLOAT
    fY*: orxFLOAT
    fPressure*: orxFLOAT

  INNER_C_STRUCT_orxSystem_102* {.bycopy.} = object
    dTime*: orxDOUBLE
    vAcceleration*: orxVECTOR

  INNER_C_STRUCT_orxSystem_109* {.bycopy.} = object
    azValueList*: cstringArray
    u32Number*: orxU32

  INNER_C_STRUCT_orxSystem_117* {.bycopy.} = object
    zValue*: cstring

  orxSYSTEM_EVENT_PAYLOAD* {.bycopy, union.} = object
    u32FrameCount*: orxU32     ##  Touch event
    stTouch*: INNER_C_STRUCT_orxSystem_94 ##  Accelerometer event
    stAccelerometer*: INNER_C_STRUCT_orxSystem_102 ##  Drop event
    stDrop*: INNER_C_STRUCT_orxSystem_109 ##  Clipboard event
    stClipboard*: INNER_C_STRUCT_orxSystem_117

## * System module setup
##

proc orxSystem_Setup*() {.cdecl, importc: "orxSystem_Setup", dynlib: libORX.}
## * Inits the system module
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxSystem_Init*(): orxSTATUS {.cdecl, importc: "orxSystem_Init",
                                 dynlib: libORX.}
## * Exits from the system module
##

proc orxSystem_Exit*() {.cdecl, importc: "orxSystem_Exit", dynlib: libORX.}
## * Gets current time (elapsed from the beginning of the application, in seconds)
##  @return Current time
##

proc orxSystem_GetTime*(): orxDOUBLE {.cdecl, importc: "orxSystem_GetTime",
                                    dynlib: libORX.}
## * Gets real time (in seconds)
##  @return Returns the amount of seconds elapsed since reference time (epoch)
##

proc orxSystem_GetRealTime*(): orxU64 {.cdecl, importc: "orxSystem_GetRealTime",
                                     dynlib: libORX.}
## * Gets current internal system time (in seconds)
##  @return Current internal system time
##

proc orxSystem_GetSystemTime*(): orxDOUBLE {.cdecl,
    importc: "orxSystem_GetSystemTime", dynlib: libORX.}
## * Delay the program for given number of seconds
##  @param[in] _fSeconds             Number of seconds to wait
##

proc orxSystem_Delay*(fSeconds: orxFLOAT) {.cdecl, importc: "orxSystem_Delay",
    dynlib: libORX.}
## * Gets orx version (compiled)
##  @param[out] _pstVersion          Structure to fill with current version
##  @return Compiled version
##

proc orxSystem_GetVersion*(pstVersion: ptr orxVERSION): ptr orxVERSION {.cdecl,
    importc: "orxSystem_GetVersion", dynlib: libORX.}
## * Gets orx version literal (compiled), excluding build number
##  @return Compiled version literal
##

proc orxSystem_GetVersionString*(): cstring {.cdecl,
    importc: "orxSystem_GetVersionString", dynlib: libORX.}
## * Gets orx version literal (compiled), including build number
##  @return Compiled version literal
##

proc orxSystem_GetVersionFullString*(): cstring {.cdecl,
    importc: "orxSystem_GetVersionFullString", dynlib: libORX.}
## * Gets orx version absolute numeric value (compiled)
##  @return Absolute numeric value of compiled version
##

proc orxSystem_GetVersionNumeric*(): orxU32 {.cdecl,
    importc: "orxSystem_GetVersionNumeric", dynlib: libORX.}
## * Gets clipboard's content
##  @return Clipboard's content / nil, valid until next call to orxSystem_GetClipboard/orxSystem_SetClipboard
##

proc orxSystem_GetClipboard*(): cstring {.cdecl,
    importc: "orxSystem_GetClipboard", dynlib: libORX.}
## * Sets clipboard's content
##  @param[in] _zValue               Value to set in the clipboard, nil to clear
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxSystem_SetClipboard*(zValue: cstring): orxSTATUS {.cdecl,
    importc: "orxSystem_SetClipboard", dynlib: libORX.}
