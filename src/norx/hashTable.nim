import incl, memory

type orxHASHTABLE* = object
##  Define flags

const
  orxHASHTABLE_KU32_FLAG_NONE* = 0x00000000
  orxHASHTABLE_KU32_FLAG_NOT_EXPANDABLE* = 0x00000001

proc hashTableCreate*(u32NbKey: orxU32; u32Flags: orxU32;
                         eMemType: orxMEMORY_TYPE): ptr orxHASHTABLE {.cdecl,
    importc: "orxHashTable_Create", dynlib: libORX.}
  ## @name HashTable creation/destruction.
  ##  @{
  ## Create a new hash table and return it.
  ##  @param[in] _u32NbKey    Number of keys that will be inserted.
  ##  @param[in] _u32Flags    Flags used by the hash table
  ##  @param[in] _eMemType    Memory type to use
  ##  @return Returns the hashtable pointer or nil if failed.

proc delete*(pstHashTable: ptr orxHASHTABLE): orxSTATUS {.cdecl,
    importc: "orxHashTable_Delete", dynlib: libORX.}
  ## Delete a hash table.
  ##  @param[in] _pstHashTable  Hash table to delete.
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc clear*(pstHashTable: ptr orxHASHTABLE): orxSTATUS {.cdecl,
    importc: "orxHashTable_Clear", dynlib: libORX.}
  ## Clear a hash table.
  ##  @param[in] _pstHashTable  Hash table to clear.
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getCount*(pstHashTable: ptr orxHASHTABLE): orxU32 {.cdecl,
    importc: "orxHashTable_GetCount", dynlib: libORX.}
  ## @}
  ## Gets a hash table item count
  ##  @param[in] _pstHashTable         Concerned hash table
  ##  @return    Item number

proc get*(pstHashTable: ptr orxHASHTABLE; u64Key: orxU64): pointer {.
    cdecl, importc: "orxHashTable_Get", dynlib: libORX.}
  ## @name HashTable key manipulation.
  ##  @{
  ## Find an item in a hash table.
  ##  @param[in] _pstHashTable  The hash table where search.
  ##  @param[in] _u64Key      Key to find.
  ##  @return The Element associated to the key or nil if not found.

proc retrieve*(pstHashTable: ptr orxHASHTABLE; u64Key: orxU64): ptr pointer {.
    cdecl, importc: "orxHashTable_Retrieve", dynlib: libORX.}
  ## Retrieves the bucket of an item in a hash table, if the item wasn't present, a new bucket will be created.
  ##  @param[in] _pstHashTable   Concerned hashtable
  ##  @param[in] _u64Key         Key to find
  ##  @return The bucket associated to the given key if success, nil otherwise

proc set*(pstHashTable: ptr orxHASHTABLE; u64Key: orxU64; pData: pointer): orxSTATUS {.
    cdecl, importc: "orxHashTable_Set", dynlib: libORX.}
  ## Set an item value.
  ##  @param[in] _pstHashTable The hash table where set.
  ##  @param[in] _u64Key      Key to assign.
  ##  @param[in] _pData       Data to assign.
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc add*(pstHashTable: ptr orxHASHTABLE; u64Key: orxU64; pData: pointer): orxSTATUS {.
    cdecl, importc: "orxHashTable_Add", dynlib: libORX.}
  ## Add an item value.
  ##  @param[in] _pstHashTable The hash table where set.
  ##  @param[in] _u64Key      Key to assign.
  ##  @param[in] _pData       Data to assign.
  ##  @return Returns the status of the operation. (fails if key already used)

proc remove*(pstHashTable: ptr orxHASHTABLE; u64Key: orxU64): orxSTATUS {.
    cdecl, importc: "orxHashTable_Remove", dynlib: libORX.}
  ## Remove an item.
  ##  @param[in] _pstHashTable  The hash table where remove.
  ##  @param[in] _u64Key      Key to remove.
  ##  @return Returns the status of the operation.

proc getNext*(pstHashTable: ptr orxHASHTABLE; hIterator: orxHANDLE;
                          pu64Key: ptr orxU64; ppData: ptr pointer): orxHANDLE {.cdecl,
    importc: "orxHashTable_GetNext", dynlib: libORX.}
  ## @}
  ## @name HashTable iteration.
  ##  Used to iterate on all elements of the hashtable.
  ##  @{
  ## Gets the next item in the hashtable and returns an iterator for next search
  ##  @param[in]   _pstHashTable   Concerned HashTable
  ##  @param[in]   _hIterator      Iterator from previous search or orxHANDLE_UNDEFINED/nil for a new search
  ##  @param[out]  _pu64Key        Current element key
  ##  @param[out]  _ppData         Current element data
  ##  @return Iterator for next element if an element has been found, orxHANDLE_UNDEFINED otherwise

proc optimize*(pstHashTable: ptr orxHASHTABLE): orxSTATUS {.cdecl,
    importc: "orxHashTable_Optimize", dynlib: libORX.}
  ## @}
  ## Optimizes a hashtable for read accesses (minimizes number of cache misses upon collisions)
  ##  @param[in] _pstHashTable HashTable to optimize
  ##  @return orxSTATUS_SUCESS / orxSTATUS_FAILURE

