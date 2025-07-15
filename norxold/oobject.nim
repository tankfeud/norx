
import
  incl, vector, animSet, clock, display, graphic, texture, OBox, bank, structure, sound

## * Defines

const
  orxOBJECT_KZ_DEFAULT_GROUP* = "default"

## * Event enum
##

type
  orxOBJECT_EVENT* {.size: sizeof(cint).} = enum
    orxOBJECT_EVENT_CREATE = 0, orxOBJECT_EVENT_DELETE, orxOBJECT_EVENT_PREPARE,
    orxOBJECT_EVENT_ENABLE, orxOBJECT_EVENT_DISABLE, orxOBJECT_EVENT_PAUSE,
    orxOBJECT_EVENT_UNPAUSE, orxOBJECT_EVENT_NUMBER,
    orxOBJECT_EVENT_NONE = orxENUM_NONE


## * Internal object structure

type orxOBJECT* = object

proc objectSetup*() {.cdecl, importc: "orxObject_Setup", dynlib: libORX.}
  ## Object module setup

proc objectInit*(): orxSTATUS {.cdecl, importc: "orxObject_Init",
                                 dynlib: libORX.}
  ## Inits the object module.
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc objectExit*() {.cdecl, importc: "orxObject_Exit", dynlib: libORX.}
  ## Exits from the object module.

proc objectCreate*(): ptr orxOBJECT {.cdecl, importc: "orxObject_Create",
                                      dynlib: libORX.}
  ## Creates an empty object.
  ##  @return orxOBJECT / nil

proc objectCreateFromConfig*(zConfigID: cstring): ptr orxOBJECT {.cdecl,
    importc: "orxObject_CreateFromConfig", dynlib: libORX.}
  ## Creates an object from config.
  ##  @param[in]   _zConfigID    Config ID
  ##  @ return orxOBJECT / nil

proc delete*(pstObject: ptr orxOBJECT): orxSTATUS {.cdecl,
    importc: "orxObject_Delete", dynlib: libORX.}
  ## Deletes an object, *unsafe* when called from an event handler: call orxObject_SetLifeTime(orxFLOAT_0) instead
  ##  @param[in] _pstObject        Concerned object
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc update*(pstObject: ptr orxOBJECT; pstClockInfo: ptr orxCLOCK_INFO): orxSTATUS {.
    cdecl, importc: "orxObject_Update", dynlib: libORX.}
  ## Updates an object.
  ##  @param[in] _pstObject        Concerned object
  ##  @param[in] _pstClockInfo     Clock information used to compute new object's state
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc enable*(pstObject: ptr orxOBJECT; bEnable: orxBOOL) {.cdecl,
    importc: "orxObject_Enable", dynlib: libORX.}
  ## Enables/disables an object. Note that enabling/disabling an object is not recursive, so its children will not be affected, see orxObject_EnableRecursive().
  ##  @param[in]   _pstObject    Concerned object
  ##  @param[in]   _bEnable      Enable / disable

proc enableRecursive*(pstObject: ptr orxOBJECT; bEnable: orxBOOL) {.cdecl,
    importc: "orxObject_EnableRecursive", dynlib: libORX.}
  ## Enables/disables an object and all its children.
  ##  @param[in]   _pstObject    Concerned object
  ##  @param[in]   _bEnable      Enable / disable

proc isEnabled*(pstObject: ptr orxOBJECT): orxBOOL {.cdecl,
    importc: "orxObject_IsEnabled", dynlib: libORX.}
  ## Is object enabled?
  ##  @param[in]   _pstObject    Concerned object
  ##  @return      orxTRUE if enabled, orxFALSE otherwise

proc pause*(pstObject: ptr orxOBJECT; bPause: orxBOOL) {.cdecl,
    importc: "orxObject_Pause", dynlib: libORX.}
  ## Pauses/unpauses an object. Note that pausing an object is not recursive, so its children will not be affected, see orxObject_PauseRecursive().
  ##  @param[in]   _pstObject    Concerned object
  ##  @param[in]   _bPause       Pause / unpause

proc pauseRecursive*(pstObject: ptr orxOBJECT; bPause: orxBOOL) {.cdecl,
    importc: "orxObject_PauseRecursive", dynlib: libORX.}
  ## Pauses/unpauses an object and its children.
  ##  @param[in]   _pstObject    Concerned object
  ##  @param[in]   _bPause       Pause / unpause

proc isPaused*(pstObject: ptr orxOBJECT): orxBOOL {.cdecl,
    importc: "orxObject_IsPaused", dynlib: libORX.}
  ## Is object paused?
  ##  @param[in]   _pstObject    Concerned object
  ##  @return      orxTRUE if paused, orxFALSE otherwise

proc setUserData*(pstObject: ptr orxOBJECT; pUserData: pointer) {.cdecl,
    importc: "orxObject_SetUserData", dynlib: libORX.}
  ## @}
  ## @name User data
  ##  @{
  ## Sets user data for an object. Orx ignores the user data, this is a mechanism for attaching custom
  ##  data to be used later by user code.
  ##  @param[in]   _pstObject    Concerned object
  ##  @param[in]   _pUserData    User data to store / nil

proc getUserData*(pstObject: ptr orxOBJECT): pointer {.cdecl,
    importc: "orxObject_GetUserData", dynlib: libORX.}
  ## Gets object's user data.
  ##  @param[in]   _pstObject    Concerned object
  ##  @return      Stored user data / nil

proc setOwner*(pstObject: ptr orxOBJECT; pOwner: pointer) {.cdecl,
    importc: "orxObject_SetOwner", dynlib: libORX.}
  ## @}
  ## @name Ownership
  ##  @{
  ## Sets owner for an object. Ownership in Orx is only about lifetime management. That is, when an object
  ##  dies, it also kills its children. Compare this with orxObject_SetParent().
  ##  Note that the "ChildList" field of an object's config section implies two things; that the object is both
  ##  the owner (orxObject_SetOwner()) and the parent (orxObject_SetParent()) of its children. There is an
  ##  exception to this though; when an object's child has a parent camera, the object is only the owner, and
  ##  the camera is the parent.
  ##  @param[in]   _pstObject    Concerned object
  ##  @param[in]   _pOwner       Owner to set / nil, if owner is an orxOBJECT, the owned object will be added to it as a children

proc getOwner*(pstObject: ptr orxOBJECT): ptr orxSTRUCTURE {.cdecl,
    importc: "orxObject_GetOwner", dynlib: libORX.}
  ## Gets object's owner. See orxObject_SetOwner().
  ##  @param[in]   _pstObject    Concerned object
  ##  @return      Owner / nil

proc getOwnedChild*(pstObject: ptr orxOBJECT): ptr orxOBJECT {.cdecl,
    importc: "orxObject_GetOwnedChild", dynlib: libORX.}
  ## Gets object's first owned child (only if created with a config ChildList / has an owner set with orxObject_SetOwner)
  ##  see orxObject_SetOwner() and orxObject_SetParent() for a comparison of ownership and parenthood in Orx.
  ##  This function is typically used to iterate over the owned children of an object. For example;
  ##  @param[in]   _pstObject    Concerned object
  ##  @return      First owned child object / nil
  # TODO: Fix these code block examples
  #  @code
  #  for(orxOBJECT * pstChild = orxObject_GetOwnedChild(pstObject);
  #      pstChild;
  #      pstChild = orxObject_GetOwnedSibling(pstChild))
  #  {
  #      do_something(pstChild);
  #  } @endcode

