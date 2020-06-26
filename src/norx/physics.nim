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

import incl, AABox, vector

## * Body definition flags
##

const
  orxBODY_DEF_KU32_FLAG_NONE* = 0x00000000
  orxBODY_DEF_KU32_FLAG_2D* = 0x00000001
  orxBODY_DEF_KU32_FLAG_DYNAMIC* = 0x00000002
  orxBODY_DEF_KU32_FLAG_HIGH_SPEED* = 0x00000004
  orxBODY_DEF_KU32_FLAG_FIXED_ROTATION* = 0x00000008
  orxBODY_DEF_KU32_FLAG_CAN_MOVE* = 0x00000010
  orxBODY_DEF_KU32_FLAG_ALLOW_SLEEP* = 0x00000020
  orxBODY_DEF_KU32_MASK_ALL* = 0xFFFFFFFF

## * Body part definition flags
##

const
  orxBODY_PART_DEF_KU32_FLAG_NONE* = 0x00000000
  orxBODY_PART_DEF_KU32_FLAG_SPHERE* = 0x00000001
  orxBODY_PART_DEF_KU32_FLAG_BOX* = 0x00000002
  orxBODY_PART_DEF_KU32_FLAG_MESH* = 0x00000004
  orxBODY_PART_DEF_KU32_FLAG_EDGE* = 0x00000008
  orxBODY_PART_DEF_KU32_FLAG_CHAIN* = 0x00000010
  orxBODY_PART_DEF_KU32_MASK_TYPE* = 0x0000001F
  orxBODY_PART_DEF_KU32_FLAG_SOLID* = 0x10000000
  orxBODY_PART_DEF_KU32_MASK_ALL* = 0xFFFFFFFF

## * Body joint definition flags
##

const
  orxBODY_JOINT_DEF_KU32_FLAG_NONE* = 0x00000000
  orxBODY_JOINT_DEF_KU32_FLAG_REVOLUTE* = 0x00000001
  orxBODY_JOINT_DEF_KU32_FLAG_PRISMATIC* = 0x00000002
  orxBODY_JOINT_DEF_KU32_FLAG_SPRING* = 0x00000004
  orxBODY_JOINT_DEF_KU32_FLAG_ROPE* = 0x00000008
  orxBODY_JOINT_DEF_KU32_FLAG_PULLEY* = 0x00000010
  orxBODY_JOINT_DEF_KU32_FLAG_SUSPENSION* = 0x00000020
  orxBODY_JOINT_DEF_KU32_FLAG_WELD* = 0x00000040
  orxBODY_JOINT_DEF_KU32_FLAG_FRICTION* = 0x00000080
  orxBODY_JOINT_DEF_KU32_FLAG_GEAR* = 0x00000100
  orxBODY_JOINT_DEF_KU32_MASK_TYPE* = 0x00000FFF
  orxBODY_JOINT_DEF_KU32_FLAG_COLLIDE* = 0x10000000
  orxBODY_JOINT_DEF_KU32_FLAG_ROTATION_LIMIT* = 0x20000000
  orxBODY_JOINT_DEF_KU32_FLAG_MOTOR* = 0x40000000
  orxBODY_JOINT_DEF_KU32_FLAG_TRANSLATION_LIMIT* = 0x80000000
  orxBODY_JOINT_DEF_KU32_MASK_ALL* = 0xFFFFFFFF

## * Misc defines
##

const
  orxBODY_PART_DEF_KU32_MESH_VERTEX_NUMBER* = 8

## * Body definition
##

type
  orxBODY_DEF* {.bycopy.} = object
    vPosition*: orxVECTOR      ## *< Position : 12
    fRotation*: orxFLOAT       ## *< Rotation : 16
    fInertia*: orxFLOAT        ## *< Inertia : 20
    fMass*: orxFLOAT           ## *< Mass : 24
    fLinearDamping*: orxFLOAT  ## *< Linear damping : 28
    fAngularDamping*: orxFLOAT ## *< Angular damping : 32
    u32Flags*: orxU32          ## *< Control flags : 36


## * Part definition
##

