import incl, pluginCore, vector, string, typ

type
  ## Button enum
  orxMOUSE_BUTTON* {.size: sizeof(cint).} = enum
    orxMOUSE_BUTTON_LEFT = 0, orxMOUSE_BUTTON_RIGHT, orxMOUSE_BUTTON_MIDDLE,
    orxMOUSE_BUTTON_EXTRA_1, orxMOUSE_BUTTON_EXTRA_2, orxMOUSE_BUTTON_EXTRA_3,
    orxMOUSE_BUTTON_EXTRA_4, orxMOUSE_BUTTON_EXTRA_5, orxMOUSE_BUTTON_WHEEL_UP,
    orxMOUSE_BUTTON_WHEEL_DOWN, orxMOUSE_BUTTON_NUMBER,
    orxMOUSE_BUTTON_NONE = orxENUM_NONE
  orxMOUSE_AXIS* {.size: sizeof(cint).} = enum
    orxMOUSE_AXIS_X = 0, orxMOUSE_AXIS_Y, orxMOUSE_AXIS_NUMBER,
    orxMOUSE_AXIS_NONE = orxENUM_NONE

const
  orxMOUSE_KZ_CONFIG_SECTION* = "Mouse"
  orxMOUSE_KZ_CONFIG_SHOW_CURSOR* = "ShowCursor"

proc mouseSetup*() {.cdecl, importc: "orxMouse_Setup", dynlib: libORX.}
  ## Mouse module setup


## **************************************************************************
##  Functions extended by plugins
## *************************************************************************

proc mouseInit*(): orxSTATUS {.cdecl, importc: "orxMouse_Init",
                                dynlib: libORX.}
  ## Inits the mouse module
  ##  @return Returns the status of the operation

proc mouseExit*() {.cdecl, importc: "orxMouse_Exit", dynlib: libORX.}
  ## Exits from the mouse module

proc setPosition*(pvPosition: ptr orxVECTOR): orxSTATUS {.cdecl,
    importc: "orxMouse_SetPosition", dynlib: libORX.}
  ## Sets mouse position
  ##  @param[in] _pvPosition  Mouse position
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getPosition*(pvPosition: ptr orxVECTOR): ptr orxVECTOR {.cdecl,
    importc: "orxMouse_GetPosition", dynlib: libORX.}
  ## Gets mouse position
  ##  @param[out] _pvPosition  Mouse position
  ##  @return orxVECTOR / nil

proc isButtonPressed*(eButton: orxMOUSE_BUTTON): orxBOOL {.cdecl,
    importc: "orxMouse_IsButtonPressed", dynlib: libORX.}
  ## Is mouse button pressed?
  ##  @param[in] _eButton          Mouse button to check
  ##  @return orxTRUE if pressed / orxFALSE otherwise

proc getMoveDelta*(pvMoveDelta: ptr orxVECTOR): ptr orxVECTOR {.cdecl,
    importc: "orxMouse_GetMoveDelta", dynlib: libORX.}
  ## Gets mouse move delta (since last call)
  ##  @param[out] _pvMoveDelta Mouse move delta
  ##  @return orxVECTOR / nil

proc getWheelDelta*(): orxFLOAT {.cdecl, importc: "orxMouse_GetWheelDelta",
                                        dynlib: libORX.}
  ## Gets mouse wheel delta (since last call)
  ##  @return Mouse wheel delta

proc showCursor*(bShow: orxBOOL): orxSTATUS {.cdecl,
    importc: "orxMouse_ShowCursor", dynlib: libORX.}
  ## Shows mouse (hardware) cursor
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setCursor*(zName: cstring; pvPivot: ptr orxVECTOR): orxSTATUS {.cdecl,
    importc: "orxMouse_SetCursor", dynlib: libORX.}
  ## Sets mouse (hardware) cursor
  ##  @param[in] _zName       Cursor's name can be: a standard name (arrow, ibeam, hand, crosshair, hresize or vresize), a file name or nil to reset the hardware cursor to default
  ##  @param[in] _pvPivot     Cursor's pivot (aka hotspot), nil will default to (0, 0)
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getButtonName*(eButton: orxMOUSE_BUTTON): cstring {.cdecl,
    importc: "orxMouse_GetButtonName", dynlib: libORX.}
  ## Gets button literal name
  ##  @param[in] _eButton          Concerned button
  ##  @return Button's name

proc getAxisName*(eAxis: orxMOUSE_AXIS): cstring {.cdecl,
    importc: "orxMouse_GetAxisName", dynlib: libORX.}
  ## Gets axis literal name
  ##  @param[in] _eAxis            Concerned axis
  ##  @return Axis's name

