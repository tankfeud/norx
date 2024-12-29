import incl


proc FPSSetup*() {.cdecl, importc: "orxFPS_Setup", dynlib: libORX.}
  ## Setups FPS module

proc FPSInit*(): orxSTATUS {.cdecl, importc: "orxFPS_Init", dynlib: libORX.}
  ## Inits the FPS module
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc FPSExit*() {.cdecl, importc: "orxFPS_Exit", dynlib: libORX.}
  ## Exits from the FPS module

proc increaseFrameCount*() {.cdecl, importc: "orxFPS_IncreaseFrameCount",
                                  dynlib: libORX.}
  ## Increases internal frame count

proc getFPS*(): orxU32 {.cdecl, importc: "orxFPS_GetFPS", dynlib: libORX.}
  ## Gets current FTP value
  ##  @return orxU32

