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

import incl, vector, memory, typ

## Public structure definition
type
  orxAABOX* {.bycopy.} = object
    vTL*: orxVECTOR            ## *< Top left corner vector : 12
    vBR*: orxVECTOR            ## *< Bottom right corner vector : 24

proc orxAABox_Reorder*(pstBox: ptr orxAABOX): ptr orxAABOX {.inline, cdecl.} =
  ##  Reorders AABox corners
  ##  @param[in]   pstBox                       Box to reorder
  ##  @return      Reordered AABox
  assert(pstBox != nil)
  ##  Reorders coordinates so as to have upper left & bottom right box corners
  ##  X coord
  if pstBox.vTL.fX > pstBox.vBR.fX:
    var fTemp: orxFLOAT
    ##  Swaps
    fTemp = pstBox.vTL.fX
    pstBox.vTL.fX = pstBox.vBR.fX
    pstBox.vBR.fX = fTemp
  if pstBox.vTL.fY > pstBox.vBR.fY:
    var fTemp: orxFLOAT
    ##  Swaps
    fTemp = pstBox.vTL.fY
    pstBox.vTL.fY = pstBox.vBR.fY
    pstBox.vBR.fY = fTemp
  if pstBox.vTL.fZ > pstBox.vBR.fZ:
    var fTemp: orxFLOAT
    ##  Swaps
    fTemp = pstBox.vTL.fZ
    pstBox.vTL.fZ = pstBox.vBR.fZ
    pstBox.vBR.fZ = fTemp
  return pstBox

## * Sets axis aligned box values
##  @param[out]  _pstRes                       AABox to set
##  @param[in]   _pvTL                         Top left corner
##  @param[in]   _pvBR                         Bottom right corner
##  @return      orxAABOX / nil
##

proc orxAABox_Set*(pstRes: ptr orxAABOX; pvTL: ptr orxVECTOR; pvBR: ptr orxVECTOR): ptr orxAABOX {.
    inline, cdecl.} =
  ##  Checks
  assert(pstRes != nil)
  assert(pvTL != nil)
  assert(pvBR != nil)
  ##  Sets values
  orxVector_Copy(addr((pstRes.vTL)), pvTL)
  orxVector_Copy(addr((pstRes.vBR)), pvBR)
  ##  Reorders corners
  orxAABox_Reorder(pstRes)

## * Is position inside axis aligned box test
##  @param[in]   _pstBox                       Box to test against position
##  @param[in]   _pvPosition                   Position to test against the box
##  @return      orxTRUE if position is inside the box, orxFALSE otherwise
##

proc orxAABox_IsInside*(pstBox: ptr orxAABOX; pvPosition: ptr orxVECTOR): orxBOOL {.
    inline, cdecl.} =
  var bResult: orxBOOL
  ##  Checks
  assert(pstBox != nil)
  assert(pvPosition != nil)
  ##  Z intersected?
  if (pvPosition.fZ >= pstBox.vTL.fZ) and (pvPosition.fZ <= pstBox.vBR.fZ):
    ##  X intersected?
    if (pvPosition.fX >= pstBox.vTL.fX) and (pvPosition.fX <= pstBox.vBR.fX):
      ##  Y intersected?
      if (pvPosition.fY >= pstBox.vTL.fY) and (pvPosition.fY <= pstBox.vBR.fY):
        ##  Intersects
        bResult = orxTRUE
  return bResult

## * Tests axis aligned box intersection
##  @param[in]   _pstBox1                      First box operand
##  @param[in]   _pstBox2                      Second box operand
##  @return      orxTRUE if boxes intersect, orxFALSE otherwise
##

proc orxAABox_TestIntersection*(pstBox1: ptr orxAABOX; pstBox2: ptr orxAABOX): orxBOOL {.
    inline, cdecl.} =
  var bResult: orxBOOL
  ##  Checks
  assert(pstBox1 != nil)
  assert(pstBox2 != nil)
  ##  Z intersected?
  if (pstBox2.vBR.fZ >= pstBox1.vTL.fZ) and (pstBox2.vTL.fZ <= pstBox1.vBR.fZ):
    ##  X intersected?
    if (pstBox2.vBR.fX >= pstBox1.vTL.fX) and (pstBox2.vTL.fX <= pstBox1.vBR.fX):
      ##  Y intersected?
      if (pstBox2.vBR.fY >= pstBox1.vTL.fY) and
          (pstBox2.vTL.fY <= pstBox1.vBR.fY):
        ##  Intersects
        bResult = orxTRUE
  return bResult

## * Tests axis aligned box 2D intersection (no Z-axis test)
##  @param[in]   _pstBox1                      First box operand
##  @param[in]   _pstBox2                      Second box operand
##  @return      orxTRUE if boxes intersect in 2D, orxFALSE otherwise
##

proc orxAABox_Test2DIntersection*(pstBox1: ptr orxAABOX; pstBox2: ptr orxAABOX): orxBOOL {.
    inline, cdecl.} =
  var bResult: orxBOOL
  ##  Checks
  assert(pstBox1 != nil)
  assert(pstBox2 != nil)
  ##  X intersected?
  if (pstBox2.vBR.fX >= pstBox1.vTL.fX) and (pstBox2.vTL.fX <= pstBox1.vBR.fX):
    ##  Y intersected?
    if (pstBox2.vBR.fY >= pstBox1.vTL.fY) and (pstBox2.vTL.fY <= pstBox1.vBR.fY):
      ##  Intersects
      bResult = orxTRUE
  return bResult

## * Copies an AABox onto another one
##  @param[out]   _pstDst                      AABox to copy to (destination)
##  @param[in]   _pstSrc                       AABox to copy from (destination)
##  @return      Destination AABox
##

proc orxAABox_Copy*(pstDst: ptr orxAABOX; pstSrc: ptr orxAABOX): ptr orxAABOX {.inline,
    cdecl.} =
  ##  Checks
  assert(pstDst != nil)
  assert(pstSrc != nil)
  ##  Copies it
  discard orxMemory_Copy(pstDst, pstSrc, sizeof((orxAABOX)).orxU32)
  ##  Done!
  return pstDst

## * Moves an AABox
##  @param[out]  _pstRes                       AABox where to store result
##  @param[in]   _pstOp                        AABox to move
##  @param[in]   _pvMove                       Move vector
##  @return      Moved AABox
##

proc orxAABox_Move*(pstRes: ptr orxAABOX; pstOp: ptr orxAABOX; pvMove: ptr orxVECTOR): ptr orxAABOX {.
    inline, cdecl.} =
  ##  Checks
  assert(pstRes != nil)
  assert(pstOp != nil)
  assert(pvMove != nil)
  ##  Updates result
  discard orxVector_Add(addr((pstRes.vTL)), addr((pstOp.vTL)), pvMove)
  discard orxVector_Add(addr((pstRes.vBR)), addr((pstOp.vBR)), pvMove)
  ##  Done!
  return pstRes

## * Gets AABox center position
##  @param[in]   _pstOp                        Concerned AABox
##  @param[out]  _pvRes                        Center position
##  @return      Center position vector
##

proc orxAABox_GetCenter*(pstOp: ptr orxAABOX; pvRes: ptr orxVECTOR): ptr orxVECTOR {.
    inline, cdecl.} =
  ##  Checks
  assert(pstOp != nil)
  assert(pvRes != nil)
  ##  Gets box center
  discard orxVector_Add(pvRes, addr((pstOp.vTL)), addr((pstOp.vBR)))
  orxVector_Mulf(pvRes, pvRes, orx2F(0.5))
  ##  Done!
  return pvRes

## * @}
