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

import incl, memory, vector  

when defined(MSVC):
  const
    strtoll* = strtoi64
    strtoull* = strtoui64


const
  orxSTRING_KC_VECTOR_START* = '('
  orxSTRING_KC_VECTOR_START_ALT* = '{'
  orxSTRING_KC_VECTOR_SEPARATOR* = ','
  orxSTRING_KC_VECTOR_END* = ')'
  orxSTRING_KC_VECTOR_END_ALT* = '}'

## * Defines
##

const
  orxSTRING_KU32_CRC_POLYNOMIAL* = 0xEDB88320

## * CRC Tables (slice-by-8)
##

var saau32CRCTable* {.importc: "saau32CRCTable", dynlib: libORX.}: array[8,
    array[256, orxU32]]

#[
##  *** String inlined functions ***
## * Skips all white spaces
##  @param[in] _zString        Concerned string
##  @return    Sub string located after all leading white spaces, including EOL characters
##

proc orxString_SkipWhiteSpaces*(zString: cstring): cstring {.inline, cdecl.} =
  var zResult: cstring
  ##  Non null?
  if zString != nil:
    ##  Skips all white spaces
    zResult = zString
    while (zResult[] == ' ') or (zResult[] == '\t') or (zResult[] == orxCHAR_CR) or
        (zResult[] == orxCHAR_LF):
      ##  Empty?
      inc(zResult)
    if zResult[] == orxCHAR_NULL:
      ##  Updates result
      zResult = orxSTRING_EMPTY
  else:
    ##  Updates result
    zResult = nil
  ##  Done!
  return zResult

## * Skips path
##  @param[in] _zString        Concerned string
##  @return    Sub string located after all non-terminal directory separators
##

proc orxString_SkipPath*(zString: cstring): cstring {.inline, cdecl.} =
  var zResult: cstring
  ##  Non null?
  if zString != nil:
    var pc: cstring
    ##  Updates result
    zResult = zString
    ##  For all characters
    pc = zString
    while pc[] != orxCHAR_NULL:
      ##  Is a directory separator?
      if (pc[] == orxCHAR_DIRECTORY_SEPARATOR_LINUX) or
          (pc[] == orxCHAR_DIRECTORY_SEPARATOR_WINDOWS):
        var cNextChar: orxCHAR
        ##  Non terminal and not a directory separator?
        if (cNextChar != orxCHAR_NULL) and
            (cNextChar != orxCHAR_DIRECTORY_SEPARATOR_LINUX) and
            (cNextChar != orxCHAR_DIRECTORY_SEPARATOR_WINDOWS):
          ##  Updates result
          zResult = pc + 1
      inc(pc)
  else:
    ##  Updates result
    zResult = nil
  ##  Done!
  return zResult

## * Returns the number of orxCHAR in the string (for non-ASCII UTF-8 string, it won't be the actual number of unicode characters)
##  @param[in] _zString                  String used for length computation
##  @return                              Length of the string (doesn't count final orxCHAR_NULL)
##

proc orxString_GetLength*(zString: cstring): orxU32 {.inline, cdecl.} =
  ##  Checks
  assert(zString != nil)
  ##  Done!
  return cast[orxU32](strlen(zString))

## * Tells if a character is ASCII from its ID
##  @param[in] _u32CharacterCodePoint    Concerned character code
##  @return                              orxTRUE is it's a non-extended ASCII character, orxFALSE otherwise
##

proc orxString_IsCharacterASCII*(u32CharacterCodePoint: orxU32): orxBOOL {.inline,
    cdecl.} =
  ##  Done!
  return if (u32CharacterCodePoint < 0x00000080): orxTRUE else: orxFALSE

## * Tells if a character is alpha-numeric from its ID
##  @param[in] _u32CharacterCodePoint    Concerned character code
##  @return                              orxTRUE is it's a non-extended ASCII alpha-numerical character, orxFALSE otherwise
##

proc orxString_IsCharacterAlphaNumeric*(u32CharacterCodePoint: orxU32): orxBOOL {.
    inline, cdecl.} =
  ##  Done!
  return if (((u32CharacterCodePoint >= 'a') and (u32CharacterCodePoint <= 'z')) or
      ((u32CharacterCodePoint >= 'A') and (u32CharacterCodePoint <= 'Z')) or
      ((u32CharacterCodePoint >= '0') and (u32CharacterCodePoint <= '9'))): orxTRUE else: orxFALSE

## * Gets the UTF-8 encoding length of given character
##  @param[in] _u32CharacterCodePoint    Concerned character code
##  @return                              Encoding length in UTF-8 for given character if valid, orxU32_UNDEFINED otherwise
##

proc orxString_GetUTF8CharacterLength*(u32CharacterCodePoint: orxU32): orxU32 {.
    inline, cdecl.} =
  var u32Result: orxU32
  ##  1-byte long?
  if u32CharacterCodePoint < 0x00000080:
    ##  Updates result
    u32Result = 1
  elif u32CharacterCodePoint < 0x00000800:
    ##  Updates result
    u32Result = 2
  elif u32CharacterCodePoint < 0x00010000:
    ##  Updates result
    u32Result = 3
  elif u32CharacterCodePoint < 0x00110000:
    ##  Updates result
    u32Result = 4
  else:
    ##  Updates result
    u32Result = orxU32_UNDEFINED
  ##  Done!
  return u32Result

## * Prints a unicode character encoded with UTF-8 to an orxSTRING
##  @param[in] _zDstString               Destination string
##  @param[in] _u32Size                  Available size on the string
##  @param[in] _u32CharacterCodePoint    Unicode code point of the character to print
##  @return                              Length of the encoded UTF-8 character (1, 2, 3 or 4) if valid, orxU32_UNDEFINED otherwise
##

