
import incl, system, module

const
  orxCLOCK_KU32_CLOCK_BANK_SIZE* = 16
  orxCLOCK_KU32_TIMER_BANK_SIZE* = 32
  orxCLOCK_KU32_FUNCTION_BANK_SIZE* = 16
  orxCLOCK_KZ_CORE* = "core"

## * Clock modifier enum
##

type
  orxCLOCK_MODIFIER* {.size: sizeof(cint).} = enum
    orxCLOCK_MODIFIER_FIXED = 0, ## The given DT will be constant, set to this modifier value
    orxCLOCK_MODIFIER_MULTIPLY, ## The given DT will be multiplied by this modifier value
    orxCLOCK_MODIFIER_MAXED, ## The given DT will be maxed by this modifier value
    orxCLOCK_MODIFIER_AVERAGE, ## The given DT will be averaged over a number of past updates defined by this modifier value
    orxCLOCK_MODIFIER_NUMBER, orxCLOCK_MODIFIER_NONE = orxENUM_NONE

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
    fTickSize*: orxFLOAT       ## Clock tick size (in seconds) : 4
    fDT*: orxFLOAT             ## Clock DT (time elapsed between 2 clock calls in seconds) : 8
    fTime*: orxFLOAT           ## Clock time : 12
    afModifierList*: array[orxCLOCK_MODIFIER_NUMBER.ord, orxFLOAT] ## Clock modifiers : 28

## * Event enum
##

type
  orxCLOCK_EVENT* {.size: sizeof(cint).} = enum
    orxCLOCK_EVENT_RESTART = 0, ## Event sent when a clock restarts
    orxCLOCK_EVENT_RESYNC,    ## Event sent when a clock resyncs
    orxCLOCK_EVENT_PAUSE,     ## Event sent when a clock is paused
    orxCLOCK_EVENT_UNPAUSE,   ## Event sent when a clock is unpaused
    orxCLOCK_EVENT_NUMBER, orxCLOCK_EVENT_NONE = orxENUM_NONE


## * Clock structure

type orxCLOCK* = object
## * Clock callback function type to use with clock bindings

type
  orxCLOCK_FUNCTION* = proc (pstClockInfo: ptr orxCLOCK_INFO; pContext: pointer) {.cdecl.}

proc clockSetup*() {.cdecl, importc: "orxClock_Setup", dynlib: libORX.}
  ## Clock module setup

proc clockInit*(): orxSTATUS {.cdecl, importc: "orxClock_Init",
                                dynlib: libORX.}
  ## Inits the clock module
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc clockExit*() {.cdecl, importc: "orxClock_Exit", dynlib: libORX.}
  ## Exits from the clock module

proc update*(): orxSTATUS {.cdecl, importc: "orxClock_Update",
                                  dynlib: libORX.}
  ## Updates the clock system
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc clockCreate*(fTickSize: orxFLOAT): ptr orxCLOCK {.cdecl,
    importc: "orxClock_Create", dynlib: libORX.}
  ## Creates a clock
  ##  @param[in]   _fTickSize                            Tick size for the clock (in seconds)
  ##  @return      orxCLOCK / nil

proc clockCreateFromConfig*(zConfigID: cstring): ptr orxCLOCK {.cdecl,
    importc: "orxClock_CreateFromConfig", dynlib: libORX.}
  ## Creates a clock from config
  ##  @param[in]   _zConfigID    Config ID
  ##  @ return orxCLOCK / nil

proc delete*(pstClock: ptr orxCLOCK): orxSTATUS {.cdecl,
    importc: "orxClock_Delete", dynlib: libORX.}
  ## Deletes a clock
  ##  @param[in]   _pstClock                             Concerned clock
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc resync*(pstClock: ptr orxCLOCK): orxSTATUS {.cdecl,
    importc: "orxClock_Resync", dynlib: libORX.}
  ## Resyncs a clock (accumulated DT => 0)
  ##  @param[in]   _pstClock                             Concerned clock

