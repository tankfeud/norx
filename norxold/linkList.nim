import incl

type
  orxLINKLIST_NODE* {.bycopy.} = object
    pstNext*: ptr orxLINKLIST_NODE ## Next node pointer : 4/8
    pstPrevious*: ptr orxLINKLIST_NODE ## Previous node pointer : 8/16
    pstList*: ptr orxLINKLIST    ## Associated list pointer : 12/24
  orxLINKLIST* {.bycopy.} = object
    pstFirst*: ptr orxLINKLIST_NODE ## First node pointer : 4/8
    pstLast*: ptr orxLINKLIST_NODE ## Last node pointer : 8/16
    u32Count*: orxU32          ## Node count : 12/20

proc clean*(pstList: ptr orxLINKLIST): orxSTATUS {.cdecl,
    importc: "orxLinkList_Clean", dynlib: libORX.}
  ## Cleans a linklist
  ##  @param[in]   _pstList                        Concerned list
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc addStart*(pstList: ptr orxLINKLIST; pstNode: ptr orxLINKLIST_NODE): orxSTATUS {.
    cdecl, importc: "orxLinkList_AddStart", dynlib: libORX.}
  ## Adds a node at the start of a list
  ##  @param[in]   _pstList                        Concerned list
  ##  @param[in]   _pstNode                        Node to add
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc addEnd*(pstList: ptr orxLINKLIST; pstNode: ptr orxLINKLIST_NODE): orxSTATUS {.
    cdecl, importc: "orxLinkList_AddEnd", dynlib: libORX.}
  ## Adds a node at the end of a list
  ##  @param[in]   _pstList                        Concerned list
  ##  @param[in]   _pstNode                        Node to add
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc addBefore*(pstRefNode: ptr orxLINKLIST_NODE;
                           pstNode: ptr orxLINKLIST_NODE): orxSTATUS {.cdecl,
    importc: "orxLinkList_AddBefore", dynlib: libORX.}
  ## Adds a node before another one
  ##  @param[in]   _pstRefNode                     Reference node (add before this one)
  ##  @param[in]   _pstNode                        Node to add
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc addAfter*(pstRefNode: ptr orxLINKLIST_NODE;
                          pstNode: ptr orxLINKLIST_NODE): orxSTATUS {.cdecl,
    importc: "orxLinkList_AddAfter", dynlib: libORX.}
  ## Adds a node after another one
  ##  @param[in]   _pstRefNode                     Reference node (add after this one)
  ##  @param[in]   _pstNode                        Node to add
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc remove*(pstNode: ptr orxLINKLIST_NODE): orxSTATUS {.cdecl,
    importc: "orxLinkList_Remove", dynlib: libORX.}
  ## Removes a node from its list
  ##  @param[in]   _pstNode                        Concerned node
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getList*(pstNode: ptr orxLINKLIST_NODE): ptr orxLINKLIST {.inline,
    cdecl.} =
  ##  *** LinkList inlined accessors ***
  ## Gets a node list
  ##  @param[in]   _pstNode                        Concerned node
  ##  @return orxLINKLIST / nil
  ##  Checks
  assert(pstNode != nil)
  ##  Returns it
  return pstNode.pstList

proc getPrevious*(pstNode: ptr orxLINKLIST_NODE): ptr orxLINKLIST_NODE {.
    inline, cdecl.} =
  ## Gets previous node in list
  ##  @param[in]   _pstNode                        Concerned node
  ##  @return orxLINKLIST_NODE / nil
  ##  Checks
  assert(pstNode != nil)
  ##  Returns it
  return if (pstNode.pstList != nil): pstNode.pstPrevious else: cast[ptr orxLINKLIST_NODE](nil)

proc getNext*(pstNode: ptr orxLINKLIST_NODE): ptr orxLINKLIST_NODE {.
    inline, cdecl.} =
  ## Gets next node in list
  ##  @param[in]   _pstNode                        Concerned node
  ##  @return orxLINKLIST_NODE / nil
  ##  Checks
  assert(pstNode != nil)
  ##  Returns it
  return if (pstNode.pstList != nil): pstNode.pstNext else: cast[ptr orxLINKLIST_NODE](nil)

proc getFirst*(pstList: ptr orxLINKLIST): ptr orxLINKLIST_NODE {.inline,
    cdecl.} =
  ## Gets a list first node
  ##  @param[in]   _pstList                        Concerned list
  ##  @return orxLINKLIST_NODE / nil
  ##  Checks
  assert(pstList != nil)
  ##  Returns it
  return pstList.pstFirst

proc getLast*(pstList: ptr orxLINKLIST): ptr orxLINKLIST_NODE {.inline,
    cdecl.} =
  ## Gets a list last node
  ##  @param[in]   _pstList                        Concerned list
  ##  @return orxLINKLIST_NODE / nil
  ##  Checks
  assert(pstList != nil)
  ##  Returns it
  return pstList.pstLast

proc getCount*(pstList: ptr orxLINKLIST): orxU32 {.inline, cdecl.} =
  ## Gets a list count
  ##  @param[in]   _pstList                        Concerned list
  ##  @return Number of nodes in list
  ##  Checks
  assert(pstList != nil)
  ##  Returns it
  return pstList.u32Count
