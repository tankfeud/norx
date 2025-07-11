## Adaptation to Nim of the 8th C tutorial, about physics.
## original author of C tutorial: iarwain@orx-project.org
## adaptation: jseb at finiderire.com

#[
  Debug compilation
  nim c S08_physics
  (it will use S08_physics.nim.cfg and liborxd.so loaded at runtime)

  Release compilation
  nim c -d:release --skipProjcfg S08_physics
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

  For details about Orx side , please refer to the physics tutorial (official C++ sample):
  https://wiki.orx-project.org/en/tutorials/physics/physics

  This is a basic C tutorial creating physical bodies and playing with physics and collisions.

  This tutorial shows how to add physical properties to objects and handle collisions.

  As you can see, the physical properties are completely data-driven.
  Creating an object with physical properties (ie. with a body) or without is the same code.

  Objects can be linked to a body which can be static or dynamic.
  Each body can be made of up to 8 parts.

  A body part is defined by
  - Its shape (currently box, sphere and mesh (ie. convex polygon) are the only available).
  - Information about shape size (corners for box, center and radius for sphere, vertices for mesh).
    If no size data specified, the shape will try to fill the complete body (using object size and scale).
  - Collision "self" flags that defines this part.
  - Collision "check" mask that defines with which other parts this one will collide.
    (two parts in the same body will never collide)
  - A flag (Solid) specifying if this shaped should only give information about collisions
    or if it should impact on the body physics simulation (bouncing, etc...)
  - Various attributes such as restitution, friction, density, ...

  Here we create static solid walls around our screen.
  We then spawn boxes in the middle.
  The number of boxes created is tweakable through the config file and is 100 by default.

  Use left and right keyboard keys (or mouse buttons) to rotate the camera.
  As we rotate it, we also update the gravity vector of our simulation.
  It gives the impression that the boxes will be always falling toward the bottom of our screen, no matter
  how the camera is rotated.

  We also register to the physics events to add a visual FXs on two colliding objects.
  By default the FX is a fast color flash and is, as usual, tweakable in realtime
  ie. reloading config history will apply new settings immediately (the FX isn't kept in cache by default).

  Updating an object scale (including changing its scale with FXs) will update its physical properties.
  Keep in mind that scaling an object with a physical body is more expensive as we have to delete
  the current shapes and recreate them at the correct size.
  Our current single physics plugin is based on Box2D which doesn't allow realtime rescaling of shapes.

  This tutorial does only show basic physics and collision control, but, for example, you can also
  be notified with events for object separating or keeping contact.
]#

import strformat
from strutils import unindent
import norx, norx/[incl, config, viewport, obj, input, keyboard, mouse, clock, math, vector, render, event, anim, camera, display, physics]

# the shared functions
import S_commons

var cam:ptr orxCAMERA

proc display_hints() =
  let gin = get_input_name
  var help = fmt"""
    {gin("RotateLeft")} and {gin("RotateRight")} will rotate the camera
    Gravity will follow the camera.
    A bump visual FX is played on objects that collide.
 """

  help = help.unindent
  orxlog( help)

proc EventHandler( event:ptr orxEVENT) :orxSTATUS {.cdecl.} =

  if event.eID == ord(orxPHYSICS_EVENT_CONTACT_ADD):
    # it's a new contact
    # we get the colliding boxes
    var box1 = cast[ptr orxOBJECT]( event.hRecipient)
    var box2 = cast[ptr orxOBJECT]( event.hSender)

    # and add a « bump » effect on them
    discard addFX( box1, "Bump");
    discard addFX( box2, "Bump");


proc Update(clockInfo: ptr orxCLOCK_INFO, context: pointer) {.cdecl.} =
  var deltaRot:orxFLOAT = orxFLOAT_0

  if isActive( "RotateLeft"):
    deltaRot = orx2F( 4.0f) * clockInfo.fDT;
  if isActive( "RotateRight"):
    deltaRot = orx2F( -4.0f) * clockInfo.fDT;

  # has turned ?
  if deltaRot != orxFLOAT_0:
    var gravity:orxVECTOR
    
    # Rotates camera
    discard setRotation( cam, getRotation( cam) + deltaRot)

    # Gets gravity
    discard getGravity( addr gravity)
    # and updates it
    discard twoDRotate( addr gravity, addr gravity, deltaRot)
    # apply new gravity
    discard setGravity( addr gravity)



proc init() :orxSTATUS {.cdecl.} =
  ## usual things
  display_hints()

  let vp = viewportCreateFromConfig( "Viewport")
  if vp.isNil:
    echo "Couldn't create viewport"
    return STATUS_FAILURE
  
  # and get the camera attached to this viewport
  cam = getCamera( vp);

  let mainclock:ptr orxClock = clockGet(CLOCK_KZ_CORE);
  result = clockRegister( mainclock, Update, nil, MODULE_ID_MAIN, CLOCK_PRIORITY_NORMAL);

  ## the event handler (for managing the bump of the boxes)
  discard addHandler( orxEVENT_TYPE_PHYSICS, EventHandler);

  ## create the whole scene (see the magic in .ini)
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
