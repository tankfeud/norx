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


import incl, system, module

const
  orxCLOCK_KU32_CLOCK_BANK_SIZE* = 16
  orxCLOCK_KU32_TIMER_BANK_SIZE* = 32
  orxCLOCK_KU32_FUNCTION_BANK_SIZE* = 16
  orxCLOCK_KZ_CORE* = "core"

## * Clock type enum
##

type
  orxCLOCK_TYPE* {.size: sizeof(cint).} = enum
    orxCLOCK_TYPE_CORE = 0, orxCLOCK_TYPE_USER, orxCLOCK_TYPE_SECOND,
    orxCLOCK_TYPE_NUMBER, orxCLOCK_TYPE_NONE = orxENUM_NONE


## * Clock mod type enum
##

type
  orxCLOCK_MOD_TYPE* {.size: sizeof(cint).} = enum
    orxCLOCK_MOD_TYPE_FIXED = 0, ## *< The given DT will always be constant (= modifier value)
    orxCLOCK_MOD_TYPE_MULTIPLY, ## *< The given DT will be the real one * modifier
    orxCLOCK_MOD_TYPE_MAXED,  ## *< The given DT will be the real one maxed by the modifier value
    orxCLOCK_MOD_TYPE_NUMBER, orxCLOCK_MOD_TYPE_NONE = orxENUM_NONE


## * Clock priority
##

type
  orxCLOCK_PRIORITY* {.size: sizeof(cint).} = enum
    orxCLOCK_PRIORITY_LOWEST = 0, orxCLOCK_PRIORITY_LOWER, orxCLOCK_PRIORITY_LOW,
    orxCLOCK_PRIORITY_NORMAL, orxCLOCK_PRIORITY_HIGH, orxCLOCK_PRIORITY_HIGHER,
    orxCLOCK_PRIORITY_HIGHEST, orxCLOCK_PRIORITY_NUMBER,
    orxCLOCK_PRIORITY_NONE = orxENUM_NONE


## * Clock info structure
##

type
  orxCLOCK_INFO* {.bycopy.} = object
    eType*: orxCLOCK_TYPE      ## *< Clock type : 4
    fTickSize*: orxFLOAT       ## *< Clock tick size (in seconds) : 8
    eModType*: orxCLOCK_MOD_TYPE ## *< Clock mod type : 12
    fModValue*: orxFLOAT       ## *< Clock mod value : 16
    fDT*: orxFLOAT             ## *< Clock DT (time elapsed between 2 clock calls in seconds) : 20
    fTime*: orxFLOAT           ## *< Clock time : 24


## * Event enum
##

type
  orxCLOCK_EVENT* {.size: sizeof(cint).} = enum
    orxCLOCK_EVENT_RESTART = 0, ## *< Event sent when a clock restarts
    orxCLOCK_EVENT_RESYNC,    ## *< Event sent when a clock resyncs
    orxCLOCK_EVENT_PAUSE,     ## *< Event sent when a clock is paused
    orxCLOCK_EVENT_UNPAUSE,   ## *< Event sent when a clock is unpaused
    orxCLOCK_EVENT_NUMBER, orxCLOCK_EVENT_NONE = orxENUM_NONE


## * Clock structure

type orxCLOCK* = object
## * Clock callback function type to use with clock bindings

type
  orxCLOCK_FUNCTION* = proc (pstClockInfo: ptr orxCLOCK_INFO; pContext: pointer) {.cdecl.}

## * Clock module setup
##

proc orxClock_Setup*() {.cdecl, importc: "orxClock_Setup", dynlib: libORX.}
## * Inits the clock module
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxClock_Init*(): orxSTATUS {.cdecl, importc: "orxClock_Init",
                                dynlib: libORX.}
## * Exits from the clock module
##

proc orxClock_Exit*() {.cdecl, importc: "orxClock_Exit", dynlib: libORX.}
## * Updates the clock system
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxClock_Update*(): orxSTATUS {.cdecl, importc: "orxClock_Update",
                                  dynlib: libORX.}
## * Creates a clock
##  @param[in]   _fTickSize                            Tick size for the clock (in seconds)
##  @param[in]   _eType                                Type of the clock
##  @return      orxCLOCK / nil
##

proc orxClock_Create*(fTickSize: orxFLOAT; eType: orxCLOCK_TYPE): ptr orxCLOCK {.cdecl,
    importc: "orxClock_Create", dynlib: libORX.}
## * Creates a clock from config
##  @param[in]   _zConfigID    Config ID
##  @ return orxCLOCK / nil
##

proc orxClock_CreateFromConfig*(zConfigID: cstring): ptr orxCLOCK {.cdecl,
    importc: "orxClock_CreateFromConfig", dynlib: libORX.}
