import incl, memory

type orxBANK* = object
##  Define flags

const
  orxBANK_KU32_FLAG_NONE* = 0x00000000
  orxBANK_KU32_FLAG_NOT_EXPANDABLE* = 0x00000001

proc bankSetup*() {.cdecl, importc: "orxBank_Setup", dynlib: libORX.}
  ## Setups the bank module

proc bankInit*(): orxSTATUS {.cdecl, importc: "orxBank_Init", dynlib: libORX.}
  ## Inits the bank Module
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc bankExit*() {.cdecl, importc: "orxBank_Exit", dynlib: libORX.}
  ## Exits from the bank module

proc bankCreate*(u16NbElem: orxU16; u32Size: orxU32; u32Flags: orxU32;
                    eMemType: orxMEMORY_TYPE): ptr orxBANK {.cdecl,
    importc: "orxBank_Create", dynlib: libORX.}
  ## Creates a new bank in memory and returns a pointer to it
  ##  @param[in] _u16NbElem  Number of elements per segments
  ##  @param[in] _u32Size    Size of an element
  ##  @param[in] _u32Flags   Flags set for this bank
  ##  @param[in] _eMemType   Memory type where the data will be allocated
  ##  @return  returns a pointer to the memory bank

proc delete*(pstBank: ptr orxBANK) {.cdecl, importc: "orxBank_Delete",
    dynlib: libORX.}
  ## Frees some memory allocated with orxMemory_Allocate
  ##  @param[in] _pstBank    Pointer to the memory bank allocated by orx

proc allocate*(pstBank: ptr orxBANK): pointer {.cdecl,
    importc: "orxBank_Allocate", dynlib: libORX.}
  ## Allocates a new cell from the bank
  ##  @param[in] _pstBank    Pointer to the memory bank to use
  ##  @return a new cell of memory (nil if no allocation possible)

proc allocateIndexed*(pstBank: ptr orxBANK; pu32ItemIndex: ptr orxU32;
                             ppPrevious: ptr pointer): pointer {.cdecl,
    importc: "orxBank_AllocateIndexed", dynlib: libORX.}
  ## Allocates a new cell from the bank and returns its index
  ##  @param[in] _pstBank        Pointer to the memory bank to use
  ##  @param[out] _pu32ItemIndex Will be set with the allocated item index
  ##  @param[out] _ppPrevious    If non-null, will contain previous neighbor if found
  ##  @return a new cell of memory (nil if no allocation possible)

proc free*(pstBank: ptr orxBANK; pCell: pointer) {.cdecl,
    importc: "orxBank_Free", dynlib: libORX.}
  ## Frees an allocated cell
  ##  @param[in] _pstBank    Bank of memory from where _pCell has been allocated
  ##  @param[in] _pCell      Pointer to the cell to free

proc clear*(pstBank: ptr orxBANK) {.cdecl, importc: "orxBank_Clear",
                                        dynlib: libORX.}
  ## Frees all allocated cell from a bank
  ##  @param[in] _pstBank    Bank of memory to clear

proc compact*(pstBank: ptr orxBANK) {.cdecl, importc: "orxBank_Compact",
    dynlib: libORX.}
  ## Compacts a bank by removing all its unused segments
  ##  @param[in] _pstBank    Bank of memory to compact

proc compactAll*() {.cdecl, importc: "orxBank_CompactAll",
                           dynlib: libORX.}
  ## Compacts all banks by removing all their unused segments

proc getNext*(pstBank: ptr orxBANK; pCell: pointer): pointer {.cdecl,
    importc: "orxBank_GetNext", dynlib: libORX.}
  ## Gets the next cell
  ##  @param[in] _pstBank    Bank of memory from where _pCell has been allocated
  ##  @param[in] _pCell      Pointer to the current cell of memory
  ##  @return The next cell. If _pCell is nil, the first cell will be returned. Returns nil when no more cell can be returned.

proc getIndex*(pstBank: ptr orxBANK; pCell: pointer): orxU32 {.cdecl,
    importc: "orxBank_GetIndex", dynlib: libORX.}
  ## Gets the cell's index
  ##  @param[in] _pstBank    Concerned memory bank
  ##  @param[in] _pCell      Cell of which we want the index
  ##  @return The index of the given cell

proc getAtIndex*(pstBank: ptr orxBANK; u32Index: orxU32): pointer {.cdecl,
    importc: "orxBank_GetAtIndex", dynlib: libORX.}
  ## Gets the cell at given index, nil is the cell isn't allocated
  ##  @param[in] _pstBank    Concerned memory bank
  ##  @param[in] _u32Index   Index of the cell to retrieve
  ##  @return The cell at the given index if allocated, nil otherwise

proc getCount*(pstBank: ptr orxBANK): orxU32 {.cdecl,
    importc: "orxBank_GetCount", dynlib: libORX.}
  ## Gets the bank allocated cell count
  ##  @param[in] _pstBank    Concerned bank
  ##  @return Number of allocated cells

when defined(DEBUG):
  proc debugPrint*(pstBank: ptr orxBANK) {.cdecl,
      importc: "orxBank_DebugPrint", dynlib: libORX.}
    ## Prints the content of a chunk bank
    ##  @param[in] _pstBank    Bank's pointer
