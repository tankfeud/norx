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
  https://wiki.orx-project.org/en/tutorials/anim

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


import norx, norx/[incl, config, viewport, obj, input, keyboard, mouse, clock, math, vector, render, event]


var soldierObject:ptr orxObject

proc Update(clockInfo: ptr orxCLOCK_INFO, context: pointer) {.cdecl.} =
  var vScale:orxVECTOR
  var status:orxSTATUS
  
  # Is walk right active?
  if isActive("GoRight"):
    # Use setCurrentAnim() to switch the animation without using the link graph.
    status = setTargetAnim( soldierObject, "WalkRight")
    if status == orxSTATUS_FAILURE:
      echo "error while setting target animaiton"
    elif isActive("GoLeft"):
      status = setTargetAnim( soldierObject, "WalkLeft")
      if status == orxSTATUS_FAILURE:
        echo "error while setting target animaiton"
    else:
    # no walk active
      status = setTargetAnim( soldierObject, nil)
      if status == orxSTATUS_FAILURE:
        echo "error while setting target animaiton"

    # TODO ScalingUp/Down

proc EventHandler( event:ptr orxEVENT) :orxSTATUS {.cdecl.} =
  echo "EventHandler() called"
  discard


proc init() :orxSTATUS {.cdecl.} =
  # Creates viewport
  var viewport = viewportCreateFromConfig( "Viewport")
  if viewport.isNil:
    return orxSTATUS_FAILURE
  
  # Registers event handler
  var status = addHandler( orxEVENT_TYPE_ANIM, EventHandler);
  if status == orxSTATUS_FAILURE:
    echo "Error while addHandler for animation on proc EventHandler"

  # Creates soldier object
  soldierObject = objectCreateFromConfig( "Soldier")

  # Gets the main clock
  var mainclock:ptr orxClock = clockGet(orxCLOCK_KZ_CORE);
  
  # Registers our update callback
  status = register( mainclock, Update, nil, orxMODULE_ID_MAIN, orxCLOCK_PRIORITY_NORMAL);

  result = orxSTATUS_SUCCESS

proc run(): orxSTATUS {.cdecl.} =
  result = orxSTATUS_SUCCESS #by default, won't quit
  if (input.isActive("Quit")):
    # Updates result
    result = orxSTATUS_FAILURE

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
