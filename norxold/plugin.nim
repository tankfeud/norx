import incl, pluginType


## ********************************************
##  Function prototypes
## *******************************************

proc pluginSetup*() {.cdecl, importc: "orxPlugin_Setup", dynlib: libORX.}
  ## Plugin module setup

proc pluginInit*(): orxSTATUS {.cdecl, importc: "orxPlugin_Init",
                                 dynlib: libORX.}
  ## Inits the plugin module
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc pluginExit*() {.cdecl, importc: "orxPlugin_Exit", dynlib: libORX.}
  ## Exits from the plugin module

proc load*(zPluginFileName: cstring; zPluginName: cstring): orxHANDLE {.
    cdecl, importc: "orxPlugin_Load", dynlib: libORX.}
  ## Loads a plugin (using its exact complete)
  ##  @param[in] _zPluginFileName  The complete path of the plugin file, including its extension
  ##  @param[in] _zPluginName      The name that the plugin will be given in the plugin list
  ##  @return The plugin handle on success, orxHANDLE_UNDEFINED on failure

proc loadUsingExt*(zPluginFileName: cstring; zPluginName: cstring): orxHANDLE {.
    cdecl, importc: "orxPlugin_LoadUsingExt", dynlib: libORX.}
  ## Loads a plugin using OS common library extension + release/debug suffixes
  ##  @param[in] _zPluginFileName  The complete path of the plugin file, without its library extension
  ##  @param[in] _zPluginName      The name that the plugin will be given in the plugin list
  ##  @return The plugin handle on success, orxHANDLE_UNDEFINED on failure

proc unload*(hPluginHandle: orxHANDLE): orxSTATUS {.cdecl,
    importc: "orxPlugin_Unload", dynlib: libORX.}
  ## Unloads a plugin
  ##  @param[in] _hPluginHandle The handle of the plugin to unload
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getFunction*(hPluginHandle: orxHANDLE; zFunctionName: cstring): orxPLUGIN_FUNCTION {.
    cdecl, importc: "orxPlugin_GetFunction", dynlib: libORX.}
  ## Gets a function from a plugin
  ##  @param[in] _hPluginHandle The plugin handle
  ##  @param[in] _zFunctionName The name of the function to find
  ##  @return orxPLUGIN_FUNCTION / nil

proc getHandle*(zPluginName: cstring): orxHANDLE {.cdecl,
    importc: "orxPlugin_GetHandle", dynlib: libORX.}
  ## Gets the handle of a plugin given its name
  ##  @param[in] _zPluginName The plugin name
  ##  @return Its orxHANDLE / orxHANDLE_UNDEFINED

proc getName*(hPluginHandle: orxHANDLE): cstring {.cdecl,
    importc: "orxPlugin_GetName", dynlib: libORX.}
  ## Gets the name of a plugin given its handle
  ##  @param[in] _hPluginHandle The plugin handle
  ##  @return The plugin name / orxSTRING_EMPTY

