import typ

# ORX_VERSION_BUILD (__orxVERSION_BUILD__) is created by Orx setup script as output from 'git rev-list --count HEAD' and written to orxBuild.h

when not defined(Android) and not defined(ANDROID_NATIVE) and not defined(iOS):
  when not declared(ORX_VERSION_BUILD):
    import build

## Version numbers
const
  ORX_VERSION_MAJOR* = 1
  ORX_VERSION_MINOR* = 12
  ORX_VERSION_RELEASE* = "dev"

when not declared(ORX_VERSION_BUILD):
  const ORX_VERSION_BUILD* = 0

const
  ORX_VERSION_STRING* = $ORX_VERSION_MAJOR & "." & $ORX_VERSION_MINOR & "-" & $ORX_VERSION_RELEASE
  ORX_VERSION_FULL_STRING* = $ORX_VERSION_MAJOR & "." & $ORX_VERSION_MINOR & "." & $ORX_VERSION_BUILD & "-" & $ORX_VERSION_RELEASE
  ORX_VERSION_MASK_MAJOR = 0xFF000000
  ORX_VERSION_SHIFT_MAJOR = 24
  ORX_VERSION_MASK_MINOR = 0x00FF0000
  ORX_VERSION_SHIFT_MINOR = 16
  ORX_VERSION_MASK_BUILD = 0x0000FFFF
  ORX_VERSION_SHIFT_BUILD = 0
  ORX_VERSION*: int64 = (((ORX_VERSION_MAJOR shl ORX_VERSION_SHIFT_MAJOR) and ORX_VERSION_MASK_MAJOR) or
      ((ORX_VERSION_MINOR shl ORX_VERSION_SHIFT_MINOR) and ORX_VERSION_MASK_MINOR) or
      ((ORX_VERSION_BUILD shl ORX_VERSION_SHIFT_BUILD) and ORX_VERSION_MASK_BUILD))

## Version structure
type
  orxVERSION* {.bycopy.} = object
    zRelease*: cstring
    u32Major*: orxU32
    u32Minor*: orxU32
    u32Build*: orxU32
