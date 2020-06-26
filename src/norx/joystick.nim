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

import incl, pluginCore


## * Helpers
##

template orxJOYSTICK_GET_AXIS*(AXIS, ID: untyped): untyped =
  (((cast[orxU32](AXIS)) mod orxJOYSTICK_AXIS_SINGLE_NUMBER) +
      ((ID - 1) * orxJOYSTICK_AXIS_SINGLE_NUMBER))

template orxJOYSTICK_GET_BUTTON*(BUTTON, ID: untyped): untyped =
  (((cast[orxU32](BUTTON)) mod orxJOYSTICK_BUTTON_SINGLE_NUMBER) +
      ((ID - 1) * orxJOYSTICK_BUTTON_SINGLE_NUMBER))

template orxJOYSTICK_GET_ID_FROM_AXIS*(AXIS: untyped): untyped =
  (((cast[orxU32](AXIS)) div orxJOYSTICK_AXIS_SINGLE_NUMBER) + 1)

template orxJOYSTICK_GET_ID_FROM_BUTTON*(BUTTON: untyped): untyped =
  (((cast[orxU32](BUTTON)) div orxJOYSTICK_BUTTON_SINGLE_NUMBER) + 1)

## * Button enum
##

type
  orxJOYSTICK_BUTTON* {.size: sizeof(cint).} = enum
    orxJOYSTICK_BUTTON_A_1 = 0, orxJOYSTICK_BUTTON_B_1, orxJOYSTICK_BUTTON_X_1,
    orxJOYSTICK_BUTTON_Y_1, orxJOYSTICK_BUTTON_LBUMPER_1,
    orxJOYSTICK_BUTTON_RBUMPER_1, orxJOYSTICK_BUTTON_BACK_1,
    orxJOYSTICK_BUTTON_START_1, orxJOYSTICK_BUTTON_GUIDE_1,
    orxJOYSTICK_BUTTON_LTHUMB_1, orxJOYSTICK_BUTTON_RTHUMB_1,
    orxJOYSTICK_BUTTON_UP_1, orxJOYSTICK_BUTTON_RIGHT_1,
    orxJOYSTICK_BUTTON_DOWN_1, orxJOYSTICK_BUTTON_LEFT_1, orxJOYSTICK_BUTTON_1_1,
    orxJOYSTICK_BUTTON_2_1, orxJOYSTICK_BUTTON_3_1, orxJOYSTICK_BUTTON_4_1,
    orxJOYSTICK_BUTTON_5_1, orxJOYSTICK_BUTTON_6_1, orxJOYSTICK_BUTTON_7_1,
    orxJOYSTICK_BUTTON_8_1, orxJOYSTICK_BUTTON_9_1, orxJOYSTICK_BUTTON_10_1,
    orxJOYSTICK_BUTTON_11_1, orxJOYSTICK_BUTTON_12_1, orxJOYSTICK_BUTTON_13_1,
    orxJOYSTICK_BUTTON_14_1, orxJOYSTICK_BUTTON_15_1, orxJOYSTICK_BUTTON_16_1,
    orxJOYSTICK_BUTTON_SINGLE_NUMBER, orxJOYSTICK_BUTTON_B_2,
    orxJOYSTICK_BUTTON_X_2, orxJOYSTICK_BUTTON_Y_2, orxJOYSTICK_BUTTON_LBUMPER_2,
    orxJOYSTICK_BUTTON_RBUMPER_2, orxJOYSTICK_BUTTON_BACK_2,
    orxJOYSTICK_BUTTON_START_2, orxJOYSTICK_BUTTON_GUIDE_2,
    orxJOYSTICK_BUTTON_LTHUMB_2, orxJOYSTICK_BUTTON_RTHUMB_2,
    orxJOYSTICK_BUTTON_UP_2, orxJOYSTICK_BUTTON_RIGHT_2,
    orxJOYSTICK_BUTTON_DOWN_2, orxJOYSTICK_BUTTON_LEFT_2, orxJOYSTICK_BUTTON_1_2,
    orxJOYSTICK_BUTTON_2_2, orxJOYSTICK_BUTTON_3_2, orxJOYSTICK_BUTTON_4_2,
    orxJOYSTICK_BUTTON_5_2, orxJOYSTICK_BUTTON_6_2, orxJOYSTICK_BUTTON_7_2,
    orxJOYSTICK_BUTTON_8_2, orxJOYSTICK_BUTTON_9_2, orxJOYSTICK_BUTTON_10_2,
    orxJOYSTICK_BUTTON_11_2, orxJOYSTICK_BUTTON_12_2, orxJOYSTICK_BUTTON_13_2,
    orxJOYSTICK_BUTTON_14_2, orxJOYSTICK_BUTTON_15_2, orxJOYSTICK_BUTTON_16_2, ## orxJOYSTICK_DECLARE_BUTTON_ENUM(3),
                                                                            ##   orxJOYSTICK_DECLARE_BUTTON_ENUM(4),
                                                                            ##   orxJOYSTICK_DECLARE_BUTTON_ENUM(5),
                                                                            ##   orxJOYSTICK_DECLARE_BUTTON_ENUM(6),
                                                                            ##   orxJOYSTICK_DECLARE_BUTTON_ENUM(7),
                                                                            ##   orxJOYSTICK_DECLARE_BUTTON_ENUM(8),
                                                                            ##   orxJOYSTICK_DECLARE_BUTTON_ENUM(9),
                                                                            ##   orxJOYSTICK_DECLARE_BUTTON_ENUM(10),
                                                                            ##   orxJOYSTICK_DECLARE_BUTTON_ENUM(11),
                                                                            ##   orxJOYSTICK_DECLARE_BUTTON_ENUM(12),
                                                                            ##   orxJOYSTICK_DECLARE_BUTTON_ENUM(13),
                                                                            ##   orxJOYSTICK_DECLARE_BUTTON_ENUM(14),
                                                                            ##   orxJOYSTICK_DECLARE_BUTTON_ENUM(15),
                                                                            ##   orxJOYSTICK_DECLARE_BUTTON_ENUM(16),
    orxJOYSTICK_BUTTON_NUMBER, orxJOYSTICK_BUTTON_NONE = orxENUM_NONE