proc orxString_PrintUTF8Character*(zDstString: cstring; u32Size: orxU32;
                                  u32CharacterCodePoint: orxU32): orxU32 {.cdecl.} =
  var u32Result: orxU32
  ##  Gets character's encoded length
  u32Result = orxString_GetUTF8CharacterLength(u32CharacterCodePoint)
  ##  Enough room?
  if u32Result <= u32Size:
    ##  Depending on character's length
    case u32Result
    of 1:
      ##  Writes character
      zDstString[] = cast[orxCHAR](u32CharacterCodePoint)
      break
    of 2:
      ##  Writes first character
      inc(zDstString)[] = (orxCHAR)(0x000000C0 or
          ((u32CharacterCodePoint and 0x000007C0) shr 6))
      ##  Writes second character
      zDstString[] = (orxCHAR)(0x00000080 or
          (u32CharacterCodePoint and 0x0000003F))
      break
    of 3:
      ##  Writes first character
      inc(zDstString)[] = (orxCHAR)(0x000000E0 or
          ((u32CharacterCodePoint and 0x0000F000) shr 12))
      ##  Writes second character
      inc(zDstString)[] = (orxCHAR)(0x00000080 or
          ((u32CharacterCodePoint and 0x00000FC0) shr 6))
      ##  Writes third character
      zDstString[] = (orxCHAR)(0x00000080 or
          (u32CharacterCodePoint and 0x0000003F))
      break
    of 4:
      ##  Writes first character
      inc(zDstString)[] = (orxCHAR)(0x000000F0 or
          ((u32CharacterCodePoint and 0x001C0000) shr 18))
      ##  Writes second character
      inc(zDstString)[] = (orxCHAR)(0x00000080 or
          ((u32CharacterCodePoint and 0x0003F000) shr 12))
      ##  Writes third character
      inc(zDstString)[] = (orxCHAR)(0x00000080 or
          ((u32CharacterCodePoint and 0x00000FC0) shr 6))
      ##  Writes fourth character
      zDstString[] = (orxCHAR)(0x00000080 or
          (u32CharacterCodePoint and 0x0000003F))
      break
    else:
      ##  Logs message
      orxDEBUG_PRINT(orxDEBUG_LEVEL_SYSTEM, "Can\'t print invalid unicode character <0x%X> to string.",
                     u32CharacterCodePoint)
      ##  Updates result
      u32Result = orxU32_UNDEFINED
      break
  else:
    ##  Logs message
    orxDEBUG_PRINT(orxDEBUG_LEVEL_SYSTEM, "Can\'t print unicode character <0x%X> to string as there isn\'t enough space for it.",
                   u32CharacterCodePoint)
    ##  Updates result
    u32Result = orxU32_UNDEFINED
  ##  Done!
  return u32Result

## * Returns the code of the first character of the UTF-8 string
##  @param[in] _zString                  Concerned string
##  @param[out] _pzRemaining             If non null, will contain the remaining string after the first UTF-8 character
##  @return                              Code of the first UTF-8 character of the string, orxU32_UNDEFINED if it's an invalid character
##

