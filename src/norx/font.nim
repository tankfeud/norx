import incl, texture, vector, display

## * Misc defines
##

const
  orxFONT_KZ_DEFAULT_FONT_NAME* = "default"

## * Internal font structure

type orxFONT* = object

proc fontSetup*() {.cdecl, importc: "orxFont_Setup", dynlib: libORX.}
  ## Setups the font module

proc fontInit*(): orxSTATUS {.cdecl, importc: "orxFont_Init", dynlib: libORX.}
  ## Inits the font module
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc fontExit*() {.cdecl, importc: "orxFont_Exit", dynlib: libORX.}
  ## Exits from the font module

proc fontCreate*(): ptr orxFONT {.cdecl, importc: "orxFont_Create",
                                  dynlib: libORX.}
  ## Creates an empty font
  ##  @return      orxFONT / nil

proc fontCreateFromConfig*(zConfigID: cstring): ptr orxFONT {.cdecl,
    importc: "orxFont_CreateFromConfig", dynlib: libORX.}
  ## Creates a font from config
  ##  @param[in]   _zConfigID    Config ID
  ##  @return      orxFONT / nil

proc delete*(pstFont: ptr orxFONT): orxSTATUS {.cdecl,
    importc: "orxFont_Delete", dynlib: libORX.}
  ## Deletes a font
  ##  @param[in]   _pstFont      Concerned font
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getDefaultFont*(): ptr orxFONT {.cdecl,
    importc: "orxFont_GetDefaultFont", dynlib: libORX.}
  ## Gets default font
  ##  @return      Default font / nil

proc setTexture*(pstFont: ptr orxFONT; pstTexture: ptr orxTEXTURE): orxSTATUS {.
    cdecl, importc: "orxFont_SetTexture", dynlib: libORX.}
  ## Sets font's texture
  ##  @param[in]   _pstFont      Concerned font
  ##  @param[in]   _pstTexture   Texture to set
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setCharacterList*(pstFont: ptr orxFONT; zList: cstring): orxSTATUS {.
    cdecl, importc: "orxFont_SetCharacterList", dynlib: libORX.}
  ## Sets font's character list
  ##  @param[in]   _pstFont      Concerned font
  ##  @param[in]   _zList        Character list
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setCharacterHeight*(pstFont: ptr orxFONT; fCharacterHeight: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxFont_SetCharacterHeight", dynlib: libORX.}
  ## Sets font's character height
  ##  @param[in]   _pstFont              Concerned font
  ##  @param[in]   _fCharacterHeight     Character's height
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setCharacterWidthList*(pstFont: ptr orxFONT;
                                   u32CharacterNumber: orxU32;
                                   afCharacterWidthList: ptr orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxFont_SetCharacterWidthList", dynlib: libORX.}
  ## Sets font's character width list
  ##  @param[in]   _pstFont              Concerned font
  ##  @param[in]   _u32CharacterNumber   Character's number
  ##  @param[in]   _afCharacterWidthList List of widths for all the characters
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setCharacterSpacing*(pstFont: ptr orxFONT; pvSpacing: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxFont_SetCharacterSpacing", dynlib: libORX.}
  ## Sets font's character spacing
  ##  @param[in]   _pstFont      Concerned font
  ##  @param[in]   _pvSpacing    Character's spacing
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setOrigin*(pstFont: ptr orxFONT; pvOrigin: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxFont_SetOrigin", dynlib: libORX.}
  ## Sets font's origin
  ##  @param[in]   _pstFont      Concerned font
  ##  @param[in]   _pvOrigin     Font's origin
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setSize*(pstFont: ptr orxFONT; pvSize: ptr orxVECTOR): orxSTATUS {.cdecl,
    importc: "orxFont_SetSize", dynlib: libORX.}
  ## Sets font's size
  ##  @param[in]   _pstFont      Concerned font
  ##  @param[in]   _pvSize       Font's size
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getTexture*(pstFont: ptr orxFONT): ptr orxTEXTURE {.cdecl,
    importc: "orxFont_GetTexture", dynlib: libORX.}
  ## Gets font's texture
  ##  @param[in]   _pstFont      Concerned font
  ##  @return      Font texture / nil

proc getCharacterList*(pstFont: ptr orxFONT): cstring {.cdecl,
    importc: "orxFont_GetCharacterList", dynlib: libORX.}
  ## Gets font's character list
  ##  @param[in]   _pstFont      Concerned font
  ##  @return      Font's character list / nil

proc getCharacterHeight*(pstFont: ptr orxFONT): orxFLOAT {.cdecl,
    importc: "orxFont_GetCharacterHeight", dynlib: libORX.}
  ## Gets font's character height
  ##  @param[in]   _pstFont                Concerned font
  ##  @return      orxFLOAT

proc getCharacterWidth*(pstFont: ptr orxFONT; u32CharacterCodePoint: orxU32): orxFLOAT {.
    cdecl, importc: "orxFont_GetCharacterWidth", dynlib: libORX.}
  ## Gets font's character width
  ##  @param[in]   _pstFont                Concerned font
  ##  @param[in]   _u32CharacterCodePoint  Character code point
  ##  @return      orxFLOAT

proc getCharacterSpacing*(pstFont: ptr orxFONT; pvSpacing: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxFont_GetCharacterSpacing", dynlib: libORX.}
  ## Gets font's character spacing
  ##  @param[in]   _pstFont      Concerned font
  ##  @param[out]  _pvSpacing    Character's spacing
  ##  @return      orxVECTOR / nil

proc getOrigin*(pstFont: ptr orxFONT; pvOrigin: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxFont_GetOrigin", dynlib: libORX.}
  ## Gets font's origin
  ##  @param[in]   _pstFont      Concerned font
  ##  @param[out]  _pvOrigin     Font's origin
  ##  @return      orxVECTOR / nil

proc getSize*(pstFont: ptr orxFONT; pvSize: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxFont_GetSize", dynlib: libORX.}
  ## Gets font's size
  ##  @param[in]   _pstFont      Concerned font
  ##  @param[out]  _pvSize       Font's size
  ##  @return      orxVECTOR / nil

proc getMap*(pstFont: ptr orxFONT): ptr orxCHARACTER_MAP {.cdecl,
    importc: "orxFont_GetMap", dynlib: libORX.}
  ## Gets font's map
  ##  @param[in]   _pstFont      Concerned font
  ##  @return      orxCHARACTER_MAP / nil

proc getName*(pstFont: ptr orxFONT): cstring {.cdecl,
    importc: "orxFont_GetName", dynlib: libORX.}
  ## Gets font name
  ##  @param[in]   _pstFont      Concerned font
  ##  @return      Font name / orxSTRING_EMPTY

