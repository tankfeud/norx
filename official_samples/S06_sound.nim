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
import norx, norx/[incl, config, viewport, obj, input, keyboard, mouse, clock, math, vector, render, event, anim, camera, display, sound]

# the shared functions
import S_commons


var soldier:orxOBJECT
# Music and sound are both of type orxSOUND.
# The difference is music is streamed whereas sound is completely loaded into memory.
# We set this difference in the config file.
var music:orxSOUND

proc display_hints() =
  let gin = get_input_name
  var help = fmt"""
  {gin("")} & {gin("")} will change the music volume (+ soldier size).
  {gin("")} & {gin("")} will change the music pitch (+ soldier rotation).
  {gin("")} will toggle music (+ soldier display).
  {gin("")} will play a random SFX on the soldier (+ change its color).
  {gin("")} will the default SFX on the soldier (+ restore its color).
  The sound effect will be played only if the soldier is active
  """
#         zInputVolumeUp, zInputVolumeDown, zInputPitchUp, zInputPitchDown, zInputToggleMusic, zInputRandomSFX, zInputDefaultSFX);

  help = help.unindent
  orxlog( help)


proc init() :orxSTATUS {.cdecl.} =
  display_hints()
  orxSTATUS_SUCCESS


proc main() =
  #[ execute is declared in norx.nim , and needs 3 functions:
      proc execute*(initProc: proc(): orxSTATUS {.cdecl.};
                    runProc: proc(): orxSTATUS {.cdecl.};
                    exitProc: proc() {.cdecl.}
                   )
  ]#
  execute(init, run, exit)

main()
