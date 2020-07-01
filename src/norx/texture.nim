import incl, display, math

## * Defines
##

const
  orxTEXTURE_KZ_RESOURCE_GROUP* = "Texture"
  orxTEXTURE_KZ_SCREEN* = "screen"
  orxTEXTURE_KZ_PIXEL* = "pixel"

## * Event enum
##

type
  orxTEXTURE_EVENT* {.size: sizeof(cint).} = enum
    orxTEXTURE_EVENT_CREATE = 0, orxTEXTURE_EVENT_DELETE, orxTEXTURE_EVENT_LOAD,
    orxTEXTURE_EVENT_NUMBER, orxTEXTURE_EVENT_NONE = orxENUM_NONE


## * Internal texture structure

type orxTEXTURE* = object

proc textureSetup*() {.cdecl, importc: "orxTexture_Setup", dynlib: libORX.}
  ## Setups the texture module

proc textureInit*(): orxSTATUS {.cdecl, importc: "orxTexture_Init",
                                  dynlib: libORX.}
  ## Inits the texture module
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc textureExit*() {.cdecl, importc: "orxTexture_Exit", dynlib: libORX.}
  ## Exits from the texture module

proc textureCreate*(): ptr orxTEXTURE {.cdecl, importc: "orxTexture_Create",
                                        dynlib: libORX.}
  ## Creates an empty texture
  ##  @return      orxTEXTURE / nil

proc createFromFile*(zFileName: cstring; bKeepInCache: orxBOOL): ptr orxTEXTURE {.
    cdecl, importc: "orxTexture_CreateFromFile", dynlib: libORX.}
  ## Creates a texture from a bitmap file
  ##  @param[in]   _zFileName      Name of the bitmap
  ##  @param[in]   _bKeepInCache   Should be kept in cache after no more references exist?
  ##  @return      orxTEXTURE / nil

proc delete*(pstTexture: ptr orxTEXTURE): orxSTATUS {.cdecl,
    importc: "orxTexture_Delete", dynlib: libORX.}
  ## Deletes a texture (and its referenced bitmap)
  ##  @param[in]   _pstTexture     Concerned texture
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc clearCache*(): orxSTATUS {.cdecl, importc: "orxTexture_ClearCache",
                                        dynlib: libORX.}
  ## Clears cache (if any texture is still in active use, it'll remain in memory until not referenced anymore)
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc linkBitmap*(pstTexture: ptr orxTEXTURE; pstBitmap: ptr orxBITMAP;
                           zDataName: cstring; bTransferOwnership: orxBOOL): orxSTATUS {.
    cdecl, importc: "orxTexture_LinkBitmap", dynlib: libORX.}
  ## Links a bitmap
  ##  @param[in]   _pstTexture     Concerned texture
  ##  @param[in]   _pstBitmap      Bitmap to link
  ##  @param[in]   _zDataName      Name associated with the bitmap (usually filename)
  ##  @param[in]   _bTransferOwnership If set to true, the texture will become the bitmap's owner and will have it deleted upon its own deletion
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc unlinkBitmap*(pstTexture: ptr orxTEXTURE): orxSTATUS {.cdecl,
    importc: "orxTexture_UnlinkBitmap", dynlib: libORX.}
  ## Unlinks (and deletes if not used anymore) a bitmap
  ##  @param[in]   _pstTexture     Concerned texture
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getBitmap*(pstTexture: ptr orxTEXTURE): ptr orxBITMAP {.cdecl,
    importc: "orxTexture_GetBitmap", dynlib: libORX.}
  ## Gets texture bitmap
  ##  @param[in]   _pstTexture     Concerned texture
  ##  @return      orxBITMAP / nil

proc getSize*(pstTexture: ptr orxTEXTURE; pfWidth: ptr orxFLOAT;
                        pfHeight: ptr orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxTexture_GetSize", dynlib: libORX.}
  ## Gets texture size
  ##  @param[in]   _pstTexture     Concerned texture
  ##  @param[out]  _pfWidth        Texture's width
  ##  @param[out]  _pfHeight       Texture's height
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getName*(pstTexture: ptr orxTEXTURE): cstring {.cdecl,
    importc: "orxTexture_GetName", dynlib: libORX.}
  ## Gets texture name
  ##  @param[in]   _pstTexture   Concerned texture
  ##  @return      Texture name / orxSTRING_EMPTY

proc getScreenTexture*(): ptr orxTEXTURE {.cdecl,
    importc: "orxTexture_GetScreenTexture", dynlib: libORX.}
  ## Gets screen texture
  ##  @return      Screen texture / nil

proc getLoadCount*(): orxU32 {.cdecl, importc: "orxTexture_GetLoadCount",
                                       dynlib: libORX.}
  ## Gets pending load count
  ##  @return      Pending load count

