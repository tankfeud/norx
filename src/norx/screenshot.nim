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
## * Screenshot module setup
##

proc orxScreenshot_Setup*() {.cdecl, importc: "orxScreenshot_Setup",
                            dynlib: libORX.}
## * Inits the screenshot module
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxScreenshot_Init*(): orxSTATUS {.cdecl, importc: "orxScreenshot_Init",
                                     dynlib: libORX.}
## * Exits from the screenshot module
##

proc orxScreenshot_Exit*() {.cdecl, importc: "orxScreenshot_Exit",
                           dynlib: libORX.}
## * Captures a screenshot
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxScreenshot_Capture*(): orxSTATUS {.cdecl, importc: "orxScreenshot_Capture",
                                        dynlib: libORX.}
## * @}
