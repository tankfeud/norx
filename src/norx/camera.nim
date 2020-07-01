import incl, structure, frame, AABox, vector

## * Anim flags
##

const
  orxCAMERA_KU32_FLAG_NONE* = 0x00000000
  orxCAMERA_KU32_FLAG_2D* = 0x00000001
  orxCAMERA_KU32_MASK_USER_ALL* = 0x000000FF

## * Misc
##

const
  orxCAMERA_KU32_GROUP_ID_NUMBER* = 16

## * Internal camera structure
##

type orxCAMERA* = object

proc cameraSetup*() {.cdecl, importc: "orxCamera_Setup", dynlib: libORX.}
  ## Camera module setup

proc cameraInit*(): orxSTATUS {.cdecl, importc: "orxCamera_Init",
                                 dynlib: libORX.}
  ## Inits the Camera module

proc cameraExit*() {.cdecl, importc: "orxCamera_Exit", dynlib: libORX.}
  ## Exits from the Camera module

proc cameraCreate*(u32Flags: orxU32): ptr orxCAMERA {.cdecl,
    importc: "orxCamera_Create", dynlib: libORX.}
  ## Creates a camera
  ##  @param[in]   _u32Flags       Camera flags (2D / ...)
  ##  @return      Created orxCAMERA / nil

proc cameraCreateFromConfig*(zConfigID: cstring): ptr orxCAMERA {.cdecl,
    importc: "orxCamera_CreateFromConfig", dynlib: libORX.}
  ## Creates a camera from config
  ##  @param[in]   _zConfigID      Config ID
  ##  @ return orxCAMERA / nil

proc delete*(pstCamera: ptr orxCAMERA): orxSTATUS {.cdecl,
    importc: "orxCamera_Delete", dynlib: libORX.}
  ## Deletes a camera
  ##  @param[in]   _pstCamera      Camera to delete
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc addGroupID*(pstCamera: ptr orxCAMERA; stGroupID: orxSTRINGID;
                          bAddFirst: orxBOOL): orxSTATUS {.cdecl,
    importc: "orxCamera_AddGroupID", dynlib: libORX.}
  ## Adds a group ID to a camera
  ##  @param[in] _pstCamera        Concerned camera
  ##  @param[in] _stGroupID        ID of the group to add
  ##  @param[in] _bAddFirst        If true this group will be used *before* any already added ones, otherwise it'll be used *after* all of them
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc removeGroupID*(pstCamera: ptr orxCAMERA; stGroupID: orxSTRINGID): orxSTATUS {.
    cdecl, importc: "orxCamera_RemoveGroupID", dynlib: libORX.}
  ## Removes a group ID from a camera
  ##  @param[in] _pstCamera        Concerned camera
  ##  @param[in] _stGroupID        ID of the group to remove
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getGroupIDCount*(pstCamera: ptr orxCAMERA): orxU32 {.cdecl,
    importc: "orxCamera_GetGroupIDCount", dynlib: libORX.}
  ## Gets number of group IDs of camera
  ##  @param[in] _pstCamera        Concerned camera
  ##  @return Number of group IDs of this camera

proc getGroupID*(pstCamera: ptr orxCAMERA; u32Index: orxU32): orxSTRINGID {.
    cdecl, importc: "orxCamera_GetGroupID", dynlib: libORX.}
  ## Gets the group ID of a camera at the given index
  ##  @param[in] _pstCamera        Concerned camera
  ##  @param[in] _u32Index         Index of group ID
  ##  @return Group ID if index is valid, orxSTRINGID_UNDEFINED otherwise

