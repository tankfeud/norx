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

const
  KZ_CONFIG_ANDROID* = "Android"
  KZ_CONFIG_SURFACE_SCALE* = "SurfaceScale"
  KZ_CONFIG_ACCELEROMETER_FREQUENCY* = "AccelerometerFrequency"
  KZ_CONFIG_USE_JOYSTICK* = "UseJoystick"

when defined(ANDROID_NATIVE):
when defined(orxANDROID):
  const ## *
       ##  Looper data ID of commands coming from the app's main thread, which
       ##  is returned as an identifier from ALooper_pollOnce().  The data for this
       ##  identifier is a pointer to an android_poll_source structure.
       ##  These can be retrieved and processed with android_app_read_cmd()
       ##  and android_app_exec_cmd().
       ##
    LOOPER_ID_MAIN* = 1
    LOOPER_ID_SENSOR* = 2
    LOOPER_ID_KEY_EVENT* = 3
    LOOPER_ID_TOUCH_EVENT* = 4
    LOOPER_ID_JOYSTICK_EVENT* = 5
    LOOPER_ID_USER* = 6
  const
    APP_CMD_PAUSE* = 0
    APP_CMD_RESUME* = 1
    APP_CMD_SURFACE_DESTROYED* = 2
    APP_CMD_SURFACE_CREATED* = 3
    APP_CMD_SURFACE_CHANGED* = 4
    APP_CMD_QUIT* = 5
    APP_CMD_FOCUS_LOST* = 6
    APP_CMD_FOCUS_GAINED* = 7
  type
    orxANDROID_TOUCH_EVENT* {.bycopy.} = object
      u32ID*: orxU32
      fX*: orxFLOAT
      fY*: orxFLOAT
      u32Action*: orxU32

type
  INNER_C_STRUCT_orxAndroid_115* {.bycopy.} = object
    fX*: orxFLOAT
    fY*: orxFLOAT
    fZ*: orxFLOAT
    fRZ*: orxFLOAT
    fHAT_X*: orxFLOAT
    fHAT_Y*: orxFLOAT
    fRTRIGGER*: orxFLOAT
    fLTRIGGER*: orxFLOAT

  INNER_C_UNION_orxAndroid_113* {.bycopy.} = object {.union.}
    ano_orxAndroid_123*: INNER_C_STRUCT_orxAndroid_115
    afValues*: array[8, orxFLOAT]

  INNER_C_UNION_orxAndroid_137* {.bycopy.} = object {.union.}
    u32KeyCode*: orxU32
    stAxisData*: orxANDROID_AXIS_DATA

  orxANDROID_AXIS_DATA* {.bycopy.} = object
    ano_orxAndroid_126*: INNER_C_UNION_orxAndroid_113

  orxANDROID_JOYSTICK_EVENT* {.bycopy.} = object
    u32Type*: orxU32
    u32DeviceId*: orxU32
    ano_orxAndroid_139*: INNER_C_UNION_orxAndroid_137

  orxANDROID_KEY_EVENT* {.bycopy.} = object
    u32Action*: orxU32
    u32KeyCode*: orxU32
    u32Unicode*: orxU32

  orxANDROID_SURFACE_CHANGED_EVENT* {.bycopy.} = object
    u32Width*: orxU32
    u32Height*: orxU32


proc orxAndroid_GetNativeWindow*(): ptr ANativeWindow {.cdecl,
    importcpp: "orxAndroid_GetNativeWindow(@)", dynlib: liborxdll.}
## *
##   Get the internal storage path
##

proc orxAndroid_GetInternalStoragePath*(): cstring {.cdecl,
    importcpp: "orxAndroid_GetInternalStoragePath(@)", dynlib: liborxdll.}
proc orxAndroid_JNI_GetRotation*(): orxU32 {.cdecl,
    importcpp: "orxAndroid_JNI_GetRotation(@)", dynlib: liborxdll.}
proc orxAndroid_JNI_GetDeviceIds*(devicesId: array[4, orxS32]) {.cdecl,
    importcpp: "orxAndroid_JNI_GetDeviceIds(@)", dynlib: liborxdll.}
## *
##   Register APK resources IO
##

proc orxAndroid_RegisterAPKResource*(): orxSTATUS {.cdecl,
    importcpp: "orxAndroid_RegisterAPKResource(@)", dynlib: liborxdll.}
proc orxAndroid_JNI_SetupThread*(_pContext: pointer): orxSTATUS {.cdecl,
    importcpp: "orxAndroid_JNI_SetupThread(@)", dynlib: liborxdll.}
proc orxAndroid_PumpEvents*() {.cdecl, importcpp: "orxAndroid_PumpEvents(@)",
                              dynlib: liborxdll.}
proc orxAndroid_GetJNIEnv*(): pointer {.cdecl, importcpp: "orxAndroid_GetJNIEnv(@)",
                                     dynlib: liborxdll.}
proc orxAndroid_GetActivity*(): jobject {.cdecl,
                                       importcpp: "orxAndroid_GetActivity(@)",
                                       dynlib: liborxdll.}
when defined(ANDROID_NATIVE):
  const
    LOOPER_ID_SENSOR* = LOOPER_ID_USER
  proc orxAndroid_GetNativeActivity*(): ptr ANativeActivity {.cdecl,
      importcpp: "orxAndroid_GetNativeActivity(@)", dynlib: liborxdll.}
  proc orxAndroid_GetAndroidApp*(): ptr android_app {.cdecl,
      importcpp: "orxAndroid_GetAndroidApp(@)", dynlib: liborxdll.}
const
  orxANDROID_EVENT_TYPE_KEYBOARD* = (orxEVENT_TYPE)(
      orxEVENT_TYPE_FIRST_RESERVED + 0)
  orxANDROID_EVENT_KEYBOARD_DOWN* = 0
  orxANDROID_EVENT_KEYBOARD_UP* = 1
  orxANDROID_EVENT_TYPE_SURFACE* = (orxEVENT_TYPE)(
      orxEVENT_TYPE_FIRST_RESERVED + 1)
  orxANDROID_EVENT_SURFACE_DESTROYED* = 0
  orxANDROID_EVENT_SURFACE_CREATED* = 1
  orxANDROID_EVENT_SURFACE_CHANGED* = 2
  orxANDROID_EVENT_TYPE_ACCELERATE* = (orxEVENT_TYPE)(
      orxEVENT_TYPE_FIRST_RESERVED + 2)
  orxANDROID_EVENT_TYPE_JOYSTICK* = (orxEVENT_TYPE)(
      orxEVENT_TYPE_FIRST_RESERVED + 3)
  orxANDROID_EVENT_JOYSTICK_ADDED* = 0
  orxANDROID_EVENT_JOYSTICK_REMOVED* = 1
  orxANDROID_EVENT_JOYSTICK_CHANGED* = 2
  orxANDROID_EVENT_JOYSTICK_DOWN* = 3
  orxANDROID_EVENT_JOYSTICK_UP* = 4
  orxANDROID_EVENT_JOYSTICK_MOVE* = 5

## * @}