proc orxString_GetFirstCharacterCodePoint*(zString: cstring;
    pzRemaining: cstringArray): orxU32 {.cdecl.} =
  var pu8Byte: ptr orxU8
  var u32Result: orxU32
  ##  Checks
  assert(zString != nil)
  ##  Gets the first byte
  pu8Byte = cast[ptr orxU8](zString)
  ##  ASCII?
  if pu8Byte[] < 0x00000080:
    ##  Updates result
    u32Result = pu8Byte[]
  elif pu8Byte[] < 0x000000C0:   ##  Overlong UTF-8 2-byte sequence
    ##  Logs message
    orxDEBUG_PRINT(orxDEBUG_LEVEL_SYSTEM, "Invalid or non-UTF-8 string at <0x%X>: multi-byte sequence non-leading byte \'%c\' (0x%2X) at index %d.",
                   zString, pu8Byte[], pu8Byte[],
                   pu8Byte - cast[ptr orxU8](zString))
    ##  Updates result
    u32Result = orxU32_UNDEFINED
  elif pu8Byte[] < 0x000000C2:   ##  2-byte sequence
    ##  Logs message
    orxDEBUG_PRINT(orxDEBUG_LEVEL_SYSTEM, "Invalid or non-UTF-8 string at <0x%X>: overlong 2-byte sequence starting with byte \'%c\' (0x%2X) at index %d.",
                   zString, pu8Byte[], pu8Byte[],
                   pu8Byte - cast[ptr orxU8](zString))
    ##  Updates result
    u32Result = orxU32_UNDEFINED
  elif pu8Byte[] < 0x000000E0:   ##  3-byte sequence
    ##  Updates result with first character
    u32Result = inc(pu8Byte)[] and 0x0000001F
    ##  Valid second character?
    if (pu8Byte[] and 0x000000C0) == 0x00000080:
      ##  Updates result
      u32Result = (u32Result shl 6) or (pu8Byte[] and 0x0000003F)
    else:
      ##  Logs message
      orxDEBUG_PRINT(orxDEBUG_LEVEL_SYSTEM, "Invalid or non-UTF-8 string at <0x%X>: 2-byte sequence non-trailing byte \'%c\' (0x%2X) at index %d.",
                     zString, pu8Byte[], pu8Byte[],
                     pu8Byte - cast[ptr orxU8](zString))
      ##  Updates result
      u32Result = orxU32_UNDEFINED
  elif pu8Byte[] < 0x000000F0:   ##  4-byte sequence
    ##  Updates result with first character
    u32Result = inc(pu8Byte)[] and 0x0000000F
    ##  Valid second character?
    if (pu8Byte[] and 0x000000C0) == 0x00000080:
      ##  Updates result
      u32Result = (u32Result shl 6) or (inc(pu8Byte)[] and 0x0000003F)
      ##  Valid third character?
      if (pu8Byte[] and 0x000000C0) == 0x00000080:
        ##  Updates result
        u32Result = (u32Result shl 6) or (pu8Byte[] and 0x0000003F)
      else:
        ##  Logs message
        orxDEBUG_PRINT(orxDEBUG_LEVEL_SYSTEM, "Invalid or non-UTF-8 string at <0x%X>: 3-byte sequence non-trailing byte \'%c\' (0x%2X) at index %d.",
                       zString, pu8Byte[], pu8Byte[],
                       pu8Byte - cast[ptr orxU8](zString))
        ##  Updates result
        u32Result = orxU32_UNDEFINED
    else:
      ##  Logs message
      orxDEBUG_PRINT(orxDEBUG_LEVEL_SYSTEM, "Invalid or non-UTF-8 string at <0x%X>: 3-byte sequence non-trailing byte \'%c\' (0x%2X) at index %d.",
                     zString, pu8Byte[], pu8Byte[],
                     pu8Byte - cast[ptr orxU8](zString))
      ##  Updates result
      u32Result = orxU32_UNDEFINED
  elif pu8Byte[] < 0x000000F5:
    ##  Updates result with first character
    u32Result = inc(pu8Byte)[] and 0x00000007
    ##  Valid second character?
    if (pu8Byte[] and 0x000000C0) == 0x00000080:
      ##  Updates result
      u32Result = (u32Result shl 6) or (inc(pu8Byte)[] and 0x0000003F)
      ##  Valid third character?
      if (pu8Byte[] and 0x000000C0) == 0x00000080:
        ##  Updates result
        u32Result = (u32Result shl 6) or (inc(pu8Byte)[] and 0x0000003F)
        ##  Valid fourth character?
        if (pu8Byte[] and 0x000000C0) == 0x00000080:
          ##  Updates result
          u32Result = (u32Result shl 6) or (pu8Byte[] and 0x0000003F)
        else:
          ##  Logs message
          orxDEBUG_PRINT(orxDEBUG_LEVEL_SYSTEM, "Invalid or non-UTF-8 string at <0x%X>: 4-byte sequence non-trailing byte \'%c\' (0x%2X) at index %d.",
                         zString, pu8Byte[], pu8Byte[],
                         pu8Byte - cast[ptr orxU8](zString))
          ##  Updates result
          u32Result = orxU32_UNDEFINED
      else:
        ##  Logs message
        orxDEBUG_PRINT(orxDEBUG_LEVEL_SYSTEM, "Invalid or non-UTF-8 string at <0x%X>: 4-byte sequence non-trailing byte \'%c\' (0x%2X) at index %d.",
                       zString, pu8Byte[], pu8Byte[],
                       pu8Byte - cast[ptr orxU8](zString))
        ##  Updates result
        u32Result = orxU32_UNDEFINED
    else:
      ##  Logs message
      orxDEBUG_PRINT(orxDEBUG_LEVEL_SYSTEM, "Invalid or non-UTF-8 string at <0x%X>: 4-byte sequence non-trailing byte \'%c\' (0x%2X) at index %d.",
                     zString, pu8Byte[], pu8Byte[],
                     pu8Byte - cast[ptr orxU8](zString))
      ##  Updates result
      u32Result = orxU32_UNDEFINED
  else:
    ##  Logs message
    orxDEBUG_PRINT(orxDEBUG_LEVEL_SYSTEM, "Invalid or non-UTF-8 string at <0x%X>: invalid out-of-bound byte \'%c\' (0x%2X) at index %d.",
                   zString, pu8Byte[], pu8Byte[],
                   pu8Byte - cast[ptr orxU8](zString))
    ##  Updates result
    u32Result = orxU32_UNDEFINED
  ##  Asks for remaining string?
  if pzRemaining != nil:
    ##  Stores it
    pzRemaining[] = cast[cstring]((pu8Byte + 1))
  return u32Result

## * Returns the number of valid unicode characters (UTF-8) in the string (for ASCII string, it will be the same result as orxString_GetLength())
##  @param[in] _zString                  Concerned string
##  @return                              Number of valid unicode characters contained in the string, orxU32_UNDEFINED for an invalid UTF-8 string
##

proc orxString_GetCharacterCount*(zString: cstring): orxU32 {.inline, cdecl.} =
  var pc: cstring
  var u32Result: orxU32
  ##  Checks
  assert(zString != nil)
  ##  For all characters
  pc = zString
  u32Result = 0
  while pc[] != orxCHAR_NULL:
    ##  Invalid current character ID
    if orxString_GetFirstCharacterCodePoint(pc, addr(pc)) == orxU32_UNDEFINED:
      ##  Updates result
      u32Result = orxU32_UNDEFINED
      ##  Logs message
      orxDEBUG_PRINT(orxDEBUG_LEVEL_SYSTEM, "Invalid or non-UTF8 string <%s>, can\'t count characters.",
                     zString)
      break
    inc(u32Result)
  ##  Done!
  return u32Result

## * Copies up to N characters from a string
##  @param[in] _zDstString       Destination string
##  @param[in] _zSrcString       Source string
##  @param[in] _u32CharNumber    Number of characters to copy
##  @return Copied string
##

