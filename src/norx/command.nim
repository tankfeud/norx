
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
  INNER_C_UNION_orxCommand_95* {.bycopy, union.} = object
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

proc commandSetup*() {.cdecl, importc: "orxCommand_Setup", dynlib: libORX.}
  ## Command module setup

proc commandInit*(): orxSTATUS {.cdecl, importc: "orxCommand_Init",
                                  dynlib: libORX.}
  ## Inits the command module
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc commandExit*() {.cdecl, importc: "orxCommand_Exit", dynlib: libORX.}
  ## Exits from the command module

proc register*(zCommand: cstring; pfnFunction: orxCOMMAND_FUNCTION;
                         u32RequiredParamNumber: orxU32;
                         u32OptionalParamNumber: orxU32;
                         astParamList: ptr orxCOMMAND_VAR_DEF;
                         pstResult: ptr orxCOMMAND_VAR_DEF): orxSTATUS {.cdecl,
    importc: "orxCommand_Register", dynlib: libORX.}
  ## Registers a command
  ##  @param[in]   _zCommand      Command name
  ##  @param[in]   _pfnFunction   Associated function
  ##  @param[in]   _u32RequiredParamNumber Number of required parameters of the command
  ##  @param[in]   _u32OptionalParamNumber Number of optional parameters of the command
  ##  @param[in]   _astParamList  List of parameters of the command
  ##  @param[in]   _pstResult     Result
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc unregister*(zCommand: cstring): orxSTATUS {.cdecl,
    importc: "orxCommand_Unregister", dynlib: libORX.}
  ## Unregisters a command
  ##  @param[in]   _zCommand      Command name
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc isRegistered*(zCommand: cstring): orxBOOL {.cdecl,
    importc: "orxCommand_IsRegistered", dynlib: libORX.}
  ## Is a command registered?
  ##  @param[in]   _zCommand      Command name
  ##  @return      orxTRUE / orxFALSE

proc addAlias*(zAlias: cstring; zCommand: cstring;
                         zArgs: cstring): orxSTATUS {.cdecl,
    importc: "orxCommand_AddAlias", dynlib: libORX.}
  ## Adds a command alias
  ##  @param[in]   _zAlias        Command alias
  ##  @param[in]   _zCommand      Command name
  ##  @param[in]   _zArgs         Command argument, nil for none
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc removeAlias*(zAlias: cstring): orxSTATUS {.cdecl,
    importc: "orxCommand_RemoveAlias", dynlib: libORX.}
  ## Removes a command alias
  ##  @param[in]   _zAlias        Command alias
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc isAlias*(zAlias: cstring): orxBOOL {.cdecl,
    importc: "orxCommand_IsAlias", dynlib: libORX.}
  ## Is a command alias?
  ##  @param[in]   _zAlias        Command alias
  ##  @return      orxTRUE / orxFALSE

proc getPrototype*(zCommand: cstring): cstring {.cdecl,
    importc: "orxCommand_GetPrototype", dynlib: libORX.}
  ## Gets a command's (text) prototype (beware: result won't persist from one call to the other)
  ##  @param[in]   _zCommand      Command name
  ##  @return      Command prototype / orxSTRING_EMPTY

proc getNext*(zBase: cstring; zPrevious: cstring;
                        pu32CommonLength: ptr orxU32): cstring {.cdecl,
    importc: "orxCommand_GetNext", dynlib: libORX.}
  ## Gets next command using an optional base
  ##  @param[in]   _zBase             Base name, can be set to nil for no base
  ##  @param[in]   _zPrevious         Previous command, nil to get the first command
  ##  @param[out]  _pu32CommonLength  Length of the common prefix of all potential results, nil to ignore
  ##  @return      Next command found, nil if none

proc evaluate*(zCommandLine: cstring; pstResult: ptr orxCOMMAND_VAR): ptr orxCOMMAND_VAR {.
    cdecl, importc: "orxCommand_Evaluate", dynlib: libORX.}
  ## Evaluates a command
  ##  @param[in]   _zCommandLine  Command name + arguments
  ##  @param[out]  _pstResult     Variable that will contain the result
  ##  @return      Command result if found, nil otherwise

proc evaluateWithGUID*(zCommandLine: cstring; u64GUID: orxU64;
                                 pstResult: ptr orxCOMMAND_VAR): ptr orxCOMMAND_VAR {.
    cdecl, importc: "orxCommand_EvaluateWithGUID", dynlib: libORX.}
  ## Evaluates a command with a specific GUID
  ##  @param[in]   _zCommandLine  Command name + arguments
  ##  @param[in]   _u64GUID       GUID to use in place of the GUID markers in the command
  ##  @param[out]  _pstResult     Variable that will contain the result
  ##  @return      Command result if found, nil otherwise

proc execute*(zCommand: cstring; u32ArgNumber: orxU32;
                        astArgList: ptr orxCOMMAND_VAR;
                        pstResult: ptr orxCOMMAND_VAR): ptr orxCOMMAND_VAR {.cdecl,
    importc: "orxCommand_Execute", dynlib: libORX.}
  ## Executes a command
  ##  @param[in]   _zCommand      Command name
  ##  @param[in]   _u32ArgNumber  Number of arguments sent to the command
  ##  @param[in]   _astArgList    List of arguments sent to the command
  ##  @param[out]  _pstResult     Variable that will contain the result
  ##  @return      Command result if found, nil otherwise

proc parseNumericalArguments*(u32ArgNumber: orxU32;
                                        astArgList: ptr orxCOMMAND_VAR;
                                        astOperandList: ptr orxCOMMAND_VAR): orxSTATUS {.
    cdecl, importc: "orxCommand_ParseNumericalArguments", dynlib: libORX.}
  ## Parses numerical arguments, string arguments will be evaluated to vectors or float when possible
  ##  @param[in]   _u32ArgNumber  Number of arguments to parse
  ##  @param[in]   _astArgList    List of arguments to parse
  ##  @param[out]  _astOperandList List of parsed arguments
  ##  @return orxSTATUS_SUCCESS if all numerical arguments have been correctly interpreted, orxSTATUS_FAILURE otherwise

proc printVar*(zDstString: cstring; u32Size: orxU32;
                         pstVar: ptr orxCOMMAND_VAR): orxU32 {.cdecl,
    importc: "orxCommand_PrintVar", dynlib: libORX.}
  ## Prints a variable to a buffer, according to its type (and ignoring any bloc/special character)
  ##  @param[out]  _zDstString    Destination string
  ##  @param[in]   _u32Size       String available size
  ##  @param[in]   _pstVar        Variable to print
  ##  @return Number of written characters (excluding trailing orxCHAR_NULL)

