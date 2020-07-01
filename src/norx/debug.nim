import lib, typ, version, decl

##  *** orxDEBUG flags ***

const
  orxDEBUG_KU32_STATIC_FLAG_NONE* = 0x00000000
  orxDEBUG_KU32_STATIC_FLAG_TIMESTAMP* = 0x00000001
  orxDEBUG_KU32_STATIC_FLAG_FULL_TIMESTAMP* = 0x00000002
  orxDEBUG_KU32_STATIC_FLAG_TYPE* = 0x00000004
  orxDEBUG_KU32_STATIC_FLAG_TAGGED* = 0x00000008
  orxDEBUG_KU32_STATIC_FLAG_FILE* = 0x00000010
  orxDEBUG_KU32_STATIC_FLAG_TERMINAL* = 0x00000020
  orxDEBUG_KU32_STATIC_FLAG_CONSOLE* = 0x00000040
  orxDEBUG_KU32_STATIC_FLAG_CALLBACK* = 0x00000080
  orxDEBUG_KU32_STATIC_MASK_DEFAULT* = 0x000000F5
  orxDEBUG_KU32_STATIC_MASK_DEBUG* = 0x000000BD
  orxDEBUG_KU32_STATIC_MASK_USER_ALL* = 0x0FFFFFFF

##  *** Misc ***

const
  orxDEBUG_KZ_DEFAULT_DEBUG_FILE* = "orx-debug.log"
  orxDEBUG_KZ_DEFAULT_LOG_FILE* = "orx.log"
  orxDEBUG_KZ_DEFAULT_LOG_SUFFIX* = ".log"
  orxDEBUG_KZ_DEFAULT_DEBUG_SUFFIX* = "-debug.log"

##  Debug levels

type
  orxDEBUG_LEVEL* {.size: sizeof(cint).} = enum
    orxDEBUG_LEVEL_ANIM = 0,    ## *< Anim Debug
    orxDEBUG_LEVEL_CONFIG,    ## *< Config Debug
    orxDEBUG_LEVEL_CLOCK,     ## *< Clock Debug
    orxDEBUG_LEVEL_DISPLAY,   ## *< Display Debug
    orxDEBUG_LEVEL_FILE,      ## *< File Debug
    orxDEBUG_LEVEL_INPUT,     ## *< Input Debug
    orxDEBUG_LEVEL_JOYSTICK,  ## *< Joystick Debug
    orxDEBUG_LEVEL_KEYBOARD,  ## *< Keyboard Debug
    orxDEBUG_LEVEL_MEMORY,    ## *< Memory Debug
    orxDEBUG_LEVEL_MOUSE,     ## *< Mouse Debug
    orxDEBUG_LEVEL_OBJECT,    ## *< Object Debug
    orxDEBUG_LEVEL_PARAM,     ## *< Param Debug
    orxDEBUG_LEVEL_PHYSICS,   ## *< Physics Debug
    orxDEBUG_LEVEL_PLUGIN,    ## *< Plug-in Debug
    orxDEBUG_LEVEL_PROFILER,  ## *< Profiler Debug
    orxDEBUG_LEVEL_RENDER,    ## *< Render Debug
    orxDEBUG_LEVEL_SCREENSHOT, ## *< Screenshot Debug
    orxDEBUG_LEVEL_SOUND,     ## *< Sound Debug
    orxDEBUG_LEVEL_SYSTEM,    ## *< System Debug
    orxDEBUG_LEVEL_TIMER,     ## *< Timer Debug
    orxDEBUG_LEVEL_LOG,       ## *< Log Debug
    orxDEBUG_LEVEL_ASSERT,    ## *< Assert Debug
    orxDEBUG_LEVEL_USER,      ## *< User Debug
    orxDEBUG_LEVEL_NUMBER, orxDEBUG_LEVEL_MAX_NUMBER = 32, orxDEBUG_LEVEL_ALL = 0xFFFFFFFE, ## *< All Debugs
    orxDEBUG_LEVEL_NONE = orxENUM_NONE



# Hack to get orxLOG to compile
proc orxLOG*(s: string) =
  echo(s)

##  Log callback function

type
  orxDEBUG_CALLBACK_FUNCTION* = proc (eLevel: orxDEBUG_LEVEL; zFunction: cstring;
                                   zFile: cstring; u32Line: orxU32;
                                   zLog: cstring): orxSTATUS {.cdecl.}

##  *** Debug Macros ***

template orxDEBUG_ENABLE_LEVEL_MACRO*(LEVEL, ENABLE: untyped): untyped =
  debug.enableLevel(LEVEL, ENABLE)

template orxDEBUG_IS_LEVEL_ENABLED_MACRO*(LEVEL: untyped): untyped =
  debug.isLevelEnabled(LEVEL)

template orxDEBUG_SET_FLAGS_MACRO*(SET, UNSET: untyped): untyped =
  debug.setFlags(SET, UNSET)

template orxDEBUG_GET_FLAGS_MACRO*(): untyped =
  debug.getFlags()

template orxDEBUG_SET_LOG_CALLBACK*(CALLBACK: untyped): untyped =
  debug.setLogCallback(CALLBACK)

template orxDEBUG_SETLOGFILE*(FILE: untyped): untyped =
  debug.setLogFile(FILE)

