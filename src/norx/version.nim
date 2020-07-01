import typ

when not defined(Android) and not defined(ANDROID_NATIVE) and not defined(iOS):
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