proc orxString_NCopy*(zDstString: cstring; zSrcString: cstring;
                     u32CharNumber: orxU32): cstring {.inline, cdecl.} =
  ##  Checks
  assert(zDstString != nil)
  assert(zSrcString != nil)
  ##  Done!
  return strncpy(zDstString, zSrcString, cast[csize](u32CharNumber))

## * Duplicate a string.
##  @param[in] _zSrcString  String to duplicate.
##  @return Duplicated string.
##

proc orxString_Duplicate*(zSrcString: cstring): cstring {.inline, cdecl.} =
  var u32Size: orxU32
  var zResult: cstring
  ##  Checks
  assert(zSrcString != nil)
  ##  Gets string size in bytes
  u32Size = (orxString_GetLength(zSrcString) + 1) * sizeof((orxCHAR))
  ##  Allocates it
  zResult = cast[cstring](orxMemory_Allocate(u32Size, orxMEMORY_TYPE_TEXT))
  ##  Valid?
  if zResult != nil:
    ##  Copies source to it
    orxMemory_Copy(zResult, zSrcString, u32Size)
  return zResult

## * Deletes a string
##  @param[in] _zString                  String to delete
##

proc orxString_Delete*(zString: cstring): orxSTATUS {.inline, cdecl.} =
  ##  Checks
  assert(zString != nil)
  assert(zString != orxSTRING_EMPTY)
  ##  Frees its memory
  orxMemory_Free(zString)
  ##  Done!
  return orxSTATUS_SUCCESS

## * Compare two strings, case sensitive. If the first one is smaller than the second it returns -1,
##  1 if the second one is bigger than the first, and 0 if they are equals
##  @param[in] _zString1    First String to compare
##  @param[in] _zString2    Second string to compare
##  @return -1, 0 or 1 as indicated in the description.
##

proc orxString_Compare*(zString1: cstring; zString2: cstring): orxS32 {.inline,
    cdecl.} =
  ##  Checks
  assert(zString1 != nil)
  assert(zString2 != nil)
  ##  Done!
  return strcmp(zString1, zString2)

## * Compare N first character from two strings, case sensitive. If the first one is smaller
##  than the second it returns -1, 1 if the second one is bigger than the first
##  and 0 if they are equals.
##  @param[in] _zString1       First String to compare
##  @param[in] _zString2       Second string to compare
##  @param[in] _u32CharNumber  Number of character to compare
##  @return -1, 0 or 1 as indicated in the description.
##

proc orxString_NCompare*(zString1: cstring; zString2: cstring;
                        u32CharNumber: orxU32): orxS32 {.inline, cdecl.} =
  ##  Checks
  assert(zString1 != nil)
  assert(zString2 != nil)
  ##  Done!
  return strncmp(zString1, zString2, cast[csize](u32CharNumber))

## * Compare two strings, case insensitive. If the first one is smaller than the second, it returns -1,
##  If the second one is bigger than the first, and 0 if they are equals
##  @param[in] _zString1    First String to compare
##  @param[in] _zString2    Second string to compare
##  @return -1, 0 or 1 as indicated in the description.
##

proc orxString_ICompare*(zString1: cstring; zString2: cstring): orxS32 {.inline,
    cdecl.} =
  ##  Checks
  assert(zString1 != nil)
  assert(zString2 != nil)
  when defined(WINDOWS):
    ##  Done!
    return stricmp(zString1, zString2)
  else:
    ##  Done!
    return strcasecmp(zString1, zString2)

## * Compare N first character from two strings, case insensitive. If the first one is smaller
##  than the second, it returns -1, If the second one is bigger than the first,
##  and 0 if they are equals.
##  @param[in] _zString1       First String to compare
##  @param[in] _zString2       Second string to compare
##  @param[in] _u32CharNumber  Number of character to compare
##  @return -1, 0 or 1 as indicated in the description.
##

proc orxString_NICompare*(zString1: cstring; zString2: cstring;
                         u32CharNumber: orxU32): orxS32 {.inline, cdecl.} =
  ##  Checks
  assert(zString1 != nil)
  assert(zString2 != nil)
  when defined(WINDOWS):
    ##  Done!
    return strnicmp(zString1, zString2, cast[csize](u32CharNumber))
  else:
    ##  Done!
    return strncasecmp(zString1, zString2, u32CharNumber)

## * Extracts the base (2, 8, 10 or 16) from a literal number
##  @param[in]   _zString        String from which to extract the base
##  @param[out]  _pzRemaining    If non null, will contain the remaining literal number, right after the base prefix (0x, 0b or 0)
##  @return  Base or the numerical value, defaults to 10 (decimal) when no prefix is found or the literal value couldn't be identified
##

proc orxString_ExtractBase*(zString: cstring; pzRemaining: cstringArray): orxU32 {.
    inline, cdecl.} =
  var zString: cstring
  var
    u32Result: orxU32
    u32Offset: orxU32
  ##  Checks
  assert(zString != nil)
  ##  Skips white spaces
  zString = orxString_SkipWhiteSpaces(zString)
  ##  Default result and offset: decimal
  u32Result = 10
  u32Offset = 0
  ##  Depending on first character
  case zString[0]
  of '0':
    ##  Depending on second character
    case zString[1] or 0x00000020
    of 'x':
      ##  Updates result and offset: hexadecimal
      u32Result = 16
      u32Offset = 2
      break
    of 'b':
      ##  Updates result and offset: binary
      u32Result = 2
      u32Offset = 2
      break
    else:
      ##  Octal?
      if (zString[1] >= '0') and (zString[1] <= '9'):
        ##  Updates result and offset: octal
        u32Result = 8
        u32Offset = 1
      break
    break
  of '#':
    ##  Updates result and offset: hexadecimal
    u32Result = 16
    u32Offset = 1
    break
  else:
    break
  ##  Asks for remaining string?
  if pzRemaining != nil:
    ##  Stores it
    pzRemaining[] = zString + u32Offset
  return u32Result

