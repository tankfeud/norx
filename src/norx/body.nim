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

import incl, structure, physics, vector, AABox

## * Internal Body structure
##

type orxBODY* = object
## * Internal Body part structure
##

type orxBODY_PART* = object
## * Internal Body joint structure
##

type orxBODY_JOINT* = object
## * Body module setup
##

proc orxBody_Setup*() {.cdecl, importc: "orxBody_Setup", dynlib: libORX.}
## * Inits the Body module
##

proc orxBody_Init*(): orxSTATUS {.cdecl, importc: "orxBody_Init", dynlib: libORX.}
## * Exits from the Body module
##

proc orxBody_Exit*() {.cdecl, importc: "orxBody_Exit", dynlib: libORX.}
## * Creates an empty body
##  @param[in]   _pstOwner                     Body's owner used for collision callbacks (usually an orxOBJECT)
##  @param[in]   _pstBodyDef                   Body definition
##  @return      Created orxGRAPHIC / nil
##

proc orxBody_Create*(pstOwner: ptr orxSTRUCTURE; pstBodyDef: ptr orxBODY_DEF): ptr orxBODY {.
    cdecl, importc: "orxBody_Create", dynlib: libORX.}
## * Creates a body from config
##  @param[in]   _pstOwner                     Body's owner used for collision callbacks (usually an orxOBJECT)
##  @param[in]   _zConfigID                    Body config ID
##  @return      Created orxGRAPHIC / nil
##

proc orxBody_CreateFromConfig*(pstOwner: ptr orxSTRUCTURE; zConfigID: cstring): ptr orxBODY {.
    cdecl, importc: "orxBody_CreateFromConfig", dynlib: libORX.}
## * Deletes a body
##  @param[in]   _pstBody        Concerned body
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxBody_Delete*(pstBody: ptr orxBODY): orxSTATUS {.cdecl,
    importc: "orxBody_Delete", dynlib: libORX.}
## * Gets body config name
##  @param[in]   _pstBody        Concerned body
##  @return      orxSTRING / orxSTRING_EMPTY
##

proc orxBody_GetName*(pstBody: ptr orxBODY): cstring {.cdecl,
    importc: "orxBody_GetName", dynlib: libORX.}
## * Tests flags against body definition ones
##  @param[in]   _pstBody        Concerned body
##  @param[in]   _u32Flags       Flags to test
##  @return      orxTRUE / orxFALSE
##

proc orxBody_TestDefFlags*(pstBody: ptr orxBODY; u32Flags: orxU32): orxBOOL {.cdecl,
    importc: "orxBody_TestDefFlags", dynlib: libORX.}
## * Tests all flags against body definition ones
##  @param[in]   _pstBody        Concerned body
##  @param[in]   _u32Flags       Flags to test
##  @return      orxTRUE / orxFALSE
##

proc orxBody_TestAllDefFlags*(pstBody: ptr orxBODY; u32Flags: orxU32): orxBOOL {.cdecl,
    importc: "orxBody_TestAllDefFlags", dynlib: libORX.}
## * Gets body definition flags
##  @param[in]   _pstBody        Concerned body
##  @param[in]   _u32Mask        Mask to use for getting flags
##  @return      orxU32
##

proc orxBody_GetDefFlags*(pstBody: ptr orxBODY; u32Mask: orxU32): orxU32 {.cdecl,
    importc: "orxBody_GetDefFlags", dynlib: libORX.}
## * Adds a part to body
##  @param[in]   _pstBody        Concerned body
##  @param[in]   _pstBodyPartDef Body part definition
##  @return      orxBODY_PART / nil
##

proc orxBody_AddPart*(pstBody: ptr orxBODY; pstBodyPartDef: ptr orxBODY_PART_DEF): ptr orxBODY_PART {.
    cdecl, importc: "orxBody_AddPart", dynlib: libORX.}