## * Deletes a clock
##  @param[in]   _pstClock                             Concerned clock
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxClock_Delete*(pstClock: ptr orxCLOCK): orxSTATUS {.cdecl,
    importc: "orxClock_Delete", dynlib: libORX.}
## * Resyncs a clock (accumulated DT => 0)
##  @param[in]   _pstClock                             Concerned clock
##

proc orxClock_Resync*(pstClock: ptr orxCLOCK): orxSTATUS {.cdecl,
    importc: "orxClock_Resync", dynlib: libORX.}
## * Resyncs all clocks (accumulated DT => 0)
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxClock_ResyncAll*(): orxSTATUS {.cdecl, importc: "orxClock_ResyncAll",
                                     dynlib: libORX.}
## * Restarts a clock
##  @param[in]   _pstClock                             Concerned clock
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxClock_Restart*(pstClock: ptr orxCLOCK): orxSTATUS {.cdecl,
    importc: "orxClock_Restart", dynlib: libORX.}
## * Pauses a clock
##  @param[in]   _pstClock                             Concerned clock
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxClock_Pause*(pstClock: ptr orxCLOCK): orxSTATUS {.cdecl,
    importc: "orxClock_Pause", dynlib: libORX.}
## * Unpauses a clock
##  @param[in]   _pstClock                             Concerned clock
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxClock_Unpause*(pstClock: ptr orxCLOCK): orxSTATUS {.cdecl,
    importc: "orxClock_Unpause", dynlib: libORX.}
## * Is a clock paused?
##  @param[in]   _pstClock                             Concerned clock
##  @return      orxTRUE if paused, orxFALSE otherwise
##

proc orxClock_IsPaused*(pstClock: ptr orxCLOCK): orxBOOL {.cdecl,
    importc: "orxClock_IsPaused", dynlib: libORX.}
## * Gets clock info
##  @param[in]   _pstClock                             Concerned clock
##  @return      orxCLOCK_INFO / nil
##

proc orxClock_GetInfo*(pstClock: ptr orxCLOCK): ptr orxCLOCK_INFO {.cdecl,
    importc: "orxClock_GetInfo", dynlib: libORX.}
## * Gets clock from its info
##  @param[in]   _pstClockInfo                         Concerned clock info
##  @return      orxCLOCK / nil
##

proc orxClock_GetFromInfo*(pstClockInfo: ptr orxCLOCK_INFO): ptr orxCLOCK {.cdecl,
    importc: "orxClock_GetFromInfo", dynlib: libORX.}