## * Converts a String to a signed int value using the given base
##  @param[in]   _zString        String To convert
##  @param[in]   _u32Base        Base of the read value (generally 10, but can be 16 to read hexa)
##  @param[out]  _ps32OutValue   Converted value
##  @param[out]  _pzRemaining    If non null, will contain the remaining string after the number conversion
##  @return  orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxString_ToS32Base*(zString: cstring; u32Base: orxU32;
                         ps32OutValue: ptr orxS32; pzRemaining: cstringArray): orxSTATUS {.
    inline, cdecl.} =
  var pcEnd: cstring
  var eResult: orxSTATUS
  ##  Checks
  assert(ps32OutValue != nil)
  assert(zString != nil)
  ##  Convert
  ps32OutValue[] = cast[orxS32](strtol(zString, addr(pcEnd), cast[cint](u32Base)))
  ##  Valid conversion ?
  if (pcEnd != zString) and (zString[0] != orxCHAR_NULL):
    ##  Updates result
    eResult = orxSTATUS_SUCCESS
  else:
    ##  Updates result
    eResult = orxSTATUS_FAILURE
  ##  Asks for remaining string?
  if pzRemaining != nil:
    ##  Stores it
    pzRemaining[] = pcEnd
  return eResult

## * Converts a String to a signed int value, guessing the base
##  @param[in]   _zString        String To convert
##  @param[out]  _ps32OutValue   Converted value
##  @param[out]  _pzRemaining    If non null, will contain the remaining string after the number conversion
##  @return  orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxString_ToS32*(zString: cstring; ps32OutValue: ptr orxS32;
                     pzRemaining: cstringArray): orxSTATUS {.inline, cdecl.} =
  var zValue: cstring
  var u32Base: orxU32
  var eResult: orxSTATUS
  ##  Checks
  assert(ps32OutValue != nil)
  assert(zString != nil)
  ##  Extracts base
  u32Base = orxString_ExtractBase(zString, addr(zValue))
  ##  Gets value
  eResult = orxString_ToS32Base(zValue, u32Base, ps32OutValue, pzRemaining)
  ##  Done!
  return eResult

## * Converts a String to an unsigned int value using the given base
##  @param[in]   _zString        String To convert
##  @param[in]   _u32Base        Base of the read value (generally 10, but can be 16 to read hexa)
##  @param[out]  _pu32OutValue   Converted value
##  @param[out]  _pzRemaining    If non null, will contain the remaining string after the number conversion
##  @return  orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxString_ToU32Base*(zString: cstring; u32Base: orxU32;
                         pu32OutValue: ptr orxU32; pzRemaining: cstringArray): orxSTATUS {.
    inline, cdecl.} =
  var pcEnd: cstring
  var eResult: orxSTATUS
  ##  Checks
  assert(pu32OutValue != nil)
  assert(zString != nil)
  ##  Convert
  pu32OutValue[] = cast[orxU32](strtoul(zString, addr(pcEnd), cast[cint](u32Base)))
  ##  Valid conversion ?
  if (pcEnd != zString) and (zString[0] != orxCHAR_NULL):
    ##  Updates result
    eResult = orxSTATUS_SUCCESS
  else:
    ##  Updates result
    eResult = orxSTATUS_FAILURE
  ##  Asks for remaining string?
  if pzRemaining != nil:
    ##  Stores it
    pzRemaining[] = pcEnd
  return eResult

## * Converts a String to an unsigned int value, guessing the base
##  @param[in]   _zString        String To convert
##  @param[out]  _pu32OutValue   Converted value
##  @param[out]  _pzRemaining    If non null, will contain the remaining string after the number conversion
##  @return  orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxString_ToU32*(zString: cstring; pu32OutValue: ptr orxU32;
                     pzRemaining: cstringArray): orxSTATUS {.inline, cdecl.} =
  var zValue: cstring
  var u32Base: orxU32
  var eResult: orxSTATUS
  ##  Checks
  assert(pu32OutValue != nil)
  assert(zString != nil)
  ##  Extracts base
  u32Base = orxString_ExtractBase(zString, addr(zValue))
  ##  Gets value
  eResult = orxString_ToU32Base(zValue, u32Base, pu32OutValue, pzRemaining)
  ##  Done!
  return eResult

## * Converts a String to a signed int value using the given base
##  @param[in]   _zString        String To convert
##  @param[in]   _u32Base        Base of the read value (generally 10, but can be 16 to read hexa)
##  @param[out]  _ps64OutValue   Converted value
##  @param[out]  _pzRemaining    If non null, will contain the remaining string after the number conversion
##  @return  orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxString_ToS64Base*(zString: cstring; u32Base: orxU32;
                         ps64OutValue: ptr orxS64; pzRemaining: cstringArray): orxSTATUS {.
    inline, cdecl.} =
  var pcEnd: cstring
  var eResult: orxSTATUS
  ##  Checks
  assert(ps64OutValue != nil)
  assert(zString != nil)
  ##  Convert
  ps64OutValue[] = cast[orxS64](strtoll(zString, addr(pcEnd), cast[cint](u32Base)))
  ##  Valid conversion ?
  if (pcEnd != zString) and (zString[0] != orxCHAR_NULL):
    ##  Updates result
    eResult = orxSTATUS_SUCCESS
  else:
    ##  Updates result
    eResult = orxSTATUS_FAILURE
  ##  Asks for remaining string?
  if pzRemaining != nil:
    ##  Stores it
    pzRemaining[] = pcEnd
  return eResult

