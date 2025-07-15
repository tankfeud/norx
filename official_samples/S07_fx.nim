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
import norx

# the shared functions
import S_commons


var soldier:ptr orxOBJECT
var box:ptr orxOBJECT
var selected_fx:string = "WobbleFX"

# This userdata will be bind to the soldier.
# It's used as a lock for applying effects
type Userdata = object
  is_locked:orxBOOL

# it's global, so wont be collected
var userdata:Userdata = Userdata(is_locked:false)

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
  Left CTRL + m : MultiFX (contains the slots of 4 of the above FXs)

  {gin("ApplyFX")} : apply the current select FX on the soldier.
 Only once FX will be applied at a time in this tutorial.
 However an object can support up to 8 FXs at the same time.
 Box has a looping rotating FX applied directly from config, requiring no code.
 """

  help = help.unindent
  orxlog( help)



proc EventHandler( event:ptr orxEVENT) :orxSTATUS {.cdecl.} =
  result = STATUS_SUCCESS

  if event.eType == EVENT_TYPE_INPUT:
    # the input handling part, where we only display which keys have been used for every active input.
    if event.eID == ord(INPUT_EVENT_ON):
      var payload = cast[ptr orxINPUT_EVENT_PAYLOAD](event.pstPayload)

      if payload.aeType[1] != INPUT_TYPE_NONE:
        # multi-input detected (that is: several key has been pressed at same time).
        # You can define combinations like this in the .ini file :
        #   [MyInputs]
        #   KEY_S = Action # Save
        #   KEY_LCTRL = Action # Save
        #   CombineList = Save

        # We only use the 2 first input entries (we didn't use combinations > 2 keys in our config file).
        # However orx supports up to 4 combined keys for a single input.
        # aeType: array[orxINPUT_KU32_BINDING_NUMBER, orxINPUT_TYPE] ## Input binding type
        var msg = fmt"""
          {payload.zInputName} triggered by combination of:
           1) {getBindingName( payload.aeType[0], payload.aeID[0], payload.aeMode[0])}
           2) {getBindingName( payload.aeType[1], payload.aeID[1], payload.aeMode[1])}
        """
        orxlog( msg.unindent)
      else:
        # it's a single key press
        orxlog( fmt"{payload.zInputName} triggered by {getBindingName( payload.aeType[0], payload.aeID[0], payload.aeMode[0])}")

  if event.eType == EVENT_TYPE_FX:
    var payload = cast[ptr orxFX_EVENT_PAYLOAD](event.pstPayload)
    var obj_recipient = cast[ptr orxOBJECT]( event.hRecipient)

    case event.eID:
      of ord(FX_EVENT_START):
        orxlog( fmt"FX {payload.zFXName} {getName( obj_recipient)} has started!")
        # was it the soldier who trigger the event ?
        if obj_recipient == soldier:
          # a new effect has started, lock the soldier to prevent another one to occur.
           cast[ptr Userdata]( soldier.getUserData()).is_locked = true;

      of ord(FX_EVENT_STOP):
        orxlog( fmt"FX {payload.zFXName} {getName( obj_recipient)} has stopped!")
        # was it the soldier who trigger the event ?
        if obj_recipient == soldier:
          # the effect is over, we can unlock the soldier.
          cast[ptr Userdata]( soldier.getUserData()).is_locked = false;
      else:
        orxlog( fmt"Event type: orxEVENT_TYPE_FX received an uknown event ID {event.eID} (object: {getName(obj_recipient)}")



proc Update(clockInfo: ptr orxCLOCK_INFO, context: pointer) {.cdecl.} =
  let key_fx:seq[tuple[key:string,fx:string]] = @[("SelectMultiFX","MultiFX"),
  ("SelectWobble","WobbleFX"), ("SelectCircle","CircleFX"), ("SelectFade","FadeFX"),
  ("SelectFlash","FlashFX"), ("SelectMove","MoveFX"), ("SelectFlip","FlipFX") ]

  for tup in key_fx:
    if isActive( tup.key.cstring):
      selected_fx = tup.fx
      break

  let soldier_userdata = cast[ptr Userdata]( soldier.getUserData())
  if hasBeenActivated( "ApplyFX"):
    if not soldier_userdata.is_locked:
      discard soldier.addFX( selected_fx.cstring)
    else:
      orxlog( "ApplyFX activated, but soldier is locked: cancel ApplyFX.")


proc init() :orxSTATUS {.cdecl.} =
  result = STATUS_SUCCESS
  display_hints()

  # create viewport
  let vp = viewportCreateFromConfig( "Viewport")
  if vp.isNil:
    echo "Couldn't create viewport"
    return STATUS_FAILURE

  # the soldier, the box.
  soldier = objectCreateFromConfig( "Soldier")
  box = objectCreateFromConfig( "Box")

  # Gets the main clock, and register our update callback
  let mainclock:ptr orxClock = clockGet(CLOCK_KZ_CORE);
  result = clockRegister( mainclock, Update, nil, MODULE_ID_MAIN, CLOCK_PRIORITY_NORMAL);

  # Registers event handler for the sound
  result = addHandler( EVENT_TYPE_FX, EventHandler)
  result = addHandler( EVENT_TYPE_INPUT, EventHandler)

  ### bind the userdata object to the soldier

  #[
  # So … you can do it the Orx way like this:
  # by following the Orx way, we need to allocate a buffer ( « allocate » returns a raw pointer)
  let userdata_raw_pointer = allocate( cast[orxU32]( sizeof(userdata)), orxMEMORY_TYPE_MAIN)

  # for modifying the returned allocated object, we need to cast it.
  # because the « pointer » type returned is not directly usable.
  var userdata_ptr = cast[ptr Userdata](userdata_raw_pointer)
  # « is_locked » is already false, but hey.
  userdata_ptr.is_locked = false

  # but for binding it, of course we use the returned « pointer » by allocate function.
  setUserData( soldier, userdata_raw_pointer);
  # but we have a simplest way to do it
  ]#

  # bind userdata : quick and easy method (thank you Gokr for the method)
  # « userdata » is global, so won't be collected by GC at the end of this function,
  # as a local variable would be.
  soldier.setUserData( cast[pointer](addr userdata) )
  # and later, for pulling the userdata : var userdata = cast[ptr Userdata]( userdata.getUserData())



proc main() =
  #[ execute is declared in norx.nim , and needs 3 functions:
      proc execute*(initProc: proc(): orxSTATUS {.cdecl.};
                    runProc: proc(): orxSTATUS {.cdecl.};
                    exitProc: proc() {.cdecl.}
                   )
  ]#
  execute(init, run, exit)

main()
