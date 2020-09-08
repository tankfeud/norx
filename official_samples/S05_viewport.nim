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
]#

import strformat
from strutils import unindent
import norx, norx/[incl, config, viewport, obj, input, keyboard, mouse, clock, math, vector, render, event, anim, camera, display]

# the shared functions
import S_commons


var viewport1:ptr orxVIEWPORT
var soldier:ptr orxOBJECT

proc display_hints() =
  let gin = get_input_name
  var help = fmt"""
  * Worskpaces 1 & 4 display camera 1 content.
  * Workspace 2 displays camera 2 (by default it's twice as close as the other cameras).
  * Workspace 3 displays camera 3.
  - Soldier will be positioned (in the world) so as to be always displayed under the mouse.
  {gin("CameraLeft")}, {gin("CameraRight")}, {gin("CameraUp")}, {gin("CameraDown")} : control camera 1 positioning.
  {gin("CameraRotateLeft")}, {gin("CameraRotateRight")} : control camera 1 rotation.
  {gin("CameraZoomIn")}, {gin("CameraZoomOut")} : control camera 1 zoom.
  {gin("ViewportLeft")}, {gin("ViewportRight")}, {gin("ViewportUp")}, {gin("ViewportDown") : control viewport 1 positioning.
  {gin("ViewportScaleUp"), {gin("ViewportScaleDown")} : control viewport 1 size.
  """

  help = help.unindent
  orxlog( help)

proc Update(clockInfo: ptr orxCLOCK_INFO, context: pointer) {.cdecl.} =

  ### camera control ###
  var camera:ptr orxCAMERA = viewport1.getCamera()
  if input.isActive("CameraRotateLeft"):
    discard camera.setRotation( camera.getRotation() + orx2F(-4.0f) * clockInfo.fDT )
  if input.isActive("CameraRotateRight"):
    discard camera.setRotation( camera.getRotation() - orx2F(-4.0f) * clockInfo.fDT )

  if input.isActive("CameraZoomIn"):
    discard camera.setZoom( camera.getZoom() * orx2F( 1.02f) )
  if input.isActive("CameraZoomOut"):
    discard camera.setZoom( camera.getZoom() * orx2F( 0.98f) )

  var vDummy:orxVECTOR = (0f,0f,0f) # camera.getPosition needs an initialized orxVECTOR as param.
  var cam_pos:ptr orxVECTOR
  cam_pos = camera.getPosition( addr vDummy)

  if input.isActive("CameraLeft"):
    cam_pos.fX -= orx2F(500) * clockInfo.fDT;
  if input.isActive("CameraRight"):
    cam_pos.fX += orx2F(500) * clockInfo.fDT;
  if input.isActive("CameraUp"):
    cam_pos.fY -= orx2F(500) * clockInfo.fDT;
  if input.isActive("CameraDown"):
    cam_pos.fY += orx2F(500) * clockInfo.fDT;

  # we need to update the camera position to see changes
  discard camera.setPosition( cam_pos)

  ### viewport control ###

#  let color:orxRGBA = orxRGBA(u8R:'1', u8G:'1', u8B:'1', u8A:'1')

#[
 ; we can add camera location displaying in the ini file
 ; it's much easier than doing by hand with code
[Box]
ChildList     = Marker1

[Marker1]
ParentCamera  = Camera1
Graphic       = @
Texture       = pixel
Size          = (10, 10)
Color         = (255, 0, 0)
Pivot         = center

; the ParentCamera property is quite handy (especially when used along UseParentSpace)
; for anything UI-related.
; it makes it easy to adapt to different aspect ratio as well, all in config
]#
# but anyway, as it's a tutorial, we're doing by hand in code :)

#[
/** Get a world position given a screen one (absolute picking)
 * @param[in]   _pvScreenPosition                     Concerned screen position
 * @param[in]   _pstViewport                          Concerned viewport, if orxNULL then either the last viewport that contains the position (if any), or the last viewport with a camera in the list if none contains the position
 * @param[out]  _pvWorldPosition                      Corresponding world position
 * @return      orxVECTOR if found *inside* the display surface, orxNULL otherwise
 */
extern orxDLLAPI orxVECTOR *orxFASTCALL       orxRender_GetWorldPosition(const orxVECTOR *_pvScreenPosition, const orxVIEWPORT *_pstViewport, orxVECTOR *_pvWorldPosition);

/** Get a screen position given a world one and a viewport (rendering position)
 * @param[in]   _pvWorldPosition                      Concerned world position
 * @param[in]   _pstViewport                          Concerned viewport, if orxNULL then the last viewport with a camera will be used
 * @param[out]  _pvScreenPosition                     Corresponding screen position
 * @return      orxVECTOR if found (can be off-screen), orxNULL otherwise
 */
extern orxDLLAPI orxVECTOR *orxFASTCALL       orxRender_GetScreenPosition(const orxVECTOR *_pvWorldPosition, const orxVIEWPORT *_pstViewport, orxVECTOR *_pvScreenPosition);
]#

  let color = orx2RGBA( 255,255,255, 255)
  var screen_pos:ptr orxVECTOR
  var spos_dummy:orxVECTOR = (0f,0f,0f)
  screen_pos = getScreenPosition( cam_pos, viewport1, addr spos_dummy)
  discard drawCircle( screen_pos, 10.0f, color, true)

proc init() :orxSTATUS {.cdecl.} =
  var status:orxSTATUS

  display_hints()

  # Creates all viewport
  var viewports_names = [ "Viewport4", "Viewport3", "Viewport2", "Viewport1" ]

  for vn in viewports_names:
    # as Viewport variable is thrashed as we go along the loop iterations,
    # we will keep only last viewport created ("Viewport1").
    viewport1 = viewportCreateFromConfig( vn)
    if viewport1.isNil:
      echo "couldn't create viewport"
      return orxSTATUS_FAILURE

  # no need to keep reference on box, so discard it
  discard objectCreateFromConfig( "Box")
  # Creates our little soldier object
  soldier = objectCreateFromConfig( "Soldier")

  # Gets the main clock
  var mainclock:ptr orxClock = clockGet(orxCLOCK_KZ_CORE);

  # Registers our update callback
  status = register( mainclock, Update, nil, orxMODULE_ID_MAIN, orxCLOCK_PRIORITY_NORMAL);
  orxSTATUS_SUCCESS


proc Main =
  #[ execute is declared in norx.nim , and needs 3 functions:
      proc execute*(initProc: proc(): orxSTATUS {.cdecl.};
                    runProc: proc(): orxSTATUS {.cdecl.};
                    exitProc: proc() {.cdecl.}
                   )
  ]#
  execute(init, run, exit)

Main()