## * Adds a part to body from config
##  @param[in]   _pstBody        Concerned body
##  @param[in]   _zConfigID      Body part config ID
##  @return      orxBODY_PART / nil
##

proc orxBody_AddPartFromConfig*(pstBody: ptr orxBODY; zConfigID: cstring): ptr orxBODY_PART {.
    cdecl, importc: "orxBody_AddPartFromConfig", dynlib: libORX.}
## * Removes a part using its config ID
##  @param[in]   _pstBody        Concerned body
##  @param[in]   _zConfigID      Config ID of the part to remove
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxBody_RemovePartFromConfig*(pstBody: ptr orxBODY; zConfigID: cstring): orxSTATUS {.
    cdecl, importc: "orxBody_RemovePartFromConfig", dynlib: libORX.}
## * Gets next body part
##  @param[in]   _pstBody        Concerned body
##  @param[in]   _pstBodyPart    Current body part (nil to get the first one)
##  @return      orxBODY_PART / nil
##

proc orxBody_GetNextPart*(pstBody: ptr orxBODY; pstBodyPart: ptr orxBODY_PART): ptr orxBODY_PART {.
    cdecl, importc: "orxBody_GetNextPart", dynlib: libORX.}
## * Gets a body part name
##  @param[in]   _pstBodyPart    Concerned body part
##  @return      orxSTRING / nil
##

proc orxBody_GetPartName*(pstBodyPart: ptr orxBODY_PART): cstring {.cdecl,
    importc: "orxBody_GetPartName", dynlib: libORX.}
## * Gets a body part definition (matching current part status)
##  @param[in]   _pstBodyPart    Concerned body part
##  @return      orxBODY_PART_DEF / nil
##

proc orxBody_GetPartDef*(pstBodyPart: ptr orxBODY_PART): ptr orxBODY_PART_DEF {.cdecl,
    importc: "orxBody_GetPartDef", dynlib: libORX.}
## * Gets a body part body (ie. owner)
##  @param[in]   _pstBodyPart    Concerned body part
##  @return      orxBODY / nil
##

proc orxBody_GetPartBody*(pstBodyPart: ptr orxBODY_PART): ptr orxBODY {.cdecl,
    importc: "orxBody_GetPartBody", dynlib: libORX.}
## * Removes a body part
##  @param[in]   _pstBodyPart    Concerned body part
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxBody_RemovePart*(pstBodyPart: ptr orxBODY_PART): orxSTATUS {.cdecl,
    importc: "orxBody_RemovePart", dynlib: libORX.}
## * Adds a joint to link two bodies together
##  @param[in]   _pstSrcBody       Concerned source body
##  @param[in]   _pstDstBody       Concerned destination body
##  @param[in]   _pstBodyJointDef  Body joint definition
##  @return      orxBODY_JOINT / nil
##

proc orxBody_AddJoint*(pstSrcBody: ptr orxBODY; pstDstBody: ptr orxBODY;
                      pstBodyJointDef: ptr orxBODY_JOINT_DEF): ptr orxBODY_JOINT {.
    cdecl, importc: "orxBody_AddJoint", dynlib: libORX.}
## * Adds a joint from config to link two bodies together
##  @param[in]   _pstSrcBody     Concerned source body
##  @param[in]   _pstDstBody     Concerned destination body
##  @param[in]   _zConfigID      Body joint config ID
##  @return      orxBODY_JOINT / nil
##

proc orxBody_AddJointFromConfig*(pstSrcBody: ptr orxBODY; pstDstBody: ptr orxBODY;
                                zConfigID: cstring): ptr orxBODY_JOINT {.cdecl,
    importc: "orxBody_AddJointFromConfig", dynlib: libORX.}
## * Gets next body joint
##  @param[in]   _pstBody        Concerned body
##  @param[in]   _pstBodyJoint   Current body joint (nil to get the first one)
##  @return      orxBODY_JOINT / nil
##

