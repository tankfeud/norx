import incl, shader, structure


## * Misc defines
##

const
  orxSHADERPOINTER_KU32_SHADER_NUMBER* = 4

## * Internal ShaderPointer structure

type orxSHADERPOINTER* = object

## * ShaderPointer module setup
##

proc orxShaderPointer_Setup*() {.cdecl, importc: "orxShaderPointer_Setup",
                               dynlib: libORX.}
## * Inits the ShaderPointer module
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxShaderPointer_Init*(): orxSTATUS {.cdecl, importc: "orxShaderPointer_Init",
                                        dynlib: libORX.}
## * Exits from the ShaderPointer module
##

proc orxShaderPointer_Exit*() {.cdecl, importc: "orxShaderPointer_Exit",
                              dynlib: libORX.}
## * Creates an empty ShaderPointer
##  @return orxSHADERPOINTER / nil
##

proc orxShaderPointer_Create*(): ptr orxSHADERPOINTER {.cdecl,
    importc: "orxShaderPointer_Create", dynlib: libORX.}
## * Deletes an ShaderPointer
##  @param[in] _pstShaderPointer     Concerned ShaderPointer
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxShaderPointer_Delete*(pstShaderPointer: ptr orxSHADERPOINTER): orxSTATUS {.
    cdecl, importc: "orxShaderPointer_Delete", dynlib: libORX.}
## * Starts a ShaderPointer
##  @param[in] _pstShaderPointer     Concerned ShaderPointer
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxShaderPointer_Start*(pstShaderPointer: ptr orxSHADERPOINTER): orxSTATUS {.
    cdecl, importc: "orxShaderPointer_Start", dynlib: libORX.}
## * Stops a ShaderPointer
##  @param[in] _pstShaderPointer     Concerned ShaderPointer
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxShaderPointer_Stop*(pstShaderPointer: ptr orxSHADERPOINTER): orxSTATUS {.
    cdecl, importc: "orxShaderPointer_Stop", dynlib: libORX.}
## * Enables/disables an ShaderPointer
##  @param[in]   _pstShaderPointer   Concerned ShaderPointer
##  @param[in]   _bEnable        Enable / disable
##

proc orxShaderPointer_Enable*(pstShaderPointer: ptr orxSHADERPOINTER;
                             bEnable: orxBOOL) {.cdecl,
    importc: "orxShaderPointer_Enable", dynlib: libORX.}
## * Is ShaderPointer enabled?
##  @param[in]   _pstShaderPointer   Concerned ShaderPointer
##  @return      orxTRUE if enabled, orxFALSE otherwise
##

proc orxShaderPointer_IsEnabled*(pstShaderPointer: ptr orxSHADERPOINTER): orxBOOL {.
    cdecl, importc: "orxShaderPointer_IsEnabled", dynlib: libORX.}
## * Adds a shader
##  @param[in]   _pstShaderPointer Concerned ShaderPointer
##  @param[in]   _pstShader        Shader to add
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxShaderPointer_AddShader*(pstShaderPointer: ptr orxSHADERPOINTER;
                                pstShader: ptr orxSHADER): orxSTATUS {.cdecl,
    importc: "orxShaderPointer_AddShader", dynlib: libORX.}
## * Removes a shader
##  @param[in]   _pstShaderPointer Concerned ShaderPointer
##  @param[in]   _pstShader        Shader to remove
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxShaderPointer_RemoveShader*(pstShaderPointer: ptr orxSHADERPOINTER;
                                   pstShader: ptr orxSHADER): orxSTATUS {.cdecl,
    importc: "orxShaderPointer_RemoveShader", dynlib: libORX.}
## * Gets a shader
##  @param[in]   _pstShaderPointer Concerned ShaderPointer
##  @param[in]   _u32Index         Index of shader to get
##  @return      orxSHADER / nil
##

proc orxShaderPointer_GetShader*(pstShaderPointer: ptr orxSHADERPOINTER;
                                u32Index: orxU32): ptr orxSHADER {.cdecl,
    importc: "orxShaderPointer_GetShader", dynlib: libORX.}
## * Adds a shader using its config ID
##  @param[in]   _pstShaderPointer Concerned ShaderPointer
##  @param[in]   _zShaderConfigID  Config ID of the shader to add
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxShaderPointer_AddShaderFromConfig*(
    pstShaderPointer: ptr orxSHADERPOINTER; zShaderConfigID: cstring): orxSTATUS {.
    cdecl, importc: "orxShaderPointer_AddShaderFromConfig", dynlib: libORX.}
## * Removes a shader using its config ID
##  @param[in]   _pstShaderPointer Concerned ShaderPointer
##  @param[in]   _zShaderConfigID  Config ID of the shader to remove
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxShaderPointer_RemoveShaderFromConfig*(
    pstShaderPointer: ptr orxSHADERPOINTER; zShaderConfigID: cstring): orxSTATUS {.
    cdecl, importc: "orxShaderPointer_RemoveShaderFromConfig", dynlib: libORX.}
