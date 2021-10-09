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

proc bankCreate*(u32Count: orxU32; u32Size: orxU32; u32Flags: orxU32;
                    eMemType: orxMEMORY_TYPE): ptr orxBANK {.cdecl,
    importc: "orxBank_Create", dynlib: libORX.}
  ## Creates a new bank in memory and returns a pointer to it
  ##  @param[in] _u32Count   Number of cells per segments
  ##  @param[in] _u32Size    Size of a cell
  ##  @param[in] _u32Flags   Bank flags
  ##  @param[in] _eMemType   Memory type
  ##  @return orxBANK / orxNULL

proc delete*(pstBank: ptr orxBANK) {.cdecl, importc: "orxBank_Delete",
    dynlib: libORX.}
  ## Deletes a bank
  ##  @param[in] _pstBank    Concerned bank

proc allocate*(pstBank: ptr orxBANK): pointer {.cdecl,
    importc: "orxBank_Allocate", dynlib: libORX.}
  ## Allocates a new cell from the bank
  ##  @param[in] _pstBank    Concerned bank
  ##  @return a new cell of memory (nil if no allocation possible)

proc allocateIndexed*(pstBank: ptr orxBANK; pu32ItemIndex: ptr orxU32;
                             ppPrevious: ptr pointer): pointer {.cdecl,
    importc: "orxBank_AllocateIndexed", dynlib: libORX.}
  ## Allocates a new cell from the bank and returns its index
  ##  @param[in] _pstBank        Concerned bank
  ##  @param[out] _pu32ItemIndex Will be set with the allocated item index
  ##  @param[out] _ppPrevious    If non-null, will contain previous neighbor if found
  ##  @return a new cell of memory (nil if no allocation possible)

proc free*(pstBank: ptr orxBANK; pCell: pointer) {.cdecl,
    importc: "orxBank_Free", dynlib: libORX.}
  ## Frees an allocated cell
  ##  @param[in] _pstBank    Concerned bank
  ##  @param[in] _pCell      Pointer to the cell to free

proc freeAtIndex*(pstBank: ptr orxBANK; u32Index: orxU32) {.cdecl,
    importc: "orxBank_FreeAtIndex", dynlib: libORX.}
  ## Frees an allocated cell at a given index
  ##  @param[in] _pstBank    Concerned bank
  ##  @param[in] _u32Index   Index of the cell to free

proc clear*(pstBank: ptr orxBANK) {.cdecl, importc: "orxBank_Clear",
                                        dynlib: libORX.}
  ## Frees all allocated cell from a bank
  ##  @param[in] _pstBank    Concerned bank

proc compact*(pstBank: ptr orxBANK) {.cdecl, importc: "orxBank_Compact",
    dynlib: libORX.}
  ## Compacts a bank by removing all its trailing unused segments
  ##  @param[in] _pstBank    Concerned bank

proc compactAll*() {.cdecl, importc: "orxBank_CompactAll",
                           dynlib: libORX.}
  ## Compacts all banks by removing all their unused segments

proc getNext*(pstBank: ptr orxBANK; pCell: pointer): pointer {.cdecl,
    importc: "orxBank_GetNext", dynlib: libORX.}
  ## Gets the next cell
  ##  @param[in] _pstBank    Concerned bank
  ##  @param[in] _pCell      Pointer to the current cell of memory, orxNULL to get the first one
  ##  @return The next cell if found, orxNULL otherwise

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
