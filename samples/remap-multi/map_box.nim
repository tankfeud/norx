import norx/[incl, obj, vector]

import norx/extras/[map_controls, joystick_extras]

type StepText* = tuple[step: MapStep, textObj: ptr orxOBJECT]

type MappingBox* = ref object
  joy*: JoyIdName
  steptexts*: seq[StepText]

proc destroy*(mapBox: MappingBox) =
  # TODO: TableRows obj with all children.... Gör setOwner(parent) på children
  orxLOG("destroy MappingBox for " & ${mapBox.joy.nr})
  for steptext in mapBox.steptexts:
    discard steptext.textObj.setLifeTime(orxFLOAT_0)

proc mapBox*(joyIdName: JoyIdName, steps: seq[MapStep], posXBase: int, posYBase: int): MappingBox =

  var boxWidth = 250
  var boxHeight = 150

  var rowWidth = boxWidth
  var rowHeight = 30
  var fontHeight = 14
  var textOffsetY = (rowHeight - fontHeight) / 2

  var posY = posYBase + rowHeight

  # Controller name in one row
  var posBase: orxVECTOR = (posXBase.cfloat, posY.cfloat, 0.cfloat)
  var headerObj = objectCreateFromConfig("TableRow")
  discard headerObj.setPosition(addr(posBase))
  var nameObj = objectCreateFromConfig("RetroTextObject")
  var posText: orxVECTOR = (posXBase.cfloat, (posY + textOffsetY.int).cfloat, 0.cfloat)
  discard nameObj.setPosition(addr(posText))
  discard nameObj.setTextString(joyIdName.name.cstring)
  posY += rowHeight

  # black box with ship
  var boxObj = objectCreateFromConfig("ShipBox")
  var shipObj = objectCreateFromConfig("Ship")
  #Position         = (-475, -125, -1)

  var posBox: orxVECTOR = (posXBase.cfloat, posY.cfloat, 0.cfloat)
  discard boxObj.setPosition(addr(posBox))
  var shipPos: orxVECTOR = ((posXBase + (boxWidth/2).int).cfloat, (posY + (boxHeight/2).int).cfloat, -1.cfloat)
  discard shipObj.setPosition(addr(shipPos))
  posY += boxHeight

  var rowTexts: seq[StepText] = @[]
  var posx = posXBase
  for step in steps:
    var pos = (posX.cfloat, posY.cfloat, 0.cfloat)
    var rowObj = objectCreateFromConfig("TableRow")
    discard rowObj.setPosition(addr(pos))

    # var textObj = objectCreateFromConfig("RetroTextObject")
    var textObj = rowObj.getOwnedChild()
    rowTexts.add((step, textObj))
    #discard textObj.setPosition(addr(posText))
    #posText = (posXBase.cfloat, (posY + textOffsetY.int).cfloat, 0.cfloat)
    #discard textObj.setTextString(joyIdName.name)

    posY += rowHeight

  return MappingBox(joy: joyIdName, steptexts: rowTexts)
