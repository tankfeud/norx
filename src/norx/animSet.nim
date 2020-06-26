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

import incl, anim, typ

## * AnimSet flags
##

const
  orxANIMSET_KU32_FLAG_NONE* = 0x00000000
  orxANIMSET_KU32_FLAG_REFERENCE_LOCK* = 0x00100000
  orxANIMSET_KU32_FLAG_LINK_STATIC* = 0x00200000

## * AnimSet Link Flags
##

const
  orxANIMSET_KU32_LINK_FLAG_NONE* = 0x00000000
  orxANIMSET_KU32_LINK_FLAG_LOOP_COUNT* = 0x10000000
  orxANIMSET_KU32_LINK_FLAG_PRIORITY* = 0x20000000
  orxANIMSET_KU32_LINK_FLAG_IMMEDIATE_CUT* = 0x40000000
  orxANIMSET_KU32_LINK_FLAG_CLEAR_TARGET* = 0x80000000

## * AnimSet defines
##

const
  orxANIMSET_KU32_MAX_ANIM_NUMBER* = 128

## * Internal AnimSet structure
##

type orxANIMSET* = object
## * Internal Link Table structure
##

type orxANIMSET_LINK_TABLE* = object
## * AnimSet module setup
##

proc orxAnimSet_Setup*() {.cdecl, importc: "orxAnimSet_Setup", dynlib: libORX.}
## * Inits the AnimSet module
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxAnimSet_Init*(): orxSTATUS {.cdecl, importc: "orxAnimSet_Init",
                                  dynlib: libORX.}
## * Exits from the AnimSet module
##

proc orxAnimSet_Exit*() {.cdecl, importc: "orxAnimSet_Exit", dynlib: libORX.}
## * Creates an empty AnimSet
##  @param[in]   _u32Size                            Storage size
##  return       Created orxANIMSET / nil
##

proc orxAnimSet_Create*(u32Size: orxU32): ptr orxANIMSET {.cdecl,
    importc: "orxAnimSet_Create", dynlib: libORX.}
## * Creates an animation set from config
##  @param[in]   _zConfigID                    Config ID
##  @return      orxANIMSET / nil
##

proc orxAnimSet_CreateFromConfig*(zConfigID: cstring): ptr orxANIMSET {.cdecl,
    importc: "orxAnimSet_CreateFromConfig", dynlib: libORX.}
## * Deletes an AnimSet
##  @param[in]   _pstAnimSet                         AnimSet to delete
##

proc orxAnimSet_Delete*(pstAnimSet: ptr orxANIMSET): orxSTATUS {.cdecl,
    importc: "orxAnimSet_Delete", dynlib: libORX.}
## * Clears cache (if any animset is still in active use, it'll remain in memory until not referenced anymore)
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxAnimSet_ClearCache*(): orxSTATUS {.cdecl, importc: "orxAnimSet_ClearCache",
                                        dynlib: libORX.}
## * Adds a reference to an AnimSet
##  @param[in]   _pstAnimSet                         Concerned AnimSet
##

proc orxAnimSet_AddReference*(pstAnimSet: ptr orxANIMSET) {.cdecl,
    importc: "orxAnimSet_AddReference", dynlib: libORX.}
## * Removes a reference from an AnimSet
##  @param[in]   _pstAnimSet                         Concerned AnimSet
##

proc orxAnimSet_RemoveReference*(pstAnimSet: ptr orxANIMSET) {.cdecl,
    importc: "orxAnimSet_RemoveReference", dynlib: libORX.}
## * Clones an AnimSet Link Table
##  @param[in]   _pstAnimSet                         AnimSet to clone
##  @return An internally allocated clone of the AnimSet
##

proc orxAnimSet_CloneLinkTable*(pstAnimSet: ptr orxANIMSET): ptr orxANIMSET_LINK_TABLE {.
    cdecl, importc: "orxAnimSet_CloneLinkTable", dynlib: libORX.}
## * Deletes a Link table
##  @param[in]   _pstLinkTable                       Link table to delete (should have been created using the clone function)
##

