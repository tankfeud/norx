import incl, clock, memory, linkList, tree


## * Structure pointer get helpers
##

template orxSTRUCTURE_ASSERT(X: untyped) =
  # TODO: Hack for now
  discard

template orxSTRUCTURE_GET_POINTER*(STRUCTURE, TYPE, ID: untyped): untyped =
  (cast[ptr TYPE](orxStructure_GetPointer(STRUCTURE, ID)))

template orxSTRUCTURE_MACRO*(STRUCTURE: untyped): untyped =
  (if (((STRUCTURE) != nil) and
      ((((cast[ptr orxSTRUCTURE](STRUCTURE)).u64GUID.int64 and
      orxSTRUCTURE_GUID_MASK_STRUCTURE_ID) shr
      orxSTRUCTURE_GUID_SHIFT_STRUCTURE_ID) < orxSTRUCTURE_ID_NUMBER.int64)): cast[ptr orxSTRUCTURE]((
      STRUCTURE)) else: cast[ptr orxSTRUCTURE](nil))

template orxANIM*(STRUCTURE: untyped): untyped =
  orxSTRUCTURE_GET_POINTER(STRUCTURE, orxANIM, orxSTRUCTURE_ID_ANIM)

template orxANIMPOINTER*(STRUCTURE: untyped): untyped =
  orxSTRUCTURE_GET_POINTER(STRUCTURE, orxANIMPOINTER, orxSTRUCTURE_ID_ANIMPOINTER)

template orxANIMSET*(STRUCTURE: untyped): untyped =
  orxSTRUCTURE_GET_POINTER(STRUCTURE, orxANIMSET, orxSTRUCTURE_ID_ANIMSET)

template orxBODY*(STRUCTURE: untyped): untyped =
  orxSTRUCTURE_GET_POINTER(STRUCTURE, orxBODY, orxSTRUCTURE_ID_BODY)

template orxCAMERA*(STRUCTURE: untyped): untyped =
  orxSTRUCTURE_GET_POINTER(STRUCTURE, orxCAMERA, orxSTRUCTURE_ID_CAMERA)

template orxCLOCK*(STRUCTURE: untyped): untyped =
  orxSTRUCTURE_GET_POINTER(STRUCTURE, orxCLOCK, orxSTRUCTURE_ID_CLOCK)

template orxFONT*(STRUCTURE: untyped): untyped =
  orxSTRUCTURE_GET_POINTER(STRUCTURE, orxFONT, orxSTRUCTURE_ID_FONT)

template orxFRAME*(STRUCTURE: untyped): untyped =
  orxSTRUCTURE_GET_POINTER(STRUCTURE, orxFRAME, orxSTRUCTURE_ID_FRAME)

template orxFX*(STRUCTURE: untyped): untyped =
  orxSTRUCTURE_GET_POINTER(STRUCTURE, orxFX, orxSTRUCTURE_ID_FX)

template orxFXPOINTER*(STRUCTURE: untyped): untyped =
  orxSTRUCTURE_GET_POINTER(STRUCTURE, orxFXPOINTER, orxSTRUCTURE_ID_FXPOINTER)

template orxGRAPHIC*(STRUCTURE: untyped): untyped =
  orxSTRUCTURE_GET_POINTER(STRUCTURE, orxGRAPHIC, orxSTRUCTURE_ID_GRAPHIC)

template orxOBJECT*(STRUCTURE: untyped): untyped =
  orxSTRUCTURE_GET_POINTER(STRUCTURE, orxOBJECT, orxSTRUCTURE_ID_OBJECT)

template orxSOUND*(STRUCTURE: untyped): untyped =
  orxSTRUCTURE_GET_POINTER(STRUCTURE, orxSOUND, orxSTRUCTURE_ID_SOUND)

template orxSOUNDPOINTER*(STRUCTURE: untyped): untyped =
  orxSTRUCTURE_GET_POINTER(STRUCTURE, orxSOUNDPOINTER,
                           orxSTRUCTURE_ID_SOUNDPOINTER)

