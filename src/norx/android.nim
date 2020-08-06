import norx/[incl, lib, event]

import android/ndk/anative_window, jnim

const
  KZ_CONFIG_ANDROID* = "Android"
  KZ_CONFIG_SURFACE_SCALE* = "SurfaceScale"
  KZ_CONFIG_ACCELEROMETER_FREQUENCY* = "AccelerometerFrequency"
  KZ_CONFIG_USE_JOYSTICK* = "UseJoystick"

when defined(ANDROID_NATIVE):
  import android/ndk/[anative_activity, native_glue]

when defined(ANDROID_NATIVE) or defined(orxANDROID):
  const
    ##  Looper data ID of commands coming from the app's main thread, which
    ##  is returned as an identifier from ALooper_pollOnce().  The data for this
    ##  identifier is a pointer to an android_poll_source structure.
    ##  These can be retrieved and processed with android_app_read_cmd()
    ##  and android_app_exec_cmd().
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

  INNER_C_UNION_orxAndroid_113* {.bycopy, union.} = object
    ano_orxAndroid_123*: INNER_C_STRUCT_orxAndroid_115
    afValues*: array[8, orxFLOAT]

  INNER_C_UNION_orxAndroid_137* {.bycopy, union.} = object
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
    importc: "orxAndroid_GetNativeWindow", dynlib: libORX.}

##
##   Get the internal storage path
##

proc orxAndroid_GetInternalStoragePath*(): cstring {.cdecl,
    importc: "orxAndroid_GetInternalStoragePath", dynlib: libORX.}
proc orxAndroid_JNI_GetRotation*(): orxU32 {.cdecl,
    importc: "orxAndroid_JNI_GetRotation", dynlib: libORX.}
proc orxAndroid_JNI_GetDeviceIds*(devicesId: array[4, orxS32]) {.cdecl,
    importc: "orxAndroid_JNI_GetDeviceIds", dynlib: libORX.}

##
##   Register APK resources IO
##

proc orxAndroid_RegisterAPKResource*(): orxSTATUS {.cdecl,
    importc: "orxAndroid_RegisterAPKResource", dynlib: libORX.}
proc orxAndroid_JNI_SetupThread*(pContext: pointer): orxSTATUS {.cdecl,
    importc: "orxAndroid_JNI_SetupThread", dynlib: libORX.}
proc orxAndroid_PumpEvents*() {.cdecl, importc: "orxAndroid_PumpEvents",
                              dynlib: libORX.}
proc orxAndroid_GetJNIEnv*(): pointer {.cdecl, importc: "orxAndroid_GetJNIEnv",
                                     dynlib: libORX.}
proc orxAndroid_GetActivity*(): jobject {.cdecl,
                                       importc: "orxAndroid_GetActivity",
                                       dynlib: libORX.}
when defined(ANDROID_NATIVE):
  # TODO: What is this?
  #const
  #  LOOPER_ID_SENSOR* = LOOPER_ID_USER
  proc orxAndroid_GetNativeActivity*(): ptr ANativeActivity {.cdecl,
      importc: "orxAndroid_GetNativeActivity", dynlib: libORX.}
  proc orxAndroid_GetAndroidApp*(): ptr object {.cdecl,
      importc: "orxAndroid_GetAndroidApp", dynlib: libORX.}

const
  orxANDROID_EVENT_TYPE_KEYBOARD* = orxEVENT_TYPE_FIRST_RESERVED.ord
  orxANDROID_EVENT_KEYBOARD_DOWN* = 0
  orxANDROID_EVENT_KEYBOARD_UP* = 1
  orxANDROID_EVENT_TYPE_SURFACE* = orxEVENT_TYPE_FIRST_RESERVED.ord + 1
  orxANDROID_EVENT_SURFACE_DESTROYED* = 0
  orxANDROID_EVENT_SURFACE_CREATED* = 1
  orxANDROID_EVENT_SURFACE_CHANGED* = 2
  orxANDROID_EVENT_TYPE_ACCELERATE* = orxEVENT_TYPE_FIRST_RESERVED.ord + 2
  orxANDROID_EVENT_TYPE_JOYSTICK* = orxEVENT_TYPE_FIRST_RESERVED.ord + 3
  orxANDROID_EVENT_JOYSTICK_ADDED* = 0
  orxANDROID_EVENT_JOYSTICK_REMOVED* = 1
  orxANDROID_EVENT_JOYSTICK_CHANGED* = 2
  orxANDROID_EVENT_JOYSTICK_DOWN* = 3
  orxANDROID_EVENT_JOYSTICK_UP* = 4
  orxANDROID_EVENT_JOYSTICK_MOVE* = 5