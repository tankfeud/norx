import incl, debug

type
  orxTREE_NODE* {.bycopy.} = object
    pstParent*: ptr orxTREE_NODE ## *< Parent node pointer : 4/8
    pstChild*: ptr orxTREE_NODE  ## *< First child node pointer : 8/16
    pstSibling*: ptr orxTREE_NODE ## *< Next sibling node pointer : 12/24
    pstPrevious*: ptr orxTREE_NODE ## *< Previous sibling node pointer : 16/32
    pstTree*: ptr orxTREE        ## *< Associated tree pointer : 20/40
  orxTREE* {.bycopy.} = object
    pstRoot*: ptr orxTREE_NODE  ## *< Root node pointer : 4/8
    u32Count*: orxU32          ## *< Node count : 8/12

proc clean*(pstTree: ptr orxTREE): orxSTATUS {.cdecl,
    importc: "orxTree_Clean", dynlib: libORX.}
  ## Cleans a tree
  ##  @param[in]   _pstTree                        Concerned tree
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc addRoot*(pstTree: ptr orxTREE; pstNode: ptr orxTREE_NODE): orxSTATUS {.
    cdecl, importc: "orxTree_AddRoot", dynlib: libORX.}
  ## Adds a node at the root of a tree
  ##  @param[in]   _pstTree                        Concerned tree
  ##  @param[in]   _pstNode                        Node to add
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc addParent*(pstRefNode: ptr orxTREE_NODE; pstNode: ptr orxTREE_NODE): orxSTATUS {.
    cdecl, importc: "orxTree_AddParent", dynlib: libORX.}
  ## Adds a node as a parent of another one
  ##  @param[in]   _pstRefNode                     Reference node (add as a parent of this one)
  ##  @param[in]   _pstNode                        Node to add
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc addSibling*(pstRefNode: ptr orxTREE_NODE; pstNode: ptr orxTREE_NODE): orxSTATUS {.
    cdecl, importc: "orxTree_AddSibling", dynlib: libORX.}
  ## Adds a node as a sibling of another one
  ##  @param[in]   _pstRefNode                     Reference node (add as a sibling of this one)
  ##  @param[in]   _pstNode                        Node to add
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc addChild*(pstRefNode: ptr orxTREE_NODE; pstNode: ptr orxTREE_NODE): orxSTATUS {.
    cdecl, importc: "orxTree_AddChild", dynlib: libORX.}
  ## Adds a node as a child of another one
  ##  @param[in]   _pstRefNode                     Reference node (add as a child of this one)
  ##  @param[in]   _pstNode                        Node to add
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc moveAsChild*(pstRefNode: ptr orxTREE_NODE; pstNode: ptr orxTREE_NODE): orxSTATUS {.
    cdecl, importc: "orxTree_MoveAsChild", dynlib: libORX.}
  ## Moves a node as a child of another one of the same tree
  ##  @param[in]   _pstRefNode                     Reference node (move as a child of this one)
  ##  @param[in]   _pstNode                        Node to move
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc remove*(pstNode: ptr orxTREE_NODE): orxSTATUS {.cdecl,
    importc: "orxTree_Remove", dynlib: libORX.}
  ## Removes a node from its tree
  ##  @param[in]   _pstNode                        Concerned node
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getTree*(pstNode: ptr orxTREE_NODE): ptr orxTREE {.inline, cdecl.} =
  ##  *** Tree inlined accessors ***
  ## Gets a node tree
  ##  @param[in]   _pstNode                        Concerned node
  ##  @return orxTREE / nil
  ##  Checks
  assert(pstNode != nil)
  ##  Returns it
  return pstNode.pstTree

proc getParent*(pstNode: ptr orxTREE_NODE): ptr orxTREE_NODE {.inline, cdecl.} =
  ## Gets parent node
  ##  @param[in]   _pstNode                        Concerned node
  ##  @return orxTREE_NODE / nil
  ##  Checks
  assert(pstNode != nil)
  ##  Returns it
  return if (pstNode.pstTree != nil): pstNode.pstParent else: cast[ptr orxTREE_NODE](nil)

proc getChild*(pstNode: ptr orxTREE_NODE): ptr orxTREE_NODE {.inline, cdecl.} =
  ## Gets first child node
  ##  @param[in]   _pstNode                        Concerned node
  ##  @return orxTREE_NODE / nil
  ##  Checks
  assert(pstNode != nil)
  ##  Returns it
  return if (pstNode.pstTree != nil): pstNode.pstChild else: cast[ptr orxTREE_NODE](nil)

proc getSibling*(pstNode: ptr orxTREE_NODE): ptr orxTREE_NODE {.inline, cdecl.} =
  ## Gets (next) sibling node
  ##  @param[in]   _pstNode                        Concerned node
  ##  @return orxTREE_NODE / nil
  ##  Checks
  assert(pstNode != nil)
  ##  Returns it
  return if (pstNode.pstTree != nil): pstNode.pstSibling else: cast[ptr orxTREE_NODE](nil)

proc getPrevious*(pstNode: ptr orxTREE_NODE): ptr orxTREE_NODE {.inline, cdecl.} =
  ## Gets previous sibling node
  ##  @param[in]   _pstNode                        Concerned node
  ##  @return orxTREE_NODE / nil
  ##  Checks
  assert(pstNode != nil)
  ##  Returns it
  return if (pstNode.pstTree != nil): pstNode.pstPrevious else: cast[ptr orxTREE_NODE](nil)

proc getRoot*(pstTree: ptr orxTREE): ptr orxTREE_NODE {.inline, cdecl.} =
  ## Gets a tree root
  ##  @param[in]   _pstTree                        Concerned tree
  ##  @return orxTREE_NODE / nil
  ##  Checks
  assert(pstTree != nil)
  ##  Returns it
  return pstTree.pstRoot

proc getCount*(pstTree: ptr orxTREE): orxU32 {.inline, cdecl.} =
  ## Gets a tree count
  ##  @param[in]   _pstTree                        Concerned tree
  ##  @return Number of nodes in tree
  ##  Checks
  assert(pstTree != nil)
  ##  Returns it
  return pstTree.u32Count