template orxSHADER*(STRUCTURE: untyped): untyped =
  orxSTRUCTURE_GET_POINTER(STRUCTURE, orxSHADER, orxSTRUCTURE_ID_SHADER)

template orxSHADERPOINTER*(STRUCTURE: untyped): untyped =
  orxSTRUCTURE_GET_POINTER(STRUCTURE, orxSHADERPOINTER,
                           orxSTRUCTURE_ID_SHADERPOINTER)

template orxSPAWNER*(STRUCTURE: untyped): untyped =
  orxSTRUCTURE_GET_POINTER(STRUCTURE, orxSPAWNER, orxSTRUCTURE_ID_SPAWNER)

template orxTEXT*(STRUCTURE: untyped): untyped =
  orxSTRUCTURE_GET_POINTER(STRUCTURE, orxTEXT, orxSTRUCTURE_ID_TEXT)

template orxTEXTURE*(STRUCTURE: untyped): untyped =
  orxSTRUCTURE_GET_POINTER(STRUCTURE, orxTEXTURE, orxSTRUCTURE_ID_TEXTURE)

template orxTIMELINE*(STRUCTURE: untyped): untyped =
  orxSTRUCTURE_GET_POINTER(STRUCTURE, orxTIMELINE, orxSTRUCTURE_ID_TIMELINE)

template orxVIEWPORT*(STRUCTURE: untyped): untyped =
  orxSTRUCTURE_GET_POINTER(STRUCTURE, orxVIEWPORT, orxSTRUCTURE_ID_VIEWPORT)

## * Structure register macro
##

## * Structure assert
##

## * Structure magic number
##

const
  orxSTRUCTURE_GUID_MAGIC_TAG_DELETED* = 0x0000000000000000'i64

## * Structure GUID masks/shifts
##

const
  orxSTRUCTURE_GUID_MASK_STRUCTURE_ID* = 0x00000000000000FF'i64
  orxSTRUCTURE_GUID_SHIFT_STRUCTURE_ID* = 0
  orxSTRUCTURE_GUID_MASK_ITEM_ID* = 0x00000000FFFFFF00'i64
  orxSTRUCTURE_GUID_SHIFT_ITEM_ID* = 8
  orxSTRUCTURE_GUID_MASK_INSTANCE_ID* = 0xFFFFFFFF00000000'i64
  orxSTRUCTURE_GUID_SHIFT_INSTANCE_ID* = 32

## * Structure IDs
##

type                          ##  *** Following structures can be linked to objects ***
  orxSTRUCTURE_ID* {.size: sizeof(cint).} = enum
    orxSTRUCTURE_ID_ANIMPOINTER = 0, orxSTRUCTURE_ID_BODY, orxSTRUCTURE_ID_CLOCK,
    orxSTRUCTURE_ID_FRAME, orxSTRUCTURE_ID_FXPOINTER, orxSTRUCTURE_ID_GRAPHIC,
    orxSTRUCTURE_ID_SHADERPOINTER, orxSTRUCTURE_ID_SOUNDPOINTER,
    orxSTRUCTURE_ID_SPAWNER, orxSTRUCTURE_ID_TIMELINE, orxSTRUCTURE_ID_LINKABLE_NUMBER, ##  *** Below this point, structures can not be linked to objects ***
    orxSTRUCTURE_ID_ANIMSET, orxSTRUCTURE_ID_CAMERA, orxSTRUCTURE_ID_FONT,
    orxSTRUCTURE_ID_FX, orxSTRUCTURE_ID_OBJECT, orxSTRUCTURE_ID_SHADER,
    orxSTRUCTURE_ID_SOUND, orxSTRUCTURE_ID_TEXT, orxSTRUCTURE_ID_TEXTURE,
    orxSTRUCTURE_ID_VIEWPORT, orxSTRUCTURE_ID_NUMBER,
    orxSTRUCTURE_ID_NONE = orxENUM_NONE

const
  orxSTRUCTURE_ID_ANIM = orxSTRUCTURE_ID_LINKABLE_NUMBER

## * Structure storage types
##

