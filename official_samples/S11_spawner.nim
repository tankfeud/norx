## Adaptation to Nim of the 11th C tutorial, about spawners.
## original author of C tutorial: iarwain@orx-project.org
## adaptation: jseb at finiderire.com

#[
  Debug compilation
  nim c S11_spawner
  (it will use S11_spawner.nim.cfg and liborxd.so loaded at runtime)

  Release compilation
  nim c -d:release --skipProjcfg S11_spawner
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
  See tutorial S07_fx.nim for applying FX to objects.
  See tutorial S08_physics.nim for an outlook on the physic engine.
  See tutorial S09_scrolling.nim for the world of parallax.
  See tutorial S10_locale.nim for speaking another language than you-know-what.

  For details about Orx side , please refer to the spawner tutorial:
  https://wiki.orx-project.org/en/tutorials/spawners/spawner

 This tutorial shows how to create and use spawners for particle effects.
 It's only a tiny possibility of what can be achieved using them.
 For example, they can be also used for generating monsters or firing bullets, etc…

 The code here is only used for two tasks:
  1) creating 1 main object (a scene) and a viewport
  2) switching from one test to another one by reloading the appropriate config files

 This tutorial is data-driven: test settings and input definitions are stored in .ini with spawning/move/display logic.

 With this very small amount of lines of code, you can have an infinite number of results.
 You can change physics, additive/multiply blend, masking, speed/acceleration of objects, etc…
 All you need is changing the config files.
 You can test your changes without restarting: config files are reloaded when switching tests.

 If there are too many particles displayed for your config, turn down amount of particles spawned per wave and/or the frequency of the waves.
 To do so, search for the WaveSize/WaveDelay attributes in the different spawner sections.
]#

import strformat
from strutils import unindent
import norx, norx/[incl, config, viewport, obj, input, keyboard, mouse, clock, math, vector, render, event, anim, camera, display, structure]

# the shared functions
import S_commons


var current_scene:ptr orxOBJECT = nil
var configID:orxS32 = 0

proc display_hints() =
  let gin = get_input_name
  var help = fmt"""
  {gin("NextConfig")} will switch to the next config settings.
  {gin("PreviousConfig")} will switch to the previous config settings.
  *** Config files are used with inheritance to provide all the combinations.
  *** All the tests use the same minimalist code (creating 1 object & 1 viewport).
 """

  help = help.unindent
  orxlog( help)

proc load_config() :orxSTATUS =

  # begin by deleting current scene
  if current_scene != nil:
    discard obj.delete( current_scene)
    echo fmt"scene {current_scene.repr} has been deleted."
    current_scene = nil

  # and then destroy all viewports
  var orx_struct:ptr orxSTRUCTURE = getFirst( orxSTRUCTURE_ID_VIEWPORT)
  while orx_struct != nil:
    result = viewport.delete( cast[ptr orxVIEWPORT]( orx_struct) )
    echo fmt"viewport {orx_struct.u64GUID} has been deleted."
    orx_struct = getFirst( orxSTRUCTURE_ID_VIEWPORT)

  # clear all config data
  result = config.clear( nil)
  if result != orxSTATUS_SUCCESS:
    echo "⚠  problem when deleting config !"

  # loads main config and selects tutorial section
  result = config.load( config.getMainFileName() )
  if result != orxSTATUS_SUCCESS:
    echo fmt"⚠  problem when loading {config.getMainFileName()} !"

  result = config.selectSection( "Tutorial")

  # Is current ID valid?
  if configID < config.getListCount( "ConfigList"):
    # gets config file
    var config_file = config.getListString( "ConfigList", configID)

    # Can load it?
    echo fmt"try to load {config_file}"
    result = config.load( config_file)
    if result == orxSTATUS_SUCCESS:
      # pushes tutorial section
      discard config.pushSection( "Tutorial")

      # for all defined viewports
      for i in 0..<config.getListCount( "ViewportList"):
        # Creates it (we are not interested by the viewport pointer returned)
        discard viewportCreateFromConfig( config.getListString( "ViewportList", i) )

      # finally, creates our scene
      current_scene = objectCreateFromConfig( "Scene")

      discard config.popSection()
      echo fmt"finished loading {config_file}"

    else:
      echo fmt"⚠  problem with configID {configID}"



proc init() :orxSTATUS {.cdecl.} =
  ## usual things
  display_hints()

  result = load_config()



# in the others tutorials , we were using a generic « run » procedure.
# The I/O polling (keyboard, mouse…) was done in a callback function, defined in « init » proc.
# This time, we don't have callback function , called at a certain rate (Hz) by a clock.
# The I/O polling will be done entirely in the mainloop.
proc mainloop() :orxSTATUS {.cdecl.} =
  result = orxSTATUS_SUCCESS
  if hasBeenActivated( "NextConfig"):
    configID.inc
    if configID == config.getListCount( "ConfigList"):
      configID = 0
    result = load_config()

  if hasBeenActivated( "PreviousConfig"):
    configID.dec
    if configID < 0:
      configID = config.getListCount( "ConfigList") - 1
    result = load_config()

  if hasBeenActivated( "Quit"):
    result = orxSTATUS_FAILURE



proc main() =
  #[ execute is declared in norx.nim , and needs 3 functions:
      proc execute*(initProc: proc(): orxSTATUS {.cdecl.};
                    runProc: proc(): orxSTATUS {.cdecl.};
                    exitProc: proc() {.cdecl.}
                   )
  ]#
  # NOTE : as in previous tutorial, we call mainloop (see its note) and not the generic « run » function
  execute(init, mainloop, exit)

main()