## * Converts a String to a signed int value, guessing the base
##  @param[in]   _zString        String To convert
##  @param[out]  _ps64OutValue   Converted value
##  @param[out]  _pzRemaining    If non null, will contain the remaining string after the number conversion
##  @return  orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxString_ToS64*(zString: cstring; ps64OutValue: ptr orxS64;
                     pzRemaining: cstringArray): orxSTATUS {.inline, cdecl.} =
  var zValue: cstring
  var u32Base: orxU32
  var eResult: orxSTATUS
  ##  Checks
  assert(ps64OutValue != nil)
  assert(zString != nil)
  ##  Extracts base
  u32Base = orxString_ExtractBase(zString, addr(zValue))
  ##  Gets signed value
  eResult = orxString_ToS64Base(zValue, u32Base, ps64OutValue, pzRemaining)
  ##  Done!
  return eResult

## * Converts a String to an unsigned int value using the given base
##  @param[in]   _zString        String To convert
##  @param[in]   _u32Base        Base of the read value (generally 10, but can be 16 to read hexa)
##  @param[out]  _pu64OutValue   Converted value
##  @param[out]  _pzRemaining    If non null, will contain the remaining string after the number conversion
##  @return  orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxString_ToU64Base*(zString: cstring; u32Base: orxU32;
                         pu64OutValue: ptr orxU64; pzRemaining: cstringArray): orxSTATUS {.
    inline, cdecl.} =
  var pcEnd: cstring
  var eResult: orxSTATUS
  ##  Checks
  assert(pu64OutValue != nil)
  assert(zString != nil)
  ##  Convert
  pu64OutValue[] = cast[orxU64](strtoull(zString, addr(pcEnd), cast[cint](u32Base)))
  ##  Valid conversion ?
  if (pcEnd != zString) and (zString[0] != orxCHAR_NULL):
    ##  Updates result
    eResult = orxSTATUS_SUCCESS
  else:
    ##  Updates result
    eResult = orxSTATUS_FAILURE
  ##  Asks for remaining string?
  if pzRemaining != nil:
    ##  Stores it
    pzRemaining[] = pcEnd
  return eResult

## * Converts a String to an unsigned int value, guessing the base
##  @param[in]   _zString        String To convert
##  @param[out]  _pu64OutValue   Converted value
##  @param[out]  _pzRemaining    If non null, will contain the remaining string after the number conversion
##  @return  orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxString_ToU64*(zString: cstring; pu64OutValue: ptr orxU64;
                     pzRemaining: cstringArray): orxSTATUS {.inline, cdecl.} =
  var zValue: cstring
  var u32Base: orxU32
  var eResult: orxSTATUS
  ##  Checks
  assert(pu64OutValue != nil)
  assert(zString != nil)
  ##  Extracts base
  u32Base = orxString_ExtractBase(zString, addr(zValue))
  ##  Gets signed value
  eResult = orxString_ToU64Base(zValue, u32Base, pu64OutValue, pzRemaining)
  ##  Done!
  return eResult

## * Convert a string to a value
##  @param[in]   _zString        String To convert
##  @param[out]  _pfOutValue     Converted value
##  @param[out]  _pzRemaining    If non null, will contain the remaining string after the number conversion
##  @return  orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxString_ToFloat*(zString: cstring; pfOutValue: ptr orxFLOAT;
                       pzRemaining: cstringArray): orxSTATUS {.inline, cdecl.} =
  var pcEnd: cstring
  var eResult: orxSTATUS
  ##  Checks
  assert(pfOutValue != nil)
  assert(zString != nil)
  ##  Linux / Mac / iOS / Android / MSVC?
  when defined(LINUX) or defined(MAC) or defined(IOS) or defined(MSVC) or
      defined(ANDROID):
    ##  Converts it
    pfOutValue[] = cast[orxFLOAT](strtod(zString, addr(pcEnd)))
  else:
    ##  Converts it
    pfOutValue[] = strtof(zString, addr(pcEnd))
  ##  Valid conversion ?
  if (pcEnd != zString) and (zString[0] != orxCHAR_NULL):
    ##  Updates result
    eResult = orxSTATUS_SUCCESS
  else:
    ##  Updates result
    eResult = orxSTATUS_FAILURE
  ##  Asks for remaining string?
  if pzRemaining != nil:
    ##  Stores it
    pzRemaining[] = pcEnd
  return eResult

