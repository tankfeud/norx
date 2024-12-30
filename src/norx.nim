import os
import wrapper
export wrapper

#[ ##  Windows
when defined(Windows):
  type
    orxHANDLE* = pointer
  when defined(X86_64):
    type
      orxU32* = cuint
      orxU16* = cushort
      orxU8* = uint8
      orxS32* = cint
      orxS16* = cshort
      orxS8* = cchar
      orxBOOL* = distinct cuint
  else:
    type
      orxU32* = culong
      orxU16* = cushort
      orxU8* = uint8
      orxS32* = clong
      orxS16* = cshort
      orxS8* = cchar
      orxBOOL* = distinct culong

  ##  Compiler specific
  when defined(GCC):
    type
      orxU64* = culonglong
      orxS64* = clonglong
  when defined(LLVM):
    type
      orxU64* = culonglong
      orxS64* = clonglong

  type
    orxFLOAT* = cfloat
    orxDOUBLE* = cdouble
    orxCHAR* = char
  type
    orxSTRINGID* = orxU32
    orxENUM* = orxU32
  template orx2F*(V: untyped): untyped =
    ((orxFLOAT)(V))

  template orx2D*(V: untyped): untyped =
    ((orxDOUBLE)(V))

  const
    orxENUM_NONE* = 0xFFFFFFFF

else:
  ##  Linux / Mac / iOS / Android
  when defined(Linux) or defined(MacOSX) or defined(iOS) or defined(Android) or
      defined(ANDROID_NATIVE):
    type
      orxHANDLE* = pointer
    when declared(orx64):
      type
        orxU64* = culonglong
        orxU32* = cuint
        orxU16* = cushort
        orxU8* = uint8
        orxS64* = clonglong
        orxS32* = cint
        orxS16* = cshort
        orxS8* = cchar
        orxBOOL* = distinct cuint
    else:
      type
        orxU64* = culonglong
        orxU32* = culong
        orxU16* = cushort
        orxU8* = uint8
        orxS64* = clonglong
        orxS32* = clong
        orxS16* = cshort
        orxS8* = cchar
        orxBOOL* = distinct culong
    type
      orxFLOAT* = cfloat
      orxDOUBLE* = cdouble
      orxCHAR* = char
    type
      orxSTRINGID* = orxU64
      orxENUM* = orxU32
    template orx2F*(V: untyped): untyped =
      ((orxFLOAT)(V))

    template orx2D*(V: untyped): untyped =
      ((orxDOUBLE)(V))

    const
      orxENUM_NONE* = 0xFFFFFFFF
      # orxENUM_NONE* = -1 # TODO: this value was 0xFFFFFFFF used as a commaon NONE-enum for many Enum but Nim can't handle a Range from 0 to 0xFFFFFFFF when we need to iterate Enum values.

 ]#

## Version constants
const
  ORX_VERSION_STRING* = $compiler_orxVERSION_MAJOR_private & "." & $compiler_orxVERSION_MINOR_private & "-" & $compiler_orxVERSION_RELEASE_private
  ORX_VERSION_FULL_STRING* = $compiler_orxVERSION_MAJOR_private & "." & $compiler_orxVERSION_MINOR_private & "." & $compiler_orxVERSION_BUILD_private & "-" & $compiler_orxVERSION_RELEASE_private
  ORX_VERSION_MASK_MAJOR = 0xFF000000
  ORX_VERSION_SHIFT_MAJOR = 24
  ORX_VERSION_MASK_MINOR = 0x00FF0000
  ORX_VERSION_SHIFT_MINOR = 16
  ORX_VERSION_MASK_BUILD = 0x0000FFFF
  ORX_VERSION_SHIFT_BUILD = 0
  ORX_VERSION*: int64 = (((compiler_orxVERSION_MAJOR_private shl ORX_VERSION_SHIFT_MAJOR) and ORX_VERSION_MASK_MAJOR) or
      ((compiler_orxVERSION_MINOR_private shl ORX_VERSION_SHIFT_MINOR) and ORX_VERSION_MASK_MINOR) or
      ((compiler_orxVERSION_BUILD_private shl ORX_VERSION_SHIFT_BUILD) and ORX_VERSION_MASK_BUILD))

## Boolean constants
const
  orxFALSE* = 0.orxBOOL
  orxTRUE* = 1.orxBOOL

converter toBool*(x: orxBOOL): bool = cint(x) != 0
  ## Converts orxBOOL to bool

converter toOrxBOOL*(x: bool): orxBOOL = orxBOOL(if x: 1 else: 0)
  ## Converts bool to orxBOOL

