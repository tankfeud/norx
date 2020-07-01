import incl


## * Setups FPS module

proc orxFPS_Setup*() {.cdecl, importc: "orxFPS_Setup", dynlib: libORX.}
## * Inits the FPS module
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxFPS_Init*(): orxSTATUS {.cdecl, importc: "orxFPS_Init", dynlib: libORX.}
## * Exits from the FPS module

proc orxFPS_Exit*() {.cdecl, importc: "orxFPS_Exit", dynlib: libORX.}
## * Increases internal frame count

proc orxFPS_IncreaseFrameCount*() {.cdecl, importc: "orxFPS_IncreaseFrameCount",
                                  dynlib: libORX.}
## * Gets current FTP value
##  @return orxU32
##

proc orxFPS_GetFPS*(): orxU32 {.cdecl, importc: "orxFPS_GetFPS", dynlib: libORX.}
