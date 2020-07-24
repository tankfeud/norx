import lib, decl

##  Windows
when defined(Windows):
  type
    orxHANDLE* = pointer
  when defined(X86_64):
    type
      orxU32* = cuint
      orxU16* = cushort
      orxU8* = cuchar
      orxS32* = cint
      orxS16* = cshort
      orxS8* = cchar
      orxBOOL* = distinct cuint
  else:
    type
      orxU32* = culong
      orxU16* = cushort
      orxU8* = cuchar
      orxS32* = clong
      orxS16* = cshort
      orxS8* = cchar
      orxBOOL* = distinct culong
  type
    orxFLOAT* = cfloat
    orxDOUBLE* = cdouble
    orxCHAR* = char
  type
    orxSTRINGID* = orxU32
    orxENUM* = orxU32
  template orx2F*(V: untyped): untyped =
    ((orxFLOAT)(V))

  template orx2D*(V: untyped): untyped =
    ((orxDOUBLE)(V))

  const
    orxENUM_NONE* = 0xFFFFFFFF
  ##  Compiler specific
  when defined(GCC):
    type
      orxU64* = culonglong
      orxS64* = clonglong
  when defined(LLVM):
    type
      orxU64* = culonglong
      orxS64* = clonglong
else:
  ##  Linux / Mac / iOS / Android
  when defined(Linux) or defined(MacOSX) or defined(iOS) or defined(Android) or
      defined(ANDROID_NATIVE):
    type
      orxHANDLE* = pointer
    when orx64:
      type
        orxU64* = culonglong
        orxU32* = cuint
        orxU16* = cushort
        orxU8* = cuchar
        orxS64* = clonglong
        orxS32* = cint
        orxS16* = cshort
        orxS8* = cchar
        orxBOOL* = distinct cuint
    else:
      type
        orxU64* = culonglong
        orxU32* = culong
        orxU16* = cushort
        orxU8* = cuchar
        orxS64* = clonglong
        orxS32* = clong
        orxS16* = cshort
        orxS8* = cchar
        orxBOOL* = distinct culong
    type
      orxFLOAT* = cfloat
      orxDOUBLE* = cdouble
      orxCHAR* = char
    type
      orxSTRINGID* = orxU32
      orxENUM* = orxU32
    template orx2F*(V: untyped): untyped =
      ((orxFLOAT)(V))

    template orx2D*(V: untyped): untyped =
      ((orxDOUBLE)(V))

    const
      orxENUM_NONE* = 0xFFFFFFFF

##  *** Misc constants ***

##  *** Seek offset constants ***
type
  orxSEEK_OFFSET_WHENCE* {.size: sizeof(cint).} = enum
    orxSEEK_OFFSET_WHENCE_START = 0, orxSEEK_OFFSET_WHENCE_CURRENT,
    orxSEEK_OFFSET_WHENCE_END, orxSEEK_OFFSET_WHENCE_NUMBER,
    orxSEEK_OFFSET_WHENCE_NONE = orxENUM_NONE


##  *** Boolean constants ***
const
  orxFALSE* = 0.orxBOOL
  orxTRUE* = 1.orxBOOL


converter toBool*(x: orxBOOL): bool = cint(x) != 0
  ## Converts orxBOOL to bool

converter toOrxBOOL*(x: bool): orxBOOL = orxBOOL(if x: 1 else: 0)
  ## Converts bool to orxBOOL


##  *** Float constants ***

#var orxFLOAT_0* {.importc: "orxFLOAT_0", dynlib: libORX.}: orxFLOAT
const orxFLOAT_0* = 0.0f

#var orxFLOAT_1* {.importc: "orxFLOAT_1", dynlib: libORX.}: orxFLOAT
const orxFLOAT_1* = 1.0f

#var orxFLOAT_MAX* {.importc: "orxFLOAT_MAX", dynlib: libORX.}: orxFLOAT
const orxFLOAT_MAX* = 3.402823466e+38f

##  *** Double constants ***

#var orxDOUBLE_0* {.importc: "orxDOUBLE_0", dynlib: libORX.}: orxDOUBLE

#var orxDOUBLE_1* {.importc: "orxDOUBLE_1", dynlib: libORX.}: orxDOUBLE

#var orxDOUBLE_MAX* {.importc: "orxDOUBLE_MAX", dynlib: libORX.}: orxDOUBLE

##  *** Undefined constants ***

#var orxU64_UNDEFINED* {.importc: "orxU64_UNDEFINED", dynlib: libORX.}: orxU64

#var orxU32_UNDEFINED* {.importc: "orxU32_UNDEFINED", dynlib: libORX.}: orxU32

#var orxU16_UNDEFINED* {.importc: "orxU16_UNDEFINED", dynlib: libORX.}: orxU16

#var orxU8_UNDEFINED* {.importc: "orxU8_UNDEFINED", dynlib: libORX.}: orxU8

#var orxHANDLE_UNDEFINED* {.importc: "orxHANDLE_UNDEFINED", dynlib: libORX.}: orxHANDLE

#var orxSTRINGID_UNDEFINED* {.importc: "orxSTRINGID_UNDEFINED", dynlib: libORX.}: orxSTRINGID

##  *** String & character constants ***

var orxSTRING_EMPTY* {.importc: "orxSTRING_EMPTY", dynlib: libORX.}: cstring

var orxSTRING_TRUE* {.importc: "orxSTRING_TRUE", dynlib: libORX.}: cstring

var orxSTRING_FALSE* {.importc: "orxSTRING_FALSE", dynlib: libORX.}: cstring

var orxSTRING_EOL* {.importc: "orxSTRING_EOL", dynlib: libORX.}: cstring

const
  orxCHAR_NULL* = '\x00'
  orxCHAR_CR* = '\c'
  orxCHAR_LF* = '\n'
  orxCHAR_EOL* = '\n'
  orxCHAR_ASCII_NUMBER* = 128

##  *** Directory separators ***
var orxSTRING_DIRECTORY_SEPARATOR* {.importc: "orxSTRING_DIRECTORY_SEPARATOR",
                                   dynlib: libORX.}: cstring

const
  orxCHAR_DIRECTORY_SEPARATOR_WINDOWS* = '\b'
  orxCHAR_DIRECTORY_SEPARATOR_LINUX* = '/'

when defined(Windows):
  const
    orxCHAR_DIRECTORY_SEPARATOR* = '\b'
elif defined(Linux) or defined(MacOSX) or defined(iOS) or defined(Android) or
    defined(ANDROID_NATIVE):
  const
    orxCHAR_DIRECTORY_SEPARATOR* = '/'

##  *** Status defines ***
type
  orxSTATUS* {.size: sizeof(cint).} = enum
    orxSTATUS_FAILURE = 0,      ## Failure status, the operation has failed
    orxSTATUS_SUCCESS,        ## Success status, the operation has worked has expected
    orxSTATUS_NUMBER,         ## Sentinel : Number of status
    orxSTATUS_NONE = orxENUM_NONE