template debugInitMacro*(): void =
  var u32DebugFlags: orxU32
  discard internal_orxDebug_Init()
  u32DebugFlags = internal_orxDebug_GetFlags()
  internal_orxDebug_SetFlags(DEBUG_KU32_STATIC_MASK_DEBUG, DEBUG_KU32_STATIC_MASK_USER_ALL)
  #echo "ORX_VERSION: ", ORX_VERSION
  #echo "Version Numeric: ", getVersionNumeric().int64
  if getVersionNumeric().int64 < ORX_VERSION:
    echo("The version of the runtime library [" & $getVersionFullString() &
      "] is older than the version used when compiling this program [" & ORX_VERSION_FULL_STRING & "].\n\nProblems will likely ensue!")
  elif getVersionNumeric().int64 > ORX_VERSION:
    echo("The version of the runtime library [" & $getVersionFullString() &
      "] is more recent than the version used when compiling this program [" & ORX_VERSION_FULL_STRING & "].\n\nProblems may arise due to possible incompatibilities!")
  internal_orxDebug_SetFlags(u32DebugFlags, DEBUG_KU32_STATIC_MASK_USER_ALL)


template debugExitMacro*(): untyped =
  internal_orxDebug_Exit()

template eventSendMacro*(TYPE, ID, SENDER, RECIPIENT, PAYLOAD: untyped): void =
  var stEvent: orxEVENT
  stEvent.eType = cast[orxEVENT_TYPE](TYPE)
  stEvent.eID = cast[orxENUM](ID)
  stEvent.hSender = cast[orxHANDLE](SENDER)
  stEvent.hRecipient = cast[orxHANDLE](RECIPIENT)
  stEvent.pstPayload = cast[pointer](PAYLOAD)
  discard eventSend(addr(stEvent))

