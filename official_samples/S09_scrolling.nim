## Adaptation to Nim of the 9th C tutorial, about scrolling.
## original author of C tutorial: iarwain@orx-project.org
## adaptation: jseb at finiderire.com

#[
  Debug compilation
  nim c S09_scrolling
  (it will use S09_scrolling.nim.cfg and liborxd.so loaded at runtime)

  Release compilation
  nim c -d:release --skipProjcfg S09_scrolling
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

  For details about Orx side , please refer to the scrolling tutorial (official C++ sample):
  https://wiki.orx-project.org/en/tutorials/scrolling

 This tutorial shows how to display a parallax scrolling.

 As you can see, there's no special code for the parallax scrolling.
 Orx's default 2D render plugin do the job, depending of the object's properties settings in .ini.
 By default, AutoScroll is set to 'both'.

 This means a parallax scrolling will happen on both X and Y axis when the camera moves.
 You can try to set this value to x, y or even remove it.

 Along the AutoScroll property, you can find the DepthScale one.
 This one is used to automatically adjust objects' scale depending on how far they are from the camera.
 The smaller the camera frustum is, the faster this autoscale will apply.
 Try and play with object positionning and camera near & far planes to modify scrolling and depth scale.

 You can change the scrolling speed (ie. the camera move speed) in the config file.
 As usual, you can modify its value in real time and ask for a config history reload.

 As you can see, our update code simply moves the camera in the 3D space.
 Pressing arrows will move it along X and Y axis.
 Pressing control & alt keys will move it along the Z one.

 As told before, all the parallax scrolling will happen because objects have been flagged appropriately.
 Your code merely needs to move your camera, without having to bother about any scrolling effect.
 This gives you a full control about how many scrolling planes you want, and about objects affected by it.

 The last point concerns the sky.
 As seen in the tutorial S03_frame, we set the sky object's frame as a child of the camera one.
 This means the position set for the sky object in config file will always be relative to the camera one.
 In other words, the sky will follow the camera.
 As we put it at a depth of 1000 (the same value as camera far frustum plane), it stays in the background.
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
  {gin("CameraUp")}, {gin("CameraLeft")}, {gin("CameraRight")}, {gin("CameraDown")} will move the camera.
  {gin("CameraZoomIn")} and {gin("CameraZoomOut")} will zoom in/out."
  * The scrolling and auto-scaling of objects is data-driven, no code required.
  * The sky background will follow the camera (parent/child frame relation).
 """

  help = help.unindent
  orxlog( help)


proc Update(clockInfo: ptr orxCLOCK_INFO, context: pointer) {.cdecl.} =
  var vMove, vPosition, vScrollSpeed:orxVECTOR = (0f,0f,0f)

  # enter the [Tutorial] section for getting config values.
  var is_ok = pushSection( "Tutorial")
  # usually i don't test return values in tutorial, but IMAGINE if you've made a mistake in section name.
  if is_ok == orxSTATUS_SUCCESS:
    discard getVector( "ScrollSpeed", addr vScrollSpeed) # well i should check here as well, but hey.
    is_ok = popSection()
  else:
    orxlog( "Error while pushing section.")

  # update scroll speed
  mulf( addr vScrollSpeed, addr vScrollSpeed, clockInfo.fDT)
  
  if isActive("CameraLeft"): vMove.fX -= vScrollSpeed.fX
  if isActive("CameraRight"): vMove.fX += vScrollSpeed.fX
  if isActive("CameraDown"): vMove.fY += vScrollSpeed.fY
  if isActive("CameraUp"): vMove.fY -= vScrollSpeed.fY
  if isActive("CameraZoomIn"): vMove.fZ += vScrollSpeed.fZ
  if isActive("CameraZoomOut"): vMove.fZ -= vScrollSpeed.fZ

  discard setPosition( cam, vector.add( addr vPosition, getPosition( cam, addr vPosition), addr vMove) )


proc init() :orxSTATUS {.cdecl.} =
  ## usual things
  display_hints()

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

  

proc main() =
  #[ execute is declared in norx.nim , and needs 3 functions:
      proc execute*(initProc: proc(): orxSTATUS {.cdecl.};
                    runProc: proc(): orxSTATUS {.cdecl.};
                    exitProc: proc() {.cdecl.}
                   )
  ]#
  execute(init, run, exit)

main()
