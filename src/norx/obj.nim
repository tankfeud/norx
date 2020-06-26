##  Orx - Portable Game Engine
##
##  Copyright (c) 2008-2020 Orx-Project
##
##  This software is provided 'as-is', without any express or implied
##  warranty. In no event will the authors be held liable for any damages
##  arising from the use of this software.
##
##  Permission is granted to anyone to use this software for any purpose,
##  including commercial applications, and to alter it and redistribute it
##  freely, subject to the following restrictions:
##
##     1. The origin of this software must not be misrepresented; you must not
##     claim that you wrote the original software. If you use this software
##     in a product, an acknowledgment in the product documentation would be
##     appreciated but is not required.
##
##     2. Altered source versions must be plainly marked as such, and must not be
##     misrepresented as being the original software.
##
##     3. This notice may not be removed or altered from any source
##     distribution.


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
## * @name Internal module function
##  @{
## * Object module setup
##

proc orxObject_Setup*() {.cdecl, importc: "orxObject_Setup", dynlib: libORX.}
## * Inits the object module.
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_Init*(): orxSTATUS {.cdecl, importc: "orxObject_Init",
                                 dynlib: libORX.}
## * Exits from the object module.
##

proc orxObject_Exit*() {.cdecl, importc: "orxObject_Exit", dynlib: libORX.}

## * @}
## * @name Basic handling
##  @{
## * Creates an empty object.
##  @return orxOBJECT / nil
##
proc orxObject_Create*(): ptr orxOBJECT {.cdecl, importc: "orxObject_Create",
                                      dynlib: libORX.}

## * Creates an object from config.
##  @param[in]   _zConfigID    Config ID
##  @ return orxOBJECT / nil
##
proc orxObject_CreateFromConfig*(zConfigID: cstring): ptr orxOBJECT {.cdecl,
    importc: "orxObject_CreateFromConfig", dynlib: libORX.}

## * Deletes an object, *unsafe* when called from an event handler: call orxObject_SetLifeTime(orxFLOAT_0) instead
##  @param[in] _pstObject        Concerned object
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##
proc orxObject_Delete*(pstObject: ptr orxOBJECT): orxSTATUS {.cdecl,
    importc: "orxObject_Delete", dynlib: libORX.}
## * Updates an object.
##  @param[in] _pstObject        Concerned object
##  @param[in] _pstClockInfo     Clock information used to compute new object's state
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_Update*(pstObject: ptr orxOBJECT; pstClockInfo: ptr orxCLOCK_INFO): orxSTATUS {.
    cdecl, importc: "orxObject_Update", dynlib: libORX.}
## * Enables/disables an object. Note that enabling/disabling an object is not recursive, so its children will not be affected, see orxObject_EnableRecursive().
##  @param[in]   _pstObject    Concerned object
##  @param[in]   _bEnable      Enable / disable
##

proc orxObject_Enable*(pstObject: ptr orxOBJECT; bEnable: orxBOOL) {.cdecl,
    importc: "orxObject_Enable", dynlib: libORX.}
## * Enables/disables an object and all its children.
##  @param[in]   _pstObject    Concerned object
##  @param[in]   _bEnable      Enable / disable
##

proc orxObject_EnableRecursive*(pstObject: ptr orxOBJECT; bEnable: orxBOOL) {.cdecl,
    importc: "orxObject_EnableRecursive", dynlib: libORX.}
## * Is object enabled?
##  @param[in]   _pstObject    Concerned object
##  @return      orxTRUE if enabled, orxFALSE otherwise
##

proc orxObject_IsEnabled*(pstObject: ptr orxOBJECT): orxBOOL {.cdecl,
    importc: "orxObject_IsEnabled", dynlib: libORX.}
## * Pauses/unpauses an object. Note that pausing an object is not recursive, so its children will not be affected, see orxObject_PauseRecursive().
##  @param[in]   _pstObject    Concerned object
##  @param[in]   _bPause       Pause / unpause
##

proc orxObject_Pause*(pstObject: ptr orxOBJECT; bPause: orxBOOL) {.cdecl,
    importc: "orxObject_Pause", dynlib: libORX.}
## * Pauses/unpauses an object and its children.
##  @param[in]   _pstObject    Concerned object
##  @param[in]   _bPause       Pause / unpause
##

proc orxObject_PauseRecursive*(pstObject: ptr orxOBJECT; bPause: orxBOOL) {.cdecl,
    importc: "orxObject_PauseRecursive", dynlib: libORX.}
## * Is object paused?
##  @param[in]   _pstObject    Concerned object
##  @return      orxTRUE if paused, orxFALSE otherwise
##

proc orxObject_IsPaused*(pstObject: ptr orxOBJECT): orxBOOL {.cdecl,
    importc: "orxObject_IsPaused", dynlib: libORX.}
## * @}
## * @name User data
##  @{
## * Sets user data for an object. Orx ignores the user data, this is a mechanism for attaching custom
##  data to be used later by user code.
##  @param[in]   _pstObject    Concerned object
##  @param[in]   _pUserData    User data to store / nil
##

proc orxObject_SetUserData*(pstObject: ptr orxOBJECT; pUserData: pointer) {.cdecl,
    importc: "orxObject_SetUserData", dynlib: libORX.}
## * Gets object's user data.
##  @param[in]   _pstObject    Concerned object
##  @return      Stored user data / nil
##

proc orxObject_GetUserData*(pstObject: ptr orxOBJECT): pointer {.cdecl,
    importc: "orxObject_GetUserData", dynlib: libORX.}
## * @}
## * @name Ownership
##  @{
## * Sets owner for an object. Ownership in Orx is only about lifetime management. That is, when an object
##  dies, it also kills its children. Compare this with orxObject_SetParent().
##
##  Note that the "ChildList" field of an object's config section implies two things; that the object is both
##  the owner (orxObject_SetOwner()) and the parent (orxObject_SetParent()) of its children. There is an
##  exception to this though; when an object's child has a parent camera, the object is only the owner, and
##  the camera is the parent.
##  @param[in]   _pstObject    Concerned object
##  @param[in]   _pOwner       Owner to set / nil, if owner is an orxOBJECT, the owned object will be added to it as a children
##

proc orxObject_SetOwner*(pstObject: ptr orxOBJECT; pOwner: pointer) {.cdecl,
    importc: "orxObject_SetOwner", dynlib: libORX.}
## * Gets object's owner. See orxObject_SetOwner().
##  @param[in]   _pstObject    Concerned object
##  @return      Owner / nil
##

proc orxObject_GetOwner*(pstObject: ptr orxOBJECT): ptr orxSTRUCTURE {.cdecl,
    importc: "orxObject_GetOwner", dynlib: libORX.}
