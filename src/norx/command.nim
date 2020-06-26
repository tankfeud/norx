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
  incl, vector

## * Misc
##

const
  orxCOMMAND_KC_BLOCK_MARKER* = '\"'
  orxCOMMAND_KC_PUSH_MARKER* = '>'
  orxCOMMAND_KC_POP_MARKER* = '<'
  orxCOMMAND_KC_GUID_MARKER* = '^'
  orxCOMMAND_KC_SEPARATOR* = ','

## * Variable type enum
##

type
  orxCOMMAND_VAR_TYPE* {.size: sizeof(cint).} = enum
    orxCOMMAND_VAR_TYPE_STRING = 0, orxCOMMAND_VAR_TYPE_FLOAT,
    orxCOMMAND_VAR_TYPE_S32, orxCOMMAND_VAR_TYPE_U32, orxCOMMAND_VAR_TYPE_S64,
    orxCOMMAND_VAR_TYPE_U64, orxCOMMAND_VAR_TYPE_BOOL, orxCOMMAND_VAR_TYPE_VECTOR,
    orxCOMMAND_VAR_TYPE_NUMERIC, orxCOMMAND_VAR_TYPE_NUMBER,
    orxCOMMAND_VAR_TYPE_NONE = orxENUM_NONE


## * Variable definition structure
##

type
  orxCOMMAND_VAR_DEF* {.bycopy.} = object
    zName*: cstring         ## *< Name : 4
    eType*: orxCOMMAND_VAR_TYPE ## *< Type : 8


## * Variable structure

type
  INNER_C_UNION_orxCommand_95* {.bycopy.} = object {.union.}
    vValue*: orxVECTOR         ## *< Vector value : 12
    zValue*: cstring        ## *< String value : 4
    u32Value*: orxU32          ## *< U32 value : 4
    s32Value*: orxS32          ## *< S32 value : 4
    u64Value*: orxU64          ## *< U64 value : 8
    s64Value*: orxS64          ## *< S64 value : 8
    fValue*: orxFLOAT          ## *< Float value : 4
    bValue*: orxBOOL           ## *< Bool value : 4

  orxCOMMAND_VAR* {.bycopy.} = object
    ano_orxCommand_103*: INNER_C_UNION_orxCommand_95
    eType*: orxCOMMAND_VAR_TYPE ## *< Type : 16


## * Command function type

type
  orxCOMMAND_FUNCTION* = proc (u32ArgNumber: orxU32; astArgList: ptr orxCOMMAND_VAR;
                            pstResult: ptr orxCOMMAND_VAR) {.cdecl.}

## * Command registration helpers
##

## * Command module setup
##

proc orxCommand_Setup*() {.cdecl, importc: "orxCommand_Setup", dynlib: libORX.}
## * Inits the command module
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxCommand_Init*(): orxSTATUS {.cdecl, importc: "orxCommand_Init",
                                  dynlib: libORX.}
## * Exits from the command module
##

proc orxCommand_Exit*() {.cdecl, importc: "orxCommand_Exit", dynlib: libORX.}
## * Registers a command
##  @param[in]   _zCommand      Command name
##  @param[in]   _pfnFunction   Associated function
##  @param[in]   _u32RequiredParamNumber Number of required parameters of the command
##  @param[in]   _u32OptionalParamNumber Number of optional parameters of the command
##  @param[in]   _astParamList  List of parameters of the command
##  @param[in]   _pstResult     Result
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxCommand_Register*(zCommand: cstring; pfnFunction: orxCOMMAND_FUNCTION;
                         u32RequiredParamNumber: orxU32;
                         u32OptionalParamNumber: orxU32;
                         astParamList: ptr orxCOMMAND_VAR_DEF;
                         pstResult: ptr orxCOMMAND_VAR_DEF): orxSTATUS {.cdecl,
    importc: "orxCommand_Register", dynlib: libORX.}
## * Unregisters a command
##  @param[in]   _zCommand      Command name
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxCommand_Unregister*(zCommand: cstring): orxSTATUS {.cdecl,
    importc: "orxCommand_Unregister", dynlib: libORX.}
## * Is a command registered?
##  @param[in]   _zCommand      Command name
##  @return      orxTRUE / orxFALSE
##

proc orxCommand_IsRegistered*(zCommand: cstring): orxBOOL {.cdecl,
    importc: "orxCommand_IsRegistered", dynlib: libORX.}
## * Adds a command alias
##  @param[in]   _zAlias        Command alias
##  @param[in]   _zCommand      Command name
##  @param[in]   _zArgs         Command argument, nil for none
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxCommand_AddAlias*(zAlias: cstring; zCommand: cstring;
                         zArgs: cstring): orxSTATUS {.cdecl,
    importc: "orxCommand_AddAlias", dynlib: libORX.}
