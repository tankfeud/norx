import incl, clock, camera, shaderPointer, display, texture, AABox

## * Viewport flags
##

const
  orxVIEWPORT_KU32_FLAG_ALIGN_CENTER* = 0x00000000
  orxVIEWPORT_KU32_FLAG_ALIGN_LEFT* = 0x10000000
  orxVIEWPORT_KU32_FLAG_ALIGN_RIGHT* = 0x20000000
  orxVIEWPORT_KU32_FLAG_ALIGN_TOP* = 0x40000000
  orxVIEWPORT_KU32_FLAG_ALIGN_BOTTOM* = 0x80000000
  orxVIEWPORT_KU32_FLAG_NO_DEBUG* = 0x01000000

## * Misc defined
##

const
  orxVIEWPORT_KU32_MAX_TEXTURE_NUMBER* = 8

## * Internal Viewport structure

type orxVIEWPORT* = object
## * Event enum
##

type
  orxVIEWPORT_EVENT* {.size: sizeof(cint).} = enum
    orxVIEWPORT_EVENT_RESIZE = 0, ## *< Event sent when a viewport has been resized
    orxVIEWPORT_EVENT_NUMBER, orxVIEWPORT_EVENT_NONE = orxENUM_NONE


proc viewportSetup*() {.cdecl, importc: "orxViewport_Setup", dynlib: libORX.}
  ## Viewport module setup

proc viewportInit*(): orxSTATUS {.cdecl, importc: "orxViewport_Init",
                                   dynlib: libORX.}
  ## Inits the viewport module

proc viewportExit*() {.cdecl, importc: "orxViewport_Exit", dynlib: libORX.}
  ## Exits from the viewport module

proc viewportCreate*(): ptr orxVIEWPORT {.cdecl, importc: "orxViewport_Create",
    dynlib: libORX.}
  ## Creates a viewport
  ##  @return      Created orxVIEWPORT / nil

proc viewportCreateFromConfig*(zConfigID: cstring): ptr orxVIEWPORT {.cdecl,
    importc: "orxViewport_CreateFromConfig", dynlib: libORX.}
  ## Creates a viewport from config
  ##  @param[in]   _zConfigID    Config ID
  ##  @ return orxVIEWPORT / nil

proc delete*(pstViewport: ptr orxVIEWPORT): orxSTATUS {.cdecl,
    importc: "orxViewport_Delete", dynlib: libORX.}
  ## Deletes a viewport
  ##  @param[in]   _pstViewport    Viewport to delete
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setTextureList*(pstViewport: ptr orxVIEWPORT;
                                u32TextureNumber: orxU32;
                                apstTextureList: ptr ptr orxTEXTURE) {.cdecl,
    importc: "orxViewport_SetTextureList", dynlib: libORX.}
  ## Sets a viewport texture list
  ##  @param[in]   _pstViewport    Concerned viewport
  ##  @param[in]   _u32TextureNumber Number of textures to associate with the viewport
  ##  @param[in]   _apstTextureList List of textures to associate with the viewport

proc getTextureList*(pstViewport: ptr orxVIEWPORT;
                                u32TextureNumber: orxU32;
                                apstTextureList: ptr ptr orxTEXTURE): orxSTATUS {.
    cdecl, importc: "orxViewport_GetTextureList", dynlib: libORX.}
  ## Gets a viewport texture list
  ##  @param[in]   _pstViewport    Concerned viewport
  ##  @param[in]   _u32TextureNumber Number of textures to be retrieved
  ##  @param[out]  _apstTextureList List of textures associated with the viewport
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getTextureCount*(pstViewport: ptr orxVIEWPORT): orxU32 {.cdecl,
    importc: "orxViewport_GetTextureCount", dynlib: libORX.}
  ## Gets a viewport texture count
  ##  @param[in]   _pstViewport    Concerned viewport
  ##  @return      Number of textures associated with the viewport

proc setBackgroundColor*(pstViewport: ptr orxVIEWPORT;
                                    pstColor: ptr orxCOLOR): orxSTATUS {.cdecl,
    importc: "orxViewport_SetBackgroundColor", dynlib: libORX.}
  ## Sets a viewport background color
  ##  @param[in]   _pstViewport    Concerned viewport
  ##  @param[in]   _pstColor        Color to use for background
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc clearBackgroundColor*(pstViewport: ptr orxVIEWPORT): orxSTATUS {.
    cdecl, importc: "orxViewport_ClearBackgroundColor", dynlib: libORX.}
  ## Clears viewport background color
  ##  @param[in]   _pstViewport    Concerned viewport
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc hasBackgroundColor*(pstViewport: ptr orxVIEWPORT): orxBOOL {.cdecl,
    importc: "orxViewport_HasBackgroundColor", dynlib: libORX.}
  ## Viewport has background color accessor
  ##  @param[in]   _pstViewport    Concerned viewport
  ##  @return      orxTRUE / orxFALSE