proc getOwnedSibling*(pstObject: ptr orxOBJECT): ptr orxOBJECT {.cdecl,
    importc: "orxObject_GetOwnedSibling", dynlib: libORX.}
  ## Gets object's next owned sibling (only if created with a config ChildList / has an owner set with orxObject_SetOwner)
  ##  This function is typically used to iterate over the owned children of an object, see orxObject_GetOwnedChild() for an example.
  ##  @param[in]   _pstObject    Concerned object
  ##  @return      Next sibling object / nil

proc setClock*(pstObject: ptr orxOBJECT; pstClock: ptr orxCLOCK): orxSTATUS {.
    cdecl, importc: "orxObject_SetClock", dynlib: libORX.}
  ## @}
  ## @name Clock
  ##  @{
  ## Sets associated clock for an object.
  ##  @param[in]   _pstObject    Concerned object
  ##  @param[in]   _pstClock     Clock to associate / nil
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getClock*(pstObject: ptr orxOBJECT): ptr orxCLOCK {.cdecl,
    importc: "orxObject_GetClock", dynlib: libORX.}
  ## Gets object's clock.
  ##  @param[in]   _pstObject    Concerned object
  ##  @return      Associated clock / nil

proc linkStructure*(pstObject: ptr orxOBJECT;
                             pstStructure: ptr orxSTRUCTURE): orxSTATUS {.cdecl,
    importc: "orxObject_LinkStructure", dynlib: libORX.}
  ## @}
  ## @name Linked structures
  ##  @{
  ## Links a structure to an object.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _pstStructure   Structure to link
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc unlinkStructure*(pstObject: ptr orxOBJECT;
                               eStructureID: orxSTRUCTURE_ID) {.cdecl,
    importc: "orxObject_UnlinkStructure", dynlib: libORX.}
  ## Unlinks structure from an object, given its structure ID.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _eStructureID   ID of structure to unlink

proc getStructure*(pstObject: ptr orxOBJECT; eStructureID: orxSTRUCTURE_ID): ptr orxSTRUCTURE {.
    cdecl, importc: "_orxObject_GetStructure", dynlib: libORX.}
  ## Structure used by an object get accessor, given its structure ID. Structure must then be cast correctly. (see helper macro
  ##  #orxOBJECT_GET_STRUCTURE())
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _eStructureID   ID of the structure to get
  ##  @return orxSTRUCTURE / nil

