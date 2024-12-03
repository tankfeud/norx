import norx/[obj, vector]
import qr

proc createQrPixel*(qrCode: ptr orxOBJECT, posX: int, posY: int, color: int) =

  var qrPixel =
      if color == 1: objectCreateFromConfig("QrPixelBlack")
      else: objectCreateFromConfig("QrPixelWhite")

  var posPixel: orxVECTOR = (posX.cfloat, posY.cfloat, 0.cfloat)
  discard qrPixel.setPosition(addr(posPixel))

  qrPixel.setOwner(qrCode)
  discard qrPixel.setParent(qrCode)

proc showQrCodePopup*(qrText: string): ptr orxOBJECT =
  let border = 4

  let qrCode = objectCreateFromConfig("QrCode")
  let bkg = qrCode.getOwnedChild() # 1nd child

  let
    matrix = qrRow(qrText)
    width = matrix[0].len
    height = matrix.len

  var size: orxVECTOR = ((width + border * 2).cfloat, (height + border * 2).cfloat, 0f)
  discard bkg.setSize(addr(size))

  for y, line in matrix.pairs:
    for x, color in line.pairs:
      createQrPixel(qrCode, x + border, y + border, color)

  return qrCode
