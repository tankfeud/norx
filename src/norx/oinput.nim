import incl

## * Misc defines
##

const
  orxINPUT_KZ_CONFIG_SECTION* = "Input"
  orxINPUT_KZ_CONFIG_SET_LIST* = "SetList"
  orxINPUT_KZ_CONFIG_DEFAULT_THRESHOLD* = "DefaultThreshold"
  orxINPUT_KZ_CONFIG_DEFAULT_MULTIPLIER* = "DefaultMultiplier"
  orxINPUT_KZ_CONFIG_COMBINE_LIST* = "CombineList"
  orxINPUT_KU32_BINDING_NUMBER* = 8
  orxINPUT_KZ_INTERNAL_SET_PREFIX* = "-="
  orxINPUT_KC_MODE_PREFIX_POSITIVE* = '+'
  orxINPUT_KC_MODE_PREFIX_NEGATIVE* = '-'

template orxINPUT_GET_FLAG*(TYPE: untyped): untyped =
  ((orxU32)(1 shl (orxU32)(TYPE)))

const
  orxINPUT_KU32_FLAG_TYPE_NONE* = 0x00000000
  orxINPUT_KU32_MASK_TYPE_ALL* = 0x0000FFFF

type
  orxINPUT_TYPE* {.size: sizeof(cint).} = enum
    ## Input type enum
    orxINPUT_TYPE_KEYBOARD_KEY = 0, orxINPUT_TYPE_MOUSE_BUTTON,
    orxINPUT_TYPE_MOUSE_AXIS, orxINPUT_TYPE_JOYSTICK_BUTTON,
    orxINPUT_TYPE_JOYSTICK_AXIS, orxINPUT_TYPE_EXTERNAL, orxINPUT_TYPE_NUMBER,
    orxINPUT_TYPE_NONE = orxENUM_NONE

type
  orxINPUT_MODE* {.size: sizeof(cint).} = enum
    ## Input mode enum
    orxINPUT_MODE_FULL = 0, orxINPUT_MODE_POSITIVE, orxINPUT_MODE_NEGATIVE,
    orxINPUT_MODE_NUMBER, orxINPUT_MODE_NONE = orxENUM_NONE

type
  orxINPUT_EVENT* {.size: sizeof(cint).} = enum
    ## Event enum
    orxINPUT_EVENT_ON = 0, orxINPUT_EVENT_OFF, orxINPUT_EVENT_SELECT_SET,
    orxINPUT_EVENT_NUMBER, orxINPUT_EVENT_NONE = orxENUM_NONE

type
  orxINPUT_EVENT_PAYLOAD* {.bycopy.} = object
    ## Input event payload
    zSetName*: cstring      ## Set name : 4/8
    zInputName*: cstring    ## Input name : 8/16
    aeType*: array[orxINPUT_KU32_BINDING_NUMBER, orxINPUT_TYPE] ## Input binding type : 40/48
    aeID*: array[orxINPUT_KU32_BINDING_NUMBER, orxENUM] ## Input binding ID : 72/80
    aeMode*: array[orxINPUT_KU32_BINDING_NUMBER, orxINPUT_MODE] ## Input binding Mode : 104/112
    afValue*: array[orxINPUT_KU32_BINDING_NUMBER, orxFLOAT] ## Input binding value : 136/144

proc inputSetup*() {.cdecl, importc: "orxInput_Setup", dynlib: libORX.}
  ## Input module setup

proc inputInit*(): orxSTATUS {.cdecl, importc: "orxInput_Init",
                                dynlib: libORX.}
  ## Initializes Input module
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc inputExit*() {.cdecl, importc: "orxInput_Exit", dynlib: libORX.}
  ## Exits from Input module

proc load*(zFileName: cstring): orxSTATUS {.cdecl,
    importc: "orxInput_Load", dynlib: libORX.}
  ## Loads inputs from config
  ##  @param[in] _zFileName        File name to load, will use current loaded config if orxSTRING_EMPTY/nil
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc save*(zFileName: cstring): orxSTATUS {.cdecl,
    importc: "orxInput_Save", dynlib: libORX.}
  ## Saves inputs to config
  ##  @param[in] _zFileName        File name
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc selectSet*(zSetName: cstring): orxSTATUS {.cdecl,
    importc: "orxInput_SelectSet", dynlib: libORX.}
  ## Selects (and enables) current working set
  ##  @param[in] _zSetName         Set name to select
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getCurrentSet*(): cstring {.cdecl,
    importc: "orxInput_GetCurrentSet", dynlib: libORX.}
  ## Gets current working set
  ##  @return Current selected set