## * Convert a string to a vector
##  @param[in]   _zString        String To convert
##  @param[out]  _pvOutValue     Converted value. N.B.: if only two components (x, y) are defined, the z component will be set to zero
##  @param[out]  _pzRemaining    If non null, will contain the remaining string after the number conversion
##  @return  orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxString_ToVector*(zString: cstring; pvOutValue: ptr orxVECTOR;
                        pzRemaining: cstringArray): orxSTATUS {.inline, cdecl.} =
  var stValue: orxVECTOR
  var zString: cstring
  var eResult: orxSTATUS
  ##  Checks
  assert(pvOutValue != nil)
  assert(zString != nil)
  ##  Skips all white spaces
  zString = orxString_SkipWhiteSpaces(zString)
  ##  Is a vector start character?
  if (zString[] == orxSTRING_KC_VECTOR_START) or
      (zString[] == orxSTRING_KC_VECTOR_START_ALT):
    var cEndMarker: orxCHAR
    ##  Gets end marker
    cEndMarker = if (zString[] == orxSTRING_KC_VECTOR_START): orxSTRING_KC_VECTOR_END else: orxSTRING_KC_VECTOR_END_ALT
    ##  Skips all white spaces
    zString = orxString_SkipWhiteSpaces(zString + 1)
    ##  Gets X value
    if orxString_ToFloat(zString, addr((stValue.fX)), addr(zString)) !=
        orxSTATUS_FAILURE:
      ##  Skips all white spaces
      zString = orxString_SkipWhiteSpaces(zString)
      ##  Is a vector separator character?
      if zString[] == orxSTRING_KC_VECTOR_SEPARATOR:
        ##  Skips all white spaces
        zString = orxString_SkipWhiteSpaces(zString + 1)
        ##  Gets Y value
        if orxString_ToFloat(zString, addr((stValue.fY)), addr(zString)) !=
            orxSTATUS_FAILURE:
          ##  Skips all white spaces
          zString = orxString_SkipWhiteSpaces(zString)
          ##  Is a vector separator character?
          if zString[] == orxSTRING_KC_VECTOR_SEPARATOR:
            ##  Skips all white spaces
            zString = orxString_SkipWhiteSpaces(zString + 1)
            ##  Gets Z value
            if orxString_ToFloat(zString, addr((stValue.fZ)), addr(zString)) !=
                orxSTATUS_FAILURE:
              ##  Skips all white spaces
              zString = orxString_SkipWhiteSpaces(zString)
              ##  Has a valid end marker?
              if zString[] == cEndMarker:
                ##  Updates result
                eResult = orxSTATUS_SUCCESS
          elif zString[] == cEndMarker:
            ##  Clears Z component
            stValue.fZ = orxFLOAT_0
            ##  Updates result
            eResult = orxSTATUS_SUCCESS
  if eResult != orxSTATUS_FAILURE:
    ##  Updates vector
    orxVector_Copy(pvOutValue, addr(stValue))
    ##  Asks for remaining string?
    if pzRemaining != nil:
      ##  Stores it
      pzRemaining[] = zString + 1
  return eResult

## * Convert a string to a boolean
##  @param[in]   _zString        String To convert
##  @param[out]  _pbOutValue     Converted value
##  @param[out]  _pzRemaining    If non null, will contain the remaining string after the boolean conversion
##  @return  orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxString_ToBool*(zString: cstring; pbOutValue: ptr orxBOOL;
                      pzRemaining: cstringArray): orxSTATUS {.inline, cdecl.} =
  var s32Value: orxS32
  var eResult: orxSTATUS
  ##  Checks
  assert(pbOutValue != nil)
  assert(zString != nil)
  ##  Tries numeric value
  eResult = orxString_ToS32Base(zString, 10, addr(s32Value), pzRemaining)
  ##  Valid?
  if eResult != orxSTATUS_FAILURE:
    ##  Updates boolean
    pbOutValue[] = if (s32Value != 0): orxTRUE else: orxFALSE
  else:
    var u32Length: orxU32
    ##  Gets length of false
    u32Length = orxString_GetLength(orxSTRING_FALSE)
    ##  Is false?
    if orxString_NICompare(zString, orxSTRING_FALSE, u32Length) == 0:
      ##  Updates boolean
      pbOutValue[] = orxFALSE
      ##  Has remaining?
      if pzRemaining != nil:
        ##  Updates it
        inc(pzRemaining[], u32Length)
      eResult = orxSTATUS_SUCCESS
    else:
      ##  Gets length of true
      u32Length = orxString_GetLength(orxSTRING_TRUE)
      ##  Is true?
      if orxString_NICompare(zString, orxSTRING_TRUE, u32Length) == 0:
        ##  Updates boolean
        pbOutValue[] = orxTRUE
        ##  Has remaining?
        if pzRemaining != nil:
          ##  Updates it
          inc(pzRemaining[], u32Length)
        eResult = orxSTATUS_SUCCESS
  ##  Done!
  return eResult

## * Lowercase a string
##  @param[in] _zString          String To convert
##  @return The converted string.
##

proc orxString_LowerCase*(zString: cstring): cstring {.inline, cdecl.} =
  var pc: cstring
  ##  Checks
  assert(zString != nil)
  ##  Converts the whole string
  pc = zString
  while pc[] != orxCHAR_NULL:
    ##  Needs to be converted?
    if pc[] >= 'A' and pc[] <= 'Z':
      ##  Lower case
      pc[] = pc[] or 0x00000020
    inc(pc)
  return zString

## * Uppercase a string
##  @param[in] _zString          String To convert
##  @return The converted string.
##

proc orxString_UpperCase*(zString: cstring): cstring {.inline, cdecl.} =
  var pc: cstring
  ##  Checks
  assert(zString != nil)
  ##  Converts the whole string
  pc = zString
  while pc[] != orxCHAR_NULL:
    ##  Needs to be converted?
    if pc[] >= 'a' and pc[] <= 'z':
      ##  Upper case
      pc[] = pc[] and not 0x00000020
    inc(pc)
  return zString

## * Returns the first occurrence of _zString2 in _zString1
##  @param[in] _zString1 String to analyze
##  @param[in] _zString2 String that must be inside _zString1
##  @return The pointer of the first occurrence of _zString2, or nil if not found
##

proc orxString_SearchString*(zString1: cstring; zString2: cstring): cstring {.
    inline, cdecl.} =
  ##  Checks
  assert(zString1 != nil)
  assert(zString2 != nil)
  ##  Returns result
  return strstr(zString1, zString2)