const
  orxJOYSTICK_BUTTON_A_2 = orxJOYSTICK_BUTTON_SINGLE_NUMBER

## * Axis enum
##

type
  orxJOYSTICK_AXIS* {.size: sizeof(cint).} = enum
    orxJOYSTICK_AXIS_LX_1 = 0, orxJOYSTICK_AXIS_LY_1, orxJOYSTICK_AXIS_RX_1,
    orxJOYSTICK_AXIS_RY_1, orxJOYSTICK_AXIS_LTRIGGER_1,
    orxJOYSTICK_AXIS_RTRIGGER_1, orxJOYSTICK_AXIS_SINGLE_NUMBER,
    orxJOYSTICK_AXIS_LY_2, orxJOYSTICK_AXIS_RX_2, orxJOYSTICK_AXIS_RY_2,
    orxJOYSTICK_AXIS_LTRIGGER_2, orxJOYSTICK_AXIS_RTRIGGER_2,
    orxJOYSTICK_AXIS_LX_3, orxJOYSTICK_AXIS_LY_3, orxJOYSTICK_AXIS_RX_3,
    orxJOYSTICK_AXIS_RY_3, orxJOYSTICK_AXIS_LTRIGGER_3,
    orxJOYSTICK_AXIS_RTRIGGER_3, orxJOYSTICK_AXIS_LX_4, orxJOYSTICK_AXIS_LY_4,
    orxJOYSTICK_AXIS_RX_4, orxJOYSTICK_AXIS_RY_4, orxJOYSTICK_AXIS_LTRIGGER_4,
    orxJOYSTICK_AXIS_RTRIGGER_4, orxJOYSTICK_AXIS_LX_5, orxJOYSTICK_AXIS_LY_5,
    orxJOYSTICK_AXIS_RX_5, orxJOYSTICK_AXIS_RY_5, orxJOYSTICK_AXIS_LTRIGGER_5, orxJOYSTICK_AXIS_RTRIGGER_5, ##  TODO orxJOYSTICK_DECLARE_AXIS_ENUM(6),
                                                                                                        ##   orxJOYSTICK_DECLARE_AXIS_ENUM(7),
                                                                                                        ##   orxJOYSTICK_DECLARE_AXIS_ENUM(8),
                                                                                                        ##   orxJOYSTICK_DECLARE_AXIS_ENUM(9),
                                                                                                        ##   orxJOYSTICK_DECLARE_AXIS_ENUM(10),
                                                                                                        ##   orxJOYSTICK_DECLARE_AXIS_ENUM(11),
                                                                                                        ##   orxJOYSTICK_DECLARE_AXIS_ENUM(12),
                                                                                                        ##   orxJOYSTICK_DECLARE_AXIS_ENUM(13),
                                                                                                        ##   orxJOYSTICK_DECLARE_AXIS_ENUM(14),
                                                                                                        ##   orxJOYSTICK_DECLARE_AXIS_ENUM(15),
                                                                                                        ##   orxJOYSTICK_DECLARE_AXIS_ENUM(16),
    orxJOYSTICK_AXIS_NUMBER, orxJOYSTICK_AXIS_NONE = orxENUM_NONE

