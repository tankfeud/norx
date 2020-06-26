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

import
  incl, pluginType, plugin/coreID

## ********************************************
##  Structures
## *******************************************
##  Structure

type
  orxPLUGIN_CORE_FUNCTION* {.bycopy.} = object
    eFunctionID*: orxPLUGIN_FUNCTION_ID ## *< Function ID : 4
    pfnFunction*: ptr orxPLUGIN_FUNCTION ## *< Function Address : 8
    pfnDefaultFunction*: orxPLUGIN_FUNCTION ## *< Default Function : 12


##  Structure

type
  orxPLUGIN_USER_FUNCTION_INFO* {.bycopy.} = object
    eFunctionID*: orxPLUGIN_FUNCTION_ID ## *< Function ID
    pfnFunction*: orxPLUGIN_FUNCTION ## *< Function Address
    zFunctionArgs*: array[orxPLUGIN_KU32_FUNCTION_ARG_SIZE, orxCHAR] ## *< Function Argument Types
    zFunctionName*: cstring ## *< Function Name


## * Plugin init function prototype
##

type
  orxPLUGIN_INIT_FUNCTION* = proc (peUserFunctionNumber: ptr orxU32;
      pastUserFunctionInfo: ptr ptr orxPLUGIN_USER_FUNCTION_INFO): orxSTATUS {.cdecl.}

## ********************************************
##  Function prototypes
## *******************************************
## * Adds an info structure for the given core module
##  Has to be called during a core module init
##  @param[in] _ePluginCoreID          The numeric id of the core plugin
##  @param[in] _eModuleID              Corresponding module ID
##  @param[in] _astCoreFunction        The pointer to the core functions info array
##  @param[in] _u32CoreFunctionNumber  Number of functions in the array
##

proc orxPlugin_AddCoreInfo*(ePluginCoreID: orxPLUGIN_CORE_ID;
                           eModuleID: orxMODULE_ID;
                           astCoreFunction: ptr orxPLUGIN_CORE_FUNCTION;
                           u32CoreFunctionNumber: orxU32) {.cdecl,
    importc: "orxPlugin_AddCoreInfo", dynlib: libORX.}
when defined(EMBEDDED):
  ## * Binds a core plugin to its embedded implementation
  ##  Has to be called during a core module init
  ##  @param[in] _ePluginCoreID          The numeric id of the core plugin
  ##  @param[in] _pfnPluginInit          Embedded plug-in init function
  ##
  proc orxPlugin_BindCoreInfo*(ePluginCoreID: orxPLUGIN_CORE_ID;
                              pfnPluginInit: orxPLUGIN_INIT_FUNCTION) {.cdecl,
      importc: "orxPlugin_BindCoreInfo", dynlib: libORX.}
## * Default core plugin function
##  Needs to be referenced by all core functions at module init.
##

proc orxPlugin_DefaultCoreFunction*(zFunctionName: cstring;
                                   zFileName: cstring; u32Line: orxU32): pointer {.
    cdecl, importc: "orxPlugin_DefaultCoreFunction", dynlib: libORX.}
## * @}
