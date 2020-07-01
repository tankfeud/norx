import incl, font, oinput

## * Inputs
##

const
  orxCONSOLE_KZ_INPUT_SET* = "-=ConsoleSet=-"
  orxCONSOLE_KZ_INPUT_TOGGLE* = "Toggle"
  orxCONSOLE_KZ_INPUT_AUTOCOMPLETE* = "AutoComplete"
  orxCONSOLE_KZ_INPUT_DELETE* = "Delete"
  orxCONSOLE_KZ_INPUT_DELETE_AFTER* = "DeleteAfter"
  orxCONSOLE_KZ_INPUT_TOGGLE_MODE* = "ToggleMode"
  orxCONSOLE_KZ_INPUT_ENTER* = "Enter"
  orxCONSOLE_KZ_INPUT_PREVIOUS* = "Previous"
  orxCONSOLE_KZ_INPUT_NEXT* = "Next"
  orxCONSOLE_KZ_INPUT_LEFT* = "Left"
  orxCONSOLE_KZ_INPUT_RIGHT* = "Right"
  orxCONSOLE_KZ_INPUT_START* = "Start"
  orxCONSOLE_KZ_INPUT_END* = "End"
  orxCONSOLE_KZ_INPUT_PASTE* = "Paste"
  orxCONSOLE_KZ_INPUT_SCROLL_DOWN* = "ScrollDown"
  orxCONSOLE_KZ_INPUT_SCROLL_UP* = "ScrollUp"

proc consoleSetup*() {.cdecl, importc: "orxConsole_Setup", dynlib: libORX.}
  ## Console module setup

proc consoleInit*(): orxSTATUS {.cdecl, importc: "orxConsole_Init",
                                  dynlib: libORX.}
  ## Inits the console module
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc consoleExit*() {.cdecl, importc: "orxConsole_Exit", dynlib: libORX.}
  ## Exits from the console module

proc enable*(bEnable: orxBOOL) {.cdecl, importc: "orxConsole_Enable",
    dynlib: libORX.}
  ## Enables/disables the console
  ##  @param[in]   _bEnable      Enable / disable

proc isEnabled*(): orxBOOL {.cdecl, importc: "orxConsole_IsEnabled",
                                     dynlib: libORX.}
  ## Is the console enabled?
  ##  @return orxTRUE if enabled, orxFALSE otherwise

proc isInsertMode*(): orxBOOL {.cdecl,
                                        importc: "orxConsole_IsInsertMode",
                                        dynlib: libORX.}
  ## Is the console input in insert mode?
  ##  @return orxTRUE if insert mode, orxFALSE otherwise (overwrite mode)

proc setToggle*(eInputType: orxINPUT_TYPE; eInputID: orxENUM;
                          eInputMode: orxINPUT_MODE): orxSTATUS {.cdecl,
    importc: "orxConsole_SetToggle", dynlib: libORX.}
  ## Sets the console toggle
  ##  @param[in] _eInputType      Type of input peripheral
  ##  @param[in] _eInputID        ID of button/key/axis
  ##  @param[in] _eInputMode      Mode of input
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc log*(zText: cstring): orxSTATUS {.cdecl,
    importc: "orxConsole_Log", dynlib: libORX.}
  ## Logs to the console
  ##  @param[in]   _zText        Text to log
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setFont*(pstFont: ptr orxFONT): orxSTATUS {.cdecl,
    importc: "orxConsole_SetFont", dynlib: libORX.}
  ## Sets the console font
  ##  @param[in]   _pstFont      Font to use
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getFont*(): ptr orxFONT {.cdecl, importc: "orxConsole_GetFont",
                                      dynlib: libORX.}
  ## Gets the console font
  ##  @return Current in-use font, nil

proc setLogLineLength*(u32LineLength: orxU32): orxSTATUS {.cdecl,
    importc: "orxConsole_SetLogLineLength", dynlib: libORX.}
  ## Sets the console log line length
  ##  @param[in]   _u32LineLength Line length to use
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getLogLineLength*(): orxU32 {.cdecl,
    importc: "orxConsole_GetLogLineLength", dynlib: libORX.}
  ## Gets the console log line length
  ##  @return Console log line length

proc getCompletionCount*(pu32MaxLength: ptr orxU32): orxU32 {.cdecl,
    importc: "orxConsole_GetCompletionCount", dynlib: libORX.}
  ## Gets current completions count
  ##  @param[out]  _pu32MaxLength Max completion length, nil to ignore
  ##  @return Current completions count

proc getCompletion*(u32Index: orxU32; pbActive: ptr orxBOOL): cstring {.
    cdecl, importc: "orxConsole_GetCompletion", dynlib: libORX.}
  ## Gets completion
  ##  @param[in]   _u32Index     Index of the active completion
  ##  @param[out]  _pbActive     Is completion active, nil to ignore
  ##  @return Completion string if found, orxSTRING_EMPTY otherwise

proc getTrailLogLine*(u32TrailLineIndex: orxU32): cstring {.cdecl,
    importc: "orxConsole_GetTrailLogLine", dynlib: libORX.}
  ## Gets log line from the end (trail), using internal offset
  ##  @param[in]   _u32TrailLineIndex Index of the line starting from end
  ##  @return orxTRING / orxSTRING_EMPTY

proc getTrailLogLineOffset*(): orxU32 {.cdecl,
    importc: "orxConsole_GetTrailLogLineOffset", dynlib: libORX.}
  ## Gets log line offset from the end
  ##  @return Log line offset from the end

proc getInput*(pu32CursorIndex: ptr orxU32): cstring {.cdecl,
    importc: "orxConsole_GetInput", dynlib: libORX.}
  ## Gets input text
  ##  @param[out]  _pu32CursorIndex Index (ie. character position) of the cursor (any character past it has not been validated)
  ##  @return orxTRING / orxSTRING_EMPTY