when defined(DEBUG):
  ##  Break
  template orxBREAK*(): untyped =
    debugBreak()

  ##  Files
  template orxDEBUG_SETDEBUGFILE*(FILE: untyped): untyped =
    debug.setDebugFile(FILE)

  template orxDEBUG_SETBASEFILENAME*(FILE: untyped): void =
    var zBuffer: array[512, orxCHAR]
    zBuffer[511] = orxCHAR_NULL
    strncpy(zBuffer, FILE, 256)
    strncat(zBuffer, orxDEBUG_KZ_DEFAULT_DEBUG_SUFFIX, 255)
    orxDebug_SetDebugFile(zBuffer)
    strncpy(zBuffer, FILE, 256)
    strncat(zBuffer, orxDEBUG_KZ_DEFAULT_LOG_SUFFIX, 255)
    orxDebug_SetLogFile(zBuffer)
else:
  ##  Break
  template orxBREAK*(): void =
    nil

  ##  File
  template orxDEBUG_SETDEBUGFILE*(FILE: untyped): void =
    nil

  template orxDEBUG_SETBASEFILENAME*(FILE: untyped): void =
    var zBuffer: array[512, orxCHAR]
    zBuffer[511] = orxCHAR_NULL
    strncpy(zBuffer, FILE, 256)
    strncat(zBuffer, orxDEBUG_KZ_DEFAULT_LOG_SUFFIX, 255)
    orxDebug_SetLogFile(zBuffer)


## ***************************************************************************
##  *** Debug defines. ***

const
  orxDEBUG_KS32_BUFFER_OUTPUT_SIZE* = 2048

## ***************************************************************************
##  *** Functions ***

proc debugInit*(): orxSTATUS {.cdecl, importc: "_orxDebug_Init",
                                dynlib: libORX.}
  ## Inits the debug module
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc debugExit*() {.cdecl, importc: "_orxDebug_Exit", dynlib: libORX.}
  ## Exits from the debug module

proc log*(eLevel: orxDEBUG_LEVEL; zFunction: cstring; zFile: cstring;
                  u32Line: orxU32; zFormat: cstring) {.varargs, cdecl,
    importc: "_orxDebug_Log", dynlib: libORX.}
  ## Logs given debug text
  ##  @param[in]   _eLevel                       Debug level associated with this output
  ##  @param[in]   _zFunction                    Calling function name
  ##  @param[in]   _zFile                        Calling file name
  ##  @param[in]   _u32Line                      Calling file line
  ##  @param[in]   _zFormat                      Printf formatted text

proc enableLevel*(eLevel: orxDEBUG_LEVEL; bEnable: orxBOOL) {.cdecl,
    importc: "_orxDebug_EnableLevel", dynlib: libORX.}
  ## Enables/disables a given log level
  ##  @param[in]   _eLevel                       Debug level to enable/disable
  ##  @param[in]   _bEnable                      Enable / disable

proc isLevelEnabled*(eLevel: orxDEBUG_LEVEL): orxBOOL {.cdecl,
    importc: "_orxDebug_IsLevelEnabled", dynlib: libORX.}
  ## Is a given log level enabled?
  ##  @param[in]   _eLevel                       Concerned debug level

proc setFlags*(u32Add: orxU32; u32Remove: orxU32) {.cdecl,
    importc: "_orxDebug_SetFlags", dynlib: libORX.}
  ## Sets current debug flags
  ##  @param[in]   _u32Add                       Flags to add
  ##  @param[in]   _u32Remove                    Flags to remove

proc getFlags*(): orxU32 {.cdecl, importc: "_orxDebug_GetFlags",
                                 dynlib: libORX.}
  ## Gets current debug flags
  ##  @return Current debug flags

proc debugBreak*() {.cdecl, importc: "_orxDebug_Break", dynlib: libORX.}
  ## Software break function

proc setDebugFile*(zFileName: cstring) {.cdecl,
    importc: "_orxDebug_SetDebugFile", dynlib: libORX.}
  ## Sets debug file name
  ##  @param[in]   _zFileName                    Debug file name

proc setLogFile*(zFileName: cstring) {.cdecl,
    importc: "_orxDebug_SetLogFile", dynlib: libORX.}
  ## Sets log file name
  ##  @param[in]   _zFileName                    Log file name

proc setLogCallback*(pfnLogCallback: orxDEBUG_CALLBACK_FUNCTION) {.cdecl,
    importc: "_orxDebug_SetLogCallback", dynlib: libORX.}
  ## Sets log callback function, if the callback returns orxSTATUS_FAILURE, the log entry will be entirely inhibited
  ##  @param[in]   _pfnLogCallback                Log callback function, nil to remove it


template orxDEBUG_INIT_MACRO*(): void =
  var u32DebugFlags: orxU32
  discard debugInit()
  u32DebugFlags = getFlags()
  setFlags(orxDEBUG_KU32_STATIC_MASK_DEBUG, orxDEBUG_KU32_STATIC_MASK_USER_ALL)
  if getVersionNumeric().int64 < VERSION:
    orxLOG("The version of the runtime library [" & $getVersionFullString() &
      "] is older than the version used when compiling this program [" & VERSION_FULL_STRING & "].\n\nProblems will likely ensue!")
  elif getVersionNumeric().int64 > VERSION:
    orxLOG("The version of the runtime library [" & $getVersionFullString() &
      "] is more recent than the version used when compiling this program [" & VERSION_FULL_STRING & "].\n\nProblems may arise due to possible incompatibilities!")
  setFlags(u32DebugFlags, orxDEBUG_KU32_STATIC_MASK_USER_ALL)

template orxDEBUG_EXIT_MACRO*(): untyped =
  debugExit()

