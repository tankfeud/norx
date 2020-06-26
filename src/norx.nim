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

import norx/[incl, param, module, event, clock, memory]

when not defined(PLUGIN):
  ## Should stop execution by default event handling?
  var sbStopByEvent* = false

  ##  Orx default basic event handler
  ##  @param[in]   pstEvent                     Sent event
  ##  @return      orxSTATUS_SUCCESS if handled / orxSTATUS_FAILURE otherwise
  proc orx_DefaultEventHandler*(pstEvent: ptr orxEVENT): orxSTATUS {.cdecl.} =
    ##  Checks
    assert(pstEvent.eType == orxEVENT_TYPE_SYSTEM)
    #echo "pstEvent.eType: " & $pstEvent.eType
    #echo "pstEvent.eID: " & $pstEvent.eID
    ##  Depending on event ID
    case pstEvent.eID:
      of ord(orxSYSTEM_EVENT_CLOSE):
        ##  Updates status
        sbStopByEvent = true
      else:
        discard
    return orxSTATUS_SUCCESS

  ## Default main setup (module dependencies)
  proc orx_MainSetup*() {.cdecl.} =
    ##  Adds module dependencies
    orxModule_AddDependency(orxMODULE_ID_MAIN, orxMODULE_ID_PARAM)
    orxModule_AddDependency(orxMODULE_ID_MAIN, orxMODULE_ID_CLOCK)
    orxModule_AddDependency(orxMODULE_ID_MAIN, orxMODULE_ID_CONFIG)
    orxModule_AddDependency(orxMODULE_ID_MAIN, orxMODULE_ID_INPUT)
    orxModule_AddDependency(orxMODULE_ID_MAIN, orxMODULE_ID_EVENT)
    orxModule_AddDependency(orxMODULE_ID_MAIN, orxMODULE_ID_FILE)
    orxModule_AddDependency(orxMODULE_ID_MAIN, orxMODULE_ID_LOCALE)
    orxModule_AddDependency(orxMODULE_ID_MAIN, orxMODULE_ID_PLUGIN)
    orxModule_AddDependency(orxMODULE_ID_MAIN, orxMODULE_ID_OBJECT)
    orxModule_AddDependency(orxMODULE_ID_MAIN, orxMODULE_ID_RENDER)
    orxModule_AddOptionalDependency(orxMODULE_ID_MAIN, orxMODULE_ID_CONSOLE)
    orxModule_AddOptionalDependency(orxMODULE_ID_MAIN, orxMODULE_ID_PROFILER)
    orxModule_AddOptionalDependency(orxMODULE_ID_MAIN, orxMODULE_ID_SCREENSHOT)

  when defined(IOS):
    discard
  else:
    when defined(ANDROID) or defined(ANDROID_NATIVE):
      import
        main/orxAndroid

      ## * Orx main execution function
      ##  @param[in]   _u32NbParams                  Main function parameters number (argc)
      ##  @param[in]   _azParams                     Main function parameter list (argv)
      ##  @param[in]   _pfnInit                      Main init function (should init all the main stuff and register the main event handler to override the default one)
      ##  @param[in]   _pfnRun                       Main run function (will be called once per frame, should return orxSTATUS_SUCCESS to continue processing)
      ##  @param[in]   _pfnExit                      Main exit function (should clean all the main stuff)
      ##
      proc orx_Execute*(u32NbParams: orxU32; azParams: cstringArray;
                       pfnInit: orxMODULE_INIT_FUNCTION;
                       pfnRun: orxMODULE_RUN_FUNCTION;
                       pfnExit: orxMODULE_EXIT_FUNCTION) {.inline, cdecl.} =
        ##  Inits the Debug System
        orxDEBUG_INIT_MACRO()
        ##  Checks
        assert(pfnRun != nil)
        ##  Registers main module
        orxModule_Register(orxMODULE_ID_MAIN, "MAIN", orx_MainSetup, pfnInit, pfnExit)
        ##  Sends the command line arguments to orxParam module
        if orxParam_SetArgs(u32NbParams, azParams) != orxSTATUS_FAILURE:
          ##  Sets thread callbacks
          orxThread_SetCallbacks(orxAndroid_JNI_SetupThread, nil, nil)
          ##  Inits the engine
          if orxModule_Init(orxMODULE_ID_MAIN) != orxSTATUS_FAILURE:
            var stPayload: orxSYSTEM_EVENT_PAYLOAD
            var
              eClockStatus: orxSTATUS
              eMainStatus: orxSTATUS
            ##  Registers default event handler
            orxEvent_AddHandler(orxEVENT_TYPE_SYSTEM, orx_DefaultEventHandler)
            ##  Clears payload
            orxMemory_Zero(addr(stPayload), sizeof((orxSYSTEM_EVENT_PAYLOAD)))
            ##  Main loop
            var bStop = false
            sbStopByEvent = false
            while not bStop:
              orxAndroid_PumpEvents()
              ##  Sends frame start event
              orxEVENT_SEND_MACRO(orxEVENT_TYPE_SYSTEM,
                            orxSYSTEM_EVENT_GAME_LOOP_START, nil, nil,
                            addr(stPayload))
              ##  Runs the engine
              eMainStatus = pfnRun()
              ##  Updates clock system
              eClockStatus = orxClock_Update()
              ##  Sends frame stop event
              orxEVENT_SEND_MACRO(orxEVENT_TYPE_SYSTEM, orxSYSTEM_EVENT_GAME_LOOP_STOP,
                            nil, nil, addr(stPayload))
              ##  Updates frame count
              inc(stPayload.u32FrameCount)
              bStop = (sbStopByEvent or (eMainStatus == orxSTATUS_FAILURE) or (eClockStatus == orxSTATUS_FAILURE))
          orxEvent_RemoveHandler(orxEVENT_TYPE_SYSTEM, orx_DefaultEventHandler)
          ##  Exits from engine
          orxModule_Exit(orxMODULE_ID_MAIN)
        orxDEBUG_EXIT()

    else:
      ## * Orx main execution function
      ##  @param[in]   _u32NbParams                  Main function parameters number (argc)
      ##  @param[in]   _azParams                     Main function parameter list (argv)
      ##  @param[in]   _pfnInit                      Main init function (should init all the main stuff and register the main event handler to override the default one)
      ##  @param[in]   _pfnRun                       Main run function (will be called once per frame, should return orxSTATUS_SUCCESS to continue processing)
      ##  @param[in]   _pfnExit                      Main exit function (should clean all the main stuff)
      ##
      proc orx_Execute*(u32NbParams: orxU32; azParams: cstringArray;
                       pfnInit: orxMODULE_INIT_FUNCTION;
                       pfnRun: orxMODULE_RUN_FUNCTION;
                       pfnExit: orxMODULE_EXIT_FUNCTION) {.inline, cdecl.} =
        ##  Inits the Debug System
        orxDEBUG_INIT_MACRO()
        ##  Checks
        assert(u32NbParams > 0)
        assert(azParams != nil)
        assert(pfnRun != nil)
        ##  Registers main module
        orxModule_Register(orxMODULE_ID_MAIN, "MAIN", orx_MainSetup, pfnInit, pfnExit)
        ##  Sends the command line arguments to orxParam module
        if orxParam_SetArgs(u32NbParams, azParams) != orxSTATUS_FAILURE:
          ##  Inits the engine
          if orxModule_Init(orxMODULE_ID_MAIN) != orxSTATUS_FAILURE:
            var
              stPayload: orxSYSTEM_EVENT_PAYLOAD
              eClockStatus: orxSTATUS
              eMainStatus: orxSTATUS
            ##  Registers default event handler
            var st = orxEvent_AddHandler(orxEVENT_TYPE_SYSTEM, orx_DefaultEventHandler)
            ##  Clears payload
            discard orxMemory_Zero(addr(stPayload), sizeof(orxSYSTEM_EVENT_PAYLOAD).orxU32)
            ##  Main loop
            var bStop = false
            sbStopByEvent = false
            while not bStop:
              ##  Sends frame start event
              orxEVENT_SEND_MACRO(orxEVENT_TYPE_SYSTEM, orxSYSTEM_EVENT_GAME_LOOP_START, nil, nil, addr(stPayload))
              ##  Runs the engine
              eMainStatus = pfnRun()
              ##  Updates clock system
              eClockStatus = orxClock_Update()
              ##  Sends frame stop event
              orxEVENT_SEND_MACRO(orxEVENT_TYPE_SYSTEM, orxSYSTEM_EVENT_GAME_LOOP_STOP, nil, nil, addr(stPayload))
              ##  Updates frame count
              stPayload.u32FrameCount += 1
              bStop = (sbStopByEvent or (eMainStatus == orxSTATUS_FAILURE) or (eClockStatus == orxSTATUS_FAILURE))
          discard orxEvent_RemoveHandler(orxEVENT_TYPE_SYSTEM, cast[orxEVENT_HANDLER](orx_DefaultEventHandler))
          ##  Exits from engine
          orxModule_Exit(orxMODULE_ID_MAIN)
        orxDEBUG_EXIT()