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
    orxMEMORY_TYPE_MAIN = 0,    ## Main memory type
    orxMEMORY_TYPE_AUDIO,     ## Audio memory type
    orxMEMORY_TYPE_CONFIG,    ## Config memory
    orxMEMORY_TYPE_DEBUG,     ## Debug memory
    orxMEMORY_TYPE_PHYSICS,   ## Physics memory type
    orxMEMORY_TYPE_SYSTEM,    ## System memory type
    orxMEMORY_TYPE_TEMP,      ## Temporary / scratch memory
    orxMEMORY_TYPE_TEXT,      ## Text memory
    orxMEMORY_TYPE_VIDEO,     ## Video memory type
    orxMEMORY_TYPE_NUMBER,    ## Number of memory type
    orxMEMORY_TYPE_NONE = orxENUM_NONE


proc memorySetup*() {.cdecl, importc: "orxMemory_Setup", dynlib: libORX.}
  ## Setups the memory module

proc memoryInit*(): orxSTATUS {.cdecl, importc: "orxMemory_Init",
                                 dynlib: libORX.}
  ## Inits the memory module
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc memoryExit*() {.cdecl, importc: "orxMemory_Exit", dynlib: libORX.}
  ## Exits from the memory module

proc allocate*(u32Size: orxU32; eMemType: orxMEMORY_TYPE): pointer {.cdecl,
    importc: "orxMemory_Allocate", dynlib: libORX.}
  ## Allocates some memory in the system and returns a pointer to it
  ##  @param[in]  _u32Size  Size of the memory to allocate
  ##  @param[in]  _eMemType Memory zone where data will be allocated
  ##  @return  returns a pointer to the memory allocated, or nil if an error has occurred

proc reallocate*(pMem: pointer; u32Size: orxU32): pointer {.cdecl,
    importc: "orxMemory_Reallocate", dynlib: libORX.}
  ## Reallocates a previously allocated memory block, with the given new size and returns a pointer to it
  ##  If possible, it'll keep the current pointer and extend the memory block, if not it'll allocate a new block,
  ##  copy the data over and deallocates the original block
  ##  @param[in]  _pMem      Memory block to reallocate
  ##  @param[in]  _u32Size   Size of the memory to allocate
  ##  @return  returns a pointer to the reallocated memory block or nil if an error has occurred

proc free*(pMem: pointer) {.cdecl, importc: "orxMemory_Free",
                                   dynlib: libORX.}
  ## Frees some memory allocated with orxMemory_Allocate
  ##  @param[in]  _pMem     Pointer to the memory allocated by orx

proc copy*(pDest: pointer; pSrc: pointer; u32Size: orxU32): pointer {.inline, discardable,
    cdecl.} =
  ## Copies a part of memory into another one
  ##  @param[out] _pDest    Destination pointer
  ##  @param[in]  _pSrc     Pointer of memory from where data are read
  ##  @param[in]  _u32Size  Size of data
  ##  @return returns a pointer to _pDest
  ##  @note if _pSrc and _pDest overlap, use orxMemory_Move instead
  ##  Checks
  assert(pDest != nil)
  assert(pSrc != nil)
  ##  Done!
  {.emit"return((void *)memcpy(pDest, pSrc, (size_t)u32Size));".}

proc move*(pDest: pointer; pSrc: pointer; u32Size: orxU32): pointer {.inline,
    cdecl.} =
  ## Moves a part of memory into another one
  ##  @param[out] _pDest   Destination pointer
  ##  @param[in]  _pSrc    Pointer of memory from where data are read
  ##  @param[in]  _u32Size Size of data
  ##  @return returns a pointer to _pDest
  ##  Checks
  assert(pDest != nil)
  assert(pSrc != nil)
  ##  Done!
  {.emit"return((void *)memmove(pDest, pSrc, (size_t)u32Size));".}

proc compare*(pMem1: pointer; pMem2: pointer; u32Size: orxU32): orxU32 {.
    inline, cdecl.} =
  ## Compares two parts of memory
  ##  @param[in]  _pMem1   First part to test
  ##  @param[in]  _pMem2   Second part to test
  ##  @param[in]  _u32Size Size of data to test
  ##  @return returns a value less than, equal to or greater than 0 if the content of _pMem1 is respectively smaller, equal or greater than _pMem2's
  ##  Checks
  assert(pMem1 != nil)
  assert(pMem2 != nil)
  ##  Done!
  {.emit"return((orxU32)memcmp(pMem1, pMem2, (size_t)u32Size));".}

proc set*(pDest: pointer; u8Data: orxU8; u32Size: orxU32): pointer {.inline,
    cdecl.} =
  ## Fills a part of memory with _u32Data
  ##  @param[out] _pDest   Destination pointer
  ##  @param[in]  _u8Data  Values of the data that will fill the memory
  ##  @param[in]  _u32Size Size of data
  ##  @return returns a pointer to _pDest
  ##  Checks
  assert(pDest != nil)
  ##  Done!
  {.emit"return((void *)memset(pDest, u8Data, (size_t)u32Size));".}

proc zero*(pDest: pointer; u32Size: orxU32): pointer {.inline, cdecl.} =
  ## Fills a part of memory with zeroes
  ##  @param[out] _pDest   Destination pointer
  ##  @param[in]  _u32Size Size of data
  ##  @return returns a pointer to _pDest
  ##  Checks
  assert(pDest != nil)
  ##  Done!
  {.emit"return((void *)memset(pDest, 0, (size_t)u32Size));".}

proc getTypeName*(eMemType: orxMEMORY_TYPE): cstring {.cdecl,
    importc: "orxMemory_GetTypeName", dynlib: libORX.}
  ## Gets memory type literal name
  ##  @param[in] _eMemType               Concerned memory type
  ##  @return Memory type name / orxSTRING_EMPTY

proc getCacheLineSize*(): orxU32 {.cdecl,
    importc: "orxMemory_GetCacheLineSize", dynlib: libORX.}
  ## Gets L1 data cache line size
  ##  @return Cache line size

when defined(PROFILER):
  proc getUsage*(eMemType: orxMEMORY_TYPE; pu32Count: ptr orxU32;
                          pu32PeakCount: ptr orxU32; pu32Size: ptr orxU32;
                          pu32PeakSize: ptr orxU32; pu32OperationCount: ptr orxU32): orxSTATUS {.
      cdecl, importc: "orxMemory_GetUsage", dynlib: libORX.}
    ## Gets memory usage for a given type
    ##  @param[in] _eMemType               Concerned memory type
    ##  @param[out] _pu32Count             Current memory allocation count
    ##  @param[out] _pu32PeakCount         Peak memory allocation count
    ##  @param[out] _pu32Size              Current memory allocation size
    ##  @param[out] _pu32PeakSize          Peak memory allocation size
    ##  @param[out] _pu32OperationCount    Total number of memory operations (malloc/free)
    ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

  proc track*(eMemType: orxMEMORY_TYPE; u32Size: orxU32; bAllocate: orxBOOL): orxSTATUS {.
      cdecl, importc: "orxMemory_Track", dynlib: libORX.}
    ## Tracks (external) memory allocation
    ##  @param[in] _eMemType               Concerned memory type
    ##  @param[in] _u32Size                Size to track, in bytes
    ##  @param[in] _bAllocate              orxTRUE if allocate, orxFALSE if free
    ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

