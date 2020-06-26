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


## * Setups FPS module

proc orxFPS_Setup*() {.cdecl, importc: "orxFPS_Setup", dynlib: libORX.}
## * Inits the FPS module
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxFPS_Init*(): orxSTATUS {.cdecl, importc: "orxFPS_Init", dynlib: libORX.}
## * Exits from the FPS module

proc orxFPS_Exit*() {.cdecl, importc: "orxFPS_Exit", dynlib: libORX.}
## * Increases internal frame count

proc orxFPS_IncreaseFrameCount*() {.cdecl, importc: "orxFPS_IncreaseFrameCount",
                                  dynlib: libORX.}
## * Gets current FTP value
##  @return orxU32
##

proc orxFPS_GetFPS*(): orxU32 {.cdecl, importc: "orxFPS_GetFPS", dynlib: libORX.}
## * @}
