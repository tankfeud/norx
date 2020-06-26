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

## Mouse module setup
proc orxMouse_Setup*() {.cdecl, importc: "orxMouse_Setup", dynlib: libORX.}


## **************************************************************************
##  Functions extended by plugins
## *************************************************************************
## * Inits the mouse module
##  @return Returns the status of the operation
##

proc orxMouse_Init*(): orxSTATUS {.cdecl, importc: "orxMouse_Init",
                                dynlib: libORX.}
## * Exits from the mouse module
##

proc orxMouse_Exit*() {.cdecl, importc: "orxMouse_Exit", dynlib: libORX.}
## * Sets mouse position
##  @param[in] _pvPosition  Mouse position
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxMouse_SetPosition*(pvPosition: ptr orxVECTOR): orxSTATUS {.cdecl,
    importc: "orxMouse_SetPosition", dynlib: libORX.}
## * Gets mouse position
##  @param[out] _pvPosition  Mouse position
##  @return orxVECTOR / nil
##

proc orxMouse_GetPosition*(pvPosition: ptr orxVECTOR): ptr orxVECTOR {.cdecl,
    importc: "orxMouse_GetPosition", dynlib: libORX.}
## * Is mouse button pressed?
##  @param[in] _eButton          Mouse button to check
##  @return orxTRUE if pressed / orxFALSE otherwise
##

proc orxMouse_IsButtonPressed*(eButton: orxMOUSE_BUTTON): orxBOOL {.cdecl,
    importc: "orxMouse_IsButtonPressed", dynlib: libORX.}
## * Gets mouse move delta (since last call)
##  @param[out] _pvMoveDelta Mouse move delta
##  @return orxVECTOR / nil
##

proc orxMouse_GetMoveDelta*(pvMoveDelta: ptr orxVECTOR): ptr orxVECTOR {.cdecl,
    importc: "orxMouse_GetMoveDelta", dynlib: libORX.}
## * Gets mouse wheel delta (since last call)
##  @return Mouse wheel delta
##

proc orxMouse_GetWheelDelta*(): orxFLOAT {.cdecl, importc: "orxMouse_GetWheelDelta",
                                        dynlib: libORX.}
## * Shows mouse (hardware) cursor
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxMouse_ShowCursor*(bShow: orxBOOL): orxSTATUS {.cdecl,
    importc: "orxMouse_ShowCursor", dynlib: libORX.}
## * Sets mouse (hardware) cursor
##  @param[in] _zName       Cursor's name can be: a standard name (arrow, ibeam, hand, crosshair, hresize or vresize), a file name or nil to reset the hardware cursor to default
##  @param[in] _pvPivot     Cursor's pivot (aka hotspot), nil will default to (0, 0)
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxMouse_SetCursor*(zName: cstring; pvPivot: ptr orxVECTOR): orxSTATUS {.cdecl,
    importc: "orxMouse_SetCursor", dynlib: libORX.}
## * Gets button literal name
##  @param[in] _eButton          Concerned button
##  @return Button's name
##

proc orxMouse_GetButtonName*(eButton: orxMOUSE_BUTTON): cstring {.cdecl,
    importc: "orxMouse_GetButtonName", dynlib: libORX.}
## * Gets axis literal name
##  @param[in] _eAxis            Concerned axis
##  @return Axis's name
##

proc orxMouse_GetAxisName*(eAxis: orxMOUSE_AXIS): cstring {.cdecl,
    importc: "orxMouse_GetAxisName", dynlib: libORX.}
## * @}