proc getBackgroundColor*(pstViewport: ptr orxVIEWPORT;
                                    pstColor: ptr orxCOLOR): ptr orxCOLOR {.cdecl,
    importc: "orxViewport_GetBackgroundColor", dynlib: libORX.}
  ## Gets a viewport background color
  ##  @param[in]   _pstViewport    Concerned viewport
  ##  @param[out]  _pstColor       Viewport's color
  ##  @return      Current background color

proc enable*(pstViewport: ptr orxVIEWPORT; bEnable: orxBOOL) {.cdecl,
    importc: "orxViewport_Enable", dynlib: libORX.}
  ## Enables / disables a viewport
  ##  @param[in]   _pstViewport    Concerned viewport
  ##  @param[in]   _bEnable        Enable / disable

proc isEnabled*(pstViewport: ptr orxVIEWPORT): orxBOOL {.cdecl,
    importc: "orxViewport_IsEnabled", dynlib: libORX.}
  ## Is a viewport enabled?
  ##  @param[in]   _pstViewport    Concerned viewport
  ##  @return      orxTRUE / orxFALSE

proc setCamera*(pstViewport: ptr orxVIEWPORT; pstCamera: ptr orxCAMERA) {.
    cdecl, importc: "orxViewport_SetCamera", dynlib: libORX.}
  ## Sets a viewport camera
  ##  @param[in]   _pstViewport    Concerned viewport
  ##  @param[in]   _pstCamera      Associated camera

proc getCamera*(pstViewport: ptr orxVIEWPORT): ptr orxCAMERA {.cdecl,
    importc: "orxViewport_GetCamera", dynlib: libORX.}
  ## Gets a viewport camera
  ##  @param[in]   _pstViewport    Concerned viewport
  ##  @return      Associated camera / nil

proc addShader*(pstViewport: ptr orxVIEWPORT;
                           zShaderConfigID: cstring): orxSTATUS {.cdecl,
    importc: "orxViewport_AddShader", dynlib: libORX.}
  ## Adds a shader to a viewport using its config ID
  ##  @param[in]   _pstViewport      Concerned viewport
  ##  @param[in]   _zShaderConfigID  Config ID of the shader to add
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc removeShader*(pstViewport: ptr orxVIEWPORT;
                              zShaderConfigID: cstring): orxSTATUS {.cdecl,
    importc: "orxViewport_RemoveShader", dynlib: libORX.}
  ## Removes a shader using its config ID
  ##  @param[in]   _pstViewport      Concerned viewport
  ##  @param[in]   _zShaderConfigID Config ID of the shader to remove
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc enableShader*(pstViewport: ptr orxVIEWPORT; bEnable: orxBOOL) {.
    cdecl, importc: "orxViewport_EnableShader", dynlib: libORX.}
  ## Enables a viewport's shader
  ##  @param[in]   _pstViewport      Concerned viewport
  ##  @param[in]   _bEnable          Enable / disable

proc isShaderEnabled*(pstViewport: ptr orxVIEWPORT): orxBOOL {.cdecl,
    importc: "orxViewport_IsShaderEnabled", dynlib: libORX.}
  ## Is a viewport's shader enabled?
  ##  @param[in]   _pstViewport      Concerned viewport
  ##  @return      orxTRUE if enabled, orxFALSE otherwise

proc getShaderPointer*(pstViewport: ptr orxVIEWPORT): ptr orxSHADERPOINTER {.
    cdecl, importc: "orxViewport_GetShaderPointer", dynlib: libORX.}
  ## Gets a viewport's shader pointer
  ##  @param[in]   _pstViewport      Concerned viewport
  ##  @return      orxSHADERPOINTER / nil

proc setBlendMode*(pstViewport: ptr orxVIEWPORT;
                              eBlendMode: orxDISPLAY_BLEND_MODE): orxSTATUS {.
    cdecl, importc: "orxViewport_SetBlendMode", dynlib: libORX.}
  ## Sets a viewport blend mode (only used when has active shaders attached)
  ##  @param[in]   _pstViewport    Concerned viewport
  ##  @param[in]   _eBlendMode     Blend mode to set

proc getBlendMode*(pstViewport: ptr orxVIEWPORT): orxDISPLAY_BLEND_MODE {.
    cdecl, importc: "orxViewport_GetBlendMode", dynlib: libORX.}
  ## Gets a viewport blend mode
  ##  @param[in]   _pstViewport    Concerned viewport
  ##  @return orxDISPLAY_BLEND_MODE

