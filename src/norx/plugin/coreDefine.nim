##
##  Includes all core plugin headers
##

import display, joystick, keyboard, mouse, physics, render, soundSystem

##
##  Defines all core plugin register function
##

proc registerFunction_DISPLAY*() {.cdecl, importc: "_registerFunction_DISPLAY",
                                 dynlib: libORX.}
proc registerFunction_JOYSTICK*() {.cdecl, importc: "_registerFunction_JOYSTICK",
                                  dynlib: libORX.}
proc registerFunction_KEYBOARD*() {.cdecl, importc: "_registerFunction_KEYBOARD",
                                  dynlib: libORX.}
proc registerFunction_MOUSE*() {.cdecl, importc: "_registerFunction_MOUSE",
                               dynlib: libORX.}
proc registerFunction_PHYSICS*() {.cdecl, importc: "_registerFunction_PHYSICS",
                                 dynlib: libORX.}
proc registerFunction_RENDER*() {.cdecl, importc: "_registerFunction_RENDER",
                                dynlib: libORX.}
proc registerFunction_SOUNDSYSTEM*() {.cdecl,
                                     importc: "_registerFunction_SOUNDSYSTEM",
                                     dynlib: libORX.}
##
##  Inline core plugin registration function
##

proc orxPlugin_RegisterCorePlugins*() {.inline, cdecl.} =
  registerFunction_DISPLAY()
  registerFunction_JOYSTICK()
  registerFunction_KEYBOARD()
  registerFunction_MOUSE()
  registerFunction_PHYSICS()
  registerFunction_RENDER()
  registerFunction_SOUNDSYSTEM()