proc orxBody_GetNextJoint*(pstBody: ptr orxBODY; pstBodyJoint: ptr orxBODY_JOINT): ptr orxBODY_JOINT {.
    cdecl, importc: "orxBody_GetNextJoint", dynlib: libORX.}
## * Gets a body joint name
##  @param[in]   _pstBodyJoint   Concerned body joint
##  @return      orxSTRING / nil
##

proc orxBody_GetJointName*(pstBodyJoint: ptr orxBODY_JOINT): cstring {.cdecl,
    importc: "orxBody_GetJointName", dynlib: libORX.}
## * Removes a body joint
##  @param[in]   _pstBodyJoint   Concerned body joint
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxBody_RemoveJoint*(pstBodyJoint: ptr orxBODY_JOINT): orxSTATUS {.cdecl,
    importc: "orxBody_RemoveJoint", dynlib: libORX.}
## * Sets a body position
##  @param[in]   _pstBody        Concerned body
##  @param[in]   _pvPosition     Position to set
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxBody_SetPosition*(pstBody: ptr orxBODY; pvPosition: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxBody_SetPosition", dynlib: libORX.}
## * Sets a body rotation
##  @param[in]   _pstBody        Concerned body
##  @param[in]   _fRotation      Rotation to set (radians)
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxBody_SetRotation*(pstBody: ptr orxBODY; fRotation: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxBody_SetRotation", dynlib: libORX.}
## * Sets a body scale
##  @param[in]   _pstBody        Concerned body
##  @param[in]   _pvScale        Scale to set
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxBody_SetScale*(pstBody: ptr orxBODY; pvScale: ptr orxVECTOR): orxSTATUS {.cdecl,
    importc: "orxBody_SetScale", dynlib: libORX.}
## * Sets a body speed
##  @param[in]   _pstBody        Concerned body
##  @param[in]   _pvSpeed        Speed to set
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxBody_SetSpeed*(pstBody: ptr orxBODY; pvSpeed: ptr orxVECTOR): orxSTATUS {.cdecl,
    importc: "orxBody_SetSpeed", dynlib: libORX.}
## * Sets a body angular velocity
##  @param[in]   _pstBody        Concerned body
##  @param[in]   _fVelocity      Angular velocity to set (radians/seconds)
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxBody_SetAngularVelocity*(pstBody: ptr orxBODY; fVelocity: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxBody_SetAngularVelocity", dynlib: libORX.}
## * Sets a body custom gravity
##  @param[in]   _pstBody          Concerned body
##  @param[in]   _pvCustomGravity  Custom gravity to set / nil to remove it
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxBody_SetCustomGravity*(pstBody: ptr orxBODY; pvCustomGravity: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxBody_SetCustomGravity", dynlib: libORX.}
## * Sets a body fixed rotation
##  @param[in]   _pstBody        Concerned body
##  @param[in]   _bFixed         Fixed / not fixed
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxBody_SetFixedRotation*(pstBody: ptr orxBODY; bFixed: orxBOOL): orxSTATUS {.
    cdecl, importc: "orxBody_SetFixedRotation", dynlib: libORX.}
## * Sets the dynamic property of a body
##  @param[in]   _pstBody        Concerned physical body
##  @param[in]   _bDynamic       Dynamic / Static (or Kinematic depending on the "allow moving" property)
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxBody_SetDynamic*(pstBody: ptr orxBODY; bDynamic: orxBOOL): orxSTATUS {.cdecl,
    importc: "orxBody_SetDynamic", dynlib: libORX.}
## * Sets the "allow moving" property of a body
##  @param[in]   _pstBody        Concerned physical body
##  @param[in]   _bAllowMoving   Only used for non-dynamic bodies, Kinematic / Static
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxBody_SetAllowMoving*(pstBody: ptr orxBODY; bAllowMoving: orxBOOL): orxSTATUS {.
    cdecl, importc: "orxBody_SetAllowMoving", dynlib: libORX.}
## * Gets a body position
##  @param[in]   _pstBody        Concerned body
##  @param[out]  _pvPosition     Position to get
##  @return      Body position / nil
##

proc orxBody_GetPosition*(pstBody: ptr orxBODY; pvPosition: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxBody_GetPosition", dynlib: libORX.}
## * Gets a body rotation
##  @param[in]   _pstBody        Concerned body
##  @return      Body rotation (radians)
##

proc orxBody_GetRotation*(pstBody: ptr orxBODY): orxFLOAT {.cdecl,
    importc: "orxBody_GetRotation", dynlib: libORX.}
## * Gets a body speed
##  @param[in]   _pstBody        Concerned body
##  @param[out]  _pvSpeed        Speed to get
##  @return      Body speed / nil
##

proc orxBody_GetSpeed*(pstBody: ptr orxBODY; pvSpeed: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxBody_GetSpeed", dynlib: libORX.}
## * Gets a body speed at a specified world position
##  @param[in]   _pstBody        Concerned body
##  @param[in]   _pvPosition     Concerned world position
##  @param[out]  _pvSpeed        Speed to get
##  @return      Body speed / nil
##

proc orxBody_GetSpeedAtWorldPosition*(pstBody: ptr orxBODY;
                                     pvPosition: ptr orxVECTOR;
                                     pvSpeed: ptr orxVECTOR): ptr orxVECTOR {.cdecl,
    importc: "orxBody_GetSpeedAtWorldPosition", dynlib: libORX.}
## * Gets a body angular velocity
##  @param[in]   _pstBody        Concerned body
##  @return      Body angular velocity (radians/seconds)
##

proc orxBody_GetAngularVelocity*(pstBody: ptr orxBODY): orxFLOAT {.cdecl,
    importc: "orxBody_GetAngularVelocity", dynlib: libORX.}
## * Gets a body custom gravity
##  @param[in]   _pstBody          Concerned body
##  @param[out]  _pvCustomGravity  Custom gravity to get
##  @return      Body custom gravity / nil is object doesn't have any
##

proc orxBody_GetCustomGravity*(pstBody: ptr orxBODY; pvCustomGravity: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxBody_GetCustomGravity", dynlib: libORX.}
## * Is a body using a fixed rotation
##  @param[in]   _pstBody        Concerned body
##  @return      orxTRUE if fixed rotation, orxFALSE otherwise
##

proc orxBody_IsFixedRotation*(pstBody: ptr orxBODY): orxBOOL {.cdecl,
    importc: "orxBody_IsFixedRotation", dynlib: libORX.}
## * Gets the dynamic property of a body
##  @param[in]   _pstBody        Concerned physical body
##  @return      orxTRUE / orxFALSE
##

proc orxBody_IsDynamic*(pstBody: ptr orxBODY): orxBOOL {.cdecl,
    importc: "orxBody_IsDynamic", dynlib: libORX.}
## * Gets the "allow moving" property of a body, only relevant for non-dynamic bodies
##  @param[in]   _pstBody        Concerned physical body
##  @return      orxTRUE / orxFALSE
##

proc orxBody_GetAllowMoving*(pstBody: ptr orxBODY): orxBOOL {.cdecl,
    importc: "orxBody_GetAllowMoving", dynlib: libORX.}
## * Gets a body mass
##  @param[in]   _pstBody        Concerned body
##  @return      Body mass
##

proc orxBody_GetMass*(pstBody: ptr orxBODY): orxFLOAT {.cdecl,
    importc: "orxBody_GetMass", dynlib: libORX.}
## * Gets a body center of mass (object space)
##  @param[in]   _pstBody        Concerned body
##  @param[out]  _pvMassCenter   Mass center to get
##  @return      Mass center / nil
##

proc orxBody_GetMassCenter*(pstBody: ptr orxBODY; pvMassCenter: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxBody_GetMassCenter", dynlib: libORX.}
## * Sets a body linear damping
##  @param[in]   _pstBody        Concerned body
##  @param[in]   _fDamping       Linear damping to set
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxBody_SetLinearDamping*(pstBody: ptr orxBODY; fDamping: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxBody_SetLinearDamping", dynlib: libORX.}
## * Sets a body angular damping
##  @param[in]   _pstBody        Concerned body
##  @param[in]   _fDamping       Angular damping to set
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxBody_SetAngularDamping*(pstBody: ptr orxBODY; fDamping: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxBody_SetAngularDamping", dynlib: libORX.}
## * Gets a body linear damping
##  @param[in]   _pstBody        Concerned body
##  @return      Body's linear damping
##

proc orxBody_GetLinearDamping*(pstBody: ptr orxBODY): orxFLOAT {.cdecl,
    importc: "orxBody_GetLinearDamping", dynlib: libORX.}
## * Gets a body angular damping
##  @param[in]   _pstBody        Concerned body
##  @return      Body's angular damping
##

proc orxBody_GetAngularDamping*(pstBody: ptr orxBODY): orxFLOAT {.cdecl,
    importc: "orxBody_GetAngularDamping", dynlib: libORX.}
## * Is point inside body? (Using world coordinates)
##  @param[in]   _pstBody        Concerned physical body
##  @param[in]   _pvPosition     Position to test (world coordinates)
##  @return      orxTRUE / orxFALSE
##

proc orxBody_IsInside*(pstBody: ptr orxBODY; pvPosition: ptr orxVECTOR): orxBOOL {.
    cdecl, importc: "orxBody_IsInside", dynlib: libORX.}
## * Applies a torque
##  @param[in]   _pstBody        Concerned body
##  @param[in]   _fTorque        Torque to apply
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxBody_ApplyTorque*(pstBody: ptr orxBODY; fTorque: orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxBody_ApplyTorque", dynlib: libORX.}
## * Applies a force
##  @param[in]   _pstBody        Concerned body
##  @param[in]   _pvForce        Force to apply
##  @param[in]   _pvPoint        Point (world coordinates) where the force will be applied, if nil, center of mass will be used
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxBody_ApplyForce*(pstBody: ptr orxBODY; pvForce: ptr orxVECTOR;
                        pvPoint: ptr orxVECTOR): orxSTATUS {.cdecl,
    importc: "orxBody_ApplyForce", dynlib: libORX.}
## * Applies an impulse
##  @param[in]   _pstBody        Concerned body
##  @param[in]   _pvImpulse      Impulse to apply
##  @param[in]   _pvPoint        Point (world coordinates) where the impulse will be applied, if nil, center of mass will be used
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxBody_ApplyImpulse*(pstBody: ptr orxBODY; pvImpulse: ptr orxVECTOR;
                          pvPoint: ptr orxVECTOR): orxSTATUS {.cdecl,
    importc: "orxBody_ApplyImpulse", dynlib: libORX.}
## * Sets self flags of a body part
##  @param[in]   _pstBodyPart    Concerned body part
##  @param[in]   _u16SelfFlags   Self flags to set
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxBody_SetPartSelfFlags*(pstBodyPart: ptr orxBODY_PART; u16SelfFlags: orxU16): orxSTATUS {.
    cdecl, importc: "orxBody_SetPartSelfFlags", dynlib: libORX.}
## * Sets check mask of a body part
##  @param[in]   _pstBodyPart    Concerned body part
##  @param[in]   _u16CheckMask   Check mask to set
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxBody_SetPartCheckMask*(pstBodyPart: ptr orxBODY_PART; u16CheckMask: orxU16): orxSTATUS {.
    cdecl, importc: "orxBody_SetPartCheckMask", dynlib: libORX.}
## * Gets self flags of a body part
##  @param[in]   _pstBodyPart    Concerned body part
##  @return Self flags of the body part
##

proc orxBody_GetPartSelfFlags*(pstBodyPart: ptr orxBODY_PART): orxU16 {.cdecl,
    importc: "orxBody_GetPartSelfFlags", dynlib: libORX.}
## * Gets check mask of a body part
##  @param[in]   _pstBodyPart    Concerned body part
##  @return Check mask of the body part
##

proc orxBody_GetPartCheckMask*(pstBodyPart: ptr orxBODY_PART): orxU16 {.cdecl,
    importc: "orxBody_GetPartCheckMask", dynlib: libORX.}
## * Sets a body part solid
##  @param[in]   _pstBodyPart    Concerned body part
##  @param[in]   _bSolid         Solid or sensor?
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxBody_SetPartSolid*(pstBodyPart: ptr orxBODY_PART; bSolid: orxBOOL): orxSTATUS {.
    cdecl, importc: "orxBody_SetPartSolid", dynlib: libORX.}
## * Is a body part solid?
##  @param[in]   _pstBodyPart    Concerned body part
##  @return      orxTRUE / orxFALSE
##

proc orxBody_IsPartSolid*(pstBodyPart: ptr orxBODY_PART): orxBOOL {.cdecl,
    importc: "orxBody_IsPartSolid", dynlib: libORX.}
## * Sets friction of a body part
##  @param[in]   _pstBodyPart    Concerned body part
##  @param[in]   _fFriction      Friction
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxBody_SetPartFriction*(pstBodyPart: ptr orxBODY_PART; fFriction: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxBody_SetPartFriction", dynlib: libORX.}
## * Gets friction of a body part
##  @param[in]   _pstBodyPart    Concerned body part
##  @return      Friction
##

proc orxBody_GetPartFriction*(pstBodyPart: ptr orxBODY_PART): orxFLOAT {.cdecl,
    importc: "orxBody_GetPartFriction", dynlib: libORX.}
## * Sets restitution of a body part
##  @param[in]   _pstBodyPart    Concerned body part
##  @param[in]   _fRestitution   Restitution
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxBody_SetPartRestitution*(pstBodyPart: ptr orxBODY_PART;
                                fRestitution: orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxBody_SetPartRestitution", dynlib: libORX.}
## * Gets restitution of a body part
##  @param[in]   _pstBodyPart    Concerned body part
##  @return      Restitution
##

proc orxBody_GetPartRestitution*(pstBodyPart: ptr orxBODY_PART): orxFLOAT {.cdecl,
    importc: "orxBody_GetPartRestitution", dynlib: libORX.}
## * Sets density of a body part
##  @param[in]   _pstBodyPart    Concerned body part
##  @param[in]   _fDensity       Density
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxBody_SetPartDensity*(pstBodyPart: ptr orxBODY_PART; fDensity: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxBody_SetPartDensity", dynlib: libORX.}
## * Gets density of a body part
##  @param[in]   _pstBodyPart    Concerned body part
##  @return      Density
##

proc orxBody_GetPartDensity*(pstBodyPart: ptr orxBODY_PART): orxFLOAT {.cdecl,
    importc: "orxBody_GetPartDensity", dynlib: libORX.}
## * Is point inside part? (Using world coordinates)
##  @param[in]   _pstBodyPart    Concerned physical body part
##  @param[in]   _pvPosition     Position to test (world coordinates)
##  @return      orxTRUE / orxFALSE
##

proc orxBody_IsInsidePart*(pstBodyPart: ptr orxBODY_PART; pvPosition: ptr orxVECTOR): orxBOOL {.
    cdecl, importc: "orxBody_IsInsidePart", dynlib: libORX.}
## * Enables a (revolute) body joint motor
##  @param[in]   _pstBodyJoint   Concerned body joint
##  @param[in]   _bEnable        Enable / Disable
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxBody_EnableMotor*(pstBodyJoint: ptr orxBODY_JOINT; bEnable: orxBOOL): orxSTATUS {.
    cdecl, importc: "orxBody_EnableMotor", dynlib: libORX.}
## * Sets a (revolute) body joint motor speed
##  @param[in]   _pstBodyJoint   Concerned body joint
##  @param[in]   _fSpeed         Speed
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxBody_SetJointMotorSpeed*(pstBodyJoint: ptr orxBODY_JOINT; fSpeed: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxBody_SetJointMotorSpeed", dynlib: libORX.}
## * Sets a (revolute) body joint maximum motor torque
##  @param[in]   _pstBodyJoint   Concerned body joint
##  @param[in]   _fMaxTorque     Maximum motor torque
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxBody_SetJointMaxMotorTorque*(pstBodyJoint: ptr orxBODY_JOINT;
                                    fMaxTorque: orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxBody_SetJointMaxMotorTorque", dynlib: libORX.}
## * Gets the reaction force on the attached body at the joint anchor
##  @param[in]   _pstBodyJoint   Concerned body joint
##  @param[out]  _pvForce        Reaction force
##  @return      Reaction force in Newtons
##

proc orxBody_GetJointReactionForce*(pstBodyJoint: ptr orxBODY_JOINT;
                                   pvForce: ptr orxVECTOR): ptr orxVECTOR {.cdecl,
    importc: "orxBody_GetJointReactionForce", dynlib: libORX.}
## * Gets the reaction torque on the attached body
##  @param[in]   _pstBodyJoint   Concerned body joint
##  @return      Reaction torque
##

proc orxBody_GetJointReactionTorque*(pstBodyJoint: ptr orxBODY_JOINT): orxFLOAT {.
    cdecl, importc: "orxBody_GetJointReactionTorque", dynlib: libORX.}
## * Issues a raycast to test for potential bodies in the way
##  @param[in]   _pvBegin        Beginning of raycast
##  @param[in]   _pvEnd          End of raycast
##  @param[in]   _u16SelfFlags   Selfs flags used for filtering (0xFFFF for no filtering)
##  @param[in]   _u16CheckMask   Check mask used for filtering (0xFFFF for no filtering)
##  @param[in]   _bEarlyExit     Should stop as soon as an object has been hit (which might not be the closest)
##  @param[in]   _pvContact      If non-null and a contact is found it will be stored here
##  @param[in]   _pvNormal       If non-null and a contact is found, its normal will be stored here
##  @return Colliding orxBODY / nil
##

proc orxBody_Raycast*(pvBegin: ptr orxVECTOR; pvEnd: ptr orxVECTOR;
                     u16SelfFlags: orxU16; u16CheckMask: orxU16;
                     bEarlyExit: orxBOOL; pvContact: ptr orxVECTOR;
                     pvNormal: ptr orxVECTOR): ptr orxBODY {.cdecl,
    importc: "orxBody_Raycast", dynlib: libORX.}
## * Picks bodies in contact with the given axis aligned box.
##  @param[in]   _pstBox                               Box used for picking
##  @param[in]   _u16SelfFlags                         Selfs flags used for filtering (0xFFFF for no filtering)
##  @param[in]   _u16CheckMask                         Check mask used for filtering (0xFFFF for no filtering)
##  @param[in]   _apstBodyList                         List of bodies to fill
##  @param[in]   _u32Number                            Number of bodies
##  @return      Count of actual found bodies. It might be larger than the given array, in which case you'd need to pass a larger array to retrieve them all.
##

proc orxBody_BoxPick*(pstBox: ptr orxAABOX; u16SelfFlags: orxU16;
                     u16CheckMask: orxU16; apstBodyList: ptr ptr orxBODY;
                     u32Number: orxU32): orxU32 {.cdecl, importc: "orxBody_BoxPick",
    dynlib: libORX.}
## * @}
