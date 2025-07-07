## Adaptation to Nim of the C tutorial creating linked (hierarchical) frames.
## comments: jseb at finiderire.com

#[
  Debug compilation
  nim c S03_linked_frames
  (it will use S03_linked_frames.nim.cfg and liborxd.so loaded at runtime)

  Release compilation
  nim c -d:release --skipProjcfg S03_object
  (skip nim project cfg, liborx.so loaded at runtime)

  Note from gokr:
  The choice of the lib is made in lib.nim
  It will use liborxd for debug build, liborx for release build and liborxp if you use -d:profile

  See tutorial S01_object.nim for more info about the basic object creation.
  See tutorial S02_clock.nim for keyboard reading, configuration section retrieving, and clocks.
  
  For details about Orx side , please refer to the tutorial of the C++ sample:
  https://wiki.orx-project.org/en/tutorials/frame

  Summary is:
  All objects' positions, scales and rotations are stored in orxFRAME structures.
  
  These frames are assembled in a hierarchy graph :
  changing a parent frame propertie will affect all its children.

  In this tutorial, we have:
  - four objects that we link to a common parent
  - and a fifth one which has no parent.

  The first two children are implicitly created using the object's config property ChildList.
  The two others are created and linked in code (for didactic purposes).
  
  The invisible parent object will follow the mouse cursor.
  Left shift , left control : scale up , down the parent object.
  Left and right clicks apply a rotation to the parent object.

  All these transformations will affect its four children.

  This provides us with an easy way to create complex or grouped objects.
  We can also transform them (position, scale, rotation, speed, …) very easily. 

]#

import strformat
import norx


# global , for storing our invisible object.
# (used for rotation, the 4 rotating boxes are binded to it).
var parentObject:ptr orxObject


proc run(): orxSTATUS {.cdecl.} =
  result = orxSTATUS_SUCCESS #by default, won't quit
  if (input.isActive("Quit")):
    # Updates result
    result = orxSTATUS_FAILURE

proc get_input_name(input_name: string) :cstring =
  ## Returns the keycode corresponding to the physical key defined in .ini
  var eType: orxINPUT_TYPE
  var eID: orxENUM
  var eMode: orxINPUT_MODE

  var is_ok = getBinding(input_name, 0 #[index of desired binding]#, addr eType, addr eID, addr eMode)
  if is_ok == orxSTATUS_SUCCESS:
    let binding_name:cstring = getBindingName( eType, eID, eMode)
    echo fmt"[get_input_name] asked for {input_name}, got binding: {binding_name}"
    return binding_name

  return fmt"key {input_name} not found"

proc Update(clockInfo: ptr orxCLOCK_INFO, context: pointer) {.cdecl.} =
  var status:orxSTATUS
  
  # when RotateLeft pressed , rotate parent object CCW
  # the four child objects will follow
  if isActive("RotateLeft"):
    var rot:float32 = getRotation( parentObject) - orxMATH_KF_PI * clockInfo.fDT
    status = setRotation( parentObject, rot)
  # same principle for RotateRigh, except parent rotates CW
  if isActive("RotateRight"):
    var rot:float32 = getRotation( parentObject) + orxMATH_KF_PI * clockInfo.fDT
    status = setRotation( parentObject, rot)

  # scaling up or down if needed
  if isActive("ScaleUp"):
    #the «mulf» function need an initialized pointer
    # so you can put what you want in the vDummy
    # it will be initialized at correct value by the getScale function
    var vDummy:orxVector = (123f, 456f, 789f)
    # of course, you need the « addr » prefix to convert variable to a ptr on it.
    var vScale:ptr orxVECTOR = mulf( addr vDummy, getScale( parentObject, addr vDummy), orx2F(1.02f) )
    status = setScale( parentObject, vScale)
  # for scaling down, only scale factor changes, same principles appliy.
  if isActive("ScaleDown"):
    var vDummy:orxVector = (123f, 456f, 789f)
    var vScale:ptr orxVECTOR = mulf( addr vDummy, getScale( parentObject, addr vDummy), orx2F(0.98f) )
    status = setScale( parentObject, vScale)
   
  # now, if mouse is in viewport, follow the pointer !
  # like in the scaling, we need a pointer on an initialised vector for getting getWorldPosition to work.
  var vWorldPos:orxVECTOR = (1f,2f,3f)
  # getWorldPosition returns a vector if we are *inside* the display surface, nil otherwise.
  var vMouse:ptr orxVECTOR
  vMouse = getWorldPosition( getPosition( addr vWorldPos) #[mouse xy]#, nil, addr vWorldPos #[out]#)
  if vMouse != nil:
    # as you can see, vMouse has no other interest than checking we are inside the display surface
    # echo fmt"vWorldPos{vWorldPos} == vMouse{vMouse[]}"
    
    # now get parent position (the invisible one)
    var vParentPos:orxVECTOR
    # this time we discard the output (we know we are inside the display, at this step)
    # note: this call use getWorldPosition overriden in oobject, previous were using
    #       overrided function in render.nim
    discard getWorldPosition( parentObject, addr vParentPos)

    # the original tutorial was keeping z value of parent position
    # i don't see the point here, so i've commented it
    # vMouse.fZ = vParentPos.fZ

    # and move the parent to the mouse position
    discard setPosition( parentObject, vMouse)


proc init(): orxSTATUS {.cdecl.} =
  var mainclock:ptr orxClock
  var childObject:ptr orxObject
  var inputType:orxInputType
 
  let inputRotateLeft = "RotateLeft".get_input_name()
  let inputRotateRight = "RotateRight".get_input_name()
  let inputScaleUp = "ScaleUp".get_input_name()
  let inputScaleDown = "ScaleDown".get_input_name()

  orxLOG( fmt"""
  The parent objects will follow the mouse.
  {inputRotateLeft} & {inputRotateRight} will rotate it.
  {inputScaleUp} & {inputScaleDown} will scale it.
  """)
  
  # Creates viewport
  var viewport = viewportCreateFromConfig("Viewport")
  if viewport.isNil:
    return orxSTATUS_FAILURE

  # Creates Parent object
  # it is not shown on the screen
  # it is used in the config as the father of Object3 and Object4
  parentObject = objectCreateFromConfig("ParentObject");

  # Creates all 3 test objects and links the last two to our parent object
  # the Object0 doesn't need to be stored, discard it.
  # it is the static box which doesn't move.
  # it is not linked to parentObject.
  discard objectCreateFromConfig("Object0");

  childObject = objectCreateFromConfig("Object1");
  var status = setParent( childObject, parentObject);
  childObject = objectCreateFromConfig("Object2");
  status = setParent( childObject, parentObject);

  # Object3 and Object4 are created and linked to parentObject with the config file ,
  # no code is needed for them

  # Gets main clock
  mainclock = clockGet(orxCLOCK_KZ_CORE);

  # Registers our update callback
  # nil can replace orxNULL (defined in the C API)
  status = register( mainclock, Update, nil, orxMODULE_ID_MAIN, orxCLOCK_PRIORITY_NORMAL);

  result = orxSTATUS_SUCCESS


proc exit() {.cdecl.} =
  # We're a bit lazy here so we let orx clean all our mess! :)
  quit(0)

proc Main =
  #[ execute is declared in norx.nim , and needs 3 functions:
      proc execute*(initProc: proc(): orxSTATUS {.cdecl.};
                    runProc: proc(): orxSTATUS {.cdecl.};
                    exitProc: proc() {.cdecl.}
                   )
  ]#
  execute(init, run, exit)

Main()
