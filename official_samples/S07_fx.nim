## Adaptation to Nim of the 7th C tutorial, about effects (fx).
## original author of C tutorial: iarwain@orx-project.org
## adaptation: jseb at finiderire.com

#[
  Debug compilation
  nim c S07_fx
  (it will use S07_fx.nim.cfg and liborxd.so loaded at runtime)

  Release compilation
  nim c -d:release --skipProjcfg S07_fx
  (skip nim project cfg, liborx.so is loaded at runtime)

  Note from gokr:
  The choice of the lib is made in lib.nim
  It will use liborxd for debug build, liborx for release build and liborxp if you use -d:profile

  See tutorial S01_object.nim for more info about the basic object creation.
  See tutorial S02_clock.nim for keyboard reading, configuration section retrieving, and clocks.
  See tutorial S03_linked_frame.nim for object hierarchies, rotations and scaling.
  See tutorial S04_anim.nim for using animations.
  See tutorial S05_viewport.nim for viewports mysteriis.
  See tutorial S06_sound.nim for playing sounds.

  For details about Orx side , please refer to the fx tutorial (official C++ sample):
  https://wiki.orx-project.org/en/tutorials/audio/sound


 This tutorial shows what FXs are and how to create them.

 FXs are based on a combination of curves based on sine, triangle, square or linear shape.
 We apply theses curves on parameters: scale, rotation, position, speed, alpha and color.

 FXs are set through config file requiring only one line of code to apply them on an object.
 There can be up to 8 curves of any type combined to form a single FX.
 Up to 8 FXs can be applied on the same object at the same time.

 FXs can use absolute or relative values, depending on the Absolute attribute in its config.
 Control over curve period, phase, pow and amplification over time is also granted.
 For position and speed FXs, the output value can use the object's orientation and/or scale
 so as to be applied relatively to the object's current state.
 This allows the creation of pretty elaborated and nice looking visual FXs.

 FX parameters can be tweaked in the config file and reloaded on-the-fly using backspace,
 unless the FX was specified to be cached in memory (cf. the ''KeepInCache'' attribute).

 For example you won't be able to tweak on the fly the circle FX as it has been defined
 with this attribute in the default config file.
 All the other FXs can be updated while the tutorial run.

 As always, random parameters can be used from config allowing some variety for a single FX.
 For example, the wobble scale, the flash color and the "attack" move FXs are using limited random values.

 We also register to the FX events so as to display when FXs are played and stopped.
 As the FX played on the box object is tagged as looping, it'll never stop.
 Therefore the corresponding event (orxFX_EVENT_STOP) will never be sent.

 We also show briefly how to add some personal user data to an orxOBJECT (here a structure containing a single boolean).
 We retrieve it in the event callback to lock the object when an FX starts and unlock it when it stops.
 We use this lock to allow only one FX at a time on the soldier. It's only written here for didactic purpose.

]#

import strformat
from strutils import unindent
import norx, norx/[incl, config, viewport, obj, input, keyboard, mouse, clock, math, vector, render, event, anim, camera, display, sound]

# the shared functions
import S_commons


var soldier:ptr orxOBJECT
var box:ptr orxOBJECT


proc display_hints() =
  let gin = get_input_name
  var help = fmt"""
  To select the FX to apply:
  {gin("SelectWobble")} : Wobble.
  {gin("SelectCircle")} : Circle.
  {gin("SelectFade")} : Fade.
  {gin("SelectFlash")} : Flash.
  {gin("SelectMove")} : Move.
  {gin("SelectFlip")} : Flip.
  {gin("SelectMultiFX")} : MultiFX (contains the slots of 4 of the above FXs

  {gin("ApplyFX")} : apply the current select FX on the soldier.
 Only once FX will be applied at a time in this tutorial.
 However an object can support up to 8 FXs at the same time.
 Box has a looping rotating FX applied directly from config, requiring no code.
 """

  help = help.unindent
  orxlog( help)



proc EventHandler( event:ptr orxEVENT) :orxSTATUS {.cdecl.} =
  result = orxSTATUS_SUCCESS



proc Update(clockInfo: ptr orxCLOCK_INFO, context: pointer) {.cdecl.} =
  discard



proc init() :orxSTATUS {.cdecl.} =
  result = orxSTATUS_SUCCESS
  display_hints()

  # create viewport
  let vp = viewportCreateFromConfig( "Viewport")
  if vp.isNil:
    echo "Couldn't create viewport"
    return orxSTATUS_FAILURE

  # the soldier, the box.
  soldier = objectCreateFromConfig( "Soldier")
  box = objectCreateFromConfig( "Box")

  # Gets the main clock, and register our update callback
  let mainclock:ptr orxClock = clockGet(orxCLOCK_KZ_CORE);
  result = register( mainclock, Update, nil, orxMODULE_ID_MAIN, orxCLOCK_PRIORITY_NORMAL);

  # Registers event handler for the sound
  result = addHandler( orxEVENT_TYPE_FX, EventHandler)
  result = addHandler( orxEVENT_TYPE_INPUT, EventHandler)



proc main() =
  #[ execute is declared in norx.nim , and needs 3 functions:
      proc execute*(initProc: proc(): orxSTATUS {.cdecl.};
                    runProc: proc(): orxSTATUS {.cdecl.};
                    exitProc: proc() {.cdecl.}
                   )
  ]#
  execute(init, run, exit)

main()