type
  orxSTRUCTURE_STORAGE_TYPE* {.size: sizeof(cint).} = enum
    orxSTRUCTURE_STORAGE_TYPE_LINKLIST = 0, orxSTRUCTURE_STORAGE_TYPE_TREE,
    orxSTRUCTURE_STORAGE_TYPE_NUMBER,
    orxSTRUCTURE_STORAGE_TYPE_NONE = orxENUM_NONE


## * Public structure (Must be first derived structure member!)
##

type
  INNER_C_UNION_orxStructure_209* {.bycopy, union.} = object
    stLinkListNode*: orxLINKLIST_NODE ## Linklist node : 36/48
    stTreeNode*: orxTREE_NODE  ## Tree node : 44/64

  orxSTRUCTURE* {.bycopy.} = object
    u64GUID*: orxU64           ## Structure GUID : 8
    u64OwnerGUID*: orxU64      ## Owner's GUID : 16
    u32Flags*: orxU32          ## Flags : 20
    u32RefCount*: orxU32       ## Ref count : 24

    stStorage*: INNER_C_UNION_orxStructure_209 ## Storage node union : 44/64


## * Structure update callback function type
##

type
  orxSTRUCTURE_UPDATE_FUNCTION* = proc (pstStructure: ptr orxSTRUCTURE;
                                     pstCaller: ptr orxSTRUCTURE;
                                     pstClockInfo: ptr orxCLOCK_INFO): orxSTATUS {.
      cdecl.}

proc getPointer*(pStructure: pointer; eStructureID: orxSTRUCTURE_ID): ptr orxSTRUCTURE {.
    inline, cdecl.} =
  ## Gets structure pointer / debug mode
  ##  @param[in]   _pStructure    Concerned structure
  ##  @param[in]   _eStructureID   ID to test the structure against
  ##  @return      Valid orxSTRUCTURE, nil otherwise
  let uid: int64 = (cast[ptr orxSTRUCTURE](pStructure)).u64GUID.int64
  if (pStructure != nil and ((uid and orxSTRUCTURE_GUID_MASK_STRUCTURE_ID) shr orxSTRUCTURE_GUID_SHIFT_STRUCTURE_ID) == eStructureID.int64):
    return cast[ptr orxSTRUCTURE](pStructure)
  else:
    return cast[ptr orxSTRUCTURE](nil)


proc getIDString*(eID: orxSTRUCTURE_ID): string {.inline, cdecl.} =
  ## Gets structure ID string
  ##  @param[in]   _eID                       Concerned ID
  ##  @return      Corresponding literal string
  ##  Depending on ID
  case eID
  of orxSTRUCTURE_ID_ANIMPOINTER:
    return "ANIMPOINTER"
  of orxSTRUCTURE_ID_BODY:
    return "BODY"
  of orxSTRUCTURE_ID_CLOCK:
    return "CLOCK"
  of orxSTRUCTURE_ID_FRAME:
    return "FRAME"
  of orxSTRUCTURE_ID_FXPOINTER:
    return "FXPOINTER"
  of orxSTRUCTURE_ID_GRAPHIC:
    return "GRAPHIC"
  of orxSTRUCTURE_ID_SHADERPOINTER:
    return "SHADERPOINTER"
  of orxSTRUCTURE_ID_SOUNDPOINTER:
    return "SOUNDPOINTER"
  of orxSTRUCTURE_ID_SPAWNER:
    return "SPAWNER"
  of orxSTRUCTURE_ID_TIMELINE:
    return "TIMELINE"
  of orxSTRUCTURE_ID_ANIM:
    return "ANIM"
  of orxSTRUCTURE_ID_ANIMSET:
    return "ANIMSET"
  of orxSTRUCTURE_ID_FONT:
    return "FONT"
  of orxSTRUCTURE_ID_FX:
    return "FX"
  of orxSTRUCTURE_ID_OBJECT:
    return "OBJECT"
  of orxSTRUCTURE_ID_SHADER:
    return "SHADER"
  of orxSTRUCTURE_ID_SOUND:
    return "SOUND"
  of orxSTRUCTURE_ID_TEXT:
    return "TEXT"
  of orxSTRUCTURE_ID_TEXTURE:
    return "TEXTURE"
  of orxSTRUCTURE_ID_VIEWPORT:
    return "VIEWPORT"
  else:
    return "INVALID STRUCTURE ID"

