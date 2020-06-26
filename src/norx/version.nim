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
##
## *
##  @file orxVersion.h
##  @date 09/11/2016
##  @author iarwain@orx-project.org
##
##  @todo
##
## *
##  @addtogroup orxVersion
##
##  Version
##
##  @{
##

import typ

when not defined(ANDROID) and not defined(ANDROID_NATIVE) and not defined(IOS):
  when not defined(VERSION_BUILD):
    import build

## Version numbers
const
  VERSION_MAJOR* = 1
  VERSION_MINOR* = 12
  VERSION_RELEASE* = "dev"
  VERSION_BUILD* = 0

const
  VERSION_STRING* = $VERSION_MAJOR & "." & $VERSION_MINOR & "-" & $VERSION_RELEASE
  VERSION_FULL_STRING* = $VERSION_MAJOR & "." & $VERSION_MINOR & "." & $VERSION_BUILD & "-" & $VERSION_RELEASE
  VERSION_MASK_MAJOR* = 0xFF000000
  VERSION_SHIFT_MAJOR* = 24
  VERSION_MASK_MINOR* = 0x00FF0000
  VERSION_SHIFT_MINOR* = 16
  VERSION_MASK_BUILD* = 0x0000FFFF
  VERSION_SHIFT_BUILD* = 0
  VERSION*: int64 = (((VERSION_MAJOR shl VERSION_SHIFT_MAJOR) and VERSION_MASK_MAJOR) or
      ((VERSION_MINOR shl VERSION_SHIFT_MINOR) and VERSION_MASK_MINOR) or
      ((VERSION_BUILD shl VERSION_SHIFT_BUILD) and VERSION_MASK_BUILD))

## Version structure
type
  orxVERSION* {.bycopy.} = object
    zRelease*: cstring
    u32Major*: orxU32
    u32Minor*: orxU32
    u32Build*: orxU32