## * Gets object's first owned child (only if created with a config ChildList / has an owner set with orxObject_SetOwner)
##  see orxObject_SetOwner() and orxObject_SetParent() for a comparison of ownership and parenthood in Orx.
##
##  This function is typically used to iterate over the owned children of an object. For example;
##  @code
##  for(orxOBJECT * pstChild = orxObject_GetOwnedChild(pstObject);
##      pstChild;
##      pstChild = orxObject_GetOwnedSibling(pstChild))
##  {
##      do_something(pstChild);
##  } @endcode
##  @param[in]   _pstObject    Concerned object
##  @return      First owned child object / nil
##

proc orxObject_GetOwnedChild*(pstObject: ptr orxOBJECT): ptr orxOBJECT {.cdecl,
    importc: "orxObject_GetOwnedChild", dynlib: libORX.}
## * Gets object's next owned sibling (only if created with a config ChildList / has an owner set with orxObject_SetOwner)
##  This function is typically used to iterate over the owned children of an object, see orxObject_GetOwnedChild() for an example.
##  @param[in]   _pstObject    Concerned object
##  @return      Next sibling object / nil
##

proc orxObject_GetOwnedSibling*(pstObject: ptr orxOBJECT): ptr orxOBJECT {.cdecl,
    importc: "orxObject_GetOwnedSibling", dynlib: libORX.}
## * @}
## * @name Clock
##  @{
## * Sets associated clock for an object.
##  @param[in]   _pstObject    Concerned object
##  @param[in]   _pstClock     Clock to associate / nil
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_SetClock*(pstObject: ptr orxOBJECT; pstClock: ptr orxCLOCK): orxSTATUS {.
    cdecl, importc: "orxObject_SetClock", dynlib: libORX.}
## * Gets object's clock.
##  @param[in]   _pstObject    Concerned object
##  @return      Associated clock / nil
##

proc orxObject_GetClock*(pstObject: ptr orxOBJECT): ptr orxCLOCK {.cdecl,
    importc: "orxObject_GetClock", dynlib: libORX.}
## * @}
## * @name Linked structures
##  @{
## * Links a structure to an object.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _pstStructure   Structure to link
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_LinkStructure*(pstObject: ptr orxOBJECT;
                             pstStructure: ptr orxSTRUCTURE): orxSTATUS {.cdecl,
    importc: "orxObject_LinkStructure", dynlib: libORX.}
## * Unlinks structure from an object, given its structure ID.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _eStructureID   ID of structure to unlink
##

proc orxObject_UnlinkStructure*(pstObject: ptr orxOBJECT;
                               eStructureID: orxSTRUCTURE_ID) {.cdecl,
    importc: "orxObject_UnlinkStructure", dynlib: libORX.}
## * Structure used by an object get accessor, given its structure ID. Structure must then be cast correctly. (see helper macro
##  #orxOBJECT_GET_STRUCTURE())
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _eStructureID   ID of the structure to get
##  @return orxSTRUCTURE / nil
##

proc orxObject_GetStructure*(pstObject: ptr orxOBJECT; eStructureID: orxSTRUCTURE_ID): ptr orxSTRUCTURE {.
    cdecl, importc: "_orxObject_GetStructure", dynlib: libORX.}
## * @}
## * @name Flip
##  @{
## * Sets object flipping.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _bFlipX         Flip it on X axis
##  @param[in]   _bFlipY         Flip it on Y axis
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_SetFlip*(pstObject: ptr orxOBJECT; bFlipX: orxBOOL; bFlipY: orxBOOL): orxSTATUS {.
    cdecl, importc: "orxObject_SetFlip", dynlib: libORX.}
## * Gets object flipping.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _pbFlipX        X axis flipping
##  @param[in]   _pbFlipY        Y axis flipping
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_GetFlip*(pstObject: ptr orxOBJECT; pbFlipX: ptr orxBOOL;
                       pbFlipY: ptr orxBOOL): orxSTATUS {.cdecl,
    importc: "orxObject_GetFlip", dynlib: libORX.}