const
  orxJOYSTICK_AXIS_LX_2 = orxJOYSTICK_AXIS_SINGLE_NUMBER

const
  orxJOYSTICK_KU32_MIN_ID* = 1

const orxJOYSTICK_KU32_MAX_ID* = (ord(orxJOYSTICK_BUTTON_NUMBER) / ord(orxJOYSTICK_BUTTON_SINGLE_NUMBER))
## **************************************************************************
##  Functions directly implemented by orx core
## *************************************************************************
## * JOYSTICK module setup
##

proc orxJoystick_Setup*() {.cdecl, importc: "orxJoystick_Setup", dynlib: libORX.}
## **************************************************************************
##  Functions extended by plugins
## *************************************************************************
## * Inits the joystick module
##  @return Returns the status of the operation
##

proc orxJoystick_Init*(): orxSTATUS {.cdecl, importc: "orxJoystick_Init",
                                   dynlib: libORX.}
## * Exits from the joystick module
##

proc orxJoystick_Exit*() {.cdecl, importc: "orxJoystick_Exit", dynlib: libORX.}
## * Gets joystick axis value
##  @param[in] _eAxis        Joystick axis to check
##  @return Value of the axis
##

proc orxJoystick_GetAxisValue*(eAxis: orxJOYSTICK_AXIS): orxFLOAT {.cdecl,
    importc: "orxJoystick_GetAxisValue", dynlib: libORX.}
## * Is joystick button pressed?
##  @param[in] _eButton      Joystick button to check
##  @return orxTRUE if pressed / orxFALSE otherwise
##

proc orxJoystick_IsButtonPressed*(eButton: orxJOYSTICK_BUTTON): orxBOOL {.cdecl,
    importc: "orxJoystick_IsButtonPressed", dynlib: libORX.}
## * Gets button literal name
##  @param[in] _eButton      Concerned button
##  @return Button's name
##

proc orxJoystick_GetButtonName*(eButton: orxJOYSTICK_BUTTON): cstring {.cdecl,
    importc: "orxJoystick_GetButtonName", dynlib: libORX.}
## * Gets axis literal name
##  @param[in] _eAxis        Concerned axis
##  @return Axis's name
##

proc orxJoystick_GetAxisName*(eAxis: orxJOYSTICK_AXIS): cstring {.cdecl,
    importc: "orxJoystick_GetAxisName", dynlib: libORX.}
## * Is joystick connected?
##  @param[in] _u32ID        ID of the joystick, 1-based index
##  @return orxTRUE if connected / orxFALSE otherwise
##

proc orxJoystick_IsConnected*(u32ID: orxU32): orxBOOL {.cdecl,
    importc: "orxJoystick_IsConnected", dynlib: libORX.}
## * @}
