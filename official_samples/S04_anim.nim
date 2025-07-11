## Adaptation to Nim of the 4th C tutorial, about sprite animation.
## original author of C tutorial: iarwain@orx-project.org
## adaptation: jseb at finiderire.com

#[
  Debug compilation
  nim c S04_anim
  (it will use S04_anim_frames.nim.cfg and liborxd.so loaded at runtime)

  Release compilation
  nim c -d:release --skipProjcfg S04_anim
  (skip nim project cfg, liborx.so is loaded at runtime)

  Note from gokr:
  The choice of the lib is made in lib.nim
  It will use liborxd for debug build, liborx for release build and liborxp if you use -d:profile

  See tutorial S01_object.nim for more info about the basic object creation.
  See tutorial S02_clock.nim for keyboard reading, configuration section retrieving, and clocks.
  See tutorial S03_linked_frame.nim for object hierarchies, rotations and scaling.

  For details about Orx side , please refer to the tutorial of the C++ sample:
  https://wiki.orx-project.org/en/tutorials/animation/anim

  Summary is (mix of text tutorial & C source comments) :
  All animations are stored in a directed graph.
  This graph defines all the possible transitions between animations.
  An animation is referenced using a unique character string.
  All the transitions and animations are created via config files.
  As graph could become complex, we only have 4 animations here: IdleRight, IdleLeft, WalkRight, WalkLeft.

  All the possible transitions are defined in the config file.
  When an animation is requested, engine evaluates the chain that goes from the current one to the new one.
  If the chain exists, it is processed automatically.
  The user is notified when animations are started, stopped, cut or looping by events.

We also show how to subscribe to animation events (to know when animations are started, stopped or cut).

  For example, if the soldier was in WalkRight and you stop pressing keys, it'll know he has to go immediately to IdleRight, without having code to give this order.

  If we don't specify any animation as target, the engine will follow the links naturally according to their properties (such as loop counters that won't be covered by this basic tutorial).

  There's also a way to bypass this chaining procedure and immediately force an animation.

  Code-wise this system is very easy to use with two main functions to handle everything.
  Most of the work is made not in code but in the config files when we define animations and links.
  A very basic animation graph it used for this tutorial, to keep limited the needed config data.

]#

import strformat
# this time we add event and anim
import norx


var soldierObject:ptr orxObject

proc setSoldierAnimation( animation:cstring) =
  # Use setCurrentAnim() to switch the animation without using the link graph.
  var status:orxSTATUS = setTargetAnim( soldierObject, animation)
  if status == STATUS_FAILURE:
    echo "error while setting soldier's target animation ", animation

proc setSoldierScale( scalefactor:float) =
  var vTemp:orxVector
  var vScale:ptr orxVECTOR = mulf( addr vTemp, getScale( soldierObject, addr vTemp), scalefactor)
  var status = setScale( soldierObject, vScale)
  if status == STATUS_FAILURE:
    echo "error while setting soldier's scale ", scalefactor

proc Update(clockInfo: ptr orxCLOCK_INFO, context: pointer) {.cdecl.} =
  var vScale:orxVECTOR
  var status:orxSTATUS

  # Is walk right active?
  if isActive("GoRight"):
    setSoldierAnimation( "WalkRight")
  elif isActive("GoLeft"):
    setSoldierAnimation( "WalkLeft")
  else:
  # no walk active
    setSoldierAnimation( nil)

  # we can also scale the little soldier
  if isActive( "ScaleUp"):
    setSoldierScale( 1.02f)
  elif isActive( "ScaleDown"):
    setSoldierScale( 0.98f)


proc get_input_name(input_name: string) :cstring =
  ## Returns the keycode corresponding to the physical key defined in .ini
  var eType: orxINPUT_TYPE
  var eID: orxENUM
  var eMode: orxINPUT_MODE

  var is_ok = getBinding(input_name, 0 #[index of desired binding]#, addr eType, addr eID, addr eMode)
  if is_ok == STATUS_SUCCESS:
    let binding_name:cstring = getBindingName( eType, eID, eMode)
    echo fmt"[get_input_name] asked for {input_name}, got binding: {binding_name}"
    return binding_name

  return fmt"key {input_name} not found"


proc EventHandler( event:ptr orxEVENT) :orxSTATUS {.cdecl.} =

  # Gets event payload (.pstPayload has type « pointer », must be casted)
  var payload:ptr orxANIM_EVENT_PAYLOAD = cast[ptr orxANIM_EVENT_PAYLOAD](event.pstPayload);

  var anim_name:cstring = getName( cast[ptr orxOBJECT]( event.hRecipient))
  case ord(event.eID): # type(event.eID) : orxENUM

    of ord(ANIM_EVENT_START): # type(ANIM_EVENT_START) : orxANIM_EVENT, thus we ord(…) to compare.
      # hRecipient is an orxHANDLE (pointer) and the sender is an orxOBJECT , thus we cast to get name.
      echo fmt"Animation {payload.zAnimName}@{anim_name} has started!"

    of ord(ANIM_EVENT_STOP):
      echo fmt"Animation {payload.zAnimName}@{anim_name} has stopped!"

    of ord(ANIM_EVENT_CUT):
      # getting fTime
      let fTime = payload.anon0.stCut.fTime
      echo fmt"Animation {payload.zAnimName}@{anim_name} has been cut [time: {fTime:1.4f}]"

    of ord(ANIM_EVENT_LOOP):
      # getting loop counter
      let stLoop = payload.anon0.stLoop.u32Count
      echo fmt"Animation {payload.zAnimName}@{anim_name} has looped [count: {stLoop}]"

    of ord(ANIM_EVENT_CUSTOM_EVENT):
      # getting custom event
      let stCustom_name = payload.anon0.stCustom.zName
      echo fmt"Animation {payload.zAnimName}@{anim_name} has sent the event [{stCustom_name}]"

    else:
      # unknown event
      echo "unknown event ", $orxEVENT_TYPE(event.eID)


proc init() :orxSTATUS {.cdecl.} =

  let inputWalkLeft = "GoLeft".get_input_name()
  let inputWalkRight = "GoRight".get_input_name()
  let inputScaleUp = "ScaleUp".get_input_name()
  let inputScaleDown = "ScaleDown".get_input_name()

  orxLOG( fmt"""
  {inputWalkLeft} & {inputWalkRight} will change the soldier's animations
  {inputScaleUp} & {inputScaleDown} will scale the soldier
  """)
  # Creates viewport
  var viewport = viewportCreateFromConfig( "Viewport")
  if viewport.isNil:
    return STATUS_FAILURE

  # Registers event handler
  var status = addHandler(EVENT_TYPE_ANIM, EventHandler);
  if status == STATUS_FAILURE:
    echo "Error while addHandler for animation on proc EventHandler"

  # Creates soldier object
  soldierObject = objectCreateFromConfig( "Soldier")

  # Gets the main clock
  var mainclock:ptr orxClock = clockGet(CLOCK_KZ_CORE);

  # Registers our update callback
  status = clockRegister( mainclock, Update, nil, MODULE_ID_MAIN, CLOCK_PRIORITY_NORMAL);

  result = STATUS_SUCCESS

proc run(): orxSTATUS {.cdecl.} =
  result = STATUS_SUCCESS #by default, won't quit
  if (isActive("Quit")):
    # Updates result
    result = STATUS_FAILURE

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
