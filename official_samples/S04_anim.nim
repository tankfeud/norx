## Adaptation to Nim of the 4th C tutorial, about sprite animation.
## comments: jseb at finiderire.com

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


]#


