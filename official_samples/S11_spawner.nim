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

  For details about Orx side , please refer to the scrolling tutorial (official C++ sample):
  https://wiki.orx-project.org/en/tutorials/spawners/spawner

]#

import strformat
from strutils import unindent
import norx, norx/[incl, config, viewport, obj, input, keyboard, mouse, clock, math, vector, render, event, anim, camera, display]

# the shared functions
import S_commons

var cam:ptr orxCAMERA

proc display_hints() =
  let gin = get_input_name
  var help = fmt"""
  """
#[
{gin("CameraUp")}, {gin("CameraLeft")}, {gin("CameraRight")}, {gin("CameraDown")} will move the camera.
  {gin("CameraZoomIn")} and {gin("CameraZoomOut")} will zoom in/out."
  * The scrolling and auto-scaling of objects is data-driven, no code required.
  * The sky background will follow the camera (parent/child frame relation).
 """
]#

  help = help.unindent
  orxlog( help)



proc init() :orxSTATUS {.cdecl.} =
  ## usual things
  display_hints()

#[
  let vp = viewportCreateFromConfig( "Viewport")
  if vp.isNil:
    echo "Couldn't create viewport"
    return orxSTATUS_FAILURE
  
  # and get the camera attached to this viewport
  cam = getCamera( vp);

  let mainclock:ptr orxClock = clockGet(orxCLOCK_KZ_CORE);
  result = register( mainclock, Update, nil, orxMODULE_ID_MAIN, orxCLOCK_PRIORITY_NORMAL);

  # the whole scene is an object, with two childs: Sky & CloudSpawner.
  discard objectCreateFromConfig( "Scene")
]#
  
# in the others tutorials , we were using a generic « run » procedure.
# The I/O polling (keyboard, mouse…) was done in a callback function, defined in « init » proc.
# This time, we don't have callback function , called at a certain rate (Hz) by a clock.
# The I/O polling will be done entirely in the mainloop.
proc mainloop() :orxSTATUS {.cdecl.} =
  result = orxSTATUS_SUCCESS

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