when not defined(PLUGIN):
  ## Should stop execution by default event handling?
  var sbStopByEvent* = false

  proc mainSetup*() {.cdecl.} =
    ##  Adds module dependencies
    addDependency(MODULE_ID_MAIN, MODULE_ID_OBJECT)
    addDependency(MODULE_ID_MAIN, MODULE_ID_RENDER)
    addOptionalDependency(MODULE_ID_MAIN, MODULE_ID_SCREENSHOT)

  proc defaultEventHandler*(pstEvent: ptr orxEVENT): orxSTATUS {.cdecl.} =
    ##  Check for close event
    assert(pstEvent.eType == EVENT_TYPE_SYSTEM)
    if pstEvent.eID == ord(SYSTEM_EVENT_CLOSE):
      sbStopByEvent = true
    return STATUS_SUCCESS


  when defined(iOS):
    discard
  else:
    when defined(Android) or defined(ANDROID_NATIVE):
      import android

      ## Orx main execution function
      ##  @param[in]   initProc      Main init function (should init all the main stuff and register the main event handler to override the default one)
      ##  @param[in]   runProc       Main run function (will be called once per frame, should return orxSTATUS_SUCCESS to continue processing)
      ##  @param[in]   exitProc      Main exit function (should clean all the main stuff)
      proc execute*(initProc: proc(): orxSTATUS {.cdecl.};
                       runProc: proc(): orxSTATUS {.cdecl.};
                       exitProc: proc() {.cdecl.}) {.inline} =
        ## Inits the Debug System
        debugInitMacro()
        ## Checks
        assert(runProc != nil)
        ##  Registers main module
        register(MODULE_ID_MAIN, "MAIN", mainSetup, initProc, exitProc)
        ## On Android this is 0, null.
        if setArgs(0, nil) != STATUS_FAILURE:
          ##  Sets thread callbacks
          discard setCallbacks(orxAndroid_JNI_SetupThread, nil, nil)
          ##  Inits the engine
          if moduleInit(MODULE_ID_MAIN) != STATUS_FAILURE:
            var
              stPayload: struct_orxSYSTEM_EVENT_PAYLOAD_t
              eClockStatus: orxSTATUS
              eMainStatus: orxSTATUS

            ##  Registers default event handler
            var st = addHandler(orxEVENT_TYPE_SYSTEM, orx_DefaultEventHandler)
            discard setHandlerIDFlags(orx_DefaultEventHandler, orxEVENT_TYPE_SYSTEM, nil, orxEVENT_GET_FLAG(orxSYSTEM_EVENT_CLOSE), orxEVENT_KU32_MASK_ID_ALL)
            ##  Clears payload
            zeroMem(addr(stPayload), sizeof(orxSYSTEM_EVENT_PAYLOAD).orxU32)
            ##  Main loop
            var bStop = false
            sbStopByEvent = false
            while not bStop:
              orxAndroid_PumpEvents()
              ##  Sends frame start event
              orxEVENT_SEND_MACRO(orxEVENT_TYPE_SYSTEM, orxSYSTEM_EVENT_GAME_LOOP_START, nil, nil, addr(stPayload))
              ##  Runs game specific code
              eMainStatus = runProc()
              ##  Updates clock system
              eClockStatus = update()
              ##  Sends frame stop event
              orxEVENT_SEND_MACRO(orxEVENT_TYPE_SYSTEM, orxSYSTEM_EVENT_GAME_LOOP_STOP, nil, nil, addr(stPayload))
              ##  Updates frame count
              stPayload.u32FrameCount += 1
              bStop = (sbStopByEvent or (eMainStatus == STATUS_FAILURE) or (eClockStatus == STATUS_FAILURE))

            ##  Removes event handler
            discard removeHandler(orxEVENT_TYPE_SYSTEM, cast[orxEVENT_HANDLER](orx_DefaultEventHandler))
            ##  Exits from the engine
            moduleExit(orxMODULE_ID_MAIN)
        debugExitMacro()
    else:
      ## Orx main execution function
      ##  @param[in]   initProc      Main init function (should init all the main stuff and register the main event handler to override the default one)
      ##  @param[in]   runProc       Main run function (will be called once per frame, should return orxSTATUS_SUCCESS to continue processing)
      ##  @param[in]   exitProc      Main exit function (should clean all the main stuff)
      proc execute*(initProc: proc(): orxSTATUS {.cdecl.};
                            runProc: proc(): orxSTATUS {.cdecl.};
                            exitProc: proc() {.cdecl.}) {.inline} =
        ## Inits the Debug System
        debugInitMacro()
        ## Checks
        assert(runProc != nil)
        ##  Registers main module
        moduleRegister(MODULE_ID_MAIN, "MAIN", mainSetup, initProc, exitProc)
        # Hack to produce C style argc/argv to pass on
        var argc = paramCount()
        var nargv = newSeq[string](argc + 1)
        nargv[0] = getAppFilename()  # Better than paramStr(0)
        var x = 1
        while x <= argc:
          nargv[x] = paramStr(x)
          inc(x)
        var argv: cstringArray = nargv.allocCStringArray()
        inc(argc)
        ##  Sends the command line arguments to orxParam module
        if orxParam_SetArgs(argc.orxU32, argv) != STATUS_FAILURE:
          ##  Inits the engine
          if moduleInit(MODULE_ID_MAIN) != STATUS_FAILURE:
            var
              stPayload: struct_orxSYSTEM_EVENT_PAYLOAD_t
              eClockStatus: orxSTATUS
              eMainStatus: orxSTATUS
            ##  Registers default event handler
            var st = addHandler(EVENT_TYPE_SYSTEM, defaultEventHandler)
            # ?? discard orxEvent_SetHandlerIDFlags(orx_DefaultEventHandler, orxEVENT_TYPE_SYSTEM, nil, orxEVENT_GET_FLAG(orxSYSTEM_EVENT_CLOSE), orxEVENT_KU32_MASK_ID_ALL)
            ##  Clears payload
            zeroMem(addr(stPayload), sizeof(struct_orxSYSTEM_EVENT_PAYLOAD_t).orxU32)
            ##  Main loop
            var
              bStop = false
            sbStopByEvent = false
            while not bStop:
              ##  Sends frame start event
              eventSendMacro(EVENT_TYPE_SYSTEM, SYSTEM_EVENT_GAME_LOOP_START, nil, nil, addr(stPayload))
              ##  Runs game specific code
              eMainStatus = runProc()
              ##  Updates clock system
              eClockStatus = clockUpdate()
              ##  Sends frame stop event
              eventSendMacro(EVENT_TYPE_SYSTEM, SYSTEM_EVENT_GAME_LOOP_STOP, nil, nil, addr(stPayload))
              ##  Updates frame count
              stPayload.anon0.u32FrameCount += 1
              bStop = (sbStopByEvent or (eMainStatus == STATUS_FAILURE) or (eClockStatus == STATUS_FAILURE))

            ##  Removes event handler
            discard removeHandler(EVENT_TYPE_SYSTEM, cast[orxEVENT_HANDLER](defaultEventHandler))
            ##  Exits from the engine
            moduleExit(MODULE_ID_MAIN)
        debugExitMacro()