proc structureSetup*() {.cdecl, importc: "orxStructure_Setup",
                           dynlib: libORX.}
  ## Structure module setup

proc structureInit*(): orxSTATUS {.cdecl, importc: "orxStructure_Init",
                                    dynlib: libORX.}
  ## Initializess the structure module
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc structureExit*() {.cdecl, importc: "orxStructure_Exit", dynlib: libORX.}
  ## Exits from the structure module

proc register*(eStructureID: orxSTRUCTURE_ID;
                           eStorageType: orxSTRUCTURE_STORAGE_TYPE;
                           eMemoryType: orxMEMORY_TYPE; u32Size: orxU32;
                           u32BankSize: orxU32;
                           pfnUpdate: orxSTRUCTURE_UPDATE_FUNCTION): orxSTATUS {.
    cdecl, importc: "orxStructure_Register", dynlib: libORX.}
  ## Registers a given ID
  ##  @param[in]   _eStructureID   Concerned structure ID
  ##  @param[in]   _eStorageType   Storage type to use for this structure type
  ##  @param[in]   _eMemoryType    Memory type to store this structure type
  ##  @param[in]   _u32Size        Structure size
  ##  @param[in]   _u32BankSize    Bank (segment) size
  ##  @param[in]   _pfnUpdate      Structure update function
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc unregister*(eStructureID: orxSTRUCTURE_ID): orxSTATUS {.cdecl,
    importc: "orxStructure_Unregister", dynlib: libORX.}
  ## Unregisters a given ID
  ##  @param[in]   _eStructureID   Concerned structure ID
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc structureCreate*(eStructureID: orxSTRUCTURE_ID): ptr orxSTRUCTURE {.cdecl,
    importc: "orxStructure_Create", dynlib: libORX.}
  ## Creates a clean structure for given type
  ##  @param[in]   _eStructureID   Concerned structure ID
  ##  @return      orxSTRUCTURE / nil

proc delete*(pStructure: pointer): orxSTATUS {.cdecl,
    importc: "orxStructure_Delete", dynlib: libORX.}
  ## Deletes a structure (needs to be cleaned beforehand)
  ##  @param[in]   _pStructure    Concerned structure
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getStorageType*(eStructureID: orxSTRUCTURE_ID): orxSTRUCTURE_STORAGE_TYPE {.
    cdecl, importc: "orxStructure_GetStorageType", dynlib: libORX.}
  ## Gets structure storage type
  ##  @param[in]   _eStructureID   Concerned structure ID
  ##  @return      orxSTRUCTURE_STORAGE_TYPE

proc getCount*(eStructureID: orxSTRUCTURE_ID): orxU32 {.cdecl,
    importc: "orxStructure_GetCount", dynlib: libORX.}
  ## Gets given type structure count
  ##  @param[in]   _eStructureID   Concerned structure ID
  ##  @return      orxU32 / orxU32_UNDEFINED

proc update*(pStructure: pointer; phCaller: pointer;
                         pstClockInfo: ptr orxCLOCK_INFO): orxSTATUS {.cdecl,
    importc: "orxStructure_Update", dynlib: libORX.}
  ## Updates structure if update function was registered for the structure type
  ##  @param[in]   _pStructure     Concerned structure
  ##  @param[in]   _phCaller       Caller structure
  ##  @param[in]   _pstClockInfo   Update associated clock info
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc get*(u64GUID: orxU64): ptr orxSTRUCTURE {.cdecl,
    importc: "orxStructure_Get", dynlib: libORX.}
  ## *** Structure storage accessors ***
  ## Gets structure given its GUID
  ##  @param[in]   _u64GUID        Structure's GUID
  ##  @return      orxSTRUCTURE / nil if not found/alive

