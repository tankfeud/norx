
import incl, vector, pure/math, memory, decl

type
  orxOBOX* {.bycopy.} = object
    ## Public oriented box structure
    vPosition*: orxVECTOR      ## Position vector  : 12
    vPivot*: orxVECTOR         ## Pivot vector     : 24
    vX*: orxVECTOR             ## X axis vector    : 36
    vY*: orxVECTOR             ## Y axis vector    : 48
    vZ*: orxVECTOR             ## Z axis vector    : 60

proc twoDSet*(pstRes: ptr orxOBOX; pvWorldPosition: ptr orxVECTOR;
                   pvPivot: ptr orxVECTOR; pvSize: ptr orxVECTOR; fAngle: orxFLOAT): ptr orxOBOX {.
    inline, cdecl.} =
  ## Sets 2D oriented box values
  ##  @param[out]  _pstRes                       OBox to set
  ##  @param[in]   _pvWorldPosition              World space position vector
  ##  @param[in]   _pvPivot                      Pivot vector
  ##  @param[in]   _pvSize                       Size vector
  ##  @param[in]   _fAngle                       Z-axis angle (radians)
  ##  @return      orxOBOX / nil
  var
    fCos: orxFLOAT
    fSin: orxFLOAT
  ##  Checks
  assert(pstRes != nil)
  assert(pvWorldPosition != nil)
  assert(pvPivot != nil)
  ##  Gets cosine and sine
  if fAngle == orxFLOAT_0:
    fCos = orxFLOAT_1
    fSin = orxFLOAT_0
  else:
    fCos = cos(fAngle)
    fSin = sin(fAngle)
  ##  Sets axis
  set(addr((pstRes.vX)), fCos * pvSize.fX, fSin * pvSize.fX, orxFLOAT_0)
  set(addr((pstRes.vY)), -(fSin * pvSize.fY), fCos * pvSize.fY, orxFLOAT_0)
  set(addr((pstRes.vZ)), orxFLOAT_0, orxFLOAT_0, pvSize.fZ)
  ##  Sets pivot
  set(addr((pstRes.vPivot)), (fCos * pvPivot.fX) - (fSin * pvPivot.fY),
                (fSin * pvPivot.fX) + (fCos * pvPivot.fY), pvPivot.fZ)
  ##  Sets box position
  copy(addr((pstRes.vPosition)), pvWorldPosition)
  ##  Done!
  return pstRes

proc copy*(pstDst: ptr orxOBOX; pstSrc: ptr orxOBOX): ptr orxOBOX {.inline, cdecl.} =
  ## Copies an OBox onto another one
  ##  @param[out]  _pstDst                       OBox to copy to (destination)
  ##  @param[in]   _pstSrc                       OBox to copy from (destination)
  ##  @return      Destination OBox
  ##  Checks
  assert(pstDst != nil)
  assert(pstSrc != nil)
  ##  Copies it
  memory.copy(pstDst, pstSrc, sizeof((orxOBOX)).orxU32)
  ##  Done!
  return pstDst

proc getCenter*(pstOp: ptr orxOBOX; pvRes: ptr orxVECTOR): ptr orxVECTOR {.
    inline, cdecl.} =
  ## Gets OBox center position
  ##  @param[in]   _pstOp                        Concerned OBox
  ##  @param[out]  _pvRes                        Center position
  ##  @return      Center position vector
  ##  Checks
  assert(pstOp != nil)
  assert(pvRes != nil)
  ##  Gets box center
  add(pvRes, add(pvRes, addr((pstOp.vX)), addr((pstOp.vY))), addr((pstOp.vZ)))
  mulf(pvRes, pvRes, orx2F(0.5))
  sub(pvRes, add(pvRes, pvRes, addr((pstOp.vPosition))), addr((pstOp.vPivot)))
  ##  Done!
  return pvRes

proc move*(pstRes: ptr orxOBOX; pstOp: ptr orxOBOX; pvMove: ptr orxVECTOR): ptr orxOBOX {.
    inline, cdecl.} =
  ## Moves an OBox
  ##  @param[out]  _pstRes                       OBox where to store result
  ##  @param[in]   _pstOp                        OBox to move
  ##  @param[in]   _pvMove                       Move vector
  ##  @return      Moved OBox
  ##  Checks
  assert(pstRes != nil)
  assert(pstOp != nil)
  assert(pvMove != nil)
  ##  Updates result
  add(addr((pstRes.vPosition)), addr((pstOp.vPosition)), pvMove)
  ##  Done!
  return pstRes