proc resyncAll*(): orxSTATUS {.cdecl, importc: "orxClock_ResyncAll",
                                     dynlib: libORX.}
  ## Resyncs all clocks (accumulated DT => 0)
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc restart*(pstClock: ptr orxCLOCK): orxSTATUS {.cdecl,
    importc: "orxClock_Restart", dynlib: libORX.}
  ## Restarts a clock
  ##  @param[in]   _pstClock                             Concerned clock
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc pause*(pstClock: ptr orxCLOCK): orxSTATUS {.cdecl,
    importc: "orxClock_Pause", dynlib: libORX.}
  ## Pauses a clock
  ##  @param[in]   _pstClock                             Concerned clock
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc unpause*(pstClock: ptr orxCLOCK): orxSTATUS {.cdecl,
    importc: "orxClock_Unpause", dynlib: libORX.}
  ## Unpauses a clock
  ##  @param[in]   _pstClock                             Concerned clock
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc isPaused*(pstClock: ptr orxCLOCK): orxBOOL {.cdecl,
    importc: "orxClock_IsPaused", dynlib: libORX.}
  ## Is a clock paused?
  ##  @param[in]   _pstClock                             Concerned clock
  ##  @return      orxTRUE if paused, orxFALSE otherwise

proc getInfo*(pstClock: ptr orxCLOCK): ptr orxCLOCK_INFO {.cdecl,
    importc: "orxClock_GetInfo", dynlib: libORX.}
  ## Gets clock info
  ##  @param[in]   _pstClock                             Concerned clock
  ##  @return      orxCLOCK_INFO / nil

proc getFromInfo*(pstClockInfo: ptr orxCLOCK_INFO): ptr orxCLOCK {.cdecl,
    importc: "orxClock_GetFromInfo", dynlib: libORX.}
  ## Gets clock from its info
  ##  @param[in]   _pstClockInfo                         Concerned clock info
  ##  @return      orxCLOCK / nil

