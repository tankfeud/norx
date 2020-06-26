import incl

## ********************************************
##  Constants / Defines
## *******************************************

const
  orxPLUGIN_KU32_FLAG_CORE_ID* = 0x10000000
  orxPLUGIN_KU32_MASK_PLUGIN_ID* = 0x0000FF00
  orxPLUGIN_KU32_SHIFT_PLUGIN_ID* = 8
  orxPLUGIN_KU32_MASK_FUNCTION_ID* = 0x000000FF

##  Argument max size

const
  orxPLUGIN_KU32_FUNCTION_ARG_SIZE* = 128

##  Macro for getting plugin function id

template orxPLUGIN_MAKE_FUNCTION_ID*(PLUGIN_ID, FUNCTION_BASE_ID: untyped): untyped =
  (orxPLUGIN_FUNCTION_ID)(((PLUGIN_ID shl orxPLUGIN_KU32_SHIFT_PLUGIN_ID) and
      orxPLUGIN_KU32_MASK_PLUGIN_ID) or
      (FUNCTION_BASE_ID and orxPLUGIN_KU32_MASK_FUNCTION_ID))

##  Macro for getting core plugin function id

template orxPLUGIN_MAKE_CORE_FUNCTION_ID*(
    PLUGIN_CORE_ID, FUNCTION_BASE_ID: untyped): untyped =
  (orxPLUGIN_FUNCTION_ID)(orxPLUGIN_KU32_FLAG_CORE_ID or
      orxPLUGIN_MAKE_FUNCTION_ID(PLUGIN_CORE_ID, FUNCTION_BASE_ID))

## ********************************************
##  Structures
## *******************************************

type
  orxPLUGIN_FUNCTION_ID* {.size: sizeof(cint).} = enum
    orxPLUGIN_FUNCTION_ID_NONE = orxENUM_NONE
  orxPLUGIN_FUNCTION* = proc (): orxSTATUS {.cdecl.}


## ********************************************
##  Function prototypes
## *******************************************

## * @}
