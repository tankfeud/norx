import incl, vector, texture, structure, linkList


## * Shader parameter type
##

type
  orxSHADER_PARAM_TYPE* {.size: sizeof(cint).} = enum
    orxSHADER_PARAM_TYPE_FLOAT = 0, orxSHADER_PARAM_TYPE_TEXTURE,
    orxSHADER_PARAM_TYPE_VECTOR, orxSHADER_PARAM_TYPE_TIME,
    orxSHADER_PARAM_TYPE_NUMBER, orxSHADER_PARAM_TYPE_NONE = orxENUM_NONE


## * Shader parameter structure
##

type
  orxSHADER_PARAM* {.bycopy.} = object
    stNode*: orxLINKLIST_NODE  ## Linklist node : 12
    zName*: cstring         ## Parameter literal name : 26
    eType*: orxSHADER_PARAM_TYPE ## Parameter type : 20
    u32ArraySize*: orxU32      ## Parameter array size : 24


## * Internal shader structure
##

type orxSHADER* = object
## * Event enum
##

type
  orxSHADER_EVENT* {.size: sizeof(cint).} = enum
    orxSHADER_EVENT_SET_PARAM = 0, ## Event sent when setting a parameter
    orxSHADER_EVENT_NUMBER, orxSHADER_EVENT_NONE = orxENUM_NONE


## * Shader event payload
##

type
  INNER_C_UNION_orxShader_124* {.bycopy, union.} = object
    fValue*: orxFLOAT          ## Float value : 24
    pstValue*: ptr orxTEXTURE   ## Texture value : 24
    vValue*: orxVECTOR         ## Vector value : 32

  orxSHADER_EVENT_PAYLOAD* {.bycopy.} = object
    pstShader*: ptr orxSHADER   ## Shader reference : 4
    zShaderName*: cstring   ## Shader name : 8
    zParamName*: cstring    ## Parameter name : 12
    eParamType*: orxSHADER_PARAM_TYPE ## Parameter type : 16
    s32ParamIndex*: orxS32     ## Parameter index : 20
    ano_orxShader_127*: INNER_C_UNION_orxShader_124


proc shaderSetup*() {.cdecl, importc: "orxShader_Setup", dynlib: libORX.}
  ## Shader module setup

proc shaderInit*(): orxSTATUS {.cdecl, importc: "orxShader_Init",
                                 dynlib: libORX.}
  ## Inits the shader module
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc shaderExit*() {.cdecl, importc: "orxShader_Exit", dynlib: libORX.}
  ## Exits from the shader module

proc shaderCreate*(): ptr orxSHADER {.cdecl, importc: "orxShader_Create",
                                      dynlib: libORX.}
  ## Creates an empty shader
  ##  @return orxSHADER / nil

proc shaderCreateFromConfig*(zConfigID: cstring): ptr orxSHADER {.cdecl,
    importc: "orxShader_CreateFromConfig", dynlib: libORX.}
  ## Creates a shader from config
  ##  @param[in]   _zConfigID            Config ID
  ##  @ return orxSHADER / nil