## * @}
## * @name Graphic
##  @{
## * Sets object pivot. This is a convenience wrapper around orxGraphic_SetPivot(). The "pivot" is essentially
##  what is indicated by the "Pivot" field of a config graphic section.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _pvPivot        Object pivot
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_SetPivot*(pstObject: ptr orxOBJECT; pvPivot: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxObject_SetPivot", dynlib: libORX.}
## * Sets object origin. This is a convenience wrapper around orxGraphic_SetOrigin(). The "origin" of a graphic is
##  essentially what is indicated by the "TextureOrigin" field of a config graphic section. The "origin" together with
##  "size" (see orxObject_SetSize()) defines the sprite of an object.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _pvOrigin       Object origin
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_SetOrigin*(pstObject: ptr orxOBJECT; pvOrigin: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxObject_SetOrigin", dynlib: libORX.}
## * Sets object size. For objects that have a graphic attached it's simply a convenience wrapper for orxGraphic_SetSize(),
##  but an object can also have a size without a graphic.
##
##  Note the difference between "Scale" and "Size". The size of an object with a non-text graphic is the sprite size in
##  pixels on its texture. The object's effective size for rendering and intersection purposes (see orxObject_Pick()
##  and friends) is proportional to its "size" multiplied by its "scale". Another important distinction is that the
##  scale of an object also affects its children (see orxObject_SetParent() and note the distinction between
##  parenthood and ownership).
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _pvSize       	Object size
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_SetSize*(pstObject: ptr orxOBJECT; pvSize: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxObject_SetSize", dynlib: libORX.}
## * Get object pivot. See orxObject_SetPivot() for a more detailed explanation.
##  @param[in]   _pstObject      Concerned object
##  @param[out]  _pvPivot        Object pivot
##  @return      orxVECTOR / nil
##

proc orxObject_GetPivot*(pstObject: ptr orxOBJECT; pvPivot: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxObject_GetPivot", dynlib: libORX.}
## * Get object origin. See orxObject_SetOrigin() for a more detailed explanation.
##  @param[in]   _pstObject      Concerned object
##  @param[out]  _pvOrigin       Object origin
##  @return      orxVECTOR / nil
##

proc orxObject_GetOrigin*(pstObject: ptr orxOBJECT; pvOrigin: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxObject_GetOrigin", dynlib: libORX.}
## * Gets object size. See orxObject_SetSize() for a more detailed explanation.
##  @param[in]   _pstObject      Concerned object
##  @param[out]  _pvSize         Object's size
##  @return      orxVECTOR / nil
##

proc orxObject_GetSize*(pstObject: ptr orxOBJECT; pvSize: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxObject_GetSize", dynlib: libORX.}
## * @}
## * @name Frame
##  @{
## * Sets object position in its parent's reference frame. See orxObject_SetWorldPosition() for setting an object's
##  position in the global reference frame.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _pvPosition     Object position
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_SetPosition*(pstObject: ptr orxOBJECT; pvPosition: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxObject_SetPosition", dynlib: libORX.}
## * Sets object position in the global reference frame. See orxObject_SetPosition() for setting an object's position
##  in its parent's reference frame.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _pvPosition     Object world position
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_SetWorldPosition*(pstObject: ptr orxOBJECT; pvPosition: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxObject_SetWorldPosition", dynlib: libORX.}
## * Sets object rotation in its parent's reference frame. See orxObject_SetWorldRotation() for setting an object's
##  rotation in the global reference frame.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _fRotation      Object rotation (radians)
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_SetRotation*(pstObject: ptr orxOBJECT; fRotation: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxObject_SetRotation", dynlib: libORX.}
## * Sets object rotation in the global reference frame. See orxObject_SetRotation() for setting an object's rotation
##  in its parent's reference frame.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _fRotation      Object world rotation (radians)
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_SetWorldRotation*(pstObject: ptr orxOBJECT; fRotation: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxObject_SetWorldRotation", dynlib: libORX.}
## * Sets object scale in its parent's reference frame. See orxObject_SetWorldScale() for setting an object's scale
##  in the global reference frame.
##  See orxObject_SetSize() for a deeper explanation of the "size" of an object.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _pvScale        Object scale vector
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_SetScale*(pstObject: ptr orxOBJECT; pvScale: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxObject_SetScale", dynlib: libORX.}
## * Sets object scale in the global reference frame. See orxObject_SetScale() for setting an object's scale in its
##  parent's reference frame.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _pvScale        Object world scale vector
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_SetWorldScale*(pstObject: ptr orxOBJECT; pvScale: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxObject_SetWorldScale", dynlib: libORX.}
## * Get object position. See orxObject_SetPosition().
##  @param[in]   _pstObject      Concerned object
##  @param[out]  _pvPosition     Object position
##  @return      orxVECTOR / nil
##

proc orxObject_GetPosition*(pstObject: ptr orxOBJECT; pvPosition: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxObject_GetPosition", dynlib: libORX.}
## * Get object world position. See orxObject_SetWorldPosition().
##  @param[in]   _pstObject      Concerned object
##  @param[out]  _pvPosition     Object world position
##  @return      orxVECTOR / nil
##

proc orxObject_GetWorldPosition*(pstObject: ptr orxOBJECT; pvPosition: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxObject_GetWorldPosition", dynlib: libORX.}
## * Get object rotation. See orxObject_SetRotation().
##  @param[in]   _pstObject      Concerned object
##  @return      orxFLOAT (radians)
##

proc orxObject_GetRotation*(pstObject: ptr orxOBJECT): orxFLOAT {.cdecl,
    importc: "orxObject_GetRotation", dynlib: libORX.}
## * Get object world rotation. See orxObject_SetWorldRotation().
##  @param[in]   _pstObject      Concerned object
##  @return      orxFLOAT (radians)
##

proc orxObject_GetWorldRotation*(pstObject: ptr orxOBJECT): orxFLOAT {.cdecl,
    importc: "orxObject_GetWorldRotation", dynlib: libORX.}
## * Get object scale. See orxObject_SetScale().
##  @param[in]   _pstObject      Concerned object
##  @param[out]  _pvScale        Object scale vector
##  @return      Scale vector
##

proc orxObject_GetScale*(pstObject: ptr orxOBJECT; pvScale: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxObject_GetScale", dynlib: libORX.}
## * Gets object world scale. See orxObject_SetWorldScale().
##  @param[in]   _pstObject      Concerned object
##  @param[out]  _pvScale        Object world scale
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_GetWorldScale*(pstObject: ptr orxOBJECT; pvScale: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxObject_GetWorldScale", dynlib: libORX.}
## * @}
## * @name Parent
##  @{
## * Sets an object parent (in the frame hierarchy). Parenthood in orx is about the transformation (position,
##  rotation, scale) of objects. Transformation of objects are compounded in a frame hierarchy. Compare this
##  with orxObject_SetOwner()
##
##  Note that the "ChildList" field of an object's config section implies two things; that the object is both
##  the owner (orxObject_SetOwner()) and the parent (orxObject_SetParent()) of its children. There is an
##  exception to this though; when an object's child has a parent camera, the object is only the owner, and
##  the camera is the parent.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _pParent        Parent structure to set (object, spawner, camera or frame) / nil
##  @return      orsSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_SetParent*(pstObject: ptr orxOBJECT; pParent: pointer): orxSTATUS {.
    cdecl, importc: "orxObject_SetParent", dynlib: libORX.}
## * Gets object's parent. See orxObject_SetParent() for a more detailed explanation.
##  @param[in]   _pstObject    Concerned object
##  @return      Parent (object, spawner, camera or frame) / nil
##

proc orxObject_GetParent*(pstObject: ptr orxOBJECT): ptr orxSTRUCTURE {.cdecl,
    importc: "orxObject_GetParent", dynlib: libORX.}
## * Gets object's first child. See orxObject_SetOwner() and orxObject_SetParent() for a comparison of
##  ownership and parenthood in Orx.
##
##  This function is typically used to iterate over the children of an object. For example:
##  @code
##  for(orxOBJECT *pstChild = orxOBJECT(orxObject_GetChild(pstObject));
##      pstChild != nil;
##      pstChild = orxOBJECT(orxObject_GetSibling(pstChild)))
##  {
##      DoSomething(pstChild);
##  }
##  @endcode
##  @param[in]   _pstObject    Concerned object
##  @return      First child structure (object, spawner, camera or frame) / nil
##

proc orxObject_GetChild*(pstObject: ptr orxOBJECT): ptr orxSTRUCTURE {.cdecl,
    importc: "orxObject_GetChild", dynlib: libORX.}
## * Gets object's next sibling. This function is typically used for iterating over the children of an object,
##  see orxObject_GetChild() for an iteration example.
##  @param[in]   _pstObject    Concerned object
##  @return      Next sibling structure (object, spawner, camera or frame) / nil
##

proc orxObject_GetSibling*(pstObject: ptr orxOBJECT): ptr orxSTRUCTURE {.cdecl,
    importc: "orxObject_GetSibling", dynlib: libORX.}
## * Attaches an object to a parent while maintaining the object's world position.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _pParent        Parent structure to attach to (object, spawner, camera or frame)
##  @return      orsSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_Attach*(pstObject: ptr orxOBJECT; pParent: pointer): orxSTATUS {.cdecl,
    importc: "orxObject_Attach", dynlib: libORX.}
## * Detaches an object from a parent while maintaining the object's world position.
##  @param[in]   _pstObject      Concerned object
##  @return      orsSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_Detach*(pstObject: ptr orxOBJECT): orxSTATUS {.cdecl,
    importc: "orxObject_Detach", dynlib: libORX.}
## * Logs all parents of an object, including their frame data.
##  @param[in]   _pstObject      Concerned object
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_LogParents*(pstObject: ptr orxOBJECT): orxSTATUS {.cdecl,
    importc: "orxObject_LogParents", dynlib: libORX.}
## * @}
## * @name Animation
##  @{
## * Sets an object animset.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _pstAnimSet     Animation set to set / nil
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_SetAnimSet*(pstObject: ptr orxOBJECT; pstAnimSet: ptr orxANIMSET): orxSTATUS {.
    cdecl, importc: "orxObject_SetAnimSet", dynlib: libORX.}
## * Sets an object's relative animation frequency.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _fFrequency     Frequency to set: < 1.0 for slower than initial, > 1.0 for faster than initial
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_SetAnimFrequency*(pstObject: ptr orxOBJECT; fFrequency: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxObject_SetAnimFrequency", dynlib: libORX.}
## * Sets the relative animation frequency for an object and its children.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _fFrequency     Frequency to set: < 1.0 for slower than initial, > 1.0 for faster than initial
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_SetAnimFrequencyRecursive*(pstObject: ptr orxOBJECT;
    fFrequency: orxFLOAT) {.cdecl, importc: "orxObject_SetAnimFrequencyRecursive",
                          dynlib: libORX.}
## * Gets an object's relative animation frequency.
##  @param[in]   _pstObject      Concerned object
##  @return Animation frequency / -orxFLOAT_1
##

proc orxObject_GetAnimFrequency*(pstObject: ptr orxOBJECT): orxFLOAT {.cdecl,
    importc: "orxObject_GetAnimFrequency", dynlib: libORX.}
## * Sets current animation for an object. This function switches the currently displayed animation of the object
##  immediately. Compare this with orxObject_SetTargetAnim().
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _zAnimName      Animation name (config's one) to set / nil
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_SetCurrentAnim*(pstObject: ptr orxOBJECT; zAnimName: cstring): orxSTATUS {.
    cdecl, importc: "orxObject_SetCurrentAnim", dynlib: libORX.}
## * Sets current animation for an object and its children.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _zAnimName      Animation name (config's one) to set / nil
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_SetCurrentAnimRecursive*(pstObject: ptr orxOBJECT;
                                       zAnimName: cstring) {.cdecl,
    importc: "orxObject_SetCurrentAnimRecursive", dynlib: libORX.}
## * Sets target animation for an object. The animations are sequenced on an object according to the animation link graph
##  defined by its AnimationSet. The sequence follows the graph and tries to reach the target animation. Use
##  orxObject_SetCurrentAnim() to switch the animation without using the link graph.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _zAnimName      Animation name (config's one) to set / nil
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_SetTargetAnim*(pstObject: ptr orxOBJECT; zAnimName: cstring): orxSTATUS {.
    cdecl, importc: "orxObject_SetTargetAnim", dynlib: libORX.}
## * Sets target animation for an object and its children.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _zAnimName      Animation name (config's one) to set / nil
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_SetTargetAnimRecursive*(pstObject: ptr orxOBJECT;
                                      zAnimName: cstring) {.cdecl,
    importc: "orxObject_SetTargetAnimRecursive", dynlib: libORX.}
## * Gets current animation.
##  @param[in]   _pstObject      Concerned object
##  @return      Current animation / orxSTRING_EMPTY
##

proc orxObject_GetCurrentAnim*(pstObject: ptr orxOBJECT): cstring {.cdecl,
    importc: "orxObject_GetCurrentAnim", dynlib: libORX.}
## * Gets target animation.
##  @param[in]   _pstObject      Concerned object
##  @return      Target animation / orxSTRING_EMPTY
##

proc orxObject_GetTargetAnim*(pstObject: ptr orxOBJECT): cstring {.cdecl,
    importc: "orxObject_GetTargetAnim", dynlib: libORX.}
## * Is current animation test.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _zAnimName      Animation name (config's one) to test
##  @return      orxTRUE / orxFALSE
##

proc orxObject_IsCurrentAnim*(pstObject: ptr orxOBJECT; zAnimName: cstring): orxBOOL {.
    cdecl, importc: "orxObject_IsCurrentAnim", dynlib: libORX.}
## * Is target animation test.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _zAnimName      Animation name (config's one) to test
##  @return      orxTRUE / orxFALSE
##

proc orxObject_IsTargetAnim*(pstObject: ptr orxOBJECT; zAnimName: cstring): orxBOOL {.
    cdecl, importc: "orxObject_IsTargetAnim", dynlib: libORX.}
## * @}
## * @name Physics / dynamics
##  @{
## * Sets an object speed.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _pvSpeed        Speed to set
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_SetSpeed*(pstObject: ptr orxOBJECT; pvSpeed: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxObject_SetSpeed", dynlib: libORX.}
## * Sets an object speed relative to its rotation/scale.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _pvRelativeSpeed Relative speed to set
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_SetRelativeSpeed*(pstObject: ptr orxOBJECT;
                                pvRelativeSpeed: ptr orxVECTOR): orxSTATUS {.cdecl,
    importc: "orxObject_SetRelativeSpeed", dynlib: libORX.}
## * Sets an object angular velocity.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _fVelocity      Angular velocity to set (radians/seconds)
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_SetAngularVelocity*(pstObject: ptr orxOBJECT; fVelocity: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxObject_SetAngularVelocity", dynlib: libORX.}
## * Sets an object custom gravity.
##  @param[in]   _pstObject        Concerned object
##  @param[in]   _pvCustomGravity  Custom gravity to set / nil to remove it
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_SetCustomGravity*(pstObject: ptr orxOBJECT;
                                pvCustomGravity: ptr orxVECTOR): orxSTATUS {.cdecl,
    importc: "orxObject_SetCustomGravity", dynlib: libORX.}
## * Gets an object speed.
##  @param[in]   _pstObject      Concerned object
##  @param[out]   _pvSpeed       Speed to get
##  @return      Object speed / nil
##

proc orxObject_GetSpeed*(pstObject: ptr orxOBJECT; pvSpeed: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxObject_GetSpeed", dynlib: libORX.}
## * Gets an object relative speed.
##  @param[in]   _pstObject      Concerned object
##  @param[out]  _pvRelativeSpeed Relative speed to get
##  @return      Object relative speed / nil
##

proc orxObject_GetRelativeSpeed*(pstObject: ptr orxOBJECT;
                                pvRelativeSpeed: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxObject_GetRelativeSpeed", dynlib: libORX.}
## * Gets an object angular velocity.
##  @param[in]   _pstObject      Concerned object
##  @return      Object angular velocity (radians/seconds)
##

proc orxObject_GetAngularVelocity*(pstObject: ptr orxOBJECT): orxFLOAT {.cdecl,
    importc: "orxObject_GetAngularVelocity", dynlib: libORX.}
## * Gets an object custom gravity.
##  @param[in]   _pstObject        Concerned object
##  @param[out]  _pvCustomGravity  Custom gravity to get
##  @return      Object custom gravity / nil is object doesn't have any
##

proc orxObject_GetCustomGravity*(pstObject: ptr orxOBJECT;
                                pvCustomGravity: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxObject_GetCustomGravity", dynlib: libORX.}
## * Gets an object mass.
##  @param[in]   _pstObject      Concerned object
##  @return      Object mass
##

proc orxObject_GetMass*(pstObject: ptr orxOBJECT): orxFLOAT {.cdecl,
    importc: "orxObject_GetMass", dynlib: libORX.}
## * Gets an object center of mass (object space).
##  @param[in]   _pstObject      Concerned object
##  @param[out]  _pvMassCenter   Mass center to get
##  @return      Mass center / nil
##

proc orxObject_GetMassCenter*(pstObject: ptr orxOBJECT; pvMassCenter: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxObject_GetMassCenter", dynlib: libORX.}
## * Applies a torque.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _fTorque        Torque to apply
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_ApplyTorque*(pstObject: ptr orxOBJECT; fTorque: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxObject_ApplyTorque", dynlib: libORX.}
## * Applies a force.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _pvForce        Force to apply
##  @param[in]   _pvPoint        Point (world coordinates) where the force will be applied, if nil, center of mass will be used
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_ApplyForce*(pstObject: ptr orxOBJECT; pvForce: ptr orxVECTOR;
                          pvPoint: ptr orxVECTOR): orxSTATUS {.cdecl,
    importc: "orxObject_ApplyForce", dynlib: libORX.}
## * Applies an impulse.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _pvImpulse      Impulse to apply
##  @param[in]   _pvPoint        Point (world coordinates) where the impulse will be applied, if nil, center of mass will be used
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_ApplyImpulse*(pstObject: ptr orxOBJECT; pvImpulse: ptr orxVECTOR;
                            pvPoint: ptr orxVECTOR): orxSTATUS {.cdecl,
    importc: "orxObject_ApplyImpulse", dynlib: libORX.}
## * Issues a raycast to test for potential objects in the way.
##  @param[in]   _pvBegin        Beginning of raycast
##  @param[in]   _pvEnd          End of raycast
##  @param[in]   _u16SelfFlags   Selfs flags used for filtering (0xFFFF for no filtering)
##  @param[in]   _u16CheckMask   Check mask used for filtering (0xFFFF for no filtering)
##  @param[in]   _bEarlyExit     Should stop as soon as an object has been hit (which might not be the closest)
##  @param[in]   _pvContact      If non-null and a contact is found it will be stored here
##  @param[in]   _pvNormal       If non-null and a contact is found, its normal will be stored here
##  @return Colliding orxOBJECT / nil
##

proc orxObject_Raycast*(pvBegin: ptr orxVECTOR; pvEnd: ptr orxVECTOR;
                       u16SelfFlags: orxU16; u16CheckMask: orxU16;
                       bEarlyExit: orxBOOL; pvContact: ptr orxVECTOR;
                       pvNormal: ptr orxVECTOR): ptr orxOBJECT {.cdecl,
    importc: "orxObject_Raycast", dynlib: libORX.}
## * @}
## * @name Text
##  @{
## * Sets object text string, if object is associated to a text.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _zString        String to set
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_SetTextString*(pstObject: ptr orxOBJECT; zString: cstring): orxSTATUS {.
    cdecl, importc: "orxObject_SetTextString", dynlib: libORX.}
## * Gets object text string, if object is associated to a text.
##  @param[in]   _pstObject      Concerned object
##  @return      orxSTRING / orxSTRING_EMPTY
##

proc orxObject_GetTextString*(pstObject: ptr orxOBJECT): cstring {.cdecl,
    importc: "orxObject_GetTextString", dynlib: libORX.}
## * @}
## * @name Bounding box
##  @{
## * Gets object's bounding box (OBB).
##  @param[in]   _pstObject      Concerned object
##  @param[out]  _pstBoundingBox Bounding box result
##  @return      Bounding box / nil
##

proc orxObject_GetBoundingBox*(pstObject: ptr orxOBJECT; pstBoundingBox: ptr orxOBOX): ptr orxOBOX {.
    cdecl, importc: "orxObject_GetBoundingBox", dynlib: libORX.}
## * @}
## * @name FX
##  @{
## * Adds an FX using its config ID.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _zFXConfigID    Config ID of the FX to add
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_AddFX*(pstObject: ptr orxOBJECT; zFXConfigID: cstring): orxSTATUS {.
    cdecl, importc: "orxObject_AddFX", dynlib: libORX.}
## * Adds an FX to an object and its children.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _zFXConfigID    Config ID of the FX to add
##

proc orxObject_AddFXRecursive*(pstObject: ptr orxOBJECT; zFXConfigID: cstring) {.
    cdecl, importc: "orxObject_AddFXRecursive", dynlib: libORX.}
## * Adds a unique FX using its config ID. Refer to orxObject_AddUniqueDelayedFX() for details, since this
##  function is the same as it with the delay argument set to 0.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _zFXConfigID    Config ID of the FX to add
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_AddUniqueFX*(pstObject: ptr orxOBJECT; zFXConfigID: cstring): orxSTATUS {.
    cdecl, importc: "orxObject_AddUniqueFX", dynlib: libORX.}
## * Adds a unique FX to an object and its children.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _zFXConfigID    Config ID of the FX to add
##

proc orxObject_AddUniqueFXRecursive*(pstObject: ptr orxOBJECT;
                                    zFXConfigID: cstring) {.cdecl,
    importc: "orxObject_AddUniqueFXRecursive", dynlib: libORX.}
## * Adds a delayed FX using its config ID.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _zFXConfigID    Config ID of the FX to add
##  @param[in]   _fDelay         Delay time
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_AddDelayedFX*(pstObject: ptr orxOBJECT; zFXConfigID: cstring;
                            fDelay: orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxObject_AddDelayedFX", dynlib: libORX.}
## * Adds a delayed FX to an object and its children.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _zFXConfigID    Config ID of the FX to add
##  @param[in]   _fDelay         Delay time
##  @param[in]   _bPropagate    Should the delay be incremented with each child application?
##

proc orxObject_AddDelayedFXRecursive*(pstObject: ptr orxOBJECT;
                                     zFXConfigID: cstring; fDelay: orxFLOAT;
                                     bPropagate: orxBOOL) {.cdecl,
    importc: "orxObject_AddDelayedFXRecursive", dynlib: libORX.}
## * Adds a unique delayed FX using its config ID. The difference between this function and orxObject_AddDelayedFX()
##  is that this one does not add the specified FX, if the object already has an FX with the same config ID attached.
##  note that the "uniqueness" is determined immediately at the time of this function call, not at the time of the
##  FX start (i.e. after the delay).
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _zFXConfigID    Config ID of the FX to add
##  @param[in]   _fDelay         Delay time
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_AddUniqueDelayedFX*(pstObject: ptr orxOBJECT;
                                  zFXConfigID: cstring; fDelay: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxObject_AddUniqueDelayedFX", dynlib: libORX.}
## * Adds a unique delayed FX to an object and its children.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _zFXConfigID    Config ID of the FX to add
##  @param[in]   _fDelay         Delay time
##  @param[in]   _bPropagate    Should the delay be incremented with each child application?
##

proc orxObject_AddUniqueDelayedFXRecursive*(pstObject: ptr orxOBJECT;
    zFXConfigID: cstring; fDelay: orxFLOAT; bPropagate: orxBOOL) {.cdecl,
    importc: "orxObject_AddUniqueDelayedFXRecursive", dynlib: libORX.}
## * Removes an FX using its config ID.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _zFXConfigID    Config ID of the FX to remove
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_RemoveFX*(pstObject: ptr orxOBJECT; zFXConfigID: cstring): orxSTATUS {.
    cdecl, importc: "orxObject_RemoveFX", dynlib: libORX.}
## * Synchronizes FXs with another object's ones (if FXs are not matching on both objects the behavior is undefined).
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _pstModel       Model object on which to synchronize FXs
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_SynchronizeFX*(pstObject: ptr orxOBJECT; pstModel: ptr orxOBJECT): orxSTATUS {.
    cdecl, importc: "orxObject_SynchronizeFX", dynlib: libORX.}
## * @}
## * @name Sound
##  @{
## * Adds a sound using its config ID.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _zSoundConfigID Config ID of the sound to add
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_AddSound*(pstObject: ptr orxOBJECT; zSoundConfigID: cstring): orxSTATUS {.
    cdecl, importc: "orxObject_AddSound", dynlib: libORX.}
## * Removes a sound using its config ID.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _zSoundConfigID Config ID of the sound to remove
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_RemoveSound*(pstObject: ptr orxOBJECT; zSoundConfigID: cstring): orxSTATUS {.
    cdecl, importc: "orxObject_RemoveSound", dynlib: libORX.}
## * Gets last added sound (Do *NOT* destroy it directly before removing it!!!).
##  @param[in]   _pstObject      Concerned object
##  @return      orxSOUND / nil
##

proc orxObject_GetLastAddedSound*(pstObject: ptr orxOBJECT): ptr orxSOUND {.cdecl,
    importc: "orxObject_GetLastAddedSound", dynlib: libORX.}
## * Sets volume for all sounds of an object.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _fVolume        Desired volume (0.0 - 1.0)
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_SetVolume*(pstObject: ptr orxOBJECT; fVolume: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxObject_SetVolume", dynlib: libORX.}
## * Sets pitch for all sounds of an object.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _fPitch         Desired pitch (0.0 - 1.0)
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_SetPitch*(pstObject: ptr orxOBJECT; fPitch: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxObject_SetPitch", dynlib: libORX.}
## * Plays all the sounds of an object.
##  @param[in]   _pstObject      Concerned object
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_Play*(pstObject: ptr orxOBJECT): orxSTATUS {.cdecl,
    importc: "orxObject_Play", dynlib: libORX.}
## * Stops all the sounds of an object.
##  @param[in]   _pstObject      Concerned object
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_Stop*(pstObject: ptr orxOBJECT): orxSTATUS {.cdecl,
    importc: "orxObject_Stop", dynlib: libORX.}
## * @}
## * @name Shader
##  @{
## * Adds a shader to an object using its config ID.
##  @param[in]   _pstObject        Concerned object
##  @param[in]   _zShaderConfigID  Config ID of the shader to add
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_AddShader*(pstObject: ptr orxOBJECT; zShaderConfigID: cstring): orxSTATUS {.
    cdecl, importc: "orxObject_AddShader", dynlib: libORX.}
## * Removes a shader using its config ID.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _zShaderConfigID Config ID of the shader to remove
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_RemoveShader*(pstObject: ptr orxOBJECT; zShaderConfigID: cstring): orxSTATUS {.
    cdecl, importc: "orxObject_RemoveShader", dynlib: libORX.}
## * Enables an object's shader.
##  @param[in]   _pstObject        Concerned object
##  @param[in]   _bEnable          Enable / disable
##

proc orxObject_EnableShader*(pstObject: ptr orxOBJECT; bEnable: orxBOOL) {.cdecl,
    importc: "orxObject_EnableShader", dynlib: libORX.}
## * Is an object's shader enabled?
##  @param[in]   _pstObject        Concerned object
##  @return      orxTRUE if enabled, orxFALSE otherwise
##

proc orxObject_IsShaderEnabled*(pstObject: ptr orxOBJECT): orxBOOL {.cdecl,
    importc: "orxObject_IsShaderEnabled", dynlib: libORX.}
## * @}
## * @name TimeLine
##  @{
## * Adds a timeline track to an object using its config ID.
##  @param[in]   _pstObject        Concerned object
##  @param[in]   _zTrackConfigID   Config ID of the timeline track to add
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_AddTimeLineTrack*(pstObject: ptr orxOBJECT;
                                zTrackConfigID: cstring): orxSTATUS {.cdecl,
    importc: "orxObject_AddTimeLineTrack", dynlib: libORX.}
## * Adds a timeline track to an object and its children.
##  @param[in]   _pstObject        Concerned object
##  @param[in]   _zTrackConfigID   Config ID of the timeline track to add
##

proc orxObject_AddTimeLineTrackRecursive*(pstObject: ptr orxOBJECT;
    zTrackConfigID: cstring) {.cdecl,
                                importc: "orxObject_AddTimeLineTrackRecursive",
                                dynlib: libORX.}
## * Removes a timeline track using its config ID
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _zTrackConfigID Config ID of the timeline track to remove
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_RemoveTimeLineTrack*(pstObject: ptr orxOBJECT;
                                   zTrackConfigID: cstring): orxSTATUS {.cdecl,
    importc: "orxObject_RemoveTimeLineTrack", dynlib: libORX.}
## * Enables an object's timeline.
##  @param[in]   _pstObject        Concerned object
##  @param[in]   _bEnable          Enable / disable
##

proc orxObject_EnableTimeLine*(pstObject: ptr orxOBJECT; bEnable: orxBOOL) {.cdecl,
    importc: "orxObject_EnableTimeLine", dynlib: libORX.}
## * Is an object's timeline enabled?
##  @param[in]   _pstObject        Concerned object
##  @return      orxTRUE if enabled, orxFALSE otherwise
##

proc orxObject_IsTimeLineEnabled*(pstObject: ptr orxOBJECT): orxBOOL {.cdecl,
    importc: "orxObject_IsTimeLineEnabled", dynlib: libORX.}
## * @}
## * @name Name
##  @{
## * Gets object config name.
##  @param[in]   _pstObject      Concerned object
##  @return      orxSTRING / orxSTRING_EMPTY
##

proc orxObject_GetName*(pstObject: ptr orxOBJECT): cstring {.cdecl,
    importc: "orxObject_GetName", dynlib: libORX.}
## * @}
## * @name Neighboring
##  @{
## * Creates a list of object at neighboring of the given box (ie. whose bounding volume intersects this box).
##  The following is an example for iterating over a neighbor list:
##  @code
##  orxVECTOR vPosition; // The world position of the neighborhood area
##  // set_position(vPosition);
##  orxVECTOR vSize; // The size of the neighborhood area
##  // set_size(vSize);
##  orxVECTOR vPivot; // The pivot of the neighborhood area
##  // set_pivot(vPivot);
##
##  orxOBOX stBox;
##  orxOBox_2DSet(&stBox, &vPosition, &vPivot, &vSize, 0);
##
##  orxBANK * pstBank = orxObject_CreateNeighborList(&stBox, orxSTRINGID_UNDEFINED);
##  if(pstBank) {
##      for(int i=0; i < orxBank_GetCount(pstBank); ++i)
##      {
##          orxOBJECT * pstObject = *((orxOBJECT **) orxBank_GetAtIndex(pstBank, i));
##          do_something_with(pstObject);
##      }
##      orxObject_DeleteNeighborList(pstBank);
##  }
##  @endcode
##  @param[in]   _pstCheckBox    Box to check intersection with
##  @param[in]   _stGroupID      Group ID to consider, orxSTRINGID_UNDEFINED for all
##  @return      orxBANK / nil
##

proc orxObject_CreateNeighborList*(pstCheckBox: ptr orxOBOX; stGroupID: orxSTRINGID): ptr orxBANK {.
    cdecl, importc: "orxObject_CreateNeighborList", dynlib: libORX.}
## * Deletes an object list created with orxObject_CreateNeighborList().
##  @param[in]   _pstObjectList  Concerned object list
##

proc orxObject_DeleteNeighborList*(pstObjectList: ptr orxBANK) {.cdecl,
    importc: "orxObject_DeleteNeighborList", dynlib: libORX.}
## * @}
## * @name Smoothing
##  @{
## * Sets object smoothing.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _eSmoothing     Smoothing type (enabled, default or none)
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_SetSmoothing*(pstObject: ptr orxOBJECT;
                            eSmoothing: orxDISPLAY_SMOOTHING): orxSTATUS {.cdecl,
    importc: "orxObject_SetSmoothing", dynlib: libORX.}
## * Sets smoothing for an object and its children.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _eSmoothing     Smoothing type (enabled, default or none)
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_SetSmoothingRecursive*(pstObject: ptr orxOBJECT;
                                     eSmoothing: orxDISPLAY_SMOOTHING) {.cdecl,
    importc: "orxObject_SetSmoothingRecursive", dynlib: libORX.}
## * Gets object smoothing.
##  @param[in]   _pstObject     Concerned object
##  @return Smoothing type (enabled, default or none)
##

proc orxObject_GetSmoothing*(pstObject: ptr orxOBJECT): orxDISPLAY_SMOOTHING {.cdecl,
    importc: "orxObject_GetSmoothing", dynlib: libORX.}
## * @}
## * @name texture
##  @{
## * Gets object working texture.
##  @param[in]   _pstObject     Concerned object
##  @return orxTEXTURE / nil
##

proc orxObject_GetWorkingTexture*(pstObject: ptr orxOBJECT): ptr orxTEXTURE {.cdecl,
    importc: "orxObject_GetWorkingTexture", dynlib: libORX.}
## * @}
## * @name graphic
##  @{
## * Gets object working graphic.
##  @param[in]   _pstObject     Concerned object
##  @return orxGRAPHIC / nil
##

proc orxObject_GetWorkingGraphic*(pstObject: ptr orxOBJECT): ptr orxGRAPHIC {.cdecl,
    importc: "orxObject_GetWorkingGraphic", dynlib: libORX.}
## * Sets object color.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _pstColor       Color to set, nil to remove any specific color
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_SetColor*(pstObject: ptr orxOBJECT; pstColor: ptr orxCOLOR): orxSTATUS {.
    cdecl, importc: "orxObject_SetColor", dynlib: libORX.}
## * Sets color of an object and all its children.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _pstColor       Color to set, nil to remove any specific color
##

proc orxObject_SetColorRecursive*(pstObject: ptr orxOBJECT; pstColor: ptr orxCOLOR) {.
    cdecl, importc: "orxObject_SetColorRecursive", dynlib: libORX.}
## * Object has color accessor?
##  @param[in]   _pstObject      Concerned object
##  @return      orxTRUE / orxFALSE
##

proc orxObject_HasColor*(pstObject: ptr orxOBJECT): orxBOOL {.cdecl,
    importc: "orxObject_HasColor", dynlib: libORX.}
## * Gets object color.
##  @param[in]   _pstObject      Concerned object
##  @param[out]  _pstColor       Object's color
##  @return      orxCOLOR / nil
##

proc orxObject_GetColor*(pstObject: ptr orxOBJECT; pstColor: ptr orxCOLOR): ptr orxCOLOR {.
    cdecl, importc: "orxObject_GetColor", dynlib: libORX.}
## * Sets object RGB values.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _pvRGB          RGB values to set
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_SetRGB*(pstObject: ptr orxOBJECT; pvRGB: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxObject_SetRGB", dynlib: libORX.}
## * Sets color of an object and all its children.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _pvRGB          RGB values to set
##

proc orxObject_SetRGBRecursive*(pstObject: ptr orxOBJECT; pvRGB: ptr orxVECTOR) {.
    cdecl, importc: "orxObject_SetRGBRecursive", dynlib: libORX.}
## * Sets object alpha.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _fAlpha         Alpha value to set
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_SetAlpha*(pstObject: ptr orxOBJECT; fAlpha: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxObject_SetAlpha", dynlib: libORX.}
## * Sets alpha of an object and all its children.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _fAlpha         Alpha value to set
##

proc orxObject_SetAlphaRecursive*(pstObject: ptr orxOBJECT; fAlpha: orxFLOAT) {.cdecl,
    importc: "orxObject_SetAlphaRecursive", dynlib: libORX.}
## * Sets object repeat (wrap) values.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _fRepeatX       X-axis repeat value
##  @param[in]   _fRepeatY       Y-axis repeat value
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_SetRepeat*(pstObject: ptr orxOBJECT; fRepeatX: orxFLOAT;
                         fRepeatY: orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxObject_SetRepeat", dynlib: libORX.}
## * Gets object repeat (wrap) values.
##  @param[in]   _pstObject     Concerned object
##  @param[out]  _pfRepeatX      X-axis repeat value
##  @param[out]  _pfRepeatY      Y-axis repeat value
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_GetRepeat*(pstObject: ptr orxOBJECT; pfRepeatX: ptr orxFLOAT;
                         pfRepeatY: ptr orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxObject_GetRepeat", dynlib: libORX.}
## * Sets object blend mode.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _eBlendMode     Blend mode (alpha, multiply, add or none)
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_SetBlendMode*(pstObject: ptr orxOBJECT;
                            eBlendMode: orxDISPLAY_BLEND_MODE): orxSTATUS {.cdecl,
    importc: "orxObject_SetBlendMode", dynlib: libORX.}
## * Sets blend mode of an object and its children.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _eBlendMode     Blend mode (alpha, multiply, add or none)
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_SetBlendModeRecursive*(pstObject: ptr orxOBJECT;
                                     eBlendMode: orxDISPLAY_BLEND_MODE) {.cdecl,
    importc: "orxObject_SetBlendModeRecursive", dynlib: libORX.}
## * Object has blend mode accessor?
##  @param[in]   _pstObject      Concerned object
##  @return      orxTRUE / orxFALSE
##

proc orxObject_HasBlendMode*(pstObject: ptr orxOBJECT): orxBOOL {.cdecl,
    importc: "orxObject_HasBlendMode", dynlib: libORX.}
## * Gets object blend mode.
##  @param[in]   _pstObject     Concerned object
##  @return Blend mode (alpha, multiply, add or none)
##

proc orxObject_GetBlendMode*(pstObject: ptr orxOBJECT): orxDISPLAY_BLEND_MODE {.
    cdecl, importc: "orxObject_GetBlendMode", dynlib: libORX.}
## * @}
## * @name Life time / active time
##  @{
## * Sets object lifetime.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _fLifeTime      Lifetime to set, negative value to disable it
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_SetLifeTime*(pstObject: ptr orxOBJECT; fLifeTime: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxObject_SetLifeTime", dynlib: libORX.}
## * Gets object lifetime.
##  @param[in]   _pstObject      Concerned object
##  @return      Lifetime / negative value if none
##

proc orxObject_GetLifeTime*(pstObject: ptr orxOBJECT): orxFLOAT {.cdecl,
    importc: "orxObject_GetLifeTime", dynlib: libORX.}
## * Gets object active time, i.e. the amount of time that the object has been alive taking into account
##  the object's clock multiplier and object's periods of pause.
##  @param[in]   _pstObject      Concerned object
##  @return      Active time
##

proc orxObject_GetActiveTime*(pstObject: ptr orxOBJECT): orxFLOAT {.cdecl,
    importc: "orxObject_GetActiveTime", dynlib: libORX.}
## * @}
## * @name Group
##  @{
## * Gets default group ID.
##  @return      Default group ID
##

proc orxObject_GetDefaultGroupID*(): orxSTRINGID {.cdecl,
    importc: "orxObject_GetDefaultGroupID", dynlib: libORX.}
## * Gets object's group ID.
##  @param[in]   _pstObject      Concerned object
##  @return      Object's group ID. This is the string ID (see orxString_GetFromID()) of the object's group name.
##

proc orxObject_GetGroupID*(pstObject: ptr orxOBJECT): orxSTRINGID {.cdecl,
    importc: "orxObject_GetGroupID", dynlib: libORX.}
## * Sets object's group ID.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _stGroupID      Group ID to set. This is the string ID (see orxString_GetID()) of the object's group name.
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxObject_SetGroupID*(pstObject: ptr orxOBJECT; stGroupID: orxSTRINGID): orxSTATUS {.
    cdecl, importc: "orxObject_SetGroupID", dynlib: libORX.}
## * Sets group ID of an object and all its children.
##  @param[in]   _pstObject      Concerned object
##  @param[in]   _stGroupID      Group ID to set. This is the string ID (see orxString_GetID()) of the object's group name.
##

proc orxObject_SetGroupIDRecursive*(pstObject: ptr orxOBJECT; stGroupID: orxSTRINGID) {.
    cdecl, importc: "orxObject_SetGroupIDRecursive", dynlib: libORX.}
## * Gets next object in group.
##  @param[in]   _pstObject      Concerned object, nil to get the first one
##  @param[in]   _stGroupID      Group ID to consider, orxSTRINGID_UNDEFINED for all
##  @return      orxOBJECT / nil
##

proc orxObject_GetNext*(pstObject: ptr orxOBJECT; stGroupID: orxSTRINGID): ptr orxOBJECT {.
    cdecl, importc: "orxObject_GetNext", dynlib: libORX.}
## * @}
## * @name Picking
##  @{
## * Picks the first active object with size "under" the given position, within a given group. See
##  orxObject_BoxPick(), orxObject_CreateNeighborList() and orxObject_Raycast for other ways of picking
##  objects.
##  @param[in]   _pvPosition     Position to pick from
##  @param[in]   _stGroupID      Group ID to consider, orxSTRINGID_UNDEFINED for all
##  @return      orxOBJECT / nil
##

proc orxObject_Pick*(pvPosition: ptr orxVECTOR; stGroupID: orxSTRINGID): ptr orxOBJECT {.
    cdecl, importc: "orxObject_Pick", dynlib: libORX.}
## * Picks the first active object with size in contact with the given box, withing a given group. Use
##  orxObject_CreateNeighborList() to get all the objects in the box.
##  @param[in]   _pstBox         Box to use for picking
##  @param[in]   _stGroupID      Group ID to consider, orxSTRINGID_UNDEFINED for all
##  @return      orxOBJECT / nil
##

proc orxObject_BoxPick*(pstBox: ptr orxOBOX; stGroupID: orxSTRINGID): ptr orxOBJECT {.
    cdecl, importc: "orxObject_BoxPick", dynlib: libORX.}
## * @}

## * @}