proc setFrustum*(pstCamera: ptr orxCAMERA; fWidth: orxFLOAT;
                          fHeight: orxFLOAT; fNear: orxFLOAT; fFar: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxCamera_SetFrustum", dynlib: libORX.}
  ## Sets camera frustum
  ##  @param[in]   _pstCamera      Concerned camera
  ##  @param[in]   _fWidth         Width of frustum
  ##  @param[in]   _fHeight        Height of frustum
  ##  @param[in]   _fNear          Near distance of frustum
  ##  @param[in]   _fFar           Far distance of frustum
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setPosition*(pstCamera: ptr orxCAMERA; pvPosition: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxCamera_SetPosition", dynlib: libORX.}
  ## Sets camera position
  ##  @param[in]   _pstCamera      Concerned camera
  ##  @param[in]   _pvPosition     Camera position
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setRotation*(pstCamera: ptr orxCAMERA; fRotation: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxCamera_SetRotation", dynlib: libORX.}
  ## Sets camera rotation
  ##  @param[in]   _pstCamera      Concerned camera
  ##  @param[in]   _fRotation      Camera rotation (radians)
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setZoom*(pstCamera: ptr orxCAMERA; fZoom: orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxCamera_SetZoom", dynlib: libORX.}
  ## Sets camera zoom
  ##  @param[in]   _pstCamera      Concerned camera
  ##  @param[in]   _fZoom          Camera zoom
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getFrustum*(pstCamera: ptr orxCAMERA; pstFrustum: ptr orxAABOX): ptr orxAABOX {.
    cdecl, importc: "orxCamera_GetFrustum", dynlib: libORX.}
  ## Gets camera frustum (3D box for 2D camera)
  ##  @param[in]   _pstCamera      Concerned camera
  ##  @param[out]  _pstFrustum    Frustum box
  ##  @return      Frustum orxAABOX

proc getPosition*(pstCamera: ptr orxCAMERA; pvPosition: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxCamera_GetPosition", dynlib: libORX.}
  ## Get camera position
  ##  @param[in]   _pstCamera      Concerned camera
  ##  @param[out]  _pvPosition     Camera position
  ##  @return      orxVECTOR

proc getRotation*(pstCamera: ptr orxCAMERA): orxFLOAT {.cdecl,
    importc: "orxCamera_GetRotation", dynlib: libORX.}
  ## Get camera rotation
  ##  @param[in]   _pstCamera      Concerned camera
  ##  @return      Rotation value (radians)

proc getZoom*(pstCamera: ptr orxCAMERA): orxFLOAT {.cdecl,
    importc: "orxCamera_GetZoom", dynlib: libORX.}
  ## Get camera zoom
  ##  @param[in]   _pstCamera      Concerned camera
  ##  @return      Zoom value

proc getName*(pstCamera: ptr orxCAMERA): cstring {.cdecl,
    importc: "orxCamera_GetName", dynlib: libORX.}
  ## Gets camera config name
  ##  @param[in]   _pstCamera      Concerned camera
  ##  @return      orxSTRING / orxSTRING_EMPTY

proc cameraGet*(zName: cstring): ptr orxCAMERA {.cdecl,
    importc: "orxCamera_Get", dynlib: libORX.}
  ## Gets camera given its name
  ##  @param[in]   _zName          Camera name
  ##  @return      orxCAMERA / nil

proc getFrame*(pstCamera: ptr orxCAMERA): ptr orxFRAME {.cdecl,
    importc: "orxCamera_GetFrame", dynlib: libORX.}
  ## Gets camera frame
  ##  @param[in]   _pstCamera      Concerned camera
  ##  @return      orxFRAME

proc setParent*(pstCamera: ptr orxCAMERA; pParent: pointer): orxSTATUS {.
    cdecl, importc: "orxCamera_SetParent", dynlib: libORX.}
  ## Sets camera parent
  ##  @param[in]   _pstCamera      Concerned camera
  ##  @param[in]   _pParent        Parent structure to set (object, spawner, camera or frame) / nil
  ##  @return      orsSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getParent*(pstCamera: ptr orxCAMERA): ptr orxSTRUCTURE {.cdecl,
    importc: "orxCamera_GetParent", dynlib: libORX.}
  ## Gets camera parent
  ##  @param[in]   _pstCamera      Concerned camera
  ##  @return      Parent (object, spawner, camera or frame) / nil

