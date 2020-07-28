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
import norx, norx/[incl, config, viewport, obj, input, keyboard, clock, math]

var parentObject:orxObject



proc run(): orxSTATUS {.cdecl.} =
  result = orxSTATUS_SUCCESS #by default, won't quit
  if (input.isActive("Quit")):
    # Updates result
    result = orxSTATUS_FAILURE


proc init(): orxSTATUS {.cdecl.} =
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