type
  INNER_C_STRUCT_orxPhysics_144* {.bycopy.} = object
    vCenter*: orxVECTOR        ## *< Sphere center : 44
    fRadius*: orxFLOAT         ## *< Sphere radius : 48

  INNER_C_STRUCT_orxPhysics_150* {.bycopy.} = object
    stBox*: orxAABOX           ## *< Axis aligned Box : 56

  INNER_C_STRUCT_orxPhysics_155* {.bycopy.} = object
    u32VertexCount*: orxU32    ## *< Mesh vertex count : 36
    avVertices*: array[orxBODY_PART_DEF_KU32_MESH_VERTEX_NUMBER, orxVECTOR] ## *< Mesh vertices : 132

  INNER_C_STRUCT_orxPhysics_162* {.bycopy.} = object
    avVertices*: array[2, orxVECTOR] ## *< Edge v2 : 56
    vPrevious*: orxVECTOR      ## *< Previous vertex (ghost) : 68
    vNext*: orxVECTOR          ## *< Next vertex (ghost) : 80
    bHasPrevious*: orxBOOL     ## *< Has previous vertex : 84
    bHasNext*: orxBOOL         ## *< Has next vertex : 88

  INNER_C_STRUCT_orxPhysics_172* {.bycopy.} = object
    vPrevious*: orxVECTOR      ## *< Chain Previous vertex (ghost) : 44
    vNext*: orxVECTOR          ## *< Chain Next vertex (ghost) : 56
    avVertices*: ptr orxVECTOR  ## *< Chain vertices : 60
    u32VertexCount*: orxU32    ## *< Chain vertex count : 64
    bIsLoop*: orxBOOL          ## *< Loop chain : 68
    bHasPrevious*: orxBOOL     ## *< Has previous vertex : 72
    bHasNext*: orxBOOL         ## *< Has next vertex : 76

  INNER_C_UNION_orxPhysics_142* {.bycopy.} = object {.union.}
    stSphere*: INNER_C_STRUCT_orxPhysics_144 ## *< Sphere : 48
    stAABox*: INNER_C_STRUCT_orxPhysics_150 ## *< Box : 56
    stMesh*: INNER_C_STRUCT_orxPhysics_155
    stEdge*: INNER_C_STRUCT_orxPhysics_162
    stChain*: INNER_C_STRUCT_orxPhysics_172

  orxBODY_PART_DEF* {.bycopy.} = object
    vScale*: orxVECTOR         ## *< Scale : 12
    fFriction*: orxFLOAT       ## *< Friction : 16
    fRestitution*: orxFLOAT    ## *< Restitution : 20
    fDensity*: orxFLOAT        ## *< Density : 24
    u16SelfFlags*: orxU16      ## *< Self defining flags : 26
    u16CheckMask*: orxU16      ## *< Check mask : 28
    u32Flags*: orxU32          ## *< Control flags : 32
    ano_orxPhysics_182*: INNER_C_UNION_orxPhysics_142


## * Joint definition
##

type
  INNER_C_STRUCT_orxPhysics_199* {.bycopy.} = object
    fDefaultRotation*: orxFLOAT ## *< Default rotation : 52
    fMinRotation*: orxFLOAT    ## *< Min rotation : 56
    fMaxRotation*: orxFLOAT    ## *< Max rotation : 60
    fMotorSpeed*: orxFLOAT     ## *< Motor speed : 64
    fMaxMotorTorque*: orxFLOAT ## *< Max motor torque : 68

  INNER_C_STRUCT_orxPhysics_209* {.bycopy.} = object
    vTranslationAxis*: orxVECTOR ## *< Translation axis : 60
    fDefaultRotation*: orxFLOAT ## *< Default rotation : 64
    fMinTranslation*: orxFLOAT ## *< Min translation : 68
    fMaxTranslation*: orxFLOAT ## *< Max translation : 72
    fMotorSpeed*: orxFLOAT     ## *< Motor speed : 76
    fMaxMotorForce*: orxFLOAT  ## *< Max motor force : 80

  INNER_C_STRUCT_orxPhysics_220* {.bycopy.} = object
    fLength*: orxFLOAT         ## *< Length : 52
    fFrequency*: orxFLOAT      ## *< Frequency : 56
    fDamping*: orxFLOAT        ## *< Damping : 60

  INNER_C_STRUCT_orxPhysics_228* {.bycopy.} = object
    fLength*: orxFLOAT         ## *< Length : 52

  INNER_C_STRUCT_orxPhysics_234* {.bycopy.} = object
    vSrcGroundAnchor*: orxVECTOR ## *< Source ground anchor : 60
    vDstGroundAnchor*: orxVECTOR ## *< Destination ground anchor : 72
    fLengthRatio*: orxFLOAT    ## *< Length ratio : 76
    fSrcLength*: orxFLOAT      ## *< Source length : 80
    fMaxSrcLength*: orxFLOAT   ## *< Max source length : 84
    fDstLength*: orxFLOAT      ## *< Destination length : 88
    fMaxDstLength*: orxFLOAT   ## *< Max destination length : 92

  INNER_C_STRUCT_orxPhysics_246* {.bycopy.} = object
    vTranslationAxis*: orxVECTOR ## *< Translation axis : 64
    fFrequency*: orxFLOAT      ## *< Frequency : 68
    fDamping*: orxFLOAT        ## *< Damping : 72
    fMotorSpeed*: orxFLOAT     ## *< Motor speed : 76
    fMaxMotorForce*: orxFLOAT  ## *< Max motor force : 80

  INNER_C_STRUCT_orxPhysics_256* {.bycopy.} = object
    fDefaultRotation*: orxFLOAT ## *< Default rotation : 56

  INNER_C_STRUCT_orxPhysics_262* {.bycopy.} = object
    fMaxForce*: orxFLOAT       ## *< Max force : 56
    fMaxTorque*: orxFLOAT      ## *< Max torque : 60

  INNER_C_STRUCT_orxPhysics_269* {.bycopy.} = object
    zSrcJointName*: cstring ## *< Source joint name : 56
    zDstJointName*: cstring ## *< Destination joint name : 60
    fJointRatio*: orxFLOAT     ## *< Joint ratio : 64

  INNER_C_UNION_orxPhysics_197* {.bycopy.} = object {.union.}
    stRevolute*: INNER_C_STRUCT_orxPhysics_199 ## *< Revolute : 68
    stPrismatic*: INNER_C_STRUCT_orxPhysics_209 ## *< Prismatic : 80
    stSpring*: INNER_C_STRUCT_orxPhysics_220 ## *< Spring : 60
    stRope*: INNER_C_STRUCT_orxPhysics_228 ## *< Rope : 52
    stPulley*: INNER_C_STRUCT_orxPhysics_234 ## *< Pulley : 92
    stSuspension*: INNER_C_STRUCT_orxPhysics_246 ## *< Suspension : 80
    stWeld*: INNER_C_STRUCT_orxPhysics_256 ## *< Weld : 56
    stFriction*: INNER_C_STRUCT_orxPhysics_262 ## *< Friction : 60
    stGear*: INNER_C_STRUCT_orxPhysics_269 ## *< Gear : 64

  orxBODY_JOINT_DEF* {.bycopy.} = object
    vSrcScale*: orxVECTOR      ## *< Source scale : 12
    vDstScale*: orxVECTOR      ## *< Destination scale : 24
    vSrcAnchor*: orxVECTOR     ## *< Source body anchor : 36
    vDstAnchor*: orxVECTOR     ## *< Destination body anchor : 48
    ano_orxPhysics_275*: INNER_C_UNION_orxPhysics_197
    u32Flags*: orxU32          ## *< Control flags : 96


