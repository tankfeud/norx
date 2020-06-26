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
