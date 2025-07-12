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
  
  The camera 1 location will be displayed :
    a) as as black dot in viewport 1 (defined from code)
    b) as a blue square in every viewports (defined from ini file)

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
import norx

# the shared functions
import S_commons


var viewports_list:array[4,ptr orxVIEWPORT]
var soldier:ptr orxOBJECT

proc display_hints() =
  let gin = get_input_name
  var help = fmt"""
  * Worskpaces 1 & 4 display camera 1 content.
  * Workspace 2 displays camera 2 (by default it's twice as close as the other cameras).
  * Workspace 3 displays camera 3.

  * The camera 1 location will be displayed :
    a) as as black dot in viewport 1 (defined from code)
    b) as a blue square in every viewports (defined from ini file)
  - Soldier will be positioned (in the world) so as to be always displayed under the mouse.
  {gin("CameraLeft")}, {gin("CameraRight")}, {gin("CameraUp")}, {gin("CameraDown")} : control camera 1 positioning.
  {gin("CameraRotateLeft")}, {gin("CameraRotateRight")} : control camera 1 rotation.
  {gin("CameraZoomIn")}, {gin("CameraZoomOut")} : control camera 1 zoom.
  {gin("ViewportLeft")}, {gin("ViewportRight")}, {gin("ViewportUp")}, {gin("ViewportDown")} : control viewport 1 positioning.
  {gin("ViewportScaleUp")}, {gin("ViewportScaleDown")} : control viewport 1 size.
  """

  help = help.unindent
  orxlog( help)

proc display_camera_position( cam_pos:ptr orxVECTOR) =
#[
 ; we can add camera location symbol displaying in the ini file.
 ; it's much easier than doing by hand with code
 ; this will display the Camera1 location as a blue filled square.
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

But anyway, as it's a tutorial, we're doing also by hand in code :)
We are defhining another camera symbol, visible only in Viewport1 as a black filled circle.
This symbol will show us the Camera1 location.

There are interesting functions in « render.nim » , for coordinates computing.

proc getWorldPosition*(pvScreenPosition: ptr orxVECTOR;
                       pstViewport: ptr orxVIEWPORT;
                       pvWorldPosition: ptr orxVECTOR)
                       : ptr orxVECTOR {.cdecl, importc: "orxRender_GetWorldPosition", dynlib: libORX.}
  ## Get a world position given a screen one (absolute picking)
  ##  @param[in]   _pvScreenPosition        Concerned screen position
  ##  @param[in]   _pstViewport             Concerned viewport, if nil then either the last viewport
  ##                                        that contains the position (if any), or the last viewport 
  ##                                        with a camera in the list if none contains the position
  ##  @param[out]  _pvWorldPosition         Corresponding world position
  ##  @return      orxVECTOR if found *inside* the display surface, nil otherwise

proc getScreenPosition*(pvWorldPosition: ptr orxVECTOR;
                        pstViewport: ptr orxVIEWPORT;
                        pvScreenPosition: ptr orxVECTOR)
                        : ptr orxVECTOR {.cdecl, importc: "orxRender_GetScreenPosition", dynlib: libORX.}
  ## Get a screen position given a world one and a viewport (rendering position)
  ##  @param[in]   _pvWorldPosition       world position
  ##  @param[in]   _pstViewport           viewport, (if nil, the last viewport with a camera is used)
  ##  @param[out]  _pvScreenPosition      Corresponding screen position
  ##  @return      orxVECTOR if found (can be off-screen), nil otherwise
]#

  let color = orx2RGBA(0,0,0,255)
  var spos_dummy = newVECTOR(0.0, 0.0, 0.0)
  var screen_pos = getScreenPosition( cam_pos, viewports_list[0], addr spos_dummy)
  discard drawCircle( screen_pos, 10.0f, color, true)