## * Event enum
##

type
  orxPHYSICS_EVENT* {.size: sizeof(cint).} = enum
    orxPHYSICS_EVENT_CONTACT_ADD = 0, orxPHYSICS_EVENT_CONTACT_REMOVE,
    orxPHYSICS_EVENT_NUMBER, orxPHYSICS_EVENT_NONE = orxENUM_NONE


## * Event payload
##

type
  orxPHYSICS_EVENT_PAYLOAD* {.bycopy.} = object
    vPosition*: orxVECTOR      ## *< Contact position : 12
    vNormal*: orxVECTOR        ## *< Contact normal : 24
    zSenderPartName*: cstring ## *< Sender part name : 28
    zRecipientPartName*: cstring ## *< Recipient part name : 32


## * Internal physics body structure
##

type orxPHYSICS_BODY* = object
## * Internal physics part structure
##

type orxPHYSICS_BODY_PART* = object
## * Internal physics joint structure
##

type orxPHYSICS_BODY_JOINT* = object
## * Config defines
##

const
  orxPHYSICS_KZ_CONFIG_SECTION* = "Physics"
  orxPHYSICS_KZ_CONFIG_GRAVITY* = "Gravity"
  orxPHYSICS_KZ_CONFIG_ALLOW_SLEEP* = "AllowSleep"
  orxPHYSICS_KZ_CONFIG_ITERATIONS* = "IterationsPerStep"
  orxPHYSICS_KZ_CONFIG_RATIO* = "DimensionRatio"
  orxPHYSICS_KZ_CONFIG_STEP_FREQUENCY* = "StepFrequency"
  orxPHYSICS_KZ_CONFIG_SHOW_DEBUG* = "ShowDebug"
  orxPHYSICS_KZ_CONFIG_COLLISION_FLAG_LIST* = "CollisionFlagList"
  orxPHYSICS_KZ_CONFIG_INTERPOLATE* = "Interpolate"

## **************************************************************************
##  Functions directly implemented by orx core
## *************************************************************************
## * Physics module setup
##

proc orxPhysics_Setup*() {.cdecl, importc: "orxPhysics_Setup", dynlib: libORX.}
## * Gets collision flag literal name
##  @param[in] _u32Flag      Concerned collision flag numerical value
##  @return Flag's name
##

proc orxPhysics_GetCollisionFlagName*(u32Flag: orxU32): cstring {.cdecl,
    importc: "orxPhysics_GetCollisionFlagName", dynlib: libORX.}
