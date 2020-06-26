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

when defined(DEBUG):
  const
    PROFILER* = true
when defined(APPLE):
  import
    TargetConditionals

##  *** Platform dependent base declarations
##  No processor defines?

when not defined(ARM) and not defined(PPC) and not defined(PPC64) and
    not defined(X86_64) and not defined(X86) and not defined(ARM64):
  ##  ARM?
  when defined(arm) or defined(ARMEL) or defined(ARM_EABI):
    const
      ARM* = true
    ##  ARM64?
  elif defined(arm64) or defined(aarch64):
    const
      ARM64* = true
    ##  PowerPC?
  elif defined(ppc) or defined(PPC) or defined(PPC) or defined(POWERPC) or
      defined(powerpc):
    const
      PPC* = true
    ##  PowerPC 64?
  elif defined(powerpc64) or defined(POWERPC64):
    const
      PPC64* = true
    ##  x86_64?
  elif defined(x86_64) or defined(M_X64) or defined(ia64):
    const
      X86_64* = true
    ##  x86
  else:
    const
      X86* = true
##  Has byte order?

when defined(BYTE_ORDER) and defined(ORDER_BIG_ENDIAN):
  when (BYTE_ORDER == ORDER_BIG_ENDIAN):
    const
      BIG_ENDIAN* = true
  else:
    const
      LITTLE_ENDIAN* = true
else:
  ##  Power PC?
  when defined(PPC):
    const
      BIG_ENDIAN* = true
  else:
    const
      LITTLE_ENDIAN* = true
##  No compiler defines?

when not defined(LLVM) and not defined(GCC) and not defined(MSVC):
  ##  LLVM?
  when defined(llvm):
    const
      LLVM* = true
    ##  GCC?
  elif defined(GNUC):
    const
      GCC* = true
    ##  MSVC?
  elif defined(MSC_VER):
    const
      MSVC* = true
##  Instruction size

when defined(X86_64) or defined(PPC64) or defined(ARM64):
  ##  64 bits
  const
    orx64* = true
else:
  ##  32 bits
  const
    orx32* = true
##  No platform defines?

when not defined(WINDOWS) and not defined(MAC) and not defined(LINUX) and
    not defined(IOS) and not defined(ANDROID) and not defined(ANDROID_NATIVE):
  ##  Windows?
  when defined(WIN32) or defined(WIN32):
    const
      WINDOWS* = true
    ##  iOS?
  elif defined(TARGET_OS_IPHONE):
    const
      IOS* = true
    ##  Android
  elif defined(TARGET_OS_ANDROID):
    const
      ANDROID* = true
    ##  Android Native
  elif defined(TARGET_OS_ANDROID_NATIVE):
    const
      ANDROID_NATIVE* = true
    ##  Linux?
  elif defined(linux) or defined(linux):
    const
      LINUX* = true
    ##  Mac?
  elif defined(TARGET_OS_MAC):
    const
      MAC* = true
when defined(OBJC):
  const
    OBJC* = true
##  Plugin include?

when defined(PLUGIN):
  when defined(EMBEDDED):
    const
      orxIMPORT* = true         ##  Compiling embedded plug-in => API doesn't need to be imported
  else:
    const
      orxIMPORT* = orxDLLIMPORT
  ##  External include?
elif defined(EXTERN):
  when defined(STATIC):
    const
      orxIMPORT* = true         ##  Linking executable against orx static library
  else:
    const
      orxIMPORT* = orxDLLIMPORT
  ##  Internal (library) include
else:
  const
    orxIMPORT* = true           ##  Compiling orx library => API needs to be exported
## * Memory alignment macros

template orxALIGN*(ADDRESS, BLOCK_SIZE: untyped): untyped =
  (((size_t)(ADDRESS) + ((size_t)(BLOCK_SIZE) - 1)) and
      (not ((size_t)(BLOCK_SIZE) - 1)))

template orxALIGN16*(ADDRESS: untyped): untyped =
  orxALIGN(ADDRESS, 16)

template orxALIGN32*(ADDRESS: untyped): untyped =
  orxALIGN(ADDRESS, 32)

template orxALIGN64*(ADDRESS: untyped): untyped =
  orxALIGN(ADDRESS, 64)

## * Structure macros

template orxSTRUCT_GET_FROM_FIELD*(TYPE, FIELD, POINTER: untyped): untyped =
  (cast[ptr TYPE]((cast[ptr orxU8]((POINTER)) - offsetof(TYPE, FIELD))))

## * Array macros

