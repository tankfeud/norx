## Adaptation to Nim of the 11th C tutorial, about spawners.
## original author of C tutorial: iarwain@orx-project.org
## adaptation: jseb at finiderire.com

#[
  Debug compilation
  nim c S12_lighting
  (it will use S12_lighting.nim.cfg and liborxd.so loaded at runtime)

  Release compilation
  nim c -d:release --skipProjcfg S12_lighting
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
  See tutorial S11_spawner for learning how to manage loading of .ini files (and spawn particles).

  For details about Orx side , please refer to the lighting tutorial:
  https://wiki.orx-project.org/en/tutorials/shaders/lighting

 This tutorial shows how to generate normal maps and use shaders for pixel-based lighting effects.
 It's only one of the many possibilities of lighting you can achieve with shaders.

 The code manage an array of lights, allowing to change their properties such as position or radius.
 The whole object lighting is done in the fragment shader defined in S12_lighting.ini.

 For performance sake, normap maps are computed for each object's texture when the object is loaded.
 This is done by CPU, but could be done on GPU:
  - With viewports that would have textures as render target, instead of the screen.
  - All objects would be rendered separately once with a shader which would only compute the normal maps.
 -> This technique would improve “loading/init” performances but requires more code to be written.

 A more efficient way would be to batch the normal map creation: loading all the texture at once and creating the associated normal maps in one pass.
 We chose to do it on objects creations instead.
 It keeps this tutorial modular and allow new objects to be added in config by users without any additional knowledge on how the textures will be processed at runtime by the code.

 The lighting shader is a very basic one, far from any realistic lighting, and has been kept simple so as to provide a good base for newcomers.

]#

import strformat
from strutils import unindent
import norx

# the shared functions
import S_commons

type light = object
  color: orxCOLOR # orxCOLOR is a tuple defined in display.nim
  pos: orxVECTOR
  radius: orxFLOAT

const LIGHT_NUMBER = 10
var light_list:array[LIGHT_NUMBER, light]
var light_index:orxS32

# hash table for storing textures
var texture_table:ptr orxHASHTABLE
# and usual globals for viewport & scene
var vp:ptr orxVIEWPORT
var scene:ptr orxOBJECT


proc clear_all_lights() :orxSTATUS =
  # get lighting section
  result = pushSection( "Lighting")

  # initialization of light array
  for light in mitems(light_list):
    light.color.fAlpha = 0
    light.radius = getFloat( "Radius")
    light.pos = newVECTOR(0.0, 0.0, 0.0)

    # Get color as vector - using a temporary vector and then converting
    var vRGB: orxVECTOR
    discard getVector( "Color", addr vRGB)
    # Convert vector to color using anon0.vRGB structure
    light.color.anon0.vRGB = vRGB

  result = popSection()
  light_index = 0


proc EventHandler( event:ptr orxEVENT) :orxSTATUS {.cdecl.} =
  result = STATUS_SUCCESS

  # set shader param ?
  if event.eType == EVENT_TYPE_SHADER and event.eID == ord(SHADER_EVENT_SET_PARAM):
    var payload = cast[ptr orxSHADER_EVENT_PAYLOAD]( event.pstPayload)

    # is active ?
    if payload.s32ParamIndex <= light_index:
      # Skip shader parameter handling for now
      discard
      #else:
      #  echo fmt"⚠  unknown payload.zParamName: {$payload.zParamName}"


proc display_hints() =
  let gin = get_input_name
  var help = fmt"""
  {gin("CreateLight")} will create a new light under the cursor.
  {gin("ClearLights")} will clear all the lights from the scene.
  {gin("IncreaseRadius")} will increase the radius of the current light.
  {gin("DecreaseRadius")} will decrease the radius of the current light.
  {gin("ToggleAlpha")} will toggle alpha on light (ie. make holes in lit objects).
  """

  help = help.unindent
  orxlog( help)



proc init() :orxSTATUS {.cdecl.} =
  result = STATUS_SUCCESS
  ## usual things
  display_hints()

  # EventHandler() will listen for shader and object events.
  # There we'll populate shader parameters at runtime and create normal maps for new created object
  # if the corresponding normal map isn't already available.
  result = addHandler( EVENT_TYPE_SHADER, EventHandler)
  result = addHandler( EVENT_TYPE_TEXTURE, EventHandler)

  # create scene and viewport
  scene = objectCreateFromConfig( "Scene")
  vp = viewportCreateFromConfig( "Viewport")

  result = clear_all_lights()
  if result == STATUS_FAILURE:
    echo "⚠  problem when calling clear_all_lights()"


  # Creates hash table for storing up to 16 normal maps signatures.
  texture_table = hashTableCreate(16, HASHTABLE_KU32_FLAG_NONE, MEMORY_TYPE_MAIN)




# in the others tutorials , we were using a generic « run » procedure.
# The I/O polling (keyboard, mouse…) was done in a callback function, defined in « init » proc.
# This time, we don't have callback function , called at a certain rate (Hz) by a clock.
# The I/O polling will be done entirely in the mainloop.
proc mainloop() :orxSTATUS {.cdecl.} =
  result = STATUS_SUCCESS

  # current light position is the mouse position
  discard getPosition( addr light_list[light_index].pos)

  if hasBeenActivated( "CreateLight"):
    light_index = min( LIGHT_NUMBER - 1, light_index + 1);

  if hasBeenActivated( "ClearLights"):
    result = clear_all_lights()

  if hasBeenActivated( "IncreaseRadius"):
    var increased = getValue( "IncreaseRadius") * 0.05
    light_list[light_index].radius += increased

  if hasBeenActivated( "DecreaseRadius"):
    var decreased = max( 0.0, light_list[light_index].radius - getValue("DecreaseRadius") * 0.05)
    light_list[light_index].radius = decreased

  if hasBeenActivated( "ToggleAlpha"):
    light_list[light_index].color.fAlpha = 1.5 - light_list[light_index].color.fAlpha

  if hasBeenActivated( "Quit"):
    result = STATUS_FAILURE



proc main() =
  #[ execute is declared in norx.nim , and needs 3 functions:
      proc execute*(initProc: proc(): orxSTATUS {.cdecl.};
                    runProc: proc(): orxSTATUS {.cdecl.};
                    exitProc: proc() {.cdecl.}
                   )
  ]#
  # NOTE : once again (see previous episodes), use mainloop and not the generic « run » function
  execute(init, mainloop, exit)

main()