## * Gets collision flag numerical value
##  @param[in] _zFlag        Concerned collision flag literal name
##  @return Flag's value
##

proc orxPhysics_GetCollisionFlagValue*(zFlag: cstring): orxU32 {.cdecl,
    importc: "orxPhysics_GetCollisionFlagValue", dynlib: libORX.}
## **************************************************************************
##  Functions extended by plugins
## *************************************************************************
## * Inits the physics module
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxPhysics_Init*(): orxSTATUS {.cdecl, importc: "orxPhysics_Init",
                                  dynlib: libORX.}
## * Exits from the physics module
##

proc orxPhysics_Exit*() {.cdecl, importc: "orxPhysics_Exit", dynlib: libORX.}
## * Sets physics gravity
##  @param[in]   _pvGravity                            Gravity to set
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxPhysics_SetGravity*(pvGravity: ptr orxVECTOR): orxSTATUS {.cdecl,
    importc: "orxPhysics_SetGravity", dynlib: libORX.}
## * Gets physics gravity
##  @param[in]   _pvGravity                            Gravity to get
##  @return orxVECTOR / nil
##

proc orxPhysics_GetGravity*(pvGravity: ptr orxVECTOR): ptr orxVECTOR {.cdecl,
    importc: "orxPhysics_GetGravity", dynlib: libORX.}
## * Creates a physical body
##  @param[in]   _hUserData                            User data to associate with this physical body
##  @param[in]   _pstBodyDef                           Physical body definition
##  @return orxPHYSICS_BODY / nil
##

proc orxPhysics_CreateBody*(hUserData: orxHANDLE; pstBodyDef: ptr orxBODY_DEF): ptr orxPHYSICS_BODY {.
    cdecl, importc: "orxPhysics_CreateBody", dynlib: libORX.}
## * Deletes a physical body
##  @param[in]   _pstBody                              Concerned physical body
##

proc orxPhysics_DeleteBody*(pstBody: ptr orxPHYSICS_BODY) {.cdecl,
    importc: "orxPhysics_DeleteBody", dynlib: libORX.}
## * Creates a part for a physical body
##  @param[in]   _pstBody                              Concerned physical body
##  @param[in]   _hUserData                            User data to associate with this physical body part
##  @param[in]   _pstBodyPartDef                       Physical body part definition
##  @return orxPHYSICS_BODY_PART / nil
##

proc orxPhysics_CreatePart*(pstBody: ptr orxPHYSICS_BODY; hUserData: orxHANDLE;
                           pstBodyPartDef: ptr orxBODY_PART_DEF): ptr orxPHYSICS_BODY_PART {.
    cdecl, importc: "orxPhysics_CreatePart", dynlib: libORX.}
## * Deletes a physical body part
##  @param[in]   _pstBodyPart                          Concerned physical body part
##

proc orxPhysics_DeletePart*(pstBodyPart: ptr orxPHYSICS_BODY_PART) {.cdecl,
    importc: "orxPhysics_DeletePart", dynlib: libORX.}
## * Creates a joint to link two physical bodies together
##  @param[in]   _pstSrcBody                           Concerned source body
##  @param[in]   _pstDstBody                           Concerned destination body
##  @param[in]   _hUserData                            User data to associate with this physical body part
##  @param[in]   _pstBodyJointDef                      Physical body joint definition
##  @return orxPHYSICS_BODY_JOINT / nil
##

proc orxPhysics_CreateJoint*(pstSrcBody: ptr orxPHYSICS_BODY;
                            pstDstBody: ptr orxPHYSICS_BODY; hUserData: orxHANDLE;
                            pstBodyJointDef: ptr orxBODY_JOINT_DEF): ptr orxPHYSICS_BODY_JOINT {.
    cdecl, importc: "orxPhysics_CreateJoint", dynlib: libORX.}
## * Deletes a physical body joint
##  @param[in]   _pstBodyJoint                         Concerned physical body joint
##

proc orxPhysics_DeleteJoint*(pstBodyJoint: ptr orxPHYSICS_BODY_JOINT) {.cdecl,
    importc: "orxPhysics_DeleteJoint", dynlib: libORX.}
