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

import lib, typ

## * Memory barrier macros

when defined(GCC) or defined(LLVM):
  template orxMEMORY_BARRIER*(): untyped =
    sync_synchronize()

  const
    orxHAS_MEMORY_BARRIER* = true
elif defined(MSVC):
  when defined(orx64):
    template orxMEMORY_BARRIER*(): untyped =
      faststorefence()

  else:
    template orxMEMORY_BARRIER*(): void =
      var lBarrier: clong
      InterlockedOr(addr(lBarrier), 0)

  const
    orxHAS_MEMORY_BARRIER* = true
else:
  template orxMEMORY_BARRIER*(): void =
    nil

## * Memory tracking macros

## * Memory type
##

type
  orxMEMORY_TYPE* {.size: sizeof(cint).} = enum
    orxMEMORY_TYPE_MAIN = 0,    ## *< Main memory type
    orxMEMORY_TYPE_AUDIO,     ## *< Audio memory type
    orxMEMORY_TYPE_CONFIG,    ## *< Config memory
    orxMEMORY_TYPE_DEBUG,     ## *< Debug memory
    orxMEMORY_TYPE_PHYSICS,   ## *< Physics memory type
    orxMEMORY_TYPE_SYSTEM,    ## *< System memory type
    orxMEMORY_TYPE_TEMP,      ## *< Temporary / scratch memory
    orxMEMORY_TYPE_TEXT,      ## *< Text memory
    orxMEMORY_TYPE_VIDEO,     ## *< Video memory type
    orxMEMORY_TYPE_NUMBER,    ## *< Number of memory type
    orxMEMORY_TYPE_NONE = orxENUM_NONE


## * Setups the memory module
##

proc orxMemory_Setup*() {.cdecl, importc: "orxMemory_Setup", dynlib: libORX.}
## * Inits the memory module
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxMemory_Init*(): orxSTATUS {.cdecl, importc: "orxMemory_Init",
                                 dynlib: libORX.}
## * Exits from the memory module
##

proc orxMemory_Exit*() {.cdecl, importc: "orxMemory_Exit", dynlib: libORX.}
## * Allocates some memory in the system and returns a pointer to it
##  @param[in]  _u32Size  Size of the memory to allocate
##  @param[in]  _eMemType Memory zone where data will be allocated
##  @return  returns a pointer to the memory allocated, or nil if an error has occurred
##

proc orxMemory_Allocate*(u32Size: orxU32; eMemType: orxMEMORY_TYPE): pointer {.cdecl,
    importc: "orxMemory_Allocate", dynlib: libORX.}
## * Reallocates a previously allocated memory block, with the given new size and returns a pointer to it
##  If possible, it'll keep the current pointer and extend the memory block, if not it'll allocate a new block,
##  copy the data over and deallocates the original block
##  @param[in]  _pMem      Memory block to reallocate
##  @param[in]  _u32Size   Size of the memory to allocate
##  @return  returns a pointer to the reallocated memory block or nil if an error has occurred
##

proc orxMemory_Reallocate*(pMem: pointer; u32Size: orxU32): pointer {.cdecl,
    importc: "orxMemory_Reallocate", dynlib: libORX.}
## * Frees some memory allocated with orxMemory_Allocate
##  @param[in]  _pMem     Pointer to the memory allocated by orx
##

proc orxMemory_Free*(pMem: pointer) {.cdecl, importc: "orxMemory_Free",
                                   dynlib: libORX.}
## * Copies a part of memory into another one
##  @param[out] _pDest    Destination pointer
##  @param[in]  _pSrc     Pointer of memory from where data are read
##  @param[in]  _u32Size  Size of data
##  @return returns a pointer to _pDest
##  @note if _pSrc and _pDest overlap, use orxMemory_Move instead
##

proc orxMemory_Copy*(pDest: pointer; pSrc: pointer; u32Size: orxU32): pointer {.inline, discardable,
    cdecl.} =
  ##  Checks
  assert(pDest != nil)
  assert(pSrc != nil)
  ##  Done!
  {.emit"return((void *)memcpy(pDest, pSrc, (size_t)u32Size));".}