template orxARRAY_GET_ITEM_COUNT*(ARRAY: untyped): untyped =
  (sizeof((ARRAY) div sizeof((ARRAY[0]))))

## * Flag macros
## * Tests all flags
##  @param[in] X Flag container
##  @param[in] F Flags to test
##  @return true if flags are all presents
##

template orxFLAG_TEST_ALL*(X, F: untyped): untyped =
  (((X) and (F)) == (F))

## * Tests flags
##  @param[in] X Flag container
##  @param[in] F Flags to test
##  @return true if at least one flag is present
##

template orxFLAG_TEST*(X, F: untyped): untyped =
  (((X) and (F)) != 0)

## * Gets flags
##  @param[in] X Flag container
##  @param[in] M Filtering mask
##  @return Masked flags
##

template orxFLAG_GET*(X, M: untyped): untyped =
  ((X) and (M))

## * Sets / unsets flags
##  @param[in] X Flag container
##  @param[in] A Flags to add
##  @param[in] R Flags to remove
##

template orxFLAG_SET*(X, A, R: untyped): void =
  while true:
    (X) = (X) and not (R)
    (X) = (X) or (A)
    if not orxFALSE:
      break

## * Swaps flags
##  @param[in] X Flag container
##  @param[in] S Flags to swap
##

template orxFLAG_SWAP*(X, S: untyped): untyped =
  ((X) = (X) xor (S))

## * ANSI macros

const
  orxANSI_KC_MARKER* = '\e'
  orxANSI_KZ_COLOR_RESET* = "\e[0m"
  orxANSI_KZ_COLOR_BOLD_ON* = "\e[1m"
  orxANSI_KZ_COLOR_ITALICS_ON* = "\e[3m"
  orxANSI_KZ_COLOR_UNDERLINE_ON* = "\e[4m"
  orxANSI_KZ_COLOR_BLINK_ON* = "\e[5m"
  orxANSI_KZ_COLOR_INVERSE_ON* = "\e[7m"
  orxANSI_KZ_COLOR_STRIKETHROUGH_ON* = "\e[9m"
  orxANSI_KZ_COLOR_BOLD_OFF* = "\e[22m"
  orxANSI_KZ_COLOR_ITALICS_OFF* = "\e[23m"
  orxANSI_KZ_COLOR_UNDERLINE_OFF* = "\e[24m"
  orxANSI_KZ_COLOR_BLINK_OFF* = "\e[25m"
  orxANSI_KZ_COLOR_INVERSE_OFF* = "\e[27m"
  orxANSI_KZ_COLOR_STRIKETHROUGH_OFF* = "\e[29m"
  orxANSI_KZ_COLOR_FG_BLACK* = "\e[30m"
  orxANSI_KZ_COLOR_FG_RED* = "\e[31m"
  orxANSI_KZ_COLOR_FG_GREEN* = "\e[32m"
  orxANSI_KZ_COLOR_FG_YELLOW* = "\e[33m"
  orxANSI_KZ_COLOR_FG_BLUE* = "\e[34m"
  orxANSI_KZ_COLOR_FG_MAGENTA* = "\e[35m"
  orxANSI_KZ_COLOR_FG_CYAN* = "\e[36m"
  orxANSI_KZ_COLOR_FG_WHITE* = "\e[37m"
  orxANSI_KZ_COLOR_FG_DEFAULT* = "\e[39m"
  orxANSI_KZ_COLOR_BG_BLACK* = "\e[40m"
  orxANSI_KZ_COLOR_BG_RED* = "\e[41m"
  orxANSI_KZ_COLOR_BG_GREEN* = "\e[42m"
  orxANSI_KZ_COLOR_BG_YELLOW* = "\e[43m"
  orxANSI_KZ_COLOR_BG_BLUE* = "\e[44m"
  orxANSI_KZ_COLOR_BG_MAGENTA* = "\e[45m"
  orxANSI_KZ_COLOR_BG_CYAN* = "\e[46m"
  orxANSI_KZ_COLOR_BG_WHITE* = "\e[47m"
  orxANSI_KZ_COLOR_BG_DEFAULT* = "\e[49m"

# Named these to make them stand out
template pointerAdd*[T](p: ptr T, off: int): ptr T =
  cast[ptr type(p[])](cast[ByteAddress](p) +% off * sizeof(p[]))

template pointerSub*[T](p: ptr T, off: int): ptr T =
  cast[ptr type(p[])](cast[ByteAddress](p) -% off * sizeof(p[]))

template `[]`*[T](p: ptr T, off: int): T =
  (p + off)[]

template `[]=`*[T](p: ptr T, off: int, val: T) =
  (p + off)[] = val

