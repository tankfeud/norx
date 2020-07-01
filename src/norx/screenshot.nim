import incl


## * Misc
##

when defined(iOS):
  const
    orxSCREENSHOT_KZ_DEFAULT_DIRECTORY_NAME* = "../Documents"
    orxSCREENSHOT_KZ_DEFAULT_BASE_NAME* = "screenshot-"
    orxSCREENSHOT_KZ_DEFAULT_EXTENSION* = "png"
    orxSCREENSHOT_KU32_DEFAULT_DIGITS* = 4
elif defined(Android):
  const
    orxSCREENSHOT_KZ_DEFAULT_DIRECTORY_NAME* = "."
    orxSCREENSHOT_KZ_DEFAULT_BASE_NAME* = "screenshot-"
    orxSCREENSHOT_KZ_DEFAULT_EXTENSION* = "png"
    orxSCREENSHOT_KU32_DEFAULT_DIGITS* = 4
else:
  const
    orxSCREENSHOT_KZ_DEFAULT_DIRECTORY_NAME* = "."
    orxSCREENSHOT_KZ_DEFAULT_BASE_NAME* = "screenshot-"
    orxSCREENSHOT_KZ_DEFAULT_EXTENSION* = "tga"
    orxSCREENSHOT_KU32_DEFAULT_DIGITS* = 4

proc screenshotSetup*() {.cdecl, importc: "orxScreenshot_Setup",
                            dynlib: libORX.}
  ## Screenshot module setup

proc screenshotInit*(): orxSTATUS {.cdecl, importc: "orxScreenshot_Init",
                                     dynlib: libORX.}
  ## Inits the screenshot module
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc screenshotExit*() {.cdecl, importc: "orxScreenshot_Exit",
                           dynlib: libORX.}
  ## Exits from the screenshot module

proc capture*(): orxSTATUS {.cdecl, importc: "orxScreenshot_Capture",
                                        dynlib: libORX.}
  ## Captures a screenshot
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