proc orxAnimSet_DeleteLinkTable*(pstLinkTable: ptr orxANIMSET_LINK_TABLE) {.cdecl,
    importc: "orxAnimSet_DeleteLinkTable", dynlib: libORX.}
## * Adds an Anim to an AnimSet
##  @param[in]   _pstAnimSet                         Concerned AnimSet
##  @param[in]   _pstAnim                            Anim to add
##  @return Anim ID in the specified AnimSet
##

proc orxAnimSet_AddAnim*(pstAnimSet: ptr orxANIMSET; pstAnim: ptr orxANIM): orxU32 {.
    cdecl, importc: "orxAnimSet_AddAnim", dynlib: libORX.}
## * Removes an Anim from an AnimSet
##  @param[in]   _pstAnimSet                         Concerned AnimSet
##  @param[in]   _u32AnimID                          ID of the anim to remove
##  @return      orxSTATUS_SUCESS / orxSTATUS_FAILURE
##

proc orxAnimSet_RemoveAnim*(pstAnimSet: ptr orxANIMSET; u32AnimID: orxU32): orxSTATUS {.
    cdecl, importc: "orxAnimSet_RemoveAnim", dynlib: libORX.}
## * Removes all Anim from the AnimSet
##  @param[in]   _pstAnimSet                         Concerned AnimSet
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxAnimSet_RemoveAllAnims*(pstAnimSet: ptr orxANIMSET): orxSTATUS {.cdecl,
    importc: "orxAnimSet_RemoveAllAnims", dynlib: libORX.}
## * Adds a link between two Anims of the AnimSet
##  @param[in]   _pstAnimSet                         Concerned AnimSet
##  @param[in]   _u32SrcAnim                         Source Anim of the link
##  @param[in]   _u32DstAnim                         Destination Anim of the link
##  @return      ID of the created link / orxU32_UNDEFINED
##

proc orxAnimSet_AddLink*(pstAnimSet: ptr orxANIMSET; u32SrcAnim: orxU32;
                        u32DstAnim: orxU32): orxU32 {.cdecl,
    importc: "orxAnimSet_AddLink", dynlib: libORX.}
## * Removes a link from the AnimSet
##  @param[in]   _pstAnimSet                         Concerned AnimSet
##  @param[in]   _u32LinkID                          ID of the link
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxAnimSet_RemoveLink*(pstAnimSet: ptr orxANIMSET; u32LinkID: orxU32): orxSTATUS {.
    cdecl, importc: "orxAnimSet_RemoveLink", dynlib: libORX.}
## * Gets a direct link between two Anims, if exists
##  @param[in]   _pstAnimSet                         Concerned AnimSet
##  @param[in]   _u32SrcAnim                         ID of the source Anim
##  @param[in]   _u32DstAnim                         ID of the destination Anim
##  @return      ID of the direct link, orxU32_UNDEFINED if none
##

proc orxAnimSet_GetLink*(pstAnimSet: ptr orxANIMSET; u32SrcAnim: orxU32;
                        u32DstAnim: orxU32): orxU32 {.cdecl,
    importc: "orxAnimSet_GetLink", dynlib: libORX.}
## * Sets a link property
##  @param[in]   _pstAnimSet                         Concerned AnimSet
##  @param[in]   _u32LinkID                          ID of the concerned link
##  @param[in]   _u32Property                        ID of the property to set
##  @param[in]   _u32Value                           Value of the property to set
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxAnimSet_SetLinkProperty*(pstAnimSet: ptr orxANIMSET; u32LinkID: orxU32;
                                u32Property: orxU32; u32Value: orxU32): orxSTATUS {.
    cdecl, importc: "orxAnimSet_SetLinkProperty", dynlib: libORX.}
## * Gets a link property
##  @param[in]   _pstAnimSet                         Concerned AnimSet
##  @param[in]   _u32LinkID                          ID of the concerned link
##  @param[in]   _u32Property                        ID of the property to get
##  @return      Property value / orxU32_UNDEFINED
##

proc orxAnimSet_GetLinkProperty*(pstAnimSet: ptr orxANIMSET; u32LinkID: orxU32;
                                u32Property: orxU32): orxU32 {.cdecl,
    importc: "orxAnimSet_GetLinkProperty", dynlib: libORX.}