proc enableSet*(zSetName: cstring; bEnable: orxBOOL): orxSTATUS {.cdecl,
    importc: "orxInput_EnableSet", dynlib: libORX.}
  ## Enables/disables working set (without selecting it)
  ##  @param[in] _zSetName         Set name to enable/disable
  ##  @param[in] _bEnable          Enable / Disable
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc isSetEnabled*(zSetName: cstring): orxBOOL {.cdecl,
    importc: "orxInput_IsSetEnabled", dynlib: libORX.}
  ## Is working set enabled (includes current working set)?
  ##  @param[in] _zSetName         Set name to check
  ##  @return orxTRUE / orxFALSE

proc setTypeFlags*(u32AddTypeFlags: orxU32; u32RemoveTypeFlags: orxU32): orxSTATUS {.
    cdecl, importc: "orxInput_SetTypeFlags", dynlib: libORX.}
  ## Sets current set's type flags, only set types will be polled when updating the set (use orxINPUT_GET_FLAG(TYPE) in order to get the flag that matches a type)
  ##  @param[in] _u32AddTypeFlags      Type flags to add
  ##  @param[in] _u32RemoveTypeFlags   Type flags to remove
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc isActive*(zInputName: cstring): orxBOOL {.cdecl,
    importc: "orxInput_IsActive", dynlib: libORX.}
  ## Is input active?
  ##  @param[in] _zInputName       Concerned input name
  ##  @return orxTRUE if active, orxFALSE otherwise

proc hasBeenActivated*(zInputName: cstring): orxBOOL {.cdecl,
    importc: "orxInput_HasBeenActivated", dynlib: libORX.}
  ## Has input been activated (this frame)?
  ##  @param[in] _zInputName       Concerned input name
  ##  @return orxTRUE if newly activated since last frame, orxFALSE otherwise

proc hasBeenDeactivated*(zInputName: cstring): orxBOOL {.cdecl,
    importc: "orxInput_HasBeenDeactivated", dynlib: libORX.}
  ## Has input been deactivated (this frame)?
  ##  @param[in] _zInputName       Concerned input name
  ##  @return orxTRUE if newly deactivated since last frame, orxFALSE otherwise

proc hasNewStatus*(zInputName: cstring): orxBOOL {.cdecl,
    importc: "orxInput_HasNewStatus", dynlib: libORX.}
  ## Has a new active status since this frame?
  ##  @param[in] _zInputName       Concerned input name
  ##  @return orxTRUE if active status is new, orxFALSE otherwise

proc getValue*(zInputName: cstring): orxFLOAT {.cdecl,
    importc: "orxInput_GetValue", dynlib: libORX.}
  ## Gets input value
  ##  @param[in] _zInputName       Concerned input name
  ##  @return orxFLOAT

