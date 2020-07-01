import incl,font

## * Internal text structure

type orxTEXT* = object

proc textSetup*() {.cdecl, importc: "orxText_Setup", dynlib: libORX.}
  ## Setups the text module

proc textInit*(): orxSTATUS {.cdecl, importc: "orxText_Init", dynlib: libORX.}
  ## Inits the text module
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc textExit*() {.cdecl, importc: "orxText_Exit", dynlib: libORX.}
  ## Exits from the text module

proc textCreate*(): ptr orxTEXT {.cdecl, importc: "orxText_Create",
                                  dynlib: libORX.}
  ## Creates an empty text
  ##  @return      orxTEXT / nil

proc textCreateFromConfig*(zConfigID: cstring): ptr orxTEXT {.cdecl,
    importc: "orxText_CreateFromConfig", dynlib: libORX.}
  ## Creates a text from config
  ##  @param[in]   _zConfigID    Config ID
  ##  @return      orxTEXT / nil

proc delete*(pstText: ptr orxTEXT): orxSTATUS {.cdecl,
    importc: "orxText_Delete", dynlib: libORX.}
  ## Deletes a text
  ##  @param[in]   _pstText      Concerned text
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getName*(pstText: ptr orxTEXT): cstring {.cdecl,
    importc: "orxText_GetName", dynlib: libORX.}
  ## Gets text name
  ##  @param[in]   _pstText      Concerned text
  ##  @return      Text name / nil

proc getLineCount*(pstText: ptr orxTEXT): orxU32 {.cdecl,
    importc: "orxText_GetLineCount", dynlib: libORX.}
  ## Gets text's line count
  ##  @param[in]   _pstText      Concerned text
  ##  @return      orxU32

proc getLineSize*(pstText: ptr orxTEXT; u32Line: orxU32;
                         pfWidth: ptr orxFLOAT; pfHeight: ptr orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxText_GetLineSize", dynlib: libORX.}
  ## Gets text's line size
  ##  @param[in]   _pstText      Concerned text
  ##  @param[out]  _u32Line      Line index
  ##  @param[out]  _pfWidth      Line's width
  ##  @param[out]  _pfHeight     Line's height
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc isFixedSize*(pstText: ptr orxTEXT): orxBOOL {.cdecl,
    importc: "orxText_IsFixedSize", dynlib: libORX.}
  ## Is text's size fixed? (ie. manually constrained with orxText_SetSize())
  ##  @param[in]   _pstText      Concerned text
  ##  @return      orxTRUE / orxFALSE

proc getSize*(pstText: ptr orxTEXT; pfWidth: ptr orxFLOAT;
                     pfHeight: ptr orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxText_GetSize", dynlib: libORX.}
  ## Gets text size
  ##  @param[in]   _pstText      Concerned text
  ##  @param[out]  _pfWidth      Text's width
  ##  @param[out]  _pfHeight     Text's height
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getString*(pstText: ptr orxTEXT): cstring {.cdecl,
    importc: "orxText_GetString", dynlib: libORX.}
  ## Gets text string
  ##  @param[in]   _pstText      Concerned text
  ##  @return      Text string / orxSTRING_EMPTY

proc getFont*(pstText: ptr orxTEXT): ptr orxFONT {.cdecl,
    importc: "orxText_GetFont", dynlib: libORX.}
  ## Gets text font
  ##  @param[in]   _pstText      Concerned text
  ##  @return      Text font / nil

proc setSize*(pstText: ptr orxTEXT; fWidth: orxFLOAT; fHeight: orxFLOAT;
                     pzExtra: cstringArray): orxSTATUS {.cdecl,
    importc: "orxText_SetSize", dynlib: libORX.}
  ## Sets text's size, will lead to reformatting if text doesn't fit (pass width = -1.0f to restore text's original size, ie. unconstrained)
  ##  @param[in]   _pstText      Concerned text
  ##  @param[in]   _fWidth       Max width for the text, remove any size constraint if negative
  ##  @param[in]   _fHeight      Max height for the text, ignored if negative (ie. unconstrained height)
  ##  @param[in]   _pzExtra      Text that wouldn't fit inside the box if height is provided, orxSTRING_EMPTY if no extra, nil to ignore
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setString*(pstText: ptr orxTEXT; zString: cstring): orxSTATUS {.cdecl,
    importc: "orxText_SetString", dynlib: libORX.}
  ## Sets text string
  ##  @param[in]   _pstText      Concerned text
  ##  @param[in]   _zString      String to contain
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setFont*(pstText: ptr orxTEXT; pstFont: ptr orxFONT): orxSTATUS {.cdecl,
    importc: "orxText_SetFont", dynlib: libORX.}
  ## Sets text font
  ##  @param[in]   _pstText      Concerned text
  ##  @param[in]   _pstFont      Font / nil to use default
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

