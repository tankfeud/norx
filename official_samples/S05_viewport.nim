## Adaptation to Nim of the 5th C tutorial, about viewports and cameras.
## original author of C tutorial: iarwain@orx-project.org
## adaptation: jseb at finiderire.com

#[
  Debug compilation
  nim c S05_viewport
  (it will use S05_viewport.nim.cfg and liborxd.so loaded at runtime)

  Release compilation
  nim c -d:release --skipProjcfg S05_anim
  (skip nim project cfg, liborx.so is loaded at runtime)

  Note from gokr:
  The choice of the lib is made in lib.nim
  It will use liborxd for debug build, liborx for release build and liborxp if you use -d:profile

  See tutorial S01_object.nim for more info about the basic object creation.
  See tutorial S02_clock.nim for keyboard reading, configuration section retrieving, and clocks.
  See tutorial S03_linked_frame.nim for object hierarchies, rotations and scaling.
  See tutorial S04_anim.nim for using animations.

  For details about Orx side , please refer to the viewport tutorial (official C++ sample):
  https://wiki.orx-project.org/en/tutorials/viewport/viewport

  Summary is (mix of text tutorial & C source comments) :
  This tutorial shows how to use multiple viewports with multiple cameras.
  It creates 4 viewports, shown like this on your screen:
    (1)(2)
    (3)(4)

  Viewports (1) and (4) share the same camera (1).
  To achieve this, we just need to use the same name in the config file.
  Furthermore, when manipulating this camera using left & right mouse buttons to rotate it,
  arrow keys to move it and '+' & '-' to zoom it, these two viewports will be affected.

  Viewport (2) is based on another camera (2) which frustum is narrower than the first one,
  resulting in a display twice as big. You can't affect this viewport through keys for this tutorial.

  Viewport (3) is based on another camera (3) which has the exact same settings than the first one.
  This viewport will display what you originally had in the viewports (1) and (4).

  You can interact with the first viewport properties, using WASD to move it and 'Q' & 'E' to resize it.
  When two viewports overlap, the oldest one (the one created before the other) will be displayed on top.

  We have a box that doesn't move at all, and a little soldier whose world position will be determined
  by the current mouse on-screen position.
  In other words, no matter which viewport your mouse is on or how is set the camera for this viewport,
  the soldier will always have his feet at the same position than your mouse on screen (provided it's
  in a viewport).

  Viewports and objects are created with random colors and sizes using the character '~' in config file.
 
  NB: Cameras store their position/zoom/rotation in an orxFRAME structure.
      It allows them to be part of the orxFRAME hierarchy. (cf. tutorial 03_Frame)
  For example, object auto-following can be achieved by setting object's frame as camera's frame parent.
  On the other hand, having a camera as parent of an object will insure that the object will always
  be displayed at the same place. It is very useful for making HUD and UI.
]