## * Sets a clock modifier
##  @param[in]   _pstClock                             Concerned clock
##  @param[in]   _eModType                             Modifier type
##  @param[in]   _fModValue                            Modifier value
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxClock_SetModifier*(pstClock: ptr orxCLOCK; eModType: orxCLOCK_MOD_TYPE;
                          fModValue: orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxClock_SetModifier", dynlib: libORX.}
## * Sets a clock tick size
##  @param[in]   _pstClock                             Concerned clock
##  @param[in]   _fTickSize                            Tick size
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxClock_SetTickSize*(pstClock: ptr orxCLOCK; fTickSize: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxClock_SetTickSize", dynlib: libORX.}
## * Registers a callback function to a clock
##  @param[in]   _pstClock                             Concerned clock
##  @param[in]   _pfnCallback                          Callback to register
##  @param[in]   _pContext                             Context that will be transmitted to the callback when called
##  @param[in]   _eModuleID                            ID of the module related to this callback
##  @param[in]   _ePriority                            Priority for the function
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxClock_Register*(pstClock: ptr orxCLOCK; pfnCallback: orxCLOCK_FUNCTION;
                       pContext: pointer; eModuleID: orxMODULE_ID;
                       ePriority: orxCLOCK_PRIORITY): orxSTATUS {.cdecl,
    importc: "orxClock_Register", dynlib: libORX.}
## * Unregisters a callback function from a clock
##  @param[in]   _pstClock                             Concerned clock
##  @param[in]   _pfnCallback                          Callback to remove
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxClock_Unregister*(pstClock: ptr orxCLOCK; pfnCallback: orxCLOCK_FUNCTION): orxSTATUS {.
    cdecl, importc: "orxClock_Unregister", dynlib: libORX.}
## * Gets a callback function context
##  @param[in]   _pstClock                             Concerned clock
##  @param[in]   _pfnCallback                          Concerned callback
##  @return      Registered context
##

proc orxClock_GetContext*(pstClock: ptr orxCLOCK; pfnCallback: orxCLOCK_FUNCTION): pointer {.
    cdecl, importc: "orxClock_GetContext", dynlib: libORX.}
## * Sets a callback function context
##  @param[in]   _pstClock                             Concerned clock
##  @param[in]   _pfnCallback                          Concerned callback
##  @param[in]   _pContext                             Context that will be transmitted to the callback when called
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxClock_SetContext*(pstClock: ptr orxCLOCK; pfnCallback: orxCLOCK_FUNCTION;
                         pContext: pointer): orxSTATUS {.cdecl,
    importc: "orxClock_SetContext", dynlib: libORX.}
## * Finds a clock given its tick size and its type
##  @param[in]   _fTickSize                            Tick size of the desired clock (in seconds)
##  @param[in]   _eType                                Type of the desired clock
##  @return      orxCLOCK / nil
##

proc orxClock_FindFirst*(fTickSize: orxFLOAT; eType: orxCLOCK_TYPE): ptr orxCLOCK {.
    cdecl, importc: "orxClock_FindFirst", dynlib: libORX.}
## * Finds next clock of same type/tick size
##  @param[in]   _pstClock                             Concerned clock
##  @return      orxCLOCK / nil
##

proc orxClock_FindNext*(pstClock: ptr orxCLOCK): ptr orxCLOCK {.cdecl,
    importc: "orxClock_FindNext", dynlib: libORX.}
## * Gets next existing clock in list (can be used to parse all existing clocks)
##  @param[in]   _pstClock                             Concerned clock
##  @return      orxCLOCK / nil
##

proc orxClock_GetNext*(pstClock: ptr orxCLOCK): ptr orxCLOCK {.cdecl,
    importc: "orxClock_GetNext", dynlib: libORX.}
## * Gets clock given its name
##  @param[in]   _zName          Clock name
##  @return      orxCLOCK / nil
##

proc orxClock_Get*(zName: cstring): ptr orxCLOCK {.cdecl, importc: "orxClock_Get",
    dynlib: libORX.}
## * Gets clock config name
##  @param[in]   _pstClock       Concerned clock
##  @return      orxSTRING / orxSTRING_EMPTY
##

proc orxClock_GetName*(pstClock: ptr orxCLOCK): cstring {.cdecl,
    importc: "orxClock_GetName", dynlib: libORX.}
## * Adds a timer function to a clock
##  @param[in]   _pstClock                             Concerned clock
##  @param[in]   _pfnCallback                          Concerned timer callback
##  @param[in]   _fDelay                               Timer's delay between 2 calls, must be strictly positive
##  @param[in]   _s32Repetition                        Number of times this timer should be called before removed, -1 for infinite
##  @param[in]   _pContext                             Context that will be transmitted to the callback when called
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxClock_AddTimer*(pstClock: ptr orxCLOCK; pfnCallback: orxCLOCK_FUNCTION;
                       fDelay: orxFLOAT; s32Repetition: orxS32; pContext: pointer): orxSTATUS {.
    cdecl, importc: "orxClock_AddTimer", dynlib: libORX.}
## * Removes a timer function from a clock
##  @param[in]   _pstClock                             Concerned clock
##  @param[in]   _pfnCallback                          Concerned timer callback to remove, nil to remove all occurrences regardless of their callback
##  @param[in]   _fDelay                               Delay between 2 calls of the timer to remove, -1.0f to remove all occurrences regardless of their respective delay
##  @param[in]   _pContext                             Context of the timer to remove, nil to remove all occurrences regardless of their context
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxClock_RemoveTimer*(pstClock: ptr orxCLOCK; pfnCallback: orxCLOCK_FUNCTION;
                          fDelay: orxFLOAT; pContext: pointer): orxSTATUS {.cdecl,
    importc: "orxClock_RemoveTimer", dynlib: libORX.}
## * Adds a global timer function (ie. using the main core clock)
##  @param[in]   _pfnCallback                          Concerned timer callback
##  @param[in]   _fDelay                               Timer's delay between 2 calls, must be strictly positive
##  @param[in]   _s32Repetition                        Number of times this timer should be called before removed, -1 for infinite
##  @param[in]   _pContext                             Context that will be transmitted to the callback when called
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxClock_AddGlobalTimer*(pfnCallback: orxCLOCK_FUNCTION; fDelay: orxFLOAT;
                             s32Repetition: orxS32; pContext: pointer): orxSTATUS {.
    cdecl, importc: "orxClock_AddGlobalTimer", dynlib: libORX.}
## * Removes a global timer function (ie. from the main core clock)
##  @param[in]   _pfnCallback                          Concerned timer callback to remove, nil to remove all occurrences regardless of their callback
##  @param[in]   _fDelay                               Delay between 2 calls of the timer to remove, -1.0f to remove all occurrences regardless of their respective delay
##  @param[in]   _pContext                             Context of the timer to remove, nil to remove all occurrences regardless of their context
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxClock_RemoveGlobalTimer*(pfnCallback: orxCLOCK_FUNCTION; fDelay: orxFLOAT;
                                pContext: pointer): orxSTATUS {.cdecl,
    importc: "orxClock_RemoveGlobalTimer", dynlib: libORX.}
## * @}