proc setPosition*(pstViewport: ptr orxVIEWPORT; fX: orxFLOAT; fY: orxFLOAT) {.
    cdecl, importc: "orxViewport_SetPosition", dynlib: libORX.}
  ## Sets a viewport position
  ##  @param[in]   _pstViewport    Concerned viewport
  ##  @param[in]   _fX             X axis position (top left corner)
  ##  @param[in]   _fY             Y axis position (top left corner)

proc setRelativePosition*(pstViewport: ptr orxVIEWPORT;
                                     u32AlignFlags: orxU32): orxSTATUS {.cdecl,
    importc: "orxViewport_SetRelativePosition", dynlib: libORX.}
  ## Sets a viewport relative position
  ##  @param[in]   _pstViewport    Concerned viewport
  ##  @param[in]   _u32AlignFlags  Alignment flags
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getPosition*(pstViewport: ptr orxVIEWPORT; pfX: ptr orxFLOAT;
                             pfY: ptr orxFLOAT) {.cdecl,
    importc: "orxViewport_GetPosition", dynlib: libORX.}
  ## Gets a viewport position
  ##  @param[in]   _pstViewport    Concerned viewport
  ##  @param[out]  _pfX            X axis position (top left corner)
  ##  @param[out]  _pfY            Y axis position (top left corner)

proc setSize*(pstViewport: ptr orxVIEWPORT; fWidth: orxFLOAT;
                         fHeight: orxFLOAT) {.cdecl,
    importc: "orxViewport_SetSize", dynlib: libORX.}
  ## Sets a viewport size
  ##  @param[in]   _pstViewport    Concerned viewport
  ##  @param[in]   _fWidth         Width
  ##  @param[in]   _fHeight        Height

proc setRelativeSize*(pstViewport: ptr orxVIEWPORT; fWidth: orxFLOAT;
                                 fHeight: orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxViewport_SetRelativeSize", dynlib: libORX.}
  ## Sets a viewport relative size
  ##  @param[in]   _pstViewport    Concerned viewport
  ##  @param[in]   _fWidth         Relative width (0.0f - 1.0f)
  ##  @param[in]   _fHeight        Relative height (0.0f - 1.0f)
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getSize*(pstViewport: ptr orxVIEWPORT; pfWidth: ptr orxFLOAT;
                         pfHeight: ptr orxFLOAT) {.cdecl,
    importc: "orxViewport_GetSize", dynlib: libORX.}
  ## Gets a viewport size
  ##  @param[in]   _pstViewport    Concerned viewport
  ##  @param[out]  _pfWidth        Width
  ##  @param[out]  _pfHeight       Height

proc getRelativeSize*(pstViewport: ptr orxVIEWPORT;
                                 pfWidth: ptr orxFLOAT; pfHeight: ptr orxFLOAT) {.
    cdecl, importc: "orxViewport_GetRelativeSize", dynlib: libORX.}
  ## Gets a viewport relative size
  ##  @param[in]   _pstViewport    Concerned viewport
  ##  @param[out]  _pfWidth        Relative width
  ##  @param[out]  _pfHeight       Relative height

proc getBox*(pstViewport: ptr orxVIEWPORT; pstBox: ptr orxAABOX): ptr orxAABOX {.
    cdecl, importc: "orxViewport_GetBox", dynlib: libORX.}
  ## Gets an axis aligned box of viewport
  ##  @param[in]   _pstViewport    Concerned viewport
  ##  @param[out]  _pstBox         Output box
  ##  @return orxAABOX / nil

proc getCorrectionRatio*(pstViewport: ptr orxVIEWPORT): orxFLOAT {.cdecl,
    importc: "orxViewport_GetCorrectionRatio", dynlib: libORX.}
  ## Get viewport correction ratio
  ##  @param[in]   _pstViewport  Concerned viewport
  ##  @return      Correction ratio value

proc getName*(pstViewport: ptr orxVIEWPORT): cstring {.cdecl,
    importc: "orxViewport_GetName", dynlib: libORX.}
  ## Gets viewport config name
  ##  @param[in]   _pstViewport    Concerned viewport
  ##  @return      orxSTRING / orxSTRING_EMPTY

proc viewportGet*(zName: cstring): ptr orxVIEWPORT {.cdecl,
    importc: "orxViewport_Get", dynlib: libORX.}
  ## Gets viewport given its name
  ##  @param[in]   _zName          Camera name
  ##  @return      orxVIEWPORT / nil