proc delete*(pstShader: ptr orxSHADER): orxSTATUS {.cdecl,
    importc: "orxShader_Delete", dynlib: libORX.}
  ## Deletes a shader
  ##  @param[in] _pstShader              Concerned Shader
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc clearCache*(): orxSTATUS {.cdecl, importc: "orxShader_ClearCache",
                                       dynlib: libORX.}
  ## Clears cache (if any shader is still in active use, it'll remain in memory until not referenced anymore)
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc start*(pstShader: ptr orxSHADER; pstOwner: ptr orxSTRUCTURE): orxSTATUS {.
    cdecl, importc: "orxShader_Start", dynlib: libORX.}
  ## Starts a shader
  ##  @param[in] _pstShader              Concerned Shader
  ##  @param[in] _pstOwner               Owner structure (orxOBJECT / orxVIEWPORT / nil)
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc stop*(pstShader: ptr orxSHADER): orxSTATUS {.cdecl,
    importc: "orxShader_Stop", dynlib: libORX.}
  ## Stops a shader
  ##  @param[in] _pstShader              Concerned Shader
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc addFloatParam*(pstShader: ptr orxSHADER; zName: cstring;
                             u32ArraySize: orxU32; afValueList: ptr orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxShader_AddFloatParam", dynlib: libORX.}
  ## Adds a float parameter definition to a shader (parameters need to be set before compiling the shader code)
  ##  @param[in] _pstShader              Concerned Shader
  ##  @param[in] _zName                  Parameter's literal name
  ##  @param[in] _u32ArraySize           Parameter's array size, 0 for simple variable
  ##  @param[in] _afValueList            Parameter's float value list
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc addTextureParam*(pstShader: ptr orxSHADER; zName: cstring;
                               u32ArraySize: orxU32;
                               apstValueList: ptr ptr orxTEXTURE): orxSTATUS {.cdecl,
    importc: "orxShader_AddTextureParam", dynlib: libORX.}
  ## Adds a texture parameter definition to a shader (parameters need to be set before compiling the shader code)
  ##  @param[in] _pstShader              Concerned Shader
  ##  @param[in] _zName                  Parameter's literal name
  ##  @param[in] _u32ArraySize           Parameter's array size, 0 simple variable
  ##  @param[in] _apstValueList          Parameter's texture value list
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc addVectorParam*(pstShader: ptr orxSHADER; zName: cstring;
                              u32ArraySize: orxU32; avValueList: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxShader_AddVectorParam", dynlib: libORX.}
  ## Adds a vector parameter definition to a shader (parameters need to be set before compiling the shader code)
  ##  @param[in] _pstShader              Concerned Shader
  ##  @param[in] _zName                  Parameter's literal name
  ##  @param[in] _u32ArraySize           Parameter's array size, 0 for simple variable
  ##  @param[in] _avValueList            Parameter's vector value list
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc addTimeParam*(pstShader: ptr orxSHADER; zName: cstring): orxSTATUS {.
    cdecl, importc: "orxShader_AddTimeParam", dynlib: libORX.}
  ## Adds a time parameter definition to a shader (parameters need to be set before compiling the shader code)
  ##  @param[in] _pstShader              Concerned Shader
  ##  @param[in] _zName                  Parameter's literal name
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setFloatParam*(pstShader: ptr orxSHADER; zName: cstring;
                             u32ArraySize: orxU32; afValueList: ptr orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxShader_SetFloatParam", dynlib: libORX.}
  ## Sets the default value for a given float parameter in a shader (parameters need to be added beforehand)
  ##  @param[in] _pstShader              Concerned Shader
  ##  @param[in] _zName                  Parameter's literal name
  ##  @param[in] _u32ArraySize           Parameter's array size, 0 for simple variable, has to match the size used when declaring the parameter
  ##  @param[in] _afValueList            Parameter's float value list
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setTextureParam*(pstShader: ptr orxSHADER; zName: cstring;
                               u32ArraySize: orxU32;
                               apstValueList: ptr ptr orxTEXTURE): orxSTATUS {.cdecl,
    importc: "orxShader_SetTextureParam", dynlib: libORX.}
  ## Sets the default value for a given float parameter in a shader (parameters need to be added beforehand)
  ##  @param[in] _pstShader              Concerned Shader
  ##  @param[in] _zName                  Parameter's literal name
  ##  @param[in] _u32ArraySize           Parameter's array size, 0 for simple variable, has to match the size used when declaring the parameter
  ##  @param[in] _apstValueList          Parameter's texture value list
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setVectorParam*(pstShader: ptr orxSHADER; zName: cstring;
                              u32ArraySize: orxU32; avValueList: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxShader_SetVectorParam", dynlib: libORX.}
  ## Sets the default value for a given float parameter in a shader (parameters need to be added beforehand)
  ##  @param[in] _pstShader              Concerned Shader
  ##  @param[in] _zName                  Parameter's literal name
  ##  @param[in] _u32ArraySize           Parameter's array size, 0 for simple variable, has to match the size used when declaring the parameter
  ##  @param[in] _avValueList            Parameter's vector value list
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc compileCode*(pstShader: ptr orxSHADER; azCodeList: cstringArray;
                           u32Size: orxU32): orxSTATUS {.cdecl,
    importc: "orxShader_CompileCode", dynlib: libORX.}
  ## Sets shader code & compiles it (parameters need to be set before compiling the shader code)
  ##  @param[in] _pstShader              Concerned Shader
  ##  @param[in] _azCodeList             List of shader codes to compile (parameters need to be set beforehand), will be processed in order
  ##  @param[in] _u32Size                Size of the shader code list
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc enable*(pstShader: ptr orxSHADER; bEnable: orxBOOL) {.cdecl,
    importc: "orxShader_Enable", dynlib: libORX.}
  ## Enables/disables a shader
  ##  @param[in]   _pstShader            Concerned Shader
  ##  @param[in]   _bEnable              Enable / disable

proc isEnabled*(pstShader: ptr orxSHADER): orxBOOL {.cdecl,
    importc: "orxShader_IsEnabled", dynlib: libORX.}
  ## Is shader enabled?
  ##  @param[in]   _pstShader            Concerned Shader
  ##  @return      orxTRUE if enabled, orxFALSE otherwise

proc getName*(pstShader: ptr orxSHADER): cstring {.cdecl,
    importc: "orxShader_GetName", dynlib: libORX.}
  ## Gets shader name
  ##  @param[in]   _pstShader            Concerned Shader
  ##  @return      orxSTRING / orxSTRING_EMPTY

