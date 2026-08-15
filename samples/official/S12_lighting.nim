## Port of the official ORX tutorial: lighting.
## Adapted to Nim by jseb at finiderire.com, modernized for Norx.

#[
  Pixel-based lighting in shaders, with optional bump maps. The code manages
  an array of lights (position, radius, color) and populates the fragment
  shader's parameters at runtime; the actual lighting happens in the shader
  defined in S12_lighting.ini.

  Normal maps are computed on the CPU the first time each object texture is
  loaded, using a hash table keyed by the texture name. A production game
  would batch this work or move it to the GPU, but doing it on object
  creation keeps the tutorial modular: new objects can be added in config
  with no extra knowledge of how their textures are processed.

  Controls:
  - Left mouse button creates a new light under the cursor.
  - Right mouse button clears all lights.
  - +/- increase/decrease the current light radius.
  - Space toggles alpha (makes holes in lit objects).
]#

import strformat
import norx
import os

import S_commons

{.push cdecl.}

type
  Light = object
    color: orxCOLOR
    position: orxVECTOR
    radius: orxFLOAT

const LightCount = 10

var
  lightList: array[LightCount, Light]
  lightIndex: orxS32
  textureTable: ptr orxHASHTABLE
  viewport: ptr orxVIEWPORT
  scene: ptr orxOBJECT

proc clearLights() =
  discard pushSection("Lighting")
  for light in mitems(lightList):
    var rgb: orxVECTOR
    discard getVector("Color", addr rgb)
    light.color.anon0.vRGB = rgb
    light.color.fAlpha = 0.0
    light.position = newVECTOR()
    light.radius = getFloat("Radius")
  discard popSection()
  lightIndex = 0

proc computeGreyImage(buffer: ptr orxU8, bufferSize: orxU32) =
  let pixels = cast[ptr UncheckedArray[orxU8]](buffer)
  var i = 0
  while i < bufferSize.int:
    var color: orxCOLOR
    discard setRGBA(addr color, rgbaSet(pixels[i], pixels[i + 1],
                                        pixels[i + 2], pixels[i + 3]))
    let grey = 0.299 * color.anon0.vRGB.fX +
               0.587 * color.anon0.vRGB.fY +
               0.114 * color.anon0.vRGB.fZ
    discard setAll(addr color.anon0.vRGB, grey)
    let pixel = toRGBA(addr color)
    pixels[i] = rgbaR(pixel)
    pixels[i + 1] = rgbaG(pixel)
    pixels[i + 2] = rgbaB(pixel)
    pixels[i + 3] = rgbaA(pixel)
    i += 4

proc computeNormalMap(srcBuffer, dstBuffer: ptr orxU8;
                      width, height: orxS32) =
  let
    src = cast[ptr UncheckedArray[orxU8]](srcBuffer)
    dst = cast[ptr UncheckedArray[orxU8]](dstBuffer)
  for y in 0 ..< height:
    for x in 0 ..< width:
      let
        index = (y * width + x) * 4
        leftIndex = (y * width + max(x - 1, 0)) * 4
        rightIndex = (y * width + min(x + 1, width - 1)) * 4
        upIndex = (max(y - 1, 0) * width + x) * 4
        downIndex = (min(y + 1, height - 1) * width + x) * 4
        left = orxFLOAT(src[leftIndex]) * colorNormalizer
        right = orxFLOAT(src[rightIndex]) * colorNormalizer
        up = orxFLOAT(src[upIndex]) * colorNormalizer
        down = orxFLOAT(src[downIndex]) * colorNormalizer
      var normal: orxCOLOR
      normal.anon0.vRGB = newVector((left - right) * 0.5 + 0.5,
                                    (down - up) * 0.5 + 0.5, 0.5)
      normal.fAlpha = 1.0
      let pixel = toRGBA(addr normal)
      dst[index] = rgbaR(pixel)
      dst[index + 1] = rgbaG(pixel)
      dst[index + 2] = rgbaB(pixel)
      dst[index + 3] = rgbaA(pixel)

proc createNormalMap(texture: ptr orxTEXTURE) =
  let name = texture.getName
  if name.isNil or name.len == 0:
    return

  let textureHash = hash(name)
  if textureTable.hashTableGet(textureHash).isNil:
    let bitmap = texture.getBitmap()
    var width, height: orxFLOAT
    discard getBitmapSize(bitmap, addr width, addr height)
    let bufferSize = (width * height).orxU32 * 4.orxU32

    let srcBuffer = cast[ptr orxU8](allocate(bufferSize, MEMORY_TYPE_VIDEO))
    let dstBuffer = cast[ptr orxU8](allocate(bufferSize, MEMORY_TYPE_VIDEO))
    discard getBitmapData(bitmap, srcBuffer, bufferSize)
    computeGreyImage(srcBuffer, bufferSize)
    computeNormalMap(srcBuffer, dstBuffer, width.orxS32, height.orxS32)

    let normalBitmap = createBitmap(width.orxU32, height.orxU32)
    discard setBitmapData(normalBitmap, dstBuffer, bufferSize)
    free(srcBuffer)
    free(dstBuffer)

    let normalTexture = textureCreate()
    discard normalTexture.linkBitmap(normalBitmap, ("NM_" & $name).cstring, true)
    discard textureTable.add(textureHash, cast[pointer](normalTexture))