proc setModifier*(pstClock: ptr orxCLOCK; eModifier: orxCLOCK_MODIFIER;
                          fValue: orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxClock_SetModifier", dynlib: libORX.}
  ## Sets a clock's modifier
  ##  @param[in]   _pstClock                             Concerned clock
  ##  @param[in]   _eModifier                            Concerned modifier
  ##  @param[in]   _fValue                               Modifier value, orxFLOAT_0 to deactivate the modifier
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getModifier*(pstClock: ptr orxCLOCK; eModifier: orxCLOCK_MODIFIER): orxFLOAT {.cdecl,
    importc: "orxClock_GetModifier", dynlib: libORX.}
  ## Sets a clock's modifier
  ##  @param[in]   _pstClock                             Concerned clock
  ##  @param[in]   _eModifier                            Concerned modifier
  ##  @return      Modifier value / orxFLOAT_0 if deactivated

proc setTickSize*(pstClock: ptr orxCLOCK; fTickSize: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxClock_SetTickSize", dynlib: libORX.}
  ## Sets a clock tick size
  ##  @param[in]   _pstClock                             Concerned clock
  ##  @param[in]   _fTickSize                            Tick size, -1 for 'display'
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc register*(pstClock: ptr orxCLOCK; pfnCallback: orxCLOCK_FUNCTION;
                       pContext: pointer; eModuleID: orxMODULE_ID;
                       ePriority: orxCLOCK_PRIORITY): orxSTATUS {.cdecl,
    importc: "orxClock_Register", dynlib: libORX.}
  ## Registers a callback function to a clock
  ##  @param[in]   _pstClock                             Concerned clock
  ##  @param[in]   _pfnCallback                          Callback to register
  ##  @param[in]   _pContext                             Context that will be transmitted to the callback when called
  ##  @param[in]   _eModuleID                            ID of the module related to this callback
  ##  @param[in]   _ePriority                            Priority for the function
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc unregister*(pstClock: ptr orxCLOCK; pfnCallback: orxCLOCK_FUNCTION): orxSTATUS {.
    cdecl, importc: "orxClock_Unregister", dynlib: libORX.}
  ## Unregisters a callback function from a clock
  ##  @param[in]   _pstClock                             Concerned clock
  ##  @param[in]   _pfnCallback                          Callback to remove
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getContext*(pstClock: ptr orxCLOCK; pfnCallback: orxCLOCK_FUNCTION): pointer {.
    cdecl, importc: "orxClock_GetContext", dynlib: libORX.}
  ## Gets a callback function context
  ##  @param[in]   _pstClock                             Concerned clock
  ##  @param[in]   _pfnCallback                          Concerned callback
  ##  @return      Registered context

proc setContext*(pstClock: ptr orxCLOCK; pfnCallback: orxCLOCK_FUNCTION;
                         pContext: pointer): orxSTATUS {.cdecl,
    importc: "orxClock_SetContext", dynlib: libORX.}
  ## Sets a callback function context
  ##  @param[in]   _pstClock                             Concerned clock
  ##  @param[in]   _pfnCallback                          Concerned callback
  ##  @param[in]   _pContext                             Context that will be transmitted to the callback when called
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getNext*(pstClock: ptr orxCLOCK): ptr orxCLOCK {.cdecl,
    importc: "orxClock_GetNext", dynlib: libORX.}
  ## Gets next existing clock in list (can be used to parse all existing clocks)
  ##  @param[in]   _pstClock                             Concerned clock
  ##  @return      orxCLOCK / nil

proc clockGet*(zName: cstring): ptr orxCLOCK {.cdecl, importc: "orxClock_Get",
    dynlib: libORX.}
  ## Gets clock given its name
  ##  @param[in]   _zName          Clock name
  ##  @return      orxCLOCK / nil

proc getName*(pstClock: ptr orxCLOCK): cstring {.cdecl,
    importc: "orxClock_GetName", dynlib: libORX.}
  ## Gets clock config name
  ##  @param[in]   _pstClock       Concerned clock
  ##  @return      orxSTRING / orxSTRING_EMPTY

proc addTimer*(pstClock: ptr orxCLOCK; pfnCallback: orxCLOCK_FUNCTION;
                       fDelay: orxFLOAT; s32Repetition: orxS32; pContext: pointer): orxSTATUS {.
    cdecl, importc: "orxClock_AddTimer", dynlib: libORX.}
  ## Adds a timer function to a clock
  ##  @param[in]   _pstClock                             Concerned clock
  ##  @param[in]   _pfnCallback                          Concerned timer callback
  ##  @param[in]   _fDelay                               Timer's delay between 2 calls, must be strictly positive
  ##  @param[in]   _s32Repetition                        Number of times this timer should be called before removed, -1 for infinite
  ##  @param[in]   _pContext                             Context that will be transmitted to the callback when called
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc removeTimer*(pstClock: ptr orxCLOCK; pfnCallback: orxCLOCK_FUNCTION;
                          fDelay: orxFLOAT; pContext: pointer): orxSTATUS {.cdecl,
    importc: "orxClock_RemoveTimer", dynlib: libORX.}
  ## Removes a timer function from a clock
  ##  @param[in]   _pstClock                             Concerned clock
  ##  @param[in]   _pfnCallback                          Concerned timer callback to remove, nil to remove all occurrences regardless of their callback
  ##  @param[in]   _fDelay                               Delay between 2 calls of the timer to remove, -1.0f to remove all occurrences regardless of their respective delay
  ##  @param[in]   _pContext                             Context of the timer to remove, nil to remove all occurrences regardless of their context
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc addGlobalTimer*(pfnCallback: orxCLOCK_FUNCTION; fDelay: orxFLOAT;
                             s32Repetition: orxS32; pContext: pointer): orxSTATUS {.
    cdecl, importc: "orxClock_AddGlobalTimer", dynlib: libORX.}
  ## Adds a global timer function (ie. using the main core clock)
  ##  @param[in]   _pfnCallback                          Concerned timer callback
  ##  @param[in]   _fDelay                               Timer's delay between 2 calls, must be strictly positive
  ##  @param[in]   _s32Repetition                        Number of times this timer should be called before removed, -1 for infinite
  ##  @param[in]   _pContext                             Context that will be transmitted to the callback when called
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc removeGlobalTimer*(pfnCallback: orxCLOCK_FUNCTION; fDelay: orxFLOAT;
                                pContext: pointer): orxSTATUS {.cdecl,
    importc: "orxClock_RemoveGlobalTimer", dynlib: libORX.}
  ## Removes a global timer function (ie. from the main core clock)
  ##  @param[in]   _pfnCallback                          Concerned timer callback to remove, nil to remove all occurrences regardless of their callback
  ##  @param[in]   _fDelay                               Delay between 2 calls of the timer to remove, -1.0f to remove all occurrences regardless of their respective delay
  ##  @param[in]   _pContext                             Context of the timer to remove, nil to remove all occurrences regardless of their context
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

