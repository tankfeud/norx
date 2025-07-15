## Adaptation to Nim of the 6th C tutorial, about sound
## original author of C tutorial: iarwain@orx-project.org
## adaptation: jseb at finiderire.com

#[
  Debug compilation
  nim c S06_sound
  (it will use S06_sound.nim.cfg and liborxd.so loaded at runtime)

  Release compilation
  nim c -d:release --skipProjcfg S06_sound
  (skip nim project cfg, liborx.so is loaded at runtime)

  Note from gokr:
  The choice of the lib is made in lib.nim
  It will use liborxd for debug build, liborx for release build and liborxp if you use -d:profile

  See tutorial S01_object.nim for more info about the basic object creation.
  See tutorial S02_clock.nim for keyboard reading, configuration section retrieving, and clocks.
  See tutorial S03_linked_frame.nim for object hierarchies, rotations and scaling.
  See tutorial S04_anim.nim for using animations.
  See tutorial S05_viewport.nim for viewports mysteriis.

  For details about Orx side , please refer to the sound tutorial (official C++ sample):
  https://wiki.orx-project.org/en/tutorials/audio/sound


  This is a basic tutorial creating sounds effects and musics (streams).

  This tutorial shows how to play sounds (samples) and musics (streams).
  It also demonstrates how to alter their settings in real time, using the soldier as visual feedback.
  As with other features from previous behavior, almost everything is data driven.

  Controls:
  Up  / Down arrows : music volume will change accordingly. The soldier will be scale in consequence.
  Left / Right arrows : music pitch (frequency) will change. The soldier will rotate like a knob.
  Left control : toggle music pausing (and activates/desactivates soldier, according to music state)
  Enter and Space : play a sound effect on the soldier.

  About sound effect (triggered by Enter and Space):
  Space triggered sound effect is the same as enter.
  But with Space, volume and pitch are randomly defined in the default config file.
  This allows to easily generate step or hit sounds with variety with no extra line of code.
  We randomly change the soldier's color to illustrate this.
  NB: The sound effect will only be added and played on an active soldier.
  To play a sound effect with no object as support, do it the same way we create the music in this tutorial.
  However, playing a sound on an object will allow spatial sound positioning (not covered by this tutorial).

  Many sound effects can be played at the same time on a single object.
  The sound config attribute KeepDataInCache keeps the sound sample in memory instead of rereading it from file every time.
  This only works for non-streamed data (ie. not for musics).
  If it's set to false, the sample will be reloaded from file, unless there's currently another sound effect of the same type being played.

  We also register to the sound events to display when sound effects are played and stopped.
  These events are only sent for sound effects played on objects.
]#


import strformat
from strutils import unindent
import norx

# the shared functions
import S_commons


var soldier:ptr orxOBJECT
# Music and sound are both of type orxSOUND.
# The difference is music is streamed whereas sound is completely loaded into memory.
# We set this difference in the config file.
var music:ptr orxSOUND



proc display_hints() =
  let gin = get_input_name
  var help = fmt"""
  {gin("VolumeUp")} & {gin("VolumeDown")} will change the music volume (+ soldier size).
  {gin("PitchUp")} & {gin("PitchDown")} will change the music pitch (+ soldier rotation).
  {gin("ToggleMusic")} will toggle music (+ soldier display).
  {gin("RandomSFX")} will play a random SFX on the soldier (+ change its color).
  {gin("DefaultSFX")} will the default SFX on the soldier (+ restore its color).
  The sound effect will be played only if the soldier is active
  """

  help = help.unindent
  orxlog( help)