proc eventHandler(event: ptr orxEVENT): orxSTATUS {.cdecl.} =
  if event.eType == EVENT_TYPE_SHADER and
      event.eID == ord(SHADER_EVENT_SET_PARAM):
    let payload = cast[ptr orxSHADER_EVENT_PAYLOAD](event.pstPayload)
    if payload.s32ParamIndex <= lightIndex:
      let paramName = $payload.zParamName
      case paramName
      of "UseBumpMap":
        let sender = cast[ptr orxOBJECT](event.hSender)
        discard pushSection(sender.getName)
        payload.anon0.fValue = (if getBool("UseBumpMap"): 1.0 else: 0.0)
        discard popSection()
      of "avLightColor":
        payload.anon0.vValue = lightList[payload.s32ParamIndex].color.anon0.vRGB
      of "afLightAlpha":
        payload.anon0.fValue = lightList[payload.s32ParamIndex].color.fAlpha
      of "avLightPos":
        payload.anon0.vValue = lightList[payload.s32ParamIndex].position
      of "afLightRadius":
        payload.anon0.fValue = lightList[payload.s32ParamIndex].radius
      of "NormalMap":
        let textureName = payload.anon0.pstValue.getName
        payload.anon0.pstValue =
          cast[ptr orxTEXTURE](textureTable.hashTableGet(hash(textureName)))
      of "vScreenSize":
        discard pushSection(DISPLAY_KZ_CONFIG_SECTION)
        discard getVector(DISPLAY_KZ_CONFIG_FRAMEBUFFER_SIZE,
                          addr payload.anon0.vValue)
        discard popSection()
      else:
        discard
  elif event.eType == EVENT_TYPE_TEXTURE and
      event.eID == ord(TEXTURE_EVENT_LOAD):
    createNormalMap(cast[ptr orxTEXTURE](event.hSender))
  result = STATUS_SUCCESS

proc update(clockInfo: ptr orxCLOCK_INFO, context: pointer) =
  # The current light follows the mouse, accounting for high-DPI scaling.
  var contentScale: orxVECTOR
  discard pushSection(DISPLAY_KZ_CONFIG_SECTION)
  discard getVector(DISPLAY_KZ_CONFIG_CONTENT_SCALE, addr contentScale)
  discard getPosition(addr lightList[lightIndex].position)
  lightList[lightIndex].position =
    mul(lightList[lightIndex].position, contentScale)
  discard popSection()

  if hasBeenActivated("CreateLight"):
    lightIndex = min(LightCount - 1, lightIndex + 1)
  elif hasBeenActivated("ClearLights"):
    clearLights()
  elif hasBeenActivated("IncreaseRadius"):
    lightList[lightIndex].radius += getValue("IncreaseRadius") * 0.05
  elif hasBeenActivated("DecreaseRadius"):
    lightList[lightIndex].radius =
      max(0.0, lightList[lightIndex].radius - getValue("DecreaseRadius") * 0.05)
  elif hasBeenActivated("ToggleAlpha"):
    lightList[lightIndex].color.fAlpha = 1.5 - lightList[lightIndex].color.fAlpha

proc init(): orxSTATUS =
  echo fmt"""
{bindingName("CreateLight")} will create a new light under the cursor.
{bindingName("ClearLights")} will clear all the lights from the scene.
{bindingName("IncreaseRadius")} will increase the radius of the current light.
{bindingName("DecreaseRadius")} will decrease the radius of the current light.
{bindingName("ToggleAlpha")} will toggle alpha on the light (ie. make holes in lit objects)."""

  discard addHandler(EVENT_TYPE_SHADER, eventHandler)
  discard addHandler(EVENT_TYPE_TEXTURE, eventHandler)

  textureTable = hashTableCreate(16, HASHTABLE_KU32_FLAG_NONE, MEMORY_TYPE_MAIN)
  viewport = viewportCreateFromConfig("Viewport")
  scene = objectCreateFromConfig("Scene")
  if viewport.isNil or scene.isNil:
    return STATUS_FAILURE

  clearLights()

  if clockRegister(clockGet(CLOCK_KZ_CORE), update, nil,
                   MODULE_ID_MAIN, CLOCK_PRIORITY_NORMAL).isFailure:
    return STATUS_FAILURE
  result = STATUS_SUCCESS

proc exit() {.cdecl.} =
  # This time we clean up what we created.
  discard objectDelete(scene)
  discard viewportDelete(viewport)
  discard hashTableDelete(textureTable)

proc bootstrap(): orxSTATUS =
  result = addStorage(CONFIG_KZ_RESOURCE_GROUP, getAppDir(), false)
  if result.isFailure:
    echo "Could not add config storage"

discard setBootstrap(bootstrap)
execute(init, run, exit)
