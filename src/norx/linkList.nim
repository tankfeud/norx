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

import incl

type
  orxLINKLIST_NODE* {.bycopy.} = object
    pstNext*: ptr orxLINKLIST_NODE ## *< Next node pointer : 4/8
    pstPrevious*: ptr orxLINKLIST_NODE ## *< Previous node pointer : 8/16
    pstList*: ptr orxLINKLIST    ## *< Associated list pointer : 12/24
  orxLINKLIST* {.bycopy.} = object
    pstFirst*: ptr orxLINKLIST_NODE ## *< First node pointer : 4/8
    pstLast*: ptr orxLINKLIST_NODE ## *< Last node pointer : 8/16
    u32Count*: orxU32          ## *< Node count : 12/20
## * Cleans a linklist
##  @param[in]   _pstList                        Concerned list
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxLinkList_Clean*(pstList: ptr orxLINKLIST): orxSTATUS {.cdecl,
    importc: "orxLinkList_Clean", dynlib: libORX.}
## * Adds a node at the start of a list
##  @param[in]   _pstList                        Concerned list
##  @param[in]   _pstNode                        Node to add
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxLinkList_AddStart*(pstList: ptr orxLINKLIST; pstNode: ptr orxLINKLIST_NODE): orxSTATUS {.
    cdecl, importc: "orxLinkList_AddStart", dynlib: libORX.}
## * Adds a node at the end of a list
##  @param[in]   _pstList                        Concerned list
##  @param[in]   _pstNode                        Node to add
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxLinkList_AddEnd*(pstList: ptr orxLINKLIST; pstNode: ptr orxLINKLIST_NODE): orxSTATUS {.
    cdecl, importc: "orxLinkList_AddEnd", dynlib: libORX.}
## * Adds a node before another one
##  @param[in]   _pstRefNode                     Reference node (add before this one)
##  @param[in]   _pstNode                        Node to add
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxLinkList_AddBefore*(pstRefNode: ptr orxLINKLIST_NODE;
                           pstNode: ptr orxLINKLIST_NODE): orxSTATUS {.cdecl,
    importc: "orxLinkList_AddBefore", dynlib: libORX.}
## * Adds a node after another one
##  @param[in]   _pstRefNode                     Reference node (add after this one)
##  @param[in]   _pstNode                        Node to add
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxLinkList_AddAfter*(pstRefNode: ptr orxLINKLIST_NODE;
                          pstNode: ptr orxLINKLIST_NODE): orxSTATUS {.cdecl,
    importc: "orxLinkList_AddAfter", dynlib: libORX.}
## * Removes a node from its list
##  @param[in]   _pstNode                        Concerned node
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxLinkList_Remove*(pstNode: ptr orxLINKLIST_NODE): orxSTATUS {.cdecl,
    importc: "orxLinkList_Remove", dynlib: libORX.}
##  *** LinkList inlined accessors ***
## * Gets a node list
##  @param[in]   _pstNode                        Concerned node
##  @return orxLINKLIST / nil
##

proc orxLinkList_GetList*(pstNode: ptr orxLINKLIST_NODE): ptr orxLINKLIST {.inline,
    cdecl.} =
  ##  Checks
  assert(pstNode != nil)
  ##  Returns it
  return pstNode.pstList

## * Gets previous node in list
##  @param[in]   _pstNode                        Concerned node
##  @return orxLINKLIST_NODE / nil
##

proc orxLinkList_GetPrevious*(pstNode: ptr orxLINKLIST_NODE): ptr orxLINKLIST_NODE {.
    inline, cdecl.} =
  ##  Checks
  assert(pstNode != nil)
  ##  Returns it
  return if (pstNode.pstList != nil): pstNode.pstPrevious else: cast[ptr orxLINKLIST_NODE](nil)

## * Gets next node in list
##  @param[in]   _pstNode                        Concerned node
##  @return orxLINKLIST_NODE / nil
##

proc orxLinkList_GetNext*(pstNode: ptr orxLINKLIST_NODE): ptr orxLINKLIST_NODE {.
    inline, cdecl.} =
  ##  Checks
  assert(pstNode != nil)
  ##  Returns it
  return if (pstNode.pstList != nil): pstNode.pstNext else: cast[ptr orxLINKLIST_NODE](nil)

## * Gets a list first node
##  @param[in]   _pstList                        Concerned list
##  @return orxLINKLIST_NODE / nil
##

proc orxLinkList_GetFirst*(pstList: ptr orxLINKLIST): ptr orxLINKLIST_NODE {.inline,
    cdecl.} =
  ##  Checks
  assert(pstList != nil)
  ##  Returns it
  return pstList.pstFirst

## * Gets a list last node
##  @param[in]   _pstList                        Concerned list
##  @return orxLINKLIST_NODE / nil
##

proc orxLinkList_GetLast*(pstList: ptr orxLINKLIST): ptr orxLINKLIST_NODE {.inline,
    cdecl.} =
  ##  Checks
  assert(pstList != nil)
  ##  Returns it
  return pstList.pstLast

## * Gets a list count
##  @param[in]   _pstList                        Concerned list
##  @return Number of nodes in list
##

proc orxLinkList_GetCount*(pstList: ptr orxLINKLIST): orxU32 {.inline, cdecl.} =
  ##  Checks
  assert(pstList != nil)
  ##  Returns it
  return pstList.u32Count

## * @}