## * Returns the first occurrence of _cChar in _zString
##  @param[in] _zString String to analyze
##  @param[in] _cChar   The character to find
##  @return The pointer of the first occurrence of _cChar, or nil if not found
##

proc orxString_SearchChar*(zString: cstring; cChar: orxCHAR): cstring {.inline,
    cdecl.} =
  ##  Checks
  assert(zString != nil)
  ##  Returns result
  return strchr(zString, cChar)

## * Returns the first occurrence of _cChar in _zString
##  @param[in] _zString      String to analyze
##  @param[in] _cChar        The character to find
##  @param[in] _s32Position  Search begin position
##  @return The index of the next occurrence of requested character, starting at given position / -1 if not found
##

proc orxString_SearchCharIndex*(zString: cstring; cChar: orxCHAR;
                               s32Position: orxS32): orxS32 {.inline, cdecl.} =
  var
    s32Index: orxS32
    s32Result: orxS32
  var pc: cstring
  ##  Checks
  assert(zString != nil)
  assert(s32Position <= cast[orxS32](orxString_GetLength(zString)))
  ##  For all characters
  s32Index = s32Position
  pc = zString + s32Index
  while pc[] != orxCHAR_NULL:
    ##  Found?
    if pc[] == cChar:
      ##  Updates result
      s32Result = s32Index
      break
    inc(pc)
    inc(s32Index)
  ##  Done!
  return s32Result

## * Prints a formated string to a memory buffer
##  @param[out] _zDstString  Destination string
##  @param[in]  _zSrcString  Source formated string
##  @return The number of written characters
##

proc orxString_Print*(zDstString: cstring; zSrcString: cstring): orxS32 {.
    inline, varargs, cdecl.} =
  var stArgs: va_list
  var s32Result: orxS32
  ##  Checks
  assert(zDstString != nil)
  assert(zSrcString != nil)
  ##  Gets variable arguments & prints the string
  va_start(stArgs, zSrcString)
  s32Result = vsprintf(zDstString, zSrcString, stArgs)
  va_end(stArgs)
  ##  Clamps result
  s32Result = orxMAX(s32Result, 0)
  ##  Done!
  return s32Result

## * Prints a formated string to a memory buffer using a max size
##  @param[out] _zDstString    Destination string
##  @param[in]  _zSrcString    Source formated string
##  @param[in]  _u32CharNumber Max number of character to print
##  @return The number of written characters
##

proc orxString_NPrint*(zDstString: cstring; u32CharNumber: orxU32;
                      zSrcString: cstring): orxS32 {.inline, varargs, cdecl.} =
  var stArgs: va_list
  var s32Result: orxS32
  ##  Checks
  assert(zDstString != nil)
  assert(zSrcString != nil)
  ##  Gets variable arguments & prints the string
  va_start(stArgs, zSrcString)
  s32Result = vsnprintf(zDstString, cast[csize](u32CharNumber), zSrcString, stArgs)
  va_end(stArgs)
  when defined(MSVC):
    ##  Overflow?
    if s32Result <= 0:
      ##  Updates result
      s32Result = u32CharNumber
  ##  Clamps result
  s32Result = orxCLAMP(s32Result, 0, cast[orxS32](u32CharNumber))
  ##  Done!
  return s32Result

## * Gets the extension from a file name
##  @param[in]  _zFileName     Concerned file name
##  @return Extension if exists, orxSTRING_EMPTY otherwise
##

proc orxString_GetExtension*(zFileName: cstring): cstring {.inline, cdecl.} =
  var
    s32Index: orxS32
    s32NextIndex: orxS32
  var zResult: cstring
  ##  Checks
  assert(zFileName != nil)
  ##  Finds last '.'
  s32Index = orxString_SearchCharIndex(zFileName, '.', 0)
  while (s32Index >= 0) and
      ((s32NextIndex = orxString_SearchCharIndex(zFileName, '.', s32Index + 1)) > 0):
    ##  Updates result
    s32Index = s32NextIndex
  zResult = if (s32Index >= 0): zFileName + s32Index + 1 else: orxSTRING_EMPTY
  ##  Done!
  return zResult

##  *** String module functions ***
## * Structure module setup
##

proc orxString_Setup*() {.cdecl, importc: "orxString_Setup", dynlib: libORX.}
## * Initializess the structure module
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxString_Init*(): orxSTATUS {.cdecl, importc: "orxString_Init",
                                 dynlib: libORX.}
## * Exits from the structure module
##

proc orxString_Exit*() {.cdecl, importc: "orxString_Exit", dynlib: libORX.}
## * Gets a string's ID (and stores the string internally to prevent duplication)
##  @param[in]   _zString        Concerned string
##  @return      String's ID
##

proc orxString_GetID*(zString: cstring): orxSTRINGID {.cdecl,
    importc: "orxString_GetID", dynlib: libORX.}
## * Gets a string from an ID (it should have already been stored internally with a call to orxString_GetID)
##  @param[in]   _u32ID          Concerned string ID
##  @return      orxSTRING if ID's found, orxSTRING_EMPTY otherwise
##

proc orxString_GetFromID*(u32ID: orxSTRINGID): cstring {.cdecl,
    importc: "orxString_GetFromID", dynlib: libORX.}
## * Stores a string internally: equivalent to an optimized call to orxString_GetFromID(orxString_GetID(_zString))
##  @param[in]   _zString        Concerned string
##  @return      Stored orxSTRING
##

proc orxString_Store*(zString: cstring): cstring {.cdecl,
    importc: "orxString_Store", dynlib: libORX.}
## * @}
]#