proc twoDRotate*(pstRes: ptr orxOBOX; pstOp: ptr orxOBOX; fAngle: orxFLOAT): ptr orxOBOX {.
    inline, cdecl.} =
  ## Rotates in 2D an OBox
  ##  @param[out]  _pstRes                       OBox where to store result
  ##  @param[in]   _pstOp                        OBox to rotate (its Z-axis vector will be unchanged)
  ##  @param[in]   _fAngle                       Z-axis rotation angle (radians)
  ##  @return      Rotated OBox
  var
    fSin: orxFLOAT
    fCos: orxFLOAT
  ##  Checks
  assert(pstRes != nil)
  assert(pstOp != nil)
  ##  Gets cos & sin of angle
  if fAngle == orxFLOAT_0:
    fCos = orxFLOAT_1
    fSin = orxFLOAT_0
  else:
    fCos = cos(fAngle)
    fSin = sin(fAngle)
  ##  Updates axis
  set(addr((pstRes.vX)), (fCos * pstOp.vX.fX) - (fSin * pstOp.vX.fY),
                (fSin * pstOp.vX.fX) + (fCos * pstOp.vX.fY), pstOp.vX.fZ)
  set(addr((pstRes.vY)), (fCos * pstOp.vY.fX) - (fSin * pstOp.vY.fY),
                (fSin * pstOp.vY.fX) + (fCos * pstOp.vY.fY), pstOp.vY.fZ)
  ##  Updates pivot
  set(addr((pstRes.vPivot)),
                (fCos * pstOp.vPivot.fX) - (fSin * pstOp.vPivot.fY),
                (fSin * pstOp.vPivot.fX) + (fCos * pstOp.vPivot.fY), pstOp.vPivot.fZ)
  ##  Done!
  return pstRes

proc isInside*(pstBox: ptr orxOBOX; pvPosition: ptr orxVECTOR): bool {.
    inline, cdecl.} =
  ## Is position inside oriented box test
  ##  @param[in]   _pstBox                       Box to test against position
  ##  @param[in]   _pvPosition                   Position to test against the box
  ##  @return      orxTRUE if position is inside the box, orxFALSE otherwise
  var fProj: orxFLOAT
  var vToPos: orxVECTOR
  ##  Checks
  assert(pstBox != nil)
  assert(pvPosition != nil)
  ##  Gets origin to position vector
  sub(addr(vToPos), pvPosition, sub(addr(vToPos),
      addr((pstBox.vPosition)), addr((pstBox.vPivot))))
  ##  Z-axis test
  fProj = dot(addr(vToPos), addr(pstBox.vZ))
  if (fProj >= orxFLOAT_0) and
      (fProj <= getSquareSize(addr((pstBox.vZ)))):
    ##  X-axis test
    fProj = dot(addr(vToPos), addr(pstBox.vX))
    if (fProj >= orxFLOAT_0) and
        (fProj <= getSquareSize(addr((pstBox.vX)))):
      ##  Y-axis test
      fProj = dot(addr(vToPos), addr(pstBox.vY))
      if (fProj >= orxFLOAT_0) and
          (fProj <= getSquareSize(addr((pstBox.vY)))):
        ##  Updates result
        return true
  return false

proc twoDIsInside*(pstBox: ptr orxOBOX; pvPosition: ptr orxVECTOR): bool {.
    inline, cdecl.} =
  ## Is 2D position inside oriented box test
  ##  @param[in]   _pstBox                       Box to test against position
  ##  @param[in]   _pvPosition                   Position to test against the box (no Z-test)
  ##  @return      orxTRUE if position is inside the box, orxFALSE otherwise
  var
    fProj: orxFLOAT
    fSize: orxFLOAT
  var vToPos: orxVECTOR
  ##  Checks
  assert(pstBox != nil)
  assert(pvPosition != nil)
  ##  Gets origin to position vector
  sub(addr(vToPos), pvPosition, sub(addr(vToPos),
      addr((pstBox.vPosition)), addr((pstBox.vPivot))))
  ##  X-axis test
  fProj = dot(addr(vToPos), addr(pstBox.vX))
  if fProj >= orxFLOAT_0:
    fSize = getSquareSize(addr(pstBox.vX))
    if fSize > orxFLOAT_0 and fProj <= fSize:
      ##  Y-axis test
      fProj = dot(addr(vToPos), addr(pstBox.vY))
      if fProj >= orxFLOAT_0:
        fSize = getSquareSize(addr(pstBox.vY))
        if fSize > orxFLOAT_0 and fProj <= fSize:
          return true
  return false

