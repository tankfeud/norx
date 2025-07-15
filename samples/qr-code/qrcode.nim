import norx
import qr

proc createQrPixel*(qrCode: ptr orxOBJECT, posX: int, posY: int, color: int) =
  var qrPixel =
      if color == 1: objectCreateFromConfig("QrPixelBlack")
      else: objectCreateFromConfig("QrPixelWhite")
  var posPixel = newVECTOR(posX, posY, 0)
  discard qrPixel.setPosition(addr(posPixel))
  qrPixel.setOwner(qrCode)
  discard qrPixel.setParent(qrCode)

proc showQrCodePopup*(qrText: string): ptr orxOBJECT =
  let
    border = 4
    qrCode = objectCreateFromConfig("QrCode")
    bkg = qrCode.getOwnedChild() # 1nd child
    matrix = qrRow(qrText)
    width = matrix[0].len
    height = matrix.len
  var size = newVECTOR(width + border * 2, height + border * 2, 0)
  discard bkg.setSize(addr(size))
  for y, line in matrix.pairs:
    for x, color in line.pairs:
      createQrPixel(qrCode, x + border, y + border, color)
  return qrCode