proc Update(clockInfo: ptr orxCLOCK_INFO, context: pointer) {.cdecl.} =

  ### camera control ###
  var camera:ptr orxCAMERA = viewports_list[0].getCamera()
  if isActive("CameraRotateLeft"):
    discard camera.setRotation( camera.getRotation() + -4.0f * clockInfo.fDT )
  if isActive("CameraRotateRight"):
    discard camera.setRotation( camera.getRotation() - -4.0f * clockInfo.fDT )

  if isActive("CameraZoomIn"):
    discard camera.setZoom( camera.getZoom() *  1.02f)
  if isActive("CameraZoomOut"):
    discard camera.setZoom( camera.getZoom() *  0.98f)

  var vDummy:orxVECTOR = (0f,0f,0f) # camera.getPosition needs an initialized orxVECTOR as param.
  var cam_pos:ptr orxVECTOR
  cam_pos = camera.getPosition( addr vDummy)

  if isActive("CameraLeft"):
    cam_pos.fX -= 500.0 * clockInfo.fDT;
  if isActive("CameraRight"):
    cam_pos.fX += 500.0 * clockInfo.fDT;
  if isActive("CameraUp"):
    cam_pos.fY -= 500.0 * clockInfo.fDT;
  if isActive("CameraDown"):
    cam_pos.fY += 500.0 * clockInfo.fDT;

  # we need to update the camera position to see changes
  discard camera.setPosition( cam_pos)
  display_camera_position( cam_pos)

  ### viewport control ###
  
  # viewport scale
  var vp_width, vp_height:orxFLOAT
  getRelativeSize( viewports_list[0], addr vp_width, addr vp_height)

  if isActive("ViewportScaleUp"):
    vp_width *= 1.02;
    vp_height *= 1.02;
  if isActive("ViewportScaleDown"):
    vp_width *= 0.98;
    vp_height *= 0.98;
  # update viewport size.
  discard setRelativeSize( viewports_list[0], vp_width, vp_height)

  # viewport position
  var vp_x, vp_y:orxFLOAT
  getPosition( viewports_list[0], addr vp_x, addr vp_y)
  if isActive("ViewportRight"):
    vp_x += 500.0 * clockInfo.fDT
  if isActive("ViewportLeft"):
    vp_x -= 500.0 * clockInfo.fDT
  if isActive("ViewportDown"):
    vp_y += 500.0 * clockInfo.fDT
  if isActive("ViewportUp"):
    vp_y -= 500.0 * clockInfo.fDT
  
  setPosition( viewports_list[0], vp_x, vp_y)

  ### little soldier position ###
  var mouse_pos, soldier_pos:orxVECTOR

  # Get mouse position in world coordinates
  # we can discard result of getWorldPosition, as the same value will be put
  # in the 3rd parameter of the function. It avoids us a dummy vector def.
  discard getWorldPosition( getPosition( addr mouse_pos), nil, addr mouse_pos) 

  # get soldier object position in world coordinates
  discard getWorldPosition( soldier, addr soldier_pos)

  # mouse position is used to solier re-location. We just keep soldier's Z value
  mouse_pos.fZ = soldier_pos.fZ

  # and put the soldier under the cursor
  discard setPosition( soldier, addr mouse_pos)

#[
  /* Gets mouse world position? */
  orxRender_GetWorldPosition(orxMouse_GetPosition(&vPos), orxNULL, &vPos);

  /* Gets object current position */
  orxObject_GetWorldPosition(pstSoldier, &vSoldierPos);

  /* Keeps Z value */
  vPos.fZ = vSoldierPos.fZ;

  /* Moves the soldier under the cursor */
  orxObject_SetPosition(pstSoldier, &vPos);
]#

proc init() :orxSTATUS {.cdecl.} =
  var status:orxSTATUS

  display_hints()

  # Creates all viewport
  # the order creation of viewports is important: more recently created are above the others.
  # so here, as Viewport1 is the last created, it will be above.
  var viewports_names = [ "Viewport4", "Viewport3", "Viewport2", "Viewport1" ]

  for i,vn in viewports_names:
    viewports_list[3-i]= viewportCreateFromConfig( vn)
    # the index trick (3-i) is because we create viewports in reverse order.
    # this is awful. Don't do this at home.
    if viewports_list[3-i].isNil:
      # in case of error, we need to adjust the Viewport «real» name.
      echo &"couldn't create viewport {4-i}"
      return STATUS_FAILURE

  # BTW, since the original tutorial was written, there has been a new function
  # called « orxViewport_Get » (C API), and « viewportGet » (Nim API).
  # It returns a ref to a viewport when you give the name of it.
  # So it's not mandatory to store them at creation

  # no need to keep reference on box, so discard it
  discard objectCreateFromConfig( "Box")
  # Creates our little soldier object
  soldier = objectCreateFromConfig( "Soldier")

  # Gets the main clock
  var mainclock:ptr orxClock = clockGet(CLOCK_KZ_CORE);

  # Registers our update callback
  status = clockRegister( mainclock, Update, nil, MODULE_ID_MAIN, CLOCK_PRIORITY_NORMAL);
  STATUS_SUCCESS


proc Main =
  #[ execute is declared in norx.nim , and needs 3 functions:
      proc execute*(initProc: proc(): orxSTATUS {.cdecl.};
                    runProc: proc(): orxSTATUS {.cdecl.};
                    exitProc: proc() {.cdecl.}
                   )
  ]#
  execute(init, run, exit)

Main()