proc zAlignedTestIntersection*(pstBox1: ptr orxOBOX; pstBox2: ptr orxOBOX): orxBOOL {.
    inline, cdecl.} =
  ## Tests oriented box intersection (simple Z-axis test, to use with Z-axis aligned orxOBOX)
  ##  @param[in]   _pstBox1                      First box operand
  ##  @param[in]   _pstBox2                      Second box operand
  ##  @return      orxTRUE if boxes intersect, orxFALSE otherwise
  var bResult: orxBOOL
  ##  Checks
  assert(pstBox1 != nil)
  assert(pstBox2 != nil)
  assert(pstBox1.vZ.fX == orxFLOAT_0)
  assert(pstBox1.vZ.fY == orxFLOAT_0)
  assert(pstBox1.vZ.fZ >= orxFLOAT_0)
  ##  Z intersected?
  if (pstBox2.vPosition.fZ + pstBox2.vZ.fZ >= pstBox1.vPosition.fZ) and
      (pstBox2.vPosition.fZ <= pstBox1.vPosition.fZ + pstBox1.vZ.fZ):
    var i: orxU32
    var
      vOrigin1: orxVECTOR
      vOrigin2: orxVECTOR
      pvOrigin1: ptr orxVECTOR
      pvOrigin2: ptr orxVECTOR
      pvTemp: ptr orxVECTOR
    var
      pstBox1: ptr orxOBOX
      pstBox2: ptr orxOBOX
      pstTemp: ptr orxOBOX
    ##  Computes boxes origins
    vOrigin1.fX = pstBox1.vPosition.fX - pstBox1.vPivot.fX
    vOrigin1.fY = pstBox1.vPosition.fY - pstBox1.vPivot.fY
    vOrigin2.fX = pstBox2.vPosition.fX - pstBox2.vPivot.fX
    vOrigin2.fY = pstBox2.vPosition.fY - pstBox2.vPivot.fY
    ##  Test each box against the other
    i = 2
    bResult = orxTRUE
    while i != 0:
      var vToCorner: array[4, orxVECTOR]
      var pvAxis: ptr orxVECTOR
      var j: orxU32
      ##  Gets to-corner vectors
      vToCorner[0].fX = pvOrigin2.fX - pvOrigin1.fX
      vToCorner[0].fY = pvOrigin2.fY - pvOrigin1.fY
      vToCorner[1].fX = vToCorner[0].fX + pstBox2.vX.fX
      vToCorner[1].fY = vToCorner[0].fY + pstBox2.vX.fY
      vToCorner[2].fX = vToCorner[1].fX + pstBox2.vY.fX
      vToCorner[2].fY = vToCorner[1].fY + pstBox2.vY.fY
      vToCorner[3].fX = vToCorner[0].fX + pstBox2.vY.fX
      vToCorner[3].fY = vToCorner[0].fY + pstBox2.vY.fY
      ##  For both axis
      j = 2
      pvAxis = addr((pstBox1.vX))
      while j != 0:
        var
          fMin: orxFLOAT
          fMax: orxFLOAT
          fProj: orxFLOAT
        var k: orxU32
        ##  Gets initial projected values
        fMin = twoDDot(addr(vToCorner[0]), pvAxis)
        fMax = fMin
        fProj = fMin
        ##  For all remaining corners
        k = 1
        while k < 4:
          ##  Gets projected value
          fProj = twoDDot(addr(vToCorner[k]), pvAxis)
          ##  Updates extrema
          if fProj > fMax:
            fMax = fProj
          elif fProj < fMin:
            fMin = fProj
          inc(k)
        ##  Not intersecting?
        if (fMax < orxFLOAT_0) or (fMin > getSquareSize(pvAxis)):
          ##  Updates result
          bResult = orxFALSE
          break
        dec(j)
        pvAxis = pvAxis.pointerAdd(1) #inc(pvAxis)
      dec(i)
      pstTemp = pstBox1
      pstBox1 = pstBox2
      pstBox2 = pstTemp
      pvTemp = pvOrigin1
      pvOrigin1 = pvOrigin2
      pvOrigin2 = pvTemp
  else:
    ##  Updates result
    bResult = orxFALSE
  ##  Done!
  return bResult