## * Moves a part of memory into another one
##  @param[out] _pDest   Destination pointer
##  @param[in]  _pSrc    Pointer of memory from where data are read
##  @param[in]  _u32Size Size of data
##  @return returns a pointer to _pDest
##

proc orxMemory_Move*(pDest: pointer; pSrc: pointer; u32Size: orxU32): pointer {.inline,
    cdecl.} =
  ##  Checks
  assert(pDest != nil)
  assert(pSrc != nil)
  ##  Done!
  {.emit"return((void *)memmove(pDest, pSrc, (size_t)u32Size));".}

## * Compares two parts of memory
##  @param[in]  _pMem1   First part to test
##  @param[in]  _pMem2   Second part to test
##  @param[in]  _u32Size Size of data to test
##  @return returns a value less than, equal to or greater than 0 if the content of _pMem1 is respectively smaller, equal or greater than _pMem2's
##

proc orxMemory_Compare*(pMem1: pointer; pMem2: pointer; u32Size: orxU32): orxU32 {.
    inline, cdecl.} =
  ##  Checks
  assert(pMem1 != nil)
  assert(pMem2 != nil)
  ##  Done!
  {.emit"return((orxU32)memcmp(pMem1, pMem2, (size_t)u32Size));".}

## * Fills a part of memory with _u32Data
##  @param[out] _pDest   Destination pointer
##  @param[in]  _u8Data  Values of the data that will fill the memory
##  @param[in]  _u32Size Size of data
##  @return returns a pointer to _pDest
##

proc orxMemory_Set*(pDest: pointer; u8Data: orxU8; u32Size: orxU32): pointer {.inline,
    cdecl.} =
  ##  Checks
  assert(pDest != nil)
  ##  Done!
  {.emit"return((void *)memset(pDest, u8Data, (size_t)u32Size));".}

## * Fills a part of memory with zeroes
##  @param[out] _pDest   Destination pointer
##  @param[in]  _u32Size Size of data
##  @return returns a pointer to _pDest
##

proc orxMemory_Zero*(pDest: pointer; u32Size: orxU32): pointer {.inline, cdecl.} =
  ##  Checks
  assert(pDest != nil)
  ##  Done!
  {.emit"return((void *)memset(pDest, 0, (size_t)u32Size));".}

## * Gets memory type literal name
##  @param[in] _eMemType               Concerned memory type
##  @return Memory type name / orxSTRING_EMPTY
##

proc orxMemory_GetTypeName*(eMemType: orxMEMORY_TYPE): cstring {.cdecl,
    importc: "orxMemory_GetTypeName", dynlib: libORX.}
## * Gets L1 data cache line size
##  @return Cache line size
##

proc orxMemory_GetCacheLineSize*(): orxU32 {.cdecl,
    importc: "orxMemory_GetCacheLineSize", dynlib: libORX.}
when defined(PROFILER):
  ## * Gets memory usage for a given type
  ##  @param[in] _eMemType               Concerned memory type
  ##  @param[out] _pu32Count             Current memory allocation count
  ##  @param[out] _pu32PeakCount         Peak memory allocation count
  ##  @param[out] _pu32Size              Current memory allocation size
  ##  @param[out] _pu32PeakSize          Peak memory allocation size
  ##  @param[out] _pu32OperationCount    Total number of memory operations (malloc/free)
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
  ##
  proc orxMemory_GetUsage*(eMemType: orxMEMORY_TYPE; pu32Count: ptr orxU32;
                          pu32PeakCount: ptr orxU32; pu32Size: ptr orxU32;
                          pu32PeakSize: ptr orxU32; pu32OperationCount: ptr orxU32): orxSTATUS {.
      cdecl, importc: "orxMemory_GetUsage", dynlib: libORX.}
  ## * Tracks (external) memory allocation
  ##  @param[in] _eMemType               Concerned memory type
  ##  @param[in] _u32Size                Size to track, in bytes
  ##  @param[in] _bAllocate              orxTRUE if allocate, orxFALSE if free
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
  ##
  proc orxMemory_Track*(eMemType: orxMEMORY_TYPE; u32Size: orxU32; bAllocate: orxBOOL): orxSTATUS {.
      cdecl, importc: "orxMemory_Track", dynlib: libORX.}
## * @}