## * Removes a command alias
##  @param[in]   _zAlias        Command alias
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxCommand_RemoveAlias*(zAlias: cstring): orxSTATUS {.cdecl,
    importc: "orxCommand_RemoveAlias", dynlib: libORX.}
## * Is a command alias?
##  @param[in]   _zAlias        Command alias
##  @return      orxTRUE / orxFALSE
##

proc orxCommand_IsAlias*(zAlias: cstring): orxBOOL {.cdecl,
    importc: "orxCommand_IsAlias", dynlib: libORX.}
## * Gets a command's (text) prototype (beware: result won't persist from one call to the other)
##  @param[in]   _zCommand      Command name
##  @return      Command prototype / orxSTRING_EMPTY
##

proc orxCommand_GetPrototype*(zCommand: cstring): cstring {.cdecl,
    importc: "orxCommand_GetPrototype", dynlib: libORX.}
## * Gets next command using an optional base
##  @param[in]   _zBase             Base name, can be set to nil for no base
##  @param[in]   _zPrevious         Previous command, nil to get the first command
##  @param[out]  _pu32CommonLength  Length of the common prefix of all potential results, nil to ignore
##  @return      Next command found, nil if none
##

proc orxCommand_GetNext*(zBase: cstring; zPrevious: cstring;
                        pu32CommonLength: ptr orxU32): cstring {.cdecl,
    importc: "orxCommand_GetNext", dynlib: libORX.}
## * Evaluates a command
##  @param[in]   _zCommandLine  Command name + arguments
##  @param[out]  _pstResult     Variable that will contain the result
##  @return      Command result if found, nil otherwise
##

proc orxCommand_Evaluate*(zCommandLine: cstring; pstResult: ptr orxCOMMAND_VAR): ptr orxCOMMAND_VAR {.
    cdecl, importc: "orxCommand_Evaluate", dynlib: libORX.}
## * Evaluates a command with a specific GUID
##  @param[in]   _zCommandLine  Command name + arguments
##  @param[in]   _u64GUID       GUID to use in place of the GUID markers in the command
##  @param[out]  _pstResult     Variable that will contain the result
##  @return      Command result if found, nil otherwise
##

proc orxCommand_EvaluateWithGUID*(zCommandLine: cstring; u64GUID: orxU64;
                                 pstResult: ptr orxCOMMAND_VAR): ptr orxCOMMAND_VAR {.
    cdecl, importc: "orxCommand_EvaluateWithGUID", dynlib: libORX.}
## * Executes a command
##  @param[in]   _zCommand      Command name
##  @param[in]   _u32ArgNumber  Number of arguments sent to the command
##  @param[in]   _astArgList    List of arguments sent to the command
##  @param[out]  _pstResult     Variable that will contain the result
##  @return      Command result if found, nil otherwise
##

proc orxCommand_Execute*(zCommand: cstring; u32ArgNumber: orxU32;
                        astArgList: ptr orxCOMMAND_VAR;
                        pstResult: ptr orxCOMMAND_VAR): ptr orxCOMMAND_VAR {.cdecl,
    importc: "orxCommand_Execute", dynlib: libORX.}
## * Parses numerical arguments, string arguments will be evaluated to vectors or float when possible
##  @param[in]   _u32ArgNumber  Number of arguments to parse
##  @param[in]   _astArgList    List of arguments to parse
##  @param[out]  _astOperandList List of parsed arguments
##  @return orxSTATUS_SUCCESS if all numerical arguments have been correctly interpreted, orxSTATUS_FAILURE otherwise
##

proc orxCommand_ParseNumericalArguments*(u32ArgNumber: orxU32;
                                        astArgList: ptr orxCOMMAND_VAR;
                                        astOperandList: ptr orxCOMMAND_VAR): orxSTATUS {.
    cdecl, importc: "orxCommand_ParseNumericalArguments", dynlib: libORX.}
## * Prints a variable to a buffer, according to its type (and ignoring any bloc/special character)
##  @param[out]  _zDstString    Destination string
##  @param[in]   _u32Size       String available size
##  @param[in]   _pstVar        Variable to print
##  @return Number of written characters (excluding trailing orxCHAR_NULL)
##

proc orxCommand_PrintVar*(zDstString: cstring; u32Size: orxU32;
                         pstVar: ptr orxCOMMAND_VAR): orxU32 {.cdecl,
    importc: "orxCommand_PrintVar", dynlib: libORX.}
## * @}