proc getOwner*(pStructure: pointer): ptr orxSTRUCTURE {.cdecl,
    importc: "orxStructure_GetOwner", dynlib: libORX.}
  ## Gets structure's owner
  ##  @param[in]   _pStructure    Concerned structure
  ##  @return      orxSTRUCTURE / nil if not found/alive

proc setOwner*(pStructure: pointer; pOwner: pointer): orxSTATUS {.cdecl,
    importc: "orxStructure_SetOwner", dynlib: libORX.}
  ## Sets structure owner
  ##  @param[in]   _pStructure    Concerned structure
  ##  @param[in]   _pOwner        Structure to set as owner
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getFirst*(eStructureID: orxSTRUCTURE_ID): ptr orxSTRUCTURE {.cdecl,
    importc: "orxStructure_GetFirst", dynlib: libORX.}
  ## Gets first stored structure (first list cell or tree root depending on storage type)
  ##  @param[in]   _eStructureID   Concerned structure ID
  ##  @return      orxSTRUCTURE

proc getLast*(eStructureID: orxSTRUCTURE_ID): ptr orxSTRUCTURE {.cdecl,
    importc: "orxStructure_GetLast", dynlib: libORX.}
  ## Gets last stored structure (last list cell or tree root depending on storage type)
  ##  @param[in]   _eStructureID   Concerned structure ID
  ##  @return      orxSTRUCTURE

proc getParent*(pStructure: pointer): ptr orxSTRUCTURE {.cdecl,
    importc: "orxStructure_GetParent", dynlib: libORX.}
  ## Gets structure tree parent
  ##  @param[in]   _pStructure    Concerned structure
  ##  @return      orxSTRUCTURE

proc getChild*(pStructure: pointer): ptr orxSTRUCTURE {.cdecl,
    importc: "orxStructure_GetChild", dynlib: libORX.}
  ## Gets structure tree child
  ##  @param[in]   _pStructure    Concerned structure
  ##  @return      orxSTRUCTURE

proc getSibling*(pStructure: pointer): ptr orxSTRUCTURE {.cdecl,
    importc: "orxStructure_GetSibling", dynlib: libORX.}
  ## Gets structure tree sibling
  ##  @param[in]   _pStructure    Concerned structure
  ##  @return      orxSTRUCTURE

proc getPrevious*(pStructure: pointer): ptr orxSTRUCTURE {.cdecl,
    importc: "orxStructure_GetPrevious", dynlib: libORX.}
  ## Gets structure list previous
  ##  @param[in]   _pStructure    Concerned structure
  ##  @return      orxSTRUCTURE

proc getNext*(pStructure: pointer): ptr orxSTRUCTURE {.cdecl,
    importc: "orxStructure_GetNext", dynlib: libORX.}
  ## Gets structure list next
  ##  @param[in]   _pStructure    Concerned structure
  ##  @return      orxSTRUCTURE

proc setParent*(pStructure: pointer; phParent: pointer): orxSTATUS {.
    cdecl, importc: "orxStructure_SetParent", dynlib: libORX.}
  ## Sets structure tree parent
  ##  @param[in]   _pStructure    Concerned structure
  ##  @param[in]   _phParent       Structure to set as parent
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc logAll*(): orxSTATUS {.cdecl, importc: "orxStructure_LogAll",
                                      dynlib: libORX.}
  ## Logs all user-generated active structures
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc increaseCount*(pStructure: pointer) {.inline, cdecl.} =
  ## *** Inlined structure accessors ***
  ## Increases structure reference count
  ##  @param[in]   _pStructure    Concerned structure

  ##  Checks
  orxSTRUCTURE_ASSERT(pStructure)
  assert(orxSTRUCTURE_MACRO(pStructure).u32RefCount < (orxU32)0xFFFFFFFF)

  ##  Increases ref count
  orxSTRUCTURE_MACRO(pStructure).u32RefCount += 1

  ##  Done!
  return

