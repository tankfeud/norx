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

import lib, typ

## Module enum
type
  orxMODULE_ID* {.size: sizeof(cint).} = enum
    orxMODULE_ID_ANIM = 0, orxMODULE_ID_ANIMPOINTER, orxMODULE_ID_ANIMSET,
    orxMODULE_ID_BANK, orxMODULE_ID_BODY, orxMODULE_ID_CAMERA, orxMODULE_ID_CLOCK,
    orxMODULE_ID_COMMAND, orxMODULE_ID_CONFIG, orxMODULE_ID_CONSOLE,
    orxMODULE_ID_DISPLAY, orxMODULE_ID_EVENT, orxMODULE_ID_FILE, orxMODULE_ID_FONT,
    orxMODULE_ID_FPS, orxMODULE_ID_FRAME, orxMODULE_ID_FX, orxMODULE_ID_FXPOINTER,
    orxMODULE_ID_GRAPHIC, orxMODULE_ID_INPUT, orxMODULE_ID_JOYSTICK,
    orxMODULE_ID_KEYBOARD, orxMODULE_ID_LOCALE, orxMODULE_ID_MAIN,
    orxMODULE_ID_MEMORY, orxMODULE_ID_MOUSE, orxMODULE_ID_OBJECT,
    orxMODULE_ID_PARAM, orxMODULE_ID_PHYSICS, orxMODULE_ID_PLUGIN,
    orxMODULE_ID_PROFILER, orxMODULE_ID_RENDER, orxMODULE_ID_RESOURCE,
    orxMODULE_ID_SCREENSHOT, orxMODULE_ID_SHADER, orxMODULE_ID_SHADERPOINTER,
    orxMODULE_ID_SOUND, orxMODULE_ID_SOUNDPOINTER, orxMODULE_ID_SOUNDSYSTEM,
    orxMODULE_ID_SPAWNER, orxMODULE_ID_STRING, orxMODULE_ID_STRUCTURE,
    orxMODULE_ID_SYSTEM, orxMODULE_ID_TEXT, orxMODULE_ID_TEXTURE,
    orxMODULE_ID_THREAD, orxMODULE_ID_TIMELINE, orxMODULE_ID_VIEWPORT,
    orxMODULE_ID_CORE_NUMBER, orxMODULE_ID_TOTAL_NUMBER = 64,
    orxMODULE_ID_NONE = orxENUM_NONE

const
  orxMODULE_ID_USER_DEFINED = orxMODULE_ID_CORE_NUMBER

##  *** setup/init/exit/run function prototypes ***

type
  orxMODULE_INIT_FUNCTION* = proc(): orxSTATUS {.cdecl.}
  orxMODULE_EXIT_FUNCTION* = proc() {.cdecl.}
  orxMODULE_RUN_FUNCTION* = proc(): orxSTATUS {.cdecl.}
  orxMODULE_SETUP_FUNCTION* = proc() {.cdecl.}

## * Registers a module
##  @param[in]   _eModuleID                Concerned module ID
##  @param[in]   _zModuleName              Module name
##  @param[in]   _pfnSetup                 Module setup callback
##  @param[in]   _pfnInit                  Module init callback
##  @param[in]   _pfnExit                  Module exit callback
##

proc orxModule_Register*(eModuleID: orxMODULE_ID; zModuleName: cstring;
                        pfnSetup: orxMODULE_SETUP_FUNCTION;
                        pfnInit: orxMODULE_INIT_FUNCTION;
                        pfnExit: orxMODULE_EXIT_FUNCTION) {.cdecl,
    importc: "orxModule_Register", dynlib: libORX.}
## * Adds dependencies between 2 modules
##  @param[in]   _eModuleID                Concerned module ID
##  @param[in]   _eDependID                Module ID of the needed module
##

proc orxModule_AddDependency*(eModuleID: orxMODULE_ID; eDependID: orxMODULE_ID) {.
    cdecl, importc: "orxModule_AddDependency", dynlib: libORX.}
## * Adds optional dependencies between 2 modules
##  @param[in]   _eModuleID                Concerned module ID
##  @param[in]   _eDependID                Module ID of the optionally needed module
##

proc orxModule_AddOptionalDependency*(eModuleID: orxMODULE_ID;
                                     eDependID: orxMODULE_ID) {.cdecl,
    importc: "orxModule_AddOptionalDependency", dynlib: libORX.}
## * Inits a module
##  @param[in]   _eModuleID                Concerned module ID
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxModule_Init*(eModuleID: orxMODULE_ID): orxSTATUS {.cdecl,
    importc: "orxModule_Init", dynlib: libORX.}
## * Exits from a module
##  @param[in]   _eModuleID                Concerned module ID
##

proc orxModule_Exit*(eModuleID: orxMODULE_ID) {.cdecl, importc: "orxModule_Exit",
    dynlib: libORX.}
## * Is module initialized?
##  @param[in]   _eModuleID                Concerned module ID
##  @return      orxTRUE / orxFALSE
##

proc orxModule_IsInitialized*(eModuleID: orxMODULE_ID): orxBOOL {.cdecl,
    importc: "orxModule_IsInitialized", dynlib: libORX.}
## * Gets module name
##  @param[in]   _eModuleID                Concerned module ID
##  @return Module name / orxSTRING_EMPTY
##

proc orxModule_GetName*(eModuleID: orxMODULE_ID): cstring {.cdecl,
    importc: "orxModule_GetName", dynlib: libORX.}