proc setFlip*(pstObject: ptr orxOBJECT; bFlipX: orxBOOL; bFlipY: orxBOOL): orxSTATUS {.
    cdecl, importc: "orxObject_SetFlip", dynlib: libORX.}
  ## @}
  ## @name Flip
  ##  @{
  ## Sets object flipping.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _bFlipX         Flip it on X axis
  ##  @param[in]   _bFlipY         Flip it on Y axis
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getFlip*(pstObject: ptr orxOBJECT; pbFlipX: ptr orxBOOL;
                       pbFlipY: ptr orxBOOL): orxSTATUS {.cdecl,
    importc: "orxObject_GetFlip", dynlib: libORX.}
  ## Gets object flipping.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _pbFlipX        X axis flipping
  ##  @param[in]   _pbFlipY        Y axis flipping
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setPivot*(pstObject: ptr orxOBJECT; pvPivot: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxObject_SetPivot", dynlib: libORX.}
  ## @}
  ## @name Graphic
  ##  @{
  ## Sets object pivot. This is a convenience wrapper around orxGraphic_SetPivot(). The "pivot" is essentially
  ##  what is indicated by the "Pivot" field of a config graphic section.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _pvPivot        Object pivot
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setOrigin*(pstObject: ptr orxOBJECT; pvOrigin: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxObject_SetOrigin", dynlib: libORX.}
  ## Sets object origin. This is a convenience wrapper around orxGraphic_SetOrigin(). The "origin" of a graphic is
  ##  essentially what is indicated by the "TextureOrigin" field of a config graphic section. The "origin" together with
  ##  "size" (see orxObject_SetSize()) defines the sprite of an object.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _pvOrigin       Object origin
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setSize*(pstObject: ptr orxOBJECT; pvSize: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxObject_SetSize", dynlib: libORX.}
  ## Sets object size. For objects that have a graphic attached it's simply a convenience wrapper for orxGraphic_SetSize(),
  ##  but an object can also have a size without a graphic.
  ##  Note the difference between "Scale" and "Size". The size of an object with a non-text graphic is the sprite size in
  ##  pixels on its texture. The object's effective size for rendering and intersection purposes (see orxObject_Pick()
  ##  and friends) is proportional to its "size" multiplied by its "scale". Another important distinction is that the
  ##  scale of an object also affects its children (see orxObject_SetParent() and note the distinction between
  ##  parenthood and ownership).
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _pvSize       	Object size
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getPivot*(pstObject: ptr orxOBJECT; pvPivot: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxObject_GetPivot", dynlib: libORX.}
  ## Get object pivot. See orxObject_SetPivot() for a more detailed explanation.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[out]  _pvPivot        Object pivot
  ##  @return      orxVECTOR / nil

proc getOrigin*(pstObject: ptr orxOBJECT; pvOrigin: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxObject_GetOrigin", dynlib: libORX.}
  ## Get object origin. See orxObject_SetOrigin() for a more detailed explanation.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[out]  _pvOrigin       Object origin
  ##  @return      orxVECTOR / nil

proc getSize*(pstObject: ptr orxOBJECT; pvSize: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxObject_GetSize", dynlib: libORX.}
  ## Gets object size. See orxObject_SetSize() for a more detailed explanation.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[out]  _pvSize         Object's size
  ##  @return      orxVECTOR / nil

proc setPosition*(pstObject: ptr orxOBJECT; pvPosition: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxObject_SetPosition", dynlib: libORX.}
  ## @}
  ## @name Frame
  ##  @{
  ## Sets object position in its parent's reference frame. See orxObject_SetWorldPosition() for setting an object's
  ##  position in the global reference frame.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _pvPosition     Object position
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setWorldPosition*(pstObject: ptr orxOBJECT; pvPosition: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxObject_SetWorldPosition", dynlib: libORX.}
  ## Sets object position in the global reference frame. See orxObject_SetPosition() for setting an object's position
  ##  in its parent's reference frame.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _pvPosition     Object world position
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setRotation*(pstObject: ptr orxOBJECT; fRotation: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxObject_SetRotation", dynlib: libORX.}
  ## Sets object rotation in its parent's reference frame. See orxObject_SetWorldRotation() for setting an object's
  ##  rotation in the global reference frame.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _fRotation      Object rotation (radians)
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setWorldRotation*(pstObject: ptr orxOBJECT; fRotation: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxObject_SetWorldRotation", dynlib: libORX.}
  ## Sets object rotation in the global reference frame. See orxObject_SetRotation() for setting an object's rotation
  ##  in its parent's reference frame.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _fRotation      Object world rotation (radians)
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setScale*(pstObject: ptr orxOBJECT; pvScale: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxObject_SetScale", dynlib: libORX.}
  ## Sets object scale in its parent's reference frame. See orxObject_SetWorldScale() for setting an object's scale
  ##  in the global reference frame.
  ##  See orxObject_SetSize() for a deeper explanation of the "size" of an object.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _pvScale        Object scale vector
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setWorldScale*(pstObject: ptr orxOBJECT; pvScale: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxObject_SetWorldScale", dynlib: libORX.}
  ## Sets object scale in the global reference frame. See orxObject_SetScale() for setting an object's scale in its
  ##  parent's reference frame.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _pvScale        Object world scale vector
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getPosition*(pstObject: ptr orxOBJECT; pvPosition: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxObject_GetPosition", dynlib: libORX.}
  ## Get object position. See orxObject_SetPosition().
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[out]  _pvPosition     Object position
  ##  @return      orxVECTOR / nil

proc getWorldPosition*(pstObject: ptr orxOBJECT; pvPosition: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxObject_GetWorldPosition", dynlib: libORX.}
  ## Get object world position. See orxObject_SetWorldPosition().
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[out]  _pvPosition     Object world position
  ##  @return      orxVECTOR / nil

proc getRotation*(pstObject: ptr orxOBJECT): orxFLOAT {.cdecl,
    importc: "orxObject_GetRotation", dynlib: libORX.}
  ## Get object rotation. See orxObject_SetRotation().
  ##  @param[in]   _pstObject      Concerned object
  ##  @return      orxFLOAT (radians)

proc getWorldRotation*(pstObject: ptr orxOBJECT): orxFLOAT {.cdecl,
    importc: "orxObject_GetWorldRotation", dynlib: libORX.}
  ## Get object world rotation. See orxObject_SetWorldRotation().
  ##  @param[in]   _pstObject      Concerned object
  ##  @return      orxFLOAT (radians)

proc getScale*(pstObject: ptr orxOBJECT; pvScale: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxObject_GetScale", dynlib: libORX.}
  ## Get object scale. See orxObject_SetScale().
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[out]  _pvScale        Object scale vector
  ##  @return      Scale vector

proc getWorldScale*(pstObject: ptr orxOBJECT; pvScale: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxObject_GetWorldScale", dynlib: libORX.}
  ## Gets object world scale. See orxObject_SetWorldScale().
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[out]  _pvScale        Object world scale
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setParent*(pstObject: ptr orxOBJECT; pParent: pointer): orxSTATUS {.
    cdecl, importc: "orxObject_SetParent", dynlib: libORX.}
  ## @}
  ## @name Parent
  ##  @{
  ## Sets an object parent (in the frame hierarchy). Parenthood in orx is about the transformation (position,
  ##  rotation, scale) of objects. Transformation of objects are compounded in a frame hierarchy. Compare this
  ##  with orxObject_SetOwner()
  ##  Note that the "ChildList" field of an object's config section implies two things; that the object is both
  ##  the owner (orxObject_SetOwner()) and the parent (orxObject_SetParent()) of its children. There is an
  ##  exception to this though; when an object's child has a parent camera, the object is only the owner, and
  ##  the camera is the parent.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _pParent        Parent structure to set (object, spawner, camera or frame) / nil
  ##  @return      orsSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getParent*(pstObject: ptr orxOBJECT): ptr orxSTRUCTURE {.cdecl,
    importc: "orxObject_GetParent", dynlib: libORX.}
  ## Gets object's parent. See orxObject_SetParent() for a more detailed explanation.
  ##  @param[in]   _pstObject    Concerned object
  ##  @return      Parent (object, spawner, camera or frame) / nil

proc getChild*(pstObject: ptr orxOBJECT): ptr orxOBJECT {.cdecl,
    importc: "orxObject_GetChild", dynlib: libORX.}
  ## Gets object's first child object. See orxObject_SetOwner() and orxObject_SetParent() for a comparison of
  ##  ownership and parenthood in Orx.
  ##  Note: this function will filter out any camera or spawner and retrieve the first child object.
  ##  This function is typically used to iterate over the children objects of an object.
  ##  @param[in]   _pstObject    Concerned object
  ##  @return      First child object / nil
  # TODO: Fix code examples
  #  For example:
  #  @code
  #  for(orxOBJECT *pstChild = orxOBJECT(orxObject_GetChild(pstObject));
  #      pstChild != nil;
  #      pstChild = orxOBJECT(orxObject_GetSibling(pstChild)))
  #  {
  #      DoSomething(pstChild); // DoSomething() can recurse into the children of pstChild for a depth-first traversal
  #  }
  #  @endcode

proc getSibling*(pstObject: ptr orxOBJECT): ptr orxSTRUCTURE {.cdecl,
    importc: "orxObject_GetSibling", dynlib: libORX.}
  ## Gets object's next sibling object. This function is typically used for iterating over the children objects of an object,
  ##  see orxObject_GetChild() for an iteration example.
  ##  Note: this function will filter out any camera or spawner and retrieve the next sibling object.
  ##  @param[in]   _pstObject      Concerned object
  ##  @return      Next sibling object / orxNULL

proc getNextChild*(pstObject: ptr orxOBJECT; pChild: pointer;
                            eStructureID: orxSTRUCTURE_ID): ptr orxSTRUCTURE {.
    cdecl, importc: "orxObject_GetNextChild", dynlib: libORX.}
  ## Gets object's next child structure of a given type (camera, object or spawner).
  ##  See orxObject_SetOwner() and orxObject_SetParent() for a comparison of
  ##  ownership and parenthood in Orx.
  ##  See orxObject_GetChild()/orxObject_GetSibling() if you want to only consider children objects.
  ##  This function is typically used to iterate over the children of an object.
  ##  @param[in]   _pstObject    Concerned object
  ##  @param[in]   _pChild         Concerned child to retrieve the next sibling, orxNULL to retrieve the first child
  ##  @param[in]   _eStructureID   ID of the structure to consider (camera, spawner, object or frame)
  ##  @return      Next child/sibling structure (camera, spawner, object or frame) / nil
  # TODO: Fix code examples
  #  For example, iterating over the immediate children cameras:
  #  @code
  #  for(orxCAMERA *pstChild = orxCAMERA(orxObject_GetNextChild(pstObject, orxNULL, orxSTRUCTURE_ID_CAMERA));
  #      pstChild != orxNULL;
  #      pstChild = orxCAMERA(orxObject_GetNextChild(pstObject, pstChild, orxSTRUCTURE_ID_CAMERA)))
  #  {
  #      DoSomethingWithCamera(pstChild);
  #  }
  #  @endcode

proc attach*(pstObject: ptr orxOBJECT; pParent: pointer): orxSTATUS {.cdecl,
    importc: "orxObject_Attach", dynlib: libORX.}
  ## Attaches an object to a parent while maintaining the object's world position.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _pParent        Parent structure to attach to (object, spawner, camera or frame)
  ##  @return      orsSTATUS_SUCCESS / orxSTATUS_FAILURE

proc detach*(pstObject: ptr orxOBJECT): orxSTATUS {.cdecl,
    importc: "orxObject_Detach", dynlib: libORX.}
  ## Detaches an object from a parent while maintaining the object's world position.
  ##  @param[in]   _pstObject      Concerned object
  ##  @return      orsSTATUS_SUCCESS / orxSTATUS_FAILURE

proc logParents*(pstObject: ptr orxOBJECT): orxSTATUS {.cdecl,
    importc: "orxObject_LogParents", dynlib: libORX.}
  ## Logs all parents of an object, including their frame data.
  ##  @param[in]   _pstObject      Concerned object
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setAnimSet*(pstObject: ptr orxOBJECT; pstAnimSet: ptr orxANIMSET): orxSTATUS {.
    cdecl, importc: "orxObject_SetAnimSet", dynlib: libORX.}
  ## @}
  ## @name Animation
  ##  @{
  ## Sets an object animset.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _pstAnimSet     Animation set to set / nil
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setAnimFrequency*(pstObject: ptr orxOBJECT; fFrequency: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxObject_SetAnimFrequency", dynlib: libORX.}
  ## Sets an object's relative animation frequency.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _fFrequency     Frequency to set: < 1.0 for slower than initial, > 1.0 for faster than initial
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setAnimFrequencyRecursive*(pstObject: ptr orxOBJECT;
    fFrequency: orxFLOAT) {.cdecl, importc: "orxObject_SetAnimFrequencyRecursive",
                          dynlib: libORX.}
  ## Sets the relative animation frequency for an object and its children.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _fFrequency     Frequency to set: < 1.0 for slower than initial, > 1.0 for faster than initial
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getAnimFrequency*(pstObject: ptr orxOBJECT): orxFLOAT {.cdecl,
    importc: "orxObject_GetAnimFrequency", dynlib: libORX.}
  ## Gets an object's relative animation frequency.
  ##  @param[in]   _pstObject      Concerned object
  ##  @return Animation frequency / -orxFLOAT_1

proc setCurrentAnim*(pstObject: ptr orxOBJECT; zAnimName: cstring): orxSTATUS {.
    cdecl, importc: "orxObject_SetCurrentAnim", dynlib: libORX.}
  ## Sets current animation for an object. This function switches the currently displayed animation of the object
  ##  immediately. Compare this with orxObject_SetTargetAnim().
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _zAnimName      Animation name (config's one) to set / nil
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setCurrentAnimRecursive*(pstObject: ptr orxOBJECT;
                                       zAnimName: cstring) {.cdecl,
    importc: "orxObject_SetCurrentAnimRecursive", dynlib: libORX.}
  ## Sets current animation for an object and its children.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _zAnimName      Animation name (config's one) to set / nil
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setTargetAnim*(pstObject: ptr orxOBJECT; zAnimName: cstring): orxSTATUS {.
    cdecl, importc: "orxObject_SetTargetAnim", dynlib: libORX.}
  ## Sets target animation for an object. The animations are sequenced on an object according to the animation link graph
  ##  defined by its AnimationSet. The sequence follows the graph and tries to reach the target animation. Use
  ##  orxObject_SetCurrentAnim() to switch the animation without using the link graph.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _zAnimName      Animation name (config's one) to set / nil
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setTargetAnimRecursive*(pstObject: ptr orxOBJECT;
                                      zAnimName: cstring) {.cdecl,
    importc: "orxObject_SetTargetAnimRecursive", dynlib: libORX.}
  ## Sets target animation for an object and its children.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _zAnimName      Animation name (config's one) to set / nil
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getCurrentAnim*(pstObject: ptr orxOBJECT): cstring {.cdecl,
    importc: "orxObject_GetCurrentAnim", dynlib: libORX.}
  ## Gets current animation.
  ##  @param[in]   _pstObject      Concerned object
  ##  @return      Current animation / orxSTRING_EMPTY

proc getTargetAnim*(pstObject: ptr orxOBJECT): cstring {.cdecl,
    importc: "orxObject_GetTargetAnim", dynlib: libORX.}
  ## Gets target animation.
  ##  @param[in]   _pstObject      Concerned object
  ##  @return      Target animation / orxSTRING_EMPTY

proc isCurrentAnim*(pstObject: ptr orxOBJECT; zAnimName: cstring): orxBOOL {.
    cdecl, importc: "orxObject_IsCurrentAnim", dynlib: libORX.}
  ## Is current animation test.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _zAnimName      Animation name (config's one) to test
  ##  @return      orxTRUE / orxFALSE

proc isTargetAnim*(pstObject: ptr orxOBJECT; zAnimName: cstring): orxBOOL {.
    cdecl, importc: "orxObject_IsTargetAnim", dynlib: libORX.}
  ## Is target animation test.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _zAnimName      Animation name (config's one) to test
  ##  @return      orxTRUE / orxFALSE

proc setSpeed*(pstObject: ptr orxOBJECT; pvSpeed: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxObject_SetSpeed", dynlib: libORX.}
  ## @}
  ## @name Physics / dynamics
  ##  @{
  ## Sets an object speed.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _pvSpeed        Speed to set
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setRelativeSpeed*(pstObject: ptr orxOBJECT;
                                pvRelativeSpeed: ptr orxVECTOR): orxSTATUS {.cdecl,
    importc: "orxObject_SetRelativeSpeed", dynlib: libORX.}
  ## Sets an object speed relative to its rotation/scale.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _pvRelativeSpeed Relative speed to set
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setAngularVelocity*(pstObject: ptr orxOBJECT; fVelocity: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxObject_SetAngularVelocity", dynlib: libORX.}
  ## Sets an object angular velocity.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _fVelocity      Angular velocity to set (radians/seconds)
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setCustomGravity*(pstObject: ptr orxOBJECT;
                                pvCustomGravity: ptr orxVECTOR): orxSTATUS {.cdecl,
    importc: "orxObject_SetCustomGravity", dynlib: libORX.}
  ## Sets an object custom gravity.
  ##  @param[in]   _pstObject        Concerned object
  ##  @param[in]   _pvCustomGravity  Custom gravity to set / nil to remove it
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getSpeed*(pstObject: ptr orxOBJECT; pvSpeed: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxObject_GetSpeed", dynlib: libORX.}
  ## Gets an object speed.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[out]   _pvSpeed       Speed to get
  ##  @return      Object speed / nil

proc getRelativeSpeed*(pstObject: ptr orxOBJECT;
                                pvRelativeSpeed: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxObject_GetRelativeSpeed", dynlib: libORX.}
  ## Gets an object relative speed.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[out]  _pvRelativeSpeed Relative speed to get
  ##  @return      Object relative speed / nil

proc getAngularVelocity*(pstObject: ptr orxOBJECT): orxFLOAT {.cdecl,
    importc: "orxObject_GetAngularVelocity", dynlib: libORX.}
  ## Gets an object angular velocity.
  ##  @param[in]   _pstObject      Concerned object
  ##  @return      Object angular velocity (radians/seconds)

proc getCustomGravity*(pstObject: ptr orxOBJECT;
                                pvCustomGravity: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxObject_GetCustomGravity", dynlib: libORX.}
  ## Gets an object custom gravity.
  ##  @param[in]   _pstObject        Concerned object
  ##  @param[out]  _pvCustomGravity  Custom gravity to get
  ##  @return      Object custom gravity / nil is object doesn't have any

proc getMass*(pstObject: ptr orxOBJECT): orxFLOAT {.cdecl,
    importc: "orxObject_GetMass", dynlib: libORX.}
  ## Gets an object mass.
  ##  @param[in]   _pstObject      Concerned object
  ##  @return      Object mass

proc getMassCenter*(pstObject: ptr orxOBJECT; pvMassCenter: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxObject_GetMassCenter", dynlib: libORX.}
  ## Gets an object center of mass (object space).
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[out]  _pvMassCenter   Mass center to get
  ##  @return      Mass center / nil

proc applyTorque*(pstObject: ptr orxOBJECT; fTorque: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxObject_ApplyTorque", dynlib: libORX.}
  ## Applies a torque.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _fTorque        Torque to apply
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc applyForce*(pstObject: ptr orxOBJECT; pvForce: ptr orxVECTOR;
                          pvPoint: ptr orxVECTOR): orxSTATUS {.cdecl,
    importc: "orxObject_ApplyForce", dynlib: libORX.}
  ## Applies a force.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _pvForce        Force to apply
  ##  @param[in]   _pvPoint        Point (world coordinates) where the force will be applied, if nil, center of mass will be used
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc applyImpulse*(pstObject: ptr orxOBJECT; pvImpulse: ptr orxVECTOR;
                            pvPoint: ptr orxVECTOR): orxSTATUS {.cdecl,
    importc: "orxObject_ApplyImpulse", dynlib: libORX.}
  ## Applies an impulse.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _pvImpulse      Impulse to apply
  ##  @param[in]   _pvPoint        Point (world coordinates) where the impulse will be applied, if nil, center of mass will be used
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc raycast*(pvBegin: ptr orxVECTOR; pvEnd: ptr orxVECTOR;
                       u16SelfFlags: orxU16; u16CheckMask: orxU16;
                       bEarlyExit: orxBOOL; pvContact: ptr orxVECTOR;
                       pvNormal: ptr orxVECTOR): ptr orxOBJECT {.cdecl,
    importc: "orxObject_Raycast", dynlib: libORX.}
  ## Issues a raycast to test for potential objects in the way.
  ##  @param[in]   _pvBegin        Beginning of raycast
  ##  @param[in]   _pvEnd          End of raycast
  ##  @param[in]   _u16SelfFlags   Selfs flags used for filtering (0xFFFF for no filtering)
  ##  @param[in]   _u16CheckMask   Check mask used for filtering (0xFFFF for no filtering)
  ##  @param[in]   _bEarlyExit     Should stop as soon as an object has been hit (which might not be the closest)
  ##  @param[in]   _pvContact      If non-null and a contact is found it will be stored here
  ##  @param[in]   _pvNormal       If non-null and a contact is found, its normal will be stored here
  ##  @return Colliding orxOBJECT / nil

proc setTextString*(pstObject: ptr orxOBJECT; zString: cstring): orxSTATUS {.
    cdecl, importc: "orxObject_SetTextString", dynlib: libORX.}
  ## @}
  ## @name Text
  ##  @{
  ## Sets object text string, if object is associated to a text.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _zString        String to set
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getTextString*(pstObject: ptr orxOBJECT): cstring {.cdecl,
    importc: "orxObject_GetTextString", dynlib: libORX.}
  ## Gets object text string, if object is associated to a text.
  ##  @param[in]   _pstObject      Concerned object
  ##  @return      orxSTRING / orxSTRING_EMPTY

proc getBoundingBox*(pstObject: ptr orxOBJECT; pstBoundingBox: ptr orxOBOX): ptr orxOBOX {.
    cdecl, importc: "orxObject_GetBoundingBox", dynlib: libORX.}
  ## @}
  ## @name Bounding box
  ##  @{
  ## Gets object's bounding box (OBB).
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[out]  _pstBoundingBox Bounding box result
  ##  @return      Bounding box / nil

proc addFX*(pstObject: ptr orxOBJECT; zFXConfigID: cstring): orxSTATUS {.
    cdecl, importc: "orxObject_AddFX", dynlib: libORX.}
  ## @}
  ## @name FX
  ##  @{
  ## Adds an FX using its config ID.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _zFXConfigID    Config ID of the FX to add
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc addFXRecursive*(pstObject: ptr orxOBJECT; zFXConfigID: cstring) {.
    cdecl, importc: "orxObject_AddFXRecursive", dynlib: libORX.}
  ## Adds an FX to an object and its children.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _zFXConfigID    Config ID of the FX to add

proc addUniqueFX*(pstObject: ptr orxOBJECT; zFXConfigID: cstring): orxSTATUS {.
    cdecl, importc: "orxObject_AddUniqueFX", dynlib: libORX.}
  ## Adds a unique FX using its config ID. Refer to orxObject_AddUniqueDelayedFX() for details, since this
  ##  function is the same as it with the delay argument set to 0.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _zFXConfigID    Config ID of the FX to add
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc addUniqueFXRecursive*(pstObject: ptr orxOBJECT;
                                    zFXConfigID: cstring) {.cdecl,
    importc: "orxObject_AddUniqueFXRecursive", dynlib: libORX.}
  ## Adds a unique FX to an object and its children.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _zFXConfigID    Config ID of the FX to add

proc addDelayedFX*(pstObject: ptr orxOBJECT; zFXConfigID: cstring;
                            fDelay: orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxObject_AddDelayedFX", dynlib: libORX.}
  ## Adds a delayed FX using its config ID.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _zFXConfigID    Config ID of the FX to add
  ##  @param[in]   _fDelay         Delay time
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc addDelayedFXRecursive*(pstObject: ptr orxOBJECT;
                                     zFXConfigID: cstring; fDelay: orxFLOAT;
                                     bPropagate: orxBOOL) {.cdecl,
    importc: "orxObject_AddDelayedFXRecursive", dynlib: libORX.}
  ## Adds a delayed FX to an object and its children.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _zFXConfigID    Config ID of the FX to add
  ##  @param[in]   _fDelay         Delay time
  ##  @param[in]   _bPropagate    Should the delay be incremented with each child application?

proc addUniqueDelayedFX*(pstObject: ptr orxOBJECT;
                                  zFXConfigID: cstring; fDelay: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxObject_AddUniqueDelayedFX", dynlib: libORX.}
  ## Adds a unique delayed FX using its config ID. The difference between this function and orxObject_AddDelayedFX()
  ##  is that this one does not add the specified FX, if the object already has an FX with the same config ID attached.
  ##  note that the "uniqueness" is determined immediately at the time of this function call, not at the time of the
  ##  FX start (i.e. after the delay).
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _zFXConfigID    Config ID of the FX to add
  ##  @param[in]   _fDelay         Delay time
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc addUniqueDelayedFXRecursive*(pstObject: ptr orxOBJECT;
    zFXConfigID: cstring; fDelay: orxFLOAT; bPropagate: orxBOOL) {.cdecl,
    importc: "orxObject_AddUniqueDelayedFXRecursive", dynlib: libORX.}
  ## Adds a unique delayed FX to an object and its children.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _zFXConfigID    Config ID of the FX to add
  ##  @param[in]   _fDelay         Delay time
  ##  @param[in]   _bPropagate    Should the delay be incremented with each child application?

proc removeFX*(pstObject: ptr orxOBJECT; zFXConfigID: cstring): orxSTATUS {.
    cdecl, importc: "orxObject_RemoveFX", dynlib: libORX.}
  ## Removes an FX using its config ID.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _zFXConfigID    Config ID of the FX to remove
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc removeFXRecursive*(pstObject: ptr orxOBJECT; zFXConfigID: ptr orxCHAR) {.
    cdecl, importc: "orxObject_RemoveFXRecursive", dynlib: libORX.}
  ## Removes an FX from an object and its children.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _zFXConfigID    Config ID of the FX to remove

proc removeAllFXs*(pstObject: ptr orxOBJECT): orxSTATUS {.cdecl,
    importc: "orxObject_RemoveAllFXs", dynlib: libORX.}
  ## Removes all FXs.
  ##  @param[in]   _pstObject      Concerned object
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc synchronizeFX*(pstObject: ptr orxOBJECT; pstModel: ptr orxOBJECT): orxSTATUS {.
    cdecl, importc: "orxObject_SynchronizeFX", dynlib: libORX.}
  ## Synchronizes FXs with another object's ones (if FXs are not matching on both objects the behavior is undefined).
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _pstModel       Model object on which to synchronize FXs
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc addSound*(pstObject: ptr orxOBJECT; zSoundConfigID: cstring): orxSTATUS {.
    cdecl, importc: "orxObject_AddSound", dynlib: libORX.}
  ## @}
  ## @name Sound
  ##  @{
  ## Adds a sound using its config ID.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _zSoundConfigID Config ID of the sound to add
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc removeSound*(pstObject: ptr orxOBJECT; zSoundConfigID: cstring): orxSTATUS {.
    cdecl, importc: "orxObject_RemoveSound", dynlib: libORX.}
  ## Removes a sound using its config ID.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _zSoundConfigID Config ID of the sound to remove
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getLastAddedSound*(pstObject: ptr orxOBJECT): ptr orxSOUND {.cdecl,
    importc: "orxObject_GetLastAddedSound", dynlib: libORX.}
  ## Gets last added sound (Do *NOT* destroy it directly before removing it!!!).
  ##  @param[in]   _pstObject      Concerned object
  ##  @return      orxSOUND / nil

proc setVolume*(pstObject: ptr orxOBJECT; fVolume: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxObject_SetVolume", dynlib: libORX.}
  ## Sets volume for all sounds of an object.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _fVolume        Desired volume (0.0 - 1.0)
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setPitch*(pstObject: ptr orxOBJECT; fPitch: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxObject_SetPitch", dynlib: libORX.}
  ## Sets pitch for all sounds of an object.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _fPitch         Desired pitch (0.0 - 1.0)
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc play*(pstObject: ptr orxOBJECT): orxSTATUS {.cdecl,
    importc: "orxObject_Play", dynlib: libORX.}
  ## Plays all the sounds of an object.
  ##  @param[in]   _pstObject      Concerned object
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc stop*(pstObject: ptr orxOBJECT): orxSTATUS {.cdecl,
    importc: "orxObject_Stop", dynlib: libORX.}
  ## Stops all the sounds of an object.
  ##  @param[in]   _pstObject      Concerned object
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc addShader*(pstObject: ptr orxOBJECT; zShaderConfigID: cstring): orxSTATUS {.
    cdecl, importc: "orxObject_AddShader", dynlib: libORX.}
  ## @}
  ## @name Shader
  ##  @{
  ## Adds a shader to an object using its config ID.
  ##  @param[in]   _pstObject        Concerned object
  ##  @param[in]   _zShaderConfigID  Config ID of the shader to add
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc addShaderRecursive*(pstObject: ptr orxOBJECT;
                                  zShaderConfigID: ptr orxCHAR) {.cdecl,
    importc: "orxObject_AddShaderRecursive", dynlib: libORX.}
  ## Adds a shader to an object and its children.
  ##  @param[in]   _pstObject        Concerned object
  ##  @param[in]   _zShaderConfigID  Config ID of the shader to add

proc removeShader*(pstObject: ptr orxOBJECT; zShaderConfigID: cstring): orxSTATUS {.
    cdecl, importc: "orxObject_RemoveShader", dynlib: libORX.}
  ## Removes a shader using its config ID.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _zShaderConfigID Config ID of the shader to remove
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc removeShaderRecursive*(pstObject: ptr orxOBJECT;
                                     zShaderConfigID: ptr orxCHAR) {.cdecl,
    importc: "orxObject_RemoveShaderRecursive", dynlib: libORX.}
  ## Removes a shader from an object and its children.
  ##  @param[in]   _pstObject        Concerned object
  ##  @param[in]   _zShaderConfigID  Config ID of the shader to remove

proc enableShader*(pstObject: ptr orxOBJECT; bEnable: orxBOOL) {.cdecl,
    importc: "orxObject_EnableShader", dynlib: libORX.}
  ## Enables an object's shader.
  ##  @param[in]   _pstObject        Concerned object
  ##  @param[in]   _bEnable          Enable / disable

proc isShaderEnabled*(pstObject: ptr orxOBJECT): orxBOOL {.cdecl,
    importc: "orxObject_IsShaderEnabled", dynlib: libORX.}
  ## Is an object's shader enabled?
  ##  @param[in]   _pstObject        Concerned object
  ##  @return      orxTRUE if enabled, orxFALSE otherwise

proc addTimeLineTrack*(pstObject: ptr orxOBJECT;
                                zTrackConfigID: cstring): orxSTATUS {.cdecl,
    importc: "orxObject_AddTimeLineTrack", dynlib: libORX.}
  ## @}
  ## @name TimeLine
  ##  @{
  ## Adds a timeline track to an object using its config ID.
  ##  @param[in]   _pstObject        Concerned object
  ##  @param[in]   _zTrackConfigID   Config ID of the timeline track to add
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc addTimeLineTrackRecursive*(pstObject: ptr orxOBJECT;
    zTrackConfigID: cstring) {.cdecl,
                                importc: "orxObject_AddTimeLineTrackRecursive",
                                dynlib: libORX.}
  ## Adds a timeline track to an object and its children.
  ##  @param[in]   _pstObject        Concerned object
  ##  @param[in]   _zTrackConfigID   Config ID of the timeline track to add

proc removeTimeLineTrack*(pstObject: ptr orxOBJECT;
                                   zTrackConfigID: cstring): orxSTATUS {.cdecl,
    importc: "orxObject_RemoveTimeLineTrack", dynlib: libORX.}
  ## Removes a timeline track using its config ID
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _zTrackConfigID Config ID of the timeline track to remove
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc removeTimeLineTrackRecursive*(pstObject: ptr orxOBJECT;
    zTrackConfigID: ptr orxCHAR) {.cdecl, importc: "orxObject_RemoveTimeLineTrackRecursive",
                                dynlib: libORX.}
  ## Removes a timeline track from an object and its children.
  ##  @param[in]   _pstObject        Concerned object
  ##  @param[in]   _zTrackConfigID   Config ID of the timeline track to remove

proc enableTimeLine*(pstObject: ptr orxOBJECT; bEnable: orxBOOL) {.cdecl,
    importc: "orxObject_EnableTimeLine", dynlib: libORX.}
  ## Enables an object's timeline.
  ##  @param[in]   _pstObject        Concerned object
  ##  @param[in]   _bEnable          Enable / disable

proc isTimeLineEnabled*(pstObject: ptr orxOBJECT): orxBOOL {.cdecl,
    importc: "orxObject_IsTimeLineEnabled", dynlib: libORX.}
  ## Is an object's timeline enabled?
  ##  @param[in]   _pstObject        Concerned object
  ##  @return      orxTRUE if enabled, orxFALSE otherwise

proc getName*(pstObject: ptr orxOBJECT): cstring {.cdecl,
    importc: "orxObject_GetName", dynlib: libORX.}
  ## @}
  ## @name Name
  ##  @{
  ## Gets object config name.
  ##  @param[in]   _pstObject      Concerned object
  ##  @return      orxSTRING / orxSTRING_EMPTY

proc createNeighborList*(pstCheckBox: ptr orxOBOX; stGroupID: orxSTRINGID): ptr orxBANK {.
    cdecl, importc: "orxObject_CreateNeighborList", dynlib: libORX.}
  ## Creates a list of object at neighboring of the given box (ie. whose bounding volume intersects this box).
  ##  The following is an example for iterating over a neighbor list:
  ##  @param[in]   _pstCheckBox    Box to check intersection with
  ##  @param[in]   _stGroupID      Group ID to consider, orxSTRINGID_UNDEFINED for all
  ##  @return      orxBANK / nil
  ##
  # TODO: Fix these code block examples
  #  ## .. code-block:: nim
  #    orxVECTOR vPosition # The world position of the neighborhood area
  #    # set_position(vPosition)
  #    orxVECTOR vSize; # The size of the neighborhood area
  #    # set_size(vSize);
  #    orxVECTOR vPivot; # The pivot of the neighborhood area
  #    # set_pivot(vPivot);
  #    orxOBOX stBox;
  #    orxOBox_2DSet(&stBox, &vPosition, &vPivot, &vSize, 0);
  #    pstBank: ptr orxBANK = orxObject_CreateNeighborList(&stBox, orxSTRINGID_UNDEFINED);
  #    if(pstBank) {
  #        for(int i=0; i < orxBank_GetCount(pstBank); ++i)
  #        {
  #            orxOBJECT * pstObject = *((orxOBJECT **) orxBank_GetAtIndex(pstBank, i));
  #            do_something_with(pstObject);
  #        }
  #        orxObject_DeleteNeighborList(pstBank);
  #    }
  #

proc deleteNeighborList*(pstObjectList: ptr orxBANK) {.cdecl,
    importc: "orxObject_DeleteNeighborList", dynlib: libORX.}
  ## Deletes an object list created with orxObject_CreateNeighborList().
  ##  @param[in]   _pstObjectList  Concerned object list

proc setSmoothing*(pstObject: ptr orxOBJECT;
                            eSmoothing: orxDISPLAY_SMOOTHING): orxSTATUS {.cdecl,
    importc: "orxObject_SetSmoothing", dynlib: libORX.}
  ## @}
  ## @name Smoothing
  ##  @{
  ## Sets object smoothing.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _eSmoothing     Smoothing type (enabled, default or none)
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setSmoothingRecursive*(pstObject: ptr orxOBJECT;
                                     eSmoothing: orxDISPLAY_SMOOTHING) {.cdecl,
    importc: "orxObject_SetSmoothingRecursive", dynlib: libORX.}
  ## Sets smoothing for an object and its children.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _eSmoothing     Smoothing type (enabled, default or none)
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getSmoothing*(pstObject: ptr orxOBJECT): orxDISPLAY_SMOOTHING {.cdecl,
    importc: "orxObject_GetSmoothing", dynlib: libORX.}
  ## Gets object smoothing.
  ##  @param[in]   _pstObject     Concerned object
  ##  @return Smoothing type (enabled, default or none)

proc getWorkingTexture*(pstObject: ptr orxOBJECT): ptr orxTEXTURE {.cdecl,
    importc: "orxObject_GetWorkingTexture", dynlib: libORX.}
  ## @}
  ## @name texture
  ##  @{
  ## Gets object working texture.
  ##  @param[in]   _pstObject     Concerned object
  ##  @return orxTEXTURE / nil

proc getWorkingGraphic*(pstObject: ptr orxOBJECT): ptr orxGRAPHIC {.cdecl,
    importc: "orxObject_GetWorkingGraphic", dynlib: libORX.}
  ## @}
  ## @name graphic
  ##  @{
  ## Gets object working graphic.
  ##  @param[in]   _pstObject     Concerned object
  ##  @return orxGRAPHIC / nil

proc setColor*(pstObject: ptr orxOBJECT; pstColor: ptr orxCOLOR): orxSTATUS {.
    cdecl, importc: "orxObject_SetColor", dynlib: libORX.}
  ## Sets object color.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _pstColor       Color to set, nil to remove any specific color
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setColorRecursive*(pstObject: ptr orxOBJECT; pstColor: ptr orxCOLOR) {.
    cdecl, importc: "orxObject_SetColorRecursive", dynlib: libORX.}
  ## Sets color of an object and all its children.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _pstColor       Color to set, nil to remove any specific color

proc hasColor*(pstObject: ptr orxOBJECT): orxBOOL {.cdecl,
    importc: "orxObject_HasColor", dynlib: libORX.}
  ## Object has color accessor?
  ##  @param[in]   _pstObject      Concerned object
  ##  @return      orxTRUE / orxFALSE

proc getColor*(pstObject: ptr orxOBJECT; pstColor: ptr orxCOLOR): ptr orxCOLOR {.
    cdecl, importc: "orxObject_GetColor", dynlib: libORX.}
  ## Gets object color.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[out]  _pstColor       Object's color
  ##  @return      orxCOLOR / nil

proc setRGB*(pstObject: ptr orxOBJECT; pvRGB: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxObject_SetRGB", dynlib: libORX.}
  ## Sets object RGB values.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _pvRGB          RGB values to set
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setRGBRecursive*(pstObject: ptr orxOBJECT; pvRGB: ptr orxVECTOR) {.
    cdecl, importc: "orxObject_SetRGBRecursive", dynlib: libORX.}
  ## Sets color of an object and all its children.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _pvRGB          RGB values to set

proc setAlpha*(pstObject: ptr orxOBJECT; fAlpha: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxObject_SetAlpha", dynlib: libORX.}
  ## Sets object alpha.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _fAlpha         Alpha value to set
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setAlphaRecursive*(pstObject: ptr orxOBJECT; fAlpha: orxFLOAT) {.cdecl,
    importc: "orxObject_SetAlphaRecursive", dynlib: libORX.}
  ## Sets alpha of an object and all its children.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _fAlpha         Alpha value to set

proc setRepeat*(pstObject: ptr orxOBJECT; fRepeatX: orxFLOAT;
                         fRepeatY: orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxObject_SetRepeat", dynlib: libORX.}
  ## Sets object repeat (wrap) values.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _fRepeatX       X-axis repeat value
  ##  @param[in]   _fRepeatY       Y-axis repeat value
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getRepeat*(pstObject: ptr orxOBJECT; pfRepeatX: ptr orxFLOAT;
                         pfRepeatY: ptr orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxObject_GetRepeat", dynlib: libORX.}
  ## Gets object repeat (wrap) values.
  ##  @param[in]   _pstObject     Concerned object
  ##  @param[out]  _pfRepeatX      X-axis repeat value
  ##  @param[out]  _pfRepeatY      Y-axis repeat value
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setBlendMode*(pstObject: ptr orxOBJECT;
                            eBlendMode: orxDISPLAY_BLEND_MODE): orxSTATUS {.cdecl,
    importc: "orxObject_SetBlendMode", dynlib: libORX.}
  ## Sets object blend mode.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _eBlendMode     Blend mode (alpha, multiply, add or none)
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setBlendModeRecursive*(pstObject: ptr orxOBJECT;
                                     eBlendMode: orxDISPLAY_BLEND_MODE) {.cdecl,
    importc: "orxObject_SetBlendModeRecursive", dynlib: libORX.}
  ## Sets blend mode of an object and its children.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _eBlendMode     Blend mode (alpha, multiply, add or none)
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc hasBlendMode*(pstObject: ptr orxOBJECT): orxBOOL {.cdecl,
    importc: "orxObject_HasBlendMode", dynlib: libORX.}
  ## Object has blend mode accessor?
  ##  @param[in]   _pstObject      Concerned object
  ##  @return      orxTRUE / orxFALSE

proc getBlendMode*(pstObject: ptr orxOBJECT): orxDISPLAY_BLEND_MODE {.
    cdecl, importc: "orxObject_GetBlendMode", dynlib: libORX.}
  ## Gets object blend mode.
  ##  @param[in]   _pstObject     Concerned object
  ##  @return Blend mode (alpha, multiply, add or none)

proc setLifeTime*(pstObject: ptr orxOBJECT; fLifeTime: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxObject_SetLifeTime", dynlib: libORX.}
  ## @}
  ## @name Life time / active time
  ##  @{
  ## Sets object lifetime.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _fLifeTime      Lifetime to set, negative value to disable it
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getLifeTime*(pstObject: ptr orxOBJECT): orxFLOAT {.cdecl,
    importc: "orxObject_GetLifeTime", dynlib: libORX.}
  ## Gets object lifetime.
  ##  @param[in]   _pstObject      Concerned object
  ##  @return      Lifetime / negative value if none

proc getActiveTime*(pstObject: ptr orxOBJECT): orxFLOAT {.cdecl,
    importc: "orxObject_GetActiveTime", dynlib: libORX.}
  ## Gets object active time, i.e. the amount of time that the object has been alive taking into account
  ##  the object's clock multiplier and object's periods of pause.
  ##  @param[in]   _pstObject      Concerned object
  ##  @return      Active time

proc getDefaultGroupID*(): orxSTRINGID {.cdecl,
    importc: "orxObject_GetDefaultGroupID", dynlib: libORX.}
  ## @}
  ## @name Group
  ##  @{
  ## Gets default group ID.
  ##  @return      Default group ID

proc getGroupID*(pstObject: ptr orxOBJECT): orxSTRINGID {.cdecl,
    importc: "orxObject_GetGroupID", dynlib: libORX.}
  ## Gets object's group ID.
  ##  @param[in]   _pstObject      Concerned object
  ##  @return      Object's group ID. This is the string ID (see orxString_GetFromID()) of the object's group name.

proc setGroupID*(pstObject: ptr orxOBJECT; stGroupID: orxSTRINGID): orxSTATUS {.
    cdecl, importc: "orxObject_SetGroupID", dynlib: libORX.}
  ## Sets object's group ID.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _stGroupID      Group ID to set. This is the string ID (see orxString_GetID()) of the object's group name.
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setGroupIDRecursive*(pstObject: ptr orxOBJECT; stGroupID: orxSTRINGID) {.
    cdecl, importc: "orxObject_SetGroupIDRecursive", dynlib: libORX.}
  ## Sets group ID of an object and all its owned children.
  ##  @param[in]   _pstObject      Concerned object
  ##  @param[in]   _stGroupID      Group ID to set. This is the string ID (see orxString_GetID()) of the object's group name.

proc getNext*(pstObject: ptr orxOBJECT; stGroupID: orxSTRINGID): ptr orxOBJECT {.
    cdecl, importc: "orxObject_GetNext", dynlib: libORX.}
  ## Gets next object in group.
  ##  @param[in]   _pstObject      Concerned object, nil to get the first one
  ##  @param[in]   _stGroupID      Group ID to consider, orxSTRINGID_UNDEFINED for all
  ##  @return      orxOBJECT / nil

proc getNextEnabled*(pstObject: ptr orxOBJECT; stGroupID: orxSTRINGID): ptr orxOBJECT {.
    cdecl, importc: "orxObject_GetNextEnabled", dynlib: libORX.}
  ## Gets next object in group.
  ##  @param[in]   _pstObject      Concerned object, nil to get the first one
  ##  @param[in]   _stGroupID      Group ID to consider, orxSTRINGID_UNDEFINED for all
  ##  @return      orxOBJECT / nil

proc pick*(pvPosition: ptr orxVECTOR; stGroupID: orxSTRINGID): ptr orxOBJECT {.
    cdecl, importc: "orxObject_Pick", dynlib: libORX.}
  ## @}
  ## @name Picking
  ##  @{
  ## Picks the first active object with size "under" the given position, within a given group. See
  ##  orxObject_BoxPick(), orxObject_CreateNeighborList() and orxObject_Raycast for other ways of picking
  ##  objects.
  ##  @param[in]   _pvPosition     Position to pick from
  ##  @param[in]   _stGroupID      Group ID to consider, orxSTRINGID_UNDEFINED for all
  ##  @return      orxOBJECT / nil

proc boxPick*(pstBox: ptr orxOBOX; stGroupID: orxSTRINGID): ptr orxOBJECT {.
    cdecl, importc: "orxObject_BoxPick", dynlib: libORX.}
  ## Picks the first active object with size in contact with the given box, withing a given group. Use
  ##  orxObject_CreateNeighborList() to get all the objects in the box.
  ##  @param[in]   _pstBox         Box to use for picking
  ##  @param[in]   _stGroupID      Group ID to consider, orxSTRINGID_UNDEFINED for all
  ##  @return      orxOBJECT / nil