proc decreaseCount*(pStructure: pointer) {.inline, cdecl.} =
  ## Decreases structure reference count
  ##  @param[in]   _pStructure    Concerned structure

  ##  Checks
  orxSTRUCTURE_ASSERT(pStructure)
  assert(orxSTRUCTURE_MACRO(pStructure).u32RefCount != 0)

  ##  Decreases ref count
  orxSTRUCTURE_MACRO(pStructure).u32RefCount -= 1

  ##  Done!
  return

proc getRefCount*(pStructure: pointer): orxU32 {.inline, cdecl.} =
  ## Gets structure reference count
  ##  @param[in]   _pStructure    Concerned structure
  ##  @return      orxU32
  ##  Checks
  orxSTRUCTURE_ASSERT(pStructure)
  ##  Done!
  return orxSTRUCTURE_MACRO(pStructure).u32RefCount

proc getGUID*(pStructure: pointer): orxU64 {.inline, cdecl.} =
  ## Gets structure GUID
  ##  @param[in]   _pStructure    Concerned structure
  ##  @return      orxU64
  ##  Checks
  orxSTRUCTURE_ASSERT(pStructure)
  ##  Done!
  return orxSTRUCTURE_MACRO(pStructure).u64GUID

proc getID*(pStructure: pointer): orxSTRUCTURE_ID {.inline, cdecl.} =
  ## Gets structure ID
  ##  @param[in]   _pStructure    Concerned structure
  ##  @return      orxSTRUCTURE_ID
  ##  Checks
  orxSTRUCTURE_ASSERT(pStructure)
  ##  Done!
  return (orxSTRUCTURE_ID)((orxSTRUCTURE_MACRO(pStructure).u64GUID.uint64 and
      orxSTRUCTURE_GUID_MASK_STRUCTURE_ID.uint64) shr
      orxSTRUCTURE_GUID_SHIFT_STRUCTURE_ID)

#TODO: Removed these for now
#[

proc testFlags*(pStructure: pointer; u32Flags: orxU32): orxBOOL {.inline,
    cdecl.} =
  ## Tests flags against structure ones
  ##  @param[in]   _pStructure    Concerned structure
  ##  @param[in]   _u32Flags      Flags to test
  ##  @return      orxTRUE / orxFALSE
  ##  Checks
  orxSTRUCTURE_ASSERT(pStructure)
  ##  Done!
  return orxFLAG_TEST(orxSTRUCTURE_MACRO(pStructure).u32Flags, u32Flags)

proc testAllFlags*(pStructure: pointer; u32Flags: orxU32): orxBOOL {.
    inline, cdecl.} =
  ## Tests all flags against structure ones
  ##  @param[in]   _pStructure    Concerned structure
  ##  @param[in]   _u32Flags      Flags to test
  ##  @return      orxTRUE / orxFALSE
  ##  Checks
  orxSTRUCTURE_ASSERT(pStructure)
  ##  Done!
  return orxFLAG_TEST_ALL(orxSTRUCTURE_MACRO(pStructure).u32Flags, u32Flags)

proc getFlags*(pStructure: pointer; u32Mask: orxU32): orxU32 {.inline,
    cdecl.} =
  ## Gets structure flags
  ##  @param[in]   _pStructure    Concerned structure
  ##  @param[in]   _u32Mask       Mask to use for getting flags
  ##  @return      orxU32
  ##  Checks
  orxSTRUCTURE_ASSERT(pStructure)
  ##  Done!
  return orxFLAG_GET(orxSTRUCTURE_MACRO(pStructure).u32Flags, u32Mask)

proc setFlags*(pStructure: pointer; u32AddFlags: orxU32;
                           u32RemoveFlags: orxU32) {.inline, cdecl.} =
  ## Sets structure flags
  ##  @param[in]   _pStructure    Concerned structure
  ##  @param[in]   _u32AddFlags    Flags to add
  ##  @param[in]   _u32RemoveFlags Flags to remove
  ##  Checks
  orxSTRUCTURE_ASSERT(pStructure)
  orxFLAG_SET(orxSTRUCTURE_MACRO(pStructure).u32Flags, u32AddFlags, u32RemoveFlags)
  ##  Done!
  return
]#