## * Computes active Anim given current and destination Anim IDs & a relative timestamp
##  @param[in]   _pstAnimSet                         Concerned AnimSet
##  @param[in]   _u32SrcAnim                         Source (current) Anim ID
##  @param[in]   _u32DstAnim                         Destination Anim ID, if none (auto mode) set it to orxU32_UNDEFINED
##  @param[in,out] _pfTime                           Pointer to the current timestamp relative to the source Anim (time elapsed since the beginning of this anim)
##  @param[in,out] _pstLinkTable                     Anim Pointer link table (updated if AnimSet link table isn't static, when using loop counts for example)
##  @param[out] _pbCut                               Animation has been cut
##  @param[out] _pbClearTarget                       Animation has requested a target clearing
##  @return Current Anim ID. If it's not the source one, _pu32Time will contain the new timestamp, relative to the new Anim
##

proc orxAnimSet_ComputeAnim*(pstAnimSet: ptr orxANIMSET; u32SrcAnim: orxU32;
                            u32DstAnim: orxU32; pfTime: ptr orxFLOAT;
                            pstLinkTable: ptr orxANIMSET_LINK_TABLE;
                            pbCut: ptr orxBOOL; pbClearTarget: ptr orxBOOL): orxU32 {.
    cdecl, importc: "orxAnimSet_ComputeAnim", dynlib: libORX.}
## * Finds next Anim given current and destination Anim IDs
##  @param[in]   _pstAnimSet                         Concerned AnimSet
##  @param[in]   _u32SrcAnim                         Source (current) Anim ID
##  @param[in]   _u32DstAnim                         Destination Anim ID, if none (auto mode) set it to orxU32_UNDEFINED
##  @return Next Anim ID if found, orxU32_UNDEFINED otherwise
##

proc orxAnimSet_FindNextAnim*(pstAnimSet: ptr orxANIMSET; u32SrcAnim: orxU32;
                             u32DstAnim: orxU32): orxU32 {.cdecl,
    importc: "orxAnimSet_FindNextAnim", dynlib: libORX.}
## * AnimSet Anim get accessor
##  @param[in]   _pstAnimSet                         Concerned AnimSet
##  @param[in]   _u32AnimID                          Anim ID
##  @return Anim pointer / nil
##

proc orxAnimSet_GetAnim*(pstAnimSet: ptr orxANIMSET; u32AnimID: orxU32): ptr orxANIM {.
    cdecl, importc: "orxAnimSet_GetAnim", dynlib: libORX.}
## * AnimSet Anim storage size get accessor
##  @param[in]   _pstAnimSet                         Concerned AnimSet
##  @return      AnimSet Storage size / orxU32_UNDEFINED
##

proc orxAnimSet_GetAnimStorageSize*(pstAnimSet: ptr orxANIMSET): orxU32 {.cdecl,
    importc: "orxAnimSet_GetAnimStorageSize", dynlib: libORX.}
## * AnimSet Anim count get accessor
##  @param[in]   _pstAnimSet                         Concerned AnimSet
##  @return      Anim count / orxU32_UNDEFINED
##

proc orxAnimSet_GetAnimCount*(pstAnimSet: ptr orxANIMSET): orxU32 {.cdecl,
    importc: "orxAnimSet_GetAnimCount", dynlib: libORX.}
## * Gets animation ID from name
##  @param[in]   _pstAnimSet                         Concerned AnimSet
##  @param[in]   _zAnimName                          Animation name (config's section)
##  @return Anim ID / orxU32_UNDEFINED
##

proc orxAnimSet_GetAnimIDFromName*(pstAnimSet: ptr orxANIMSET;
                                  zAnimName: cstring): orxU32 {.cdecl,
    importc: "orxAnimSet_GetAnimIDFromName", dynlib: libORX.}
## * AnimSet name get accessor
##  @param[in]   _pstAnimSet                         Concerned AnimSet
##  @return      orxSTRING / orxSTRING_EMPTY
##

proc orxAnimSet_GetName*(pstAnimSet: ptr orxANIMSET): cstring {.cdecl,
    importc: "orxAnimSet_GetName", dynlib: libORX.}
## * @}