## * Sets the position of a physical body
##  @param[in]   _pstBody                              Concerned physical body
##  @param[in]   _pvPosition                           Position to set
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxPhysics_SetPosition*(pstBody: ptr orxPHYSICS_BODY; pvPosition: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxPhysics_SetPosition", dynlib: libORX.}
## * Sets the rotation of a physical body
##  @param[in]   _pstBody                              Concerned physical body
##  @param[in]   _fRotation                            Rotation (radians) to set
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxPhysics_SetRotation*(pstBody: ptr orxPHYSICS_BODY; fRotation: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxPhysics_SetRotation", dynlib: libORX.}
## * Sets the speed of a physical body
##  @param[in]   _pstBody                              Concerned physical body
##  @param[in]   _pvSpeed                              Speed to set
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxPhysics_SetSpeed*(pstBody: ptr orxPHYSICS_BODY; pvSpeed: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxPhysics_SetSpeed", dynlib: libORX.}
## * Sets the angular velocity of a physical body
##  @param[in]   _pstBody                              Concerned physical body
##  @param[in]   _fVelocity                            Angular velocity (radians/seconds) to set
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxPhysics_SetAngularVelocity*(pstBody: ptr orxPHYSICS_BODY;
                                   fVelocity: orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxPhysics_SetAngularVelocity", dynlib: libORX.}
## * Sets the custom gravity of a physical body
##  @param[in]   _pstBody                              Concerned physical body
##  @param[in]   _pvCustomGravity                      Custom gravity multiplier to set / nil to remove it
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxPhysics_SetCustomGravity*(pstBody: ptr orxPHYSICS_BODY;
                                 pvCustomGravity: ptr orxVECTOR): orxSTATUS {.cdecl,
    importc: "orxPhysics_SetCustomGravity", dynlib: libORX.}
## * Sets the fixed rotation property of a physical body
##  @param[in]   _pstBody                              Concerned physical body
##  @param[in]   _bFixed                               Fixed / not fixed
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxPhysics_SetFixedRotation*(pstBody: ptr orxPHYSICS_BODY; bFixed: orxBOOL): orxSTATUS {.
    cdecl, importc: "orxPhysics_SetFixedRotation", dynlib: libORX.}
## * Sets the dynamic property of a body
##  @param[in]   _pstBody                              Concerned physical body
##  @param[in]   _bDynamic                             Dynamic / Static (or Kinematic depending on the "allow moving" property)
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxPhysics_SetDynamic*(pstBody: ptr orxPHYSICS_BODY; bDynamic: orxBOOL): orxSTATUS {.
    cdecl, importc: "orxPhysics_SetDynamic", dynlib: libORX.}
## * Sets the "allow moving" property of a body
##  @param[in]   _pstBody                              Concerned physical body
##  @param[in]   _bAllowMoving                         Only used for non-dynamic bodies, Kinematic / Static
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxPhysics_SetAllowMoving*(pstBody: ptr orxPHYSICS_BODY; bAllowMoving: orxBOOL): orxSTATUS {.
    cdecl, importc: "orxPhysics_SetAllowMoving", dynlib: libORX.}
## * Gets the position of a physical body
##  @param[in]   _pstBody                              Concerned physical body
##  @param[out]  _pvPosition                           Position to get
##  @return Position of the physical body
##

proc orxPhysics_GetPosition*(pstBody: ptr orxPHYSICS_BODY; pvPosition: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxPhysics_GetPosition", dynlib: libORX.}
## * Gets the rotation of a physical body
##  @param[in]   _pstBody                              Concerned physical body
##  @return Rotation (radians) of the physical body
##

proc orxPhysics_GetRotation*(pstBody: ptr orxPHYSICS_BODY): orxFLOAT {.cdecl,
    importc: "orxPhysics_GetRotation", dynlib: libORX.}
## * Gets the speed of a physical body
##  @param[in]   _pstBody                              Concerned physical body
##  @param[out]  _pvSpeed                              Speed to get
##  @return Speed of the physical body
##

proc orxPhysics_GetSpeed*(pstBody: ptr orxPHYSICS_BODY; pvSpeed: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxPhysics_GetSpeed", dynlib: libORX.}
## * Gets the speed of a physical body at a specified world position
##  @param[in]   _pstBody                              Concerned body
##  @param[in]   _pvPosition                           Concerned world position
##  @param[out]  _pvSpeed                              Speed to get
##  @return Speed of the physical body
##

proc orxPhysics_GetSpeedAtWorldPosition*(pstBody: ptr orxPHYSICS_BODY;
                                        pvPosition: ptr orxVECTOR;
                                        pvSpeed: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxPhysics_GetSpeedAtWorldPosition", dynlib: libORX.}
## * Gets the angular velocity of a physical body
##  @param[in]   _pstBody                              Concerned physical body
##  @return Angular velocity (radians/seconds) of the physical body
##

proc orxPhysics_GetAngularVelocity*(pstBody: ptr orxPHYSICS_BODY): orxFLOAT {.cdecl,
    importc: "orxPhysics_GetAngularVelocity", dynlib: libORX.}
## * Gets the custom gravity of a physical body
##  @param[in]   _pstBody                              Concerned physical body
##  @param[out]  _pvCustomGravity                      Custom gravity to get
##  @return Physical body custom gravity / nil is object doesn't have any
##

proc orxPhysics_GetCustomGravity*(pstBody: ptr orxPHYSICS_BODY;
                                 pvCustomGravity: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxPhysics_GetCustomGravity", dynlib: libORX.}
## * Is a physical body using a fixed rotation
##  @param[in]   _pstBody                              Concerned physical body
##  @return      orxTRUE if fixed rotation, orxFALSE otherwise
##

proc orxPhysics_IsFixedRotation*(pstBody: ptr orxPHYSICS_BODY): orxBOOL {.cdecl,
    importc: "orxPhysics_IsFixedRotation", dynlib: libORX.}
## * Gets the mass of a physical body
##  @param[in]   _pstBody                              Concerned physical body
##  @return Mass of the physical body
##

proc orxPhysics_GetMass*(pstBody: ptr orxPHYSICS_BODY): orxFLOAT {.cdecl,
    importc: "orxPhysics_GetMass", dynlib: libORX.}
## * Gets the center of mass of a physical body (object space but scale isn't accounted for)
##  @param[in]   _pstBody                              Concerned physical body
##  @param[out]  _pvMassCenter                         Center of mass to get
##  @return Center of mass of the physical body
##

proc orxPhysics_GetMassCenter*(pstBody: ptr orxPHYSICS_BODY;
                              pvMassCenter: ptr orxVECTOR): ptr orxVECTOR {.cdecl,
    importc: "orxPhysics_GetMassCenter", dynlib: libORX.}
## * Sets linear damping of a physical body
##  @param[in]   _pstBody                              Concerned physical body
##  @param[in]   _fDamping                             Linear damping to set
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxPhysics_SetLinearDamping*(pstBody: ptr orxPHYSICS_BODY; fDamping: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxPhysics_SetLinearDamping", dynlib: libORX.}
## * Sets angular damping of a physical body
##  @param[in]   _pstBody                              Concerned physical body
##  @param[in]   _fDamping                             Angular damping to set
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxPhysics_SetAngularDamping*(pstBody: ptr orxPHYSICS_BODY; fDamping: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxPhysics_SetAngularDamping", dynlib: libORX.}
## * Gets linear damping of a physical body
##  @param[in]   _pstBody                              Concerned physical body
##  @return Linear damping of the physical body
##

proc orxPhysics_GetLinearDamping*(pstBody: ptr orxPHYSICS_BODY): orxFLOAT {.cdecl,
    importc: "orxPhysics_GetLinearDamping", dynlib: libORX.}
## * Gets angular damping of a physical body
##  @param[in]   _pstBody                              Concerned physical body
##  @return Angular damping of the physical body
##

proc orxPhysics_GetAngularDamping*(pstBody: ptr orxPHYSICS_BODY): orxFLOAT {.cdecl,
    importc: "orxPhysics_GetAngularDamping", dynlib: libORX.}
## * Applies a torque to a physical body
##  @param[in]   _pstBody                              Concerned physical body
##  @param[in]   _fTorque                              Torque to apply
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxPhysics_ApplyTorque*(pstBody: ptr orxPHYSICS_BODY; fTorque: orxFLOAT): orxSTATUS {.
    cdecl, importc: "orxPhysics_ApplyTorque", dynlib: libORX.}
## * Applies a force to a physical body
##  @param[in]   _pstBody                              Concerned physical body
##  @param[in]   _pvForce                              Force to apply
##  @param[in]   _pvPoint                              Point of application (world coordinates) (if null, center of mass will be used)
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxPhysics_ApplyForce*(pstBody: ptr orxPHYSICS_BODY; pvForce: ptr orxVECTOR;
                           pvPoint: ptr orxVECTOR): orxSTATUS {.cdecl,
    importc: "orxPhysics_ApplyForce", dynlib: libORX.}
## * Applies an impulse to a physical body
##  @param[in]   _pstBody                              Concerned physical body
##  @param[in]   _pvImpulse                            Impulse to apply
##  @param[in]   _pvPoint                              Point of application (world coordinates) (if null, center of mass will be used)
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxPhysics_ApplyImpulse*(pstBody: ptr orxPHYSICS_BODY;
                             pvImpulse: ptr orxVECTOR; pvPoint: ptr orxVECTOR): orxSTATUS {.
    cdecl, importc: "orxPhysics_ApplyImpulse", dynlib: libORX.}
## * Sets self flags of a physical body part
##  @param[in]   _pstBodyPart                          Concerned physical body part
##  @param[in]   _u16SelfFlags                         Self flags to set
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxPhysics_SetPartSelfFlags*(pstBodyPart: ptr orxPHYSICS_BODY_PART;
                                 u16SelfFlags: orxU16): orxSTATUS {.cdecl,
    importc: "orxPhysics_SetPartSelfFlags", dynlib: libORX.}
## * Sets check mask of a physical body part
##  @param[in]   _pstBodyPart                          Concerned physical body part
##  @param[in]   _u16CheckMask                         Check mask to set
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxPhysics_SetPartCheckMask*(pstBodyPart: ptr orxPHYSICS_BODY_PART;
                                 u16CheckMask: orxU16): orxSTATUS {.cdecl,
    importc: "orxPhysics_SetPartCheckMask", dynlib: libORX.}
## * Gets self flags of a physical body part
##  @param[in]   _pstBodyPart                          Concerned physical body part
##  @return Self flags of the physical body part
##

proc orxPhysics_GetPartSelfFlags*(pstBodyPart: ptr orxPHYSICS_BODY_PART): orxU16 {.
    cdecl, importc: "orxPhysics_GetPartSelfFlags", dynlib: libORX.}
## * Gets check mask of a physical body part
##  @param[in]   _pstBodyPart                          Concerned physical body part
##  @return Check mask of the physical body part
##

proc orxPhysics_GetPartCheckMask*(pstBodyPart: ptr orxPHYSICS_BODY_PART): orxU16 {.
    cdecl, importc: "orxPhysics_GetPartCheckMask", dynlib: libORX.}
## * Sets a physical body part solid
##  @param[in]   _pstBodyPart                          Concerned physical body part
##  @param[in]   _bSolid                               Solid or sensor?
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxPhysics_SetPartSolid*(pstBodyPart: ptr orxPHYSICS_BODY_PART; bSolid: orxBOOL): orxSTATUS {.
    cdecl, importc: "orxPhysics_SetPartSolid", dynlib: libORX.}
## * Is a physical body part solid?
##  @param[in]   _pstBodyPart                          Concerned physical body part
##  @return      orxTRUE / orxFALSE
##

proc orxPhysics_IsPartSolid*(pstBodyPart: ptr orxPHYSICS_BODY_PART): orxBOOL {.cdecl,
    importc: "orxPhysics_IsPartSolid", dynlib: libORX.}
## * Sets friction of a physical body part
##  @param[in]   _pstBodyPart                          Concerned physical body part
##  @param[in]   _fFriction                            Friction
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxPhysics_SetPartFriction*(pstBodyPart: ptr orxPHYSICS_BODY_PART;
                                fFriction: orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxPhysics_SetPartFriction", dynlib: libORX.}
## * Gets friction of a physical body part
##  @param[in]   _pstBodyPart                          Concerned physical body part
##  @return      Friction
##

proc orxPhysics_GetPartFriction*(pstBodyPart: ptr orxPHYSICS_BODY_PART): orxFLOAT {.
    cdecl, importc: "orxPhysics_GetPartFriction", dynlib: libORX.}
## * Sets restitution of a physical body part
##  @param[in]   _pstBodyPart                          Concerned physical body part
##  @param[in]   _fRestitution                         Restitution
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxPhysics_SetPartRestitution*(pstBodyPart: ptr orxPHYSICS_BODY_PART;
                                   fRestitution: orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxPhysics_SetPartRestitution", dynlib: libORX.}
## * Gets restitution of a physical body part
##  @param[in]   _pstBodyPart                          Concerned physical body part
##  @return      Restitution
##

proc orxPhysics_GetPartRestitution*(pstBodyPart: ptr orxPHYSICS_BODY_PART): orxFLOAT {.
    cdecl, importc: "orxPhysics_GetPartRestitution", dynlib: libORX.}
## * Sets density of a physical body part
##  @param[in]   _pstBodyPart                          Concerned physical body part
##  @param[in]   _fDensity                             Density
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxPhysics_SetPartDensity*(pstBodyPart: ptr orxPHYSICS_BODY_PART;
                               fDensity: orxFLOAT): orxSTATUS {.cdecl,
    importc: "orxPhysics_SetPartDensity", dynlib: libORX.}
## * Gets density of a physical body part
##  @param[in]   _pstBodyPart                          Concerned physical body part
##  @return      Density
##

proc orxPhysics_GetPartDensity*(pstBodyPart: ptr orxPHYSICS_BODY_PART): orxFLOAT {.
    cdecl, importc: "orxPhysics_GetPartDensity", dynlib: libORX.}
## * Is point inside part? (Using world coordinates)
##  @param[in]   _pstBodyPart                          Concerned physical body part
##  @param[in]   _pvPosition                           Position to test (world coordinates)
##  @return      orxTRUE / orxFALSE
##

proc orxPhysics_IsInsidePart*(pstBodyPart: ptr orxPHYSICS_BODY_PART;
                             pvPosition: ptr orxVECTOR): orxBOOL {.cdecl,
    importc: "orxPhysics_IsInsidePart", dynlib: libORX.}
## * Enables a (revolute) body joint motor
##  @param[in]   _pstBodyJoint                         Concerned body joint
##  @param[in]   _bEnable                              Enable / Disable
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxPhysics_EnableMotor*(pstBodyJoint: ptr orxPHYSICS_BODY_JOINT;
                            bEnable: orxBOOL) {.cdecl,
    importc: "orxPhysics_EnableMotor", dynlib: libORX.}
## * Sets a (revolute) body joint motor speed
##  @param[in]   _pstBodyJoint                         Concerned body joint
##  @param[in]   _fSpeed                               Speed
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxPhysics_SetJointMotorSpeed*(pstBodyJoint: ptr orxPHYSICS_BODY_JOINT;
                                   fSpeed: orxFLOAT) {.cdecl,
    importc: "orxPhysics_SetJointMotorSpeed", dynlib: libORX.}
## * Sets a (revolute) body joint maximum motor torque
##  @param[in]   _pstBodyJoint                         Concerned body joint
##  @param[in]   _fMaxTorque                           Maximum motor torque
##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxPhysics_SetJointMaxMotorTorque*(pstBodyJoint: ptr orxPHYSICS_BODY_JOINT;
                                       fMaxTorque: orxFLOAT) {.cdecl,
    importc: "orxPhysics_SetJointMaxMotorTorque", dynlib: libORX.}
## * Gets the reaction force on the attached body at the joint anchor
##  @param[in]   _pstBodyJoint                         Concerned body joint
##  @param[out]  _pvForce                              Reaction force
##  @return      Reaction force in Newtons
##

proc orxPhysics_GetJointReactionForce*(pstBodyJoint: ptr orxPHYSICS_BODY_JOINT;
                                      pvForce: ptr orxVECTOR): ptr orxVECTOR {.cdecl,
    importc: "orxPhysics_GetJointReactionForce", dynlib: libORX.}
## * Gets the reaction torque on the attached body
##  @param[in]   _pstBodyJoint                         Concerned body joint
##  @return      Reaction torque
##

proc orxPhysics_GetJointReactionTorque*(pstBodyJoint: ptr orxPHYSICS_BODY_JOINT): orxFLOAT {.
    cdecl, importc: "orxPhysics_GetJointReactionTorque", dynlib: libORX.}
## * Issues a raycast to test for potential physics bodies in the way
##  @param[in]   _pvBegin                              Beginning of raycast
##  @param[in]   _pvEnd                                End of raycast
##  @param[in]   _u16SelfFlags                         Selfs flags used for filtering (0xFFFF for no filtering)
##  @param[in]   _u16CheckMask                         Check mask used for filtering (0xFFFF for no filtering)
##  @param[in]   _bEarlyExit                           Should stop as soon as an object has been hit (which might not be the closest)
##  @param[in]   _pvContact                            If non-null and a contact is found it will be stored here
##  @param[in]   _pvNormal                             If non-null and a contact is found, its normal will be stored here
##  @return Colliding body's user data / orxHANDLE_UNDEFINED
##

proc orxPhysics_Raycast*(pvBegin: ptr orxVECTOR; pvEnd: ptr orxVECTOR;
                        u16SelfFlags: orxU16; u16CheckMask: orxU16;
                        bEarlyExit: orxBOOL; pvContact: ptr orxVECTOR;
                        pvNormal: ptr orxVECTOR): orxHANDLE {.cdecl,
    importc: "orxPhysics_Raycast", dynlib: libORX.}
## * Picks bodies in contact with the given axis aligned box
##  @param[in]   _pstBox                               Box used for picking
##  @param[in]   _u16SelfFlags                         Selfs flags used for filtering (0xFFFF for no filtering)
##  @param[in]   _u16CheckMask                         Check mask used for filtering (0xFFFF for no filtering)
##  @param[in]   _ahUserDataList                       List of user data to fill
##  @param[in]   _u32Number                            Number of user data
##  @return      Count of actual found bodies. It might be larger than the given array, in which case you'd need to pass a larger array to retrieve them all.
##

proc orxPhysics_BoxPick*(pstBox: ptr orxAABOX; u16SelfFlags: orxU16;
                        u16CheckMask: orxU16; ahUserDataList: ptr orxHANDLE;
                        u32Number: orxU32): orxU32 {.cdecl,
    importc: "orxPhysics_BoxPick", dynlib: libORX.}
## * Enables/disables physics simulation
##  @param[in]   _bEnable                              Enable / disable
##

proc orxPhysics_EnableSimulation*(bEnable: orxBOOL) {.cdecl,
    importc: "orxPhysics_EnableSimulation", dynlib: libORX.}
## * @}