proc EventHandler( event:ptr orxEVENT) :orxSTATUS {.cdecl.} =
  result = STATUS_SUCCESS

  if event.hRecipient == soldier:
    # Gets event payload (payload has type « pointer », must be casted)
    var payload:ptr orxSOUND_EVENT_PAYLOAD = cast[ptr orxSOUND_EVENT_PAYLOAD](event.pstPayload)

    let sound_name = getName( payload.pstSound)
    # we have to cast to orxOBJECT, because event.hRecipient is anonymous pointer (an orxHANDLE)
    let recipient_name = getName( cast[ptr orxOBJECT](event.hRecipient))

    case event.eID:
      of ord(SOUND_EVENT_START):
        echo fmt"Sound {sound_name} @ {recipient_name} has started !"

      of ord(SOUND_EVENT_STOP):
        echo fmt"Sound {sound_name} @ {recipient_name} has stopped !"

      else:
        # unknown event
        echo "unknown event ", $event.eID
        result = STATUS_FAILURE



proc Update(clockInfo: ptr orxCLOCK_INFO, context: pointer) {.cdecl.} =
  var vect_color:orxVECTOR
  var color:orxCOLOR
  color.anon0.vRGB = orxVECTOR_WHITE
  color.fAlpha = 1.0
  var res:orxSTATUS

  ## SOUND

  if hasBeenActivated("RandomSFX"):
    # add a sound FX on the soldier
    res = addSound( soldier, "RandomBip")
    # sets a random color on soldier
    # push [Tutorial] section of .ini
    res = pushSection( "Tutorial")
    # orxCOLOR {...} = tuple[vRGB: orxRGBVECTOR, fAlpha: orxFLOAT]
    discard getVector( "RandomColor", addr vect_color)
    color.anon0.vRGB = vect_color
    color.fAlpha = 1.0
    res = setColor( soldier, addr color)
    res = popSection()

  if hasBeenActivated("DefaultSFX"):
    res = addSound( soldier, "DefaultBip")
    # reset color of soldier
    res = setColor( soldier, addr color)

  ## MUSIC
  if hasBeenActivated("ToggleMusic"):
    enable( soldier, not isEnabled(soldier))

  if hasBeenActivated("PitchUp"):
    res = setPitch( music, getPitch( music) + 0.01)
    res = setRotation( soldier, getRotation( soldier) + 4.0 * clockInfo.fDT);
  if hasBeenActivated("PitchDown"):
    res = setPitch( music, getPitch( music) - 0.01)
    res = setRotation( soldier, getRotation( soldier) - 4.0 * clockInfo.fDT);

  if hasBeenActivated("VolumeDown"):
    res = setVolume( music, getVolume( music) - 0.05)
    var v:orxVECTOR = (1.0f,1.0f,1.0f)
    res = setScale( soldier, mulf(addr v, getScale( soldier, addr v), 0.98));
  if hasBeenActivated("VolumeUp"):
    res = setVolume( music, getVolume( music) + 0.05)
    var v:orxVECTOR = (1.0f,1.0f,1.0f)
    res = setScale( soldier, mulf(addr v, getScale( soldier, addr v), 1.02));



proc init() :orxSTATUS {.cdecl.} =
  result = STATUS_SUCCESS
  display_hints()

  # create viewport
  let vp = viewportCreateFromConfig( "Viewport")
  if vp.isNil:
    echo "Couldn't create viewport"
    return STATUS_FAILURE

  # our brave little soldier, always here.
  soldier = objectCreateFromConfig( "Soldier")

  # Gets the main clock, and register our update callback
  let mainclock:ptr orxClock = clockGet(CLOCK_KZ_CORE);
  result = clockRegister( mainclock, Update, nil, MODULE_ID_MAIN, CLOCK_PRIORITY_NORMAL);

  # Registers event handler for the sound
  result = addHandler( EVENT_TYPE_SOUND, EventHandler)

  # add background music to the soldier
  result = addSound( soldier, "Music")
  # store a reference to the music
  music = getLastAddedSound( soldier)
  # play the music
  result = play( music)



proc main() =
  #[ execute is declared in norx.nim , and needs 3 functions:
      proc execute*(initProc: proc(): orxSTATUS {.cdecl.};
                    runProc: proc(): orxSTATUS {.cdecl.};
                    exitProc: proc() {.cdecl.}
                   )
  ]#
  execute(init, run, exit)

main()