proc setValue*(zInputName: cstring; fValue: orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxInput_SetValue", dynlib: libORX.}
  ## Sets input value (will prevail on peripheral inputs only once)
  ##  @param[in] _zInputName       Concerned input name
  ##  @param[in] _fValue           Value to set, orxFLOAT_0 to deactivate
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setPermanentValue*(zInputName: cstring; fValue: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxInput_SetPermanentValue", dynlib: libORX.}
  ## Sets permanent input value (will prevail on peripheral inputs till reset)
  ##  @param[in] _zInputName       Concerned input name
  ##  @param[in] _fValue           Value to set, orxFLOAT_0 to deactivate
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc resetValue*(zInputName: cstring): orxSTATUS {.cdecl,
    importc: "orxInput_ResetValue", dynlib: libORX.}
  ## Resets input value (peripheral inputs will then be used instead of code ones)
  ##  @param[in] _zInputName       Concerned input name
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getThreshold*(zInputName: cstring): orxFLOAT {.cdecl,
    importc: "orxInput_GetThreshold", dynlib: libORX.}
  ## Gets input threshold
  ##  @param[in] _zInputName       Concerned input name
  ##  @return Input threshold

proc setThreshold*(zInputName: cstring; fThreshold: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxInput_SetThreshold", dynlib: libORX.}
  ## Sets input threshold, if not set the default global threshold will be used
  ##  @param[in] _zInputName       Concerned input name
  ##  @param[in] _fThreshold       Threshold value (between 0.0f and 1.0f)
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getMultiplier*(zInputName: cstring): orxFLOAT {.cdecl,
    importc: "orxInput_GetMultiplier", dynlib: libORX.}
  ## Gets input multiplier
  ##  @param[in] _zInputName       Concerned input name
  ##  @return Input multiplier

proc setMultiplier*(zInputName: cstring; fMultiplier: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxInput_SetMultiplier", dynlib: libORX.}
  ## Sets input multiplier, if not set the default global multiplier will be used
  ##  @param[in] _zInputName       Concerned input name
  ##  @param[in] _fMultiplier      Multiplier value, can be negative
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setCombineMode*(zName: cstring; bCombine: orxBOOL): orxSTATUS {.
    cdecl, importc: "orxInput_SetCombineMode", dynlib: libORX.}
  ## Sets an input combine mode
  ##  @param[in] _zName            Concerned input name
  ##  @param[in] _bCombine         If orxTRUE, all assigned bindings need to be active in order to activate input, otherwise input will be considered active if any of its binding is
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc isInCombineMode*(zName: cstring): orxBOOL {.cdecl,
    importc: "orxInput_IsInCombineMode", dynlib: libORX.}
  ## Is an input in combine mode?
  ##  @param[in] _zName            Concerned input name
  ##  @return orxTRUE if the input is in combine mode, orxFALSE otherwise

proc inputBind*(zName: cstring; eType: orxINPUT_TYPE; eID: orxENUM;
                   eMode: orxINPUT_MODE; s32BindingIndex: orxS32): orxSTATUS {.cdecl,
    importc: "orxInput_Bind", dynlib: libORX.}
  ## Binds an input to a mouse/joystick button, keyboard key or joystick axis
  ##  @param[in] _zName            Concerned input name
  ##  @param[in] _eType            Type of peripheral to bind
  ##  @param[in] _eID              ID of button/key/axis to bind
  ##  @param[in] _eMode            Mode (only used for axis input)
  ##  @param[in] _s32BindingIndex  Index of the desired binding, if < 0 the oldest binding will be replaced
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc inputUnbind*(zName: cstring; s32BindingIndex: orxS32): orxSTATUS {.cdecl,
    importc: "orxInput_Unbind", dynlib: libORX.}
  ## Unbinds an input
  ##  @param[in] _zName            Concerned input name
  ##  @param[in] _s32BindingIndex  Index of the desired binding, if < 0 all the bindings will be removed
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getBoundInputCount*(eType: orxINPUT_TYPE; eID: orxENUM;
                                 eMode: orxINPUT_MODE): orxU32 {.cdecl,
    importc: "orxInput_GetBoundInputCount", dynlib: libORX.}
  ## Gets the input count to which a mouse/joystick button, keyboard key or joystick axis is bound
  ##  @param[in] _eType            Type of peripheral to test
  ##  @param[in] _eID              ID of button/key/axis to test
  ##  @param[in] _eMode            Mode (only used for axis input)
  ##  @return Number of bound inputs

proc getBoundInput*(eType: orxINPUT_TYPE; eID: orxENUM;
                            eMode: orxINPUT_MODE; u32InputIndex: orxU32;
                            pzName: cstringArray; pu32BindingIndex: ptr orxU32): orxSTATUS {.
    cdecl, importc: "orxInput_GetBoundInput", dynlib: libORX.}
  ## Gets the input name to which a mouse/joystick button, keyboard key or joystick axis is bound (at given index)
  ##  @param[in] _eType            Type of peripheral to test
  ##  @param[in] _eID              ID of button/key/axis to test
  ##  @param[in] _eMode            Mode (only used for axis input)
  ##  @param[in] _u32InputIndex    Index of the desired input
  ##  @param[out] _pzName          Input name, mandatory
  ##  @param[out] _pu32BindingIndex Binding index for this input, ignored if nil
  ##  @return orxSTATUS_SUCCESS if binding exists / orxSTATUS_FAILURE otherwise

proc getBinding*(zName: cstring; u32BindingIndex: orxU32;
                         peType: ptr orxINPUT_TYPE; peID: ptr orxENUM;
                         peMode: ptr orxINPUT_MODE): orxSTATUS {.cdecl,
    importc: "orxInput_GetBinding", dynlib: libORX.}
  ## Gets an input binding (mouse/joystick button, keyboard key or joystick axis) at a given index
  ##  @param[in]   _zName            Concerned input name
  ##  @param[in]   _u32BindingIndex  Index of the desired binding, should be less than orxINPUT_KU32_BINDING_NUMBER
  ##  @param[out]  _peType           Binding type (if a slot is not bound, its value is orxINPUT_TYPE_NONE)
  ##  @param[out]  _peID             Binding ID (button/key/axis)
  ##  @param[out]  _peMode           Mode (only used for axis inputs)
  ##  @return orxSTATUS_SUCCESS if input exists, orxSTATUS_FAILURE otherwise

proc getBindingList*(zName: cstring; aeTypeList: array[
    orxINPUT_KU32_BINDING_NUMBER, orxINPUT_TYPE]; aeIDList: array[
    orxINPUT_KU32_BINDING_NUMBER, orxENUM]; aeModeList: array[
    orxINPUT_KU32_BINDING_NUMBER, orxINPUT_MODE]): orxSTATUS {.cdecl,
    importc: "orxInput_GetBindingList", dynlib: libORX.}
  ## Gets an input binding (mouse/joystick button, keyboard key or joystick axis) list
  ##  @param[in]   _zName          Concerned input name
  ##  @param[out]  _aeTypeList     List of binding types (if a slot is not bound, its value is orxINPUT_TYPE_NONE)
  ##  @param[out]  _aeIDList       List of binding IDs (button/key/axis)
  ##  @param[out]  _aeModeList     List of modes (only used for axis inputs)
  ##  @return orxSTATUS_SUCCESS if input exists, orxSTATUS_FAILURE otherwise

proc getBindingName*(eType: orxINPUT_TYPE; eID: orxENUM;
                             eMode: orxINPUT_MODE): cstring {.cdecl,
    importc: "orxInput_GetBindingName", dynlib: libORX.}
  ## Gets a binding name, don't keep the result as is as it'll get overridden during the next call to this function
  ##  @param[in]   _eType          Binding type (mouse/joystick button, keyboard key or joystick axis)
  ##  @param[in]   _eID            Binding ID (ID of button/key/axis to bind)
  ##  @param[in]   _eMode          Mode (only used for axis input)
  ##  @return orxSTRING (binding's name) if success, orxSTRING_EMPTY otherwise

proc getBindingType*(zName: cstring; peType: ptr orxINPUT_TYPE;
                             peID: ptr orxENUM; peMode: ptr orxINPUT_MODE): orxSTATUS {.
    cdecl, importc: "orxInput_GetBindingType", dynlib: libORX.}
  ## Gets a binding type and ID from its name
  ##  @param[in]   _zName          Concerned input name
  ##  @param[out]  _peType         Binding type (mouse/joystick button, keyboard key or joystick axis)
  ##  @param[out]  _peID           Binding ID (ID of button/key/axis to bind)
  ##  @param[out]  _peMode         Binding mode (only used for axis input)
  ##  @return orxSTATUS_SUCCESS if input is valid, orxSTATUS_FAILURE otherwise

proc getActiveBinding*(peType: ptr orxINPUT_TYPE; peID: ptr orxENUM;
                               pfValue: ptr orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxInput_GetActiveBinding", dynlib: libORX.}
  ## Gets active binding (current pressed key/button/...) so as to allow on-the-fly user rebinding
  ##  @param[out]  _peType         Active binding's type (mouse/joystick button, keyboard key or joystick axis)
  ##  @param[out]  _peID           Active binding's ID (ID of button/key/axis to bind)
  ##  @param[out]  _pfValue        Active binding's value (optional)
  ##  @return orxSTATUS_SUCCESS if one active binding is found, orxSTATUS_FAILURE otherwise
