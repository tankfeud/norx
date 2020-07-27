## Adaptation to Nim of the C tutorial creating two rotating objects, with keyboard speed control.
## comments: jseb at finiderire.com

#[
  Debug compilation
  nim c S02_clock
  (it will use S01_object.nim.cfg and liborxd.so loaded at runtime)

  Release compilation
  nim c -d:release --skipProjcfg S01_object
  (skip nim project cfg, liborx.so loaded at runtime)

  Note from gokr:
  The choice of the lib is made in lib.nim
  It will use liborxd for debug build, liborx for release build and liborxp if you use -d:profile

]#

#[
  See tutorial S01_object.nim for more info about the basic object creation.
  
  For details about Orx side , please refer to the tutorial of the C++ sample:
  https://wiki.orx-project.org/en/tutorials/clock

  Summary is:
  Here we register our callback on 2 different clocks for didactic purpose only.
  All objects can of course be updated with only one clock, and the given clock context is also
  used here for demonstration only.
  The first clock runs at 100 Hz and the second one at 5 Hz.
  You can alter the time of the first clock by activating the "Fast", "Normal" and "Slow" inputs,
  which are defined in the S02_clock.ini file.
  It'll still be updated at the same rate, but the time information that the clock will pass
  to the callback will be stretched.
  This provides an easy way of adding time distortion and having parts
  of your logic code updated at different frequencies.
  One clock can have as many callbacks registered as you want.

  For example, the FPS displayed in the top left corner is computed with a non-stretched clock
  of tick size = 1 second.
]#

import strformat
import norx, norx/[incl, config, viewport, obj, input, keyboard, clock, math]




# returns the keycode corresponding to the physical key defined in .ini
proc get_binding_name( input_name:string) :cstring =
  var eType :orxINPUT_TYPE
  var eID :orxENUM
  var eMode :orxINPUT_MODE

  #[ defined in « oinput.nim »
proc getBinding*(
                  zName: cstring; u32BindingIndex: orxU32;
                  peType: ptr orxINPUT_TYPE; peID: ptr orxENUM; peMode: ptr orxINPUT_MODE
                ) :orxSTATUS
{.cdecl, importc: "orxInput_GetBinding", dynlib: libORX.}
  ## Gets an input binding (mouse/joystick button, keyboard key or joystick axis) at a given index
  ##  @param[in]   _zName            Concerned input name
  ##  @param[in]   _u32BindingIndex  Index of desired binding, less than orxINPUT_KU32_BINDING_NUMBER
  ##  @param[out]  _peType           Binding type (if a slot is not bound, its value is orxINPUT_TYPE_NONE)
  ##  @param[out]  _peID             Binding ID (button/key/axis)
  ##  @param[out]  _peMode           Mode (only used for axis inputs)
  ##  @return orxSTATUS_SUCCESS if input exists, orxSTATUS_FAILURE otherwise
]#
  var is_ok = getBinding( input_name, 0 #[index of desired binding]#, addr eType, addr eID, addr eMode)
  if is_ok == orxSTATUS_SUCCESS:
    echo getKeyDisplayName( (orxKEYBOARD_KEY) eID)
    return getKeyDisplayName( (orxKEYBOARD_KEY) eID)

  return fmt"key {input_name} not found"


# void orxFASTCALL Update(const orxCLOCK_INFO *_pstClockInfo, void *_pstContext)
#proc Update( clock_info:orxCLOCK_FUNCTION, context:pointer) =
# 
proc Update( clock_info:ptr orxCLOCK_INFO, context:pointer) {.cdecl.} =
  #### LOG DISPLAY SECTION ####
  # push Main on section stack for accessing informations related to this section.
  var status = pushSection("Main")

  if getBool("DisplayLog"):
    # clock.getFromInfo( :ptr orxCLOCK_INFO): ptr orxCLOCK
    # clock.getName : returns the orxCLOCK name as a cstring
    # cast , convert, use echo directly, or $ which convert cstring to string (safe but slow)
    let clock_name:string = $getName( getFromInfo( clock_info) )
    orxLOG( &"clock_name time:{clock_info.fTime:3.2f} delta:{clock_info.fDT:1.4f}")

  # pop "Main" , still no test on orxStatus.
  status = popSection();

  #### OBJECT UPDATE SECTION ####
  # gets object from the context
  var obj :ptr orxOBJECT = cast[ptr orxOBJECT]( context)
  
  # Rotates it according to elapsed time (complete rotation every 2 seconds)
  status = setRotation( obj, orxMATH_KF_PI * clock_info.fTime);


proc inputUpdate( clock_info:ptr orxCLOCK_INFO, context:pointer) {.cdecl.} =
  # note : the ESC test for exiting is called by the main clock in " run " proc.
  
  #### LOG DISPLAY SECTION ####
  # push Main on section stack for accessing informations related to this section.
  var status = pushSection("Main")
  
  # Is "Log" key has been pressed ?
  if hasBeenActivated("Log"):
    # Toggles logging on / off
    status = setBool("DisplayLog", not getBool("DisplayLog") )

  # Pops config section
  status = popSection()


  #### CLOCK TIME STRETCHING SECTION ####
  # Finds clock1.
  # We could have stored the clock at creation, of course, but this is done here for didactic purpose.
  var clock1:ptr orxCLOCK = clockGet("Clock1");

  # this time, we test keyboard only if we could get the first Clock (which makes turning the box)
  if clock1 != nil:
    if isActive( "Faster"):
      # Makes this clock go four time faster
      status = setModifier( clock1, orxCLOCK_MOD_TYPE_MULTIPLY, orx2F(4.0f))
      
    elif isActive( "Slower"):
      # Makes this clock go four time slower
      status = setModifier( clock1, orxCLOCK_MOD_TYPE_MULTIPLY, orx2F(0.25f))

    elif isActive( "Normal"):
      # Removes modifier from this clock
      status = setModifier( clock1, orxCLOCK_MOD_TYPE_NONE, orxFLOAT_0)


proc init(): orxSTATUS {.cdecl.} =
  result = orxSTATUS_SUCCESS

  var clock1,clock2,clock_main:ptr orxCLOCK
  var object1,object2:ptr orxOBJECT


#  echo (eType, getKeyDisplayName((orxKEYBOARD_KEY) eID),eMode)

  # for getting logs in a file , as well as terminal output, compile in debug.
  # Displays a small hint in console.
  orxLOG(fmt"""
* Press {get_binding_name("Log")} to toggle log display

* To stretch time for the first clock (updating the box):
* Press key {get_binding_name("Faster")} to set it 4 times faster
* Press key {get_binding_name("Slower")} to set it 4 times slower
* Press key {get_binding_name("Normal")} to set it back to normal""")


  # Creates viewport
  #orxViewport_CreateFromConfig("Viewport");
  var vres = viewportCreateFromConfig("Viewport");
  if vres.isNil:
    result = orxSTATUS_FAILURE

  # Creates object
  object1 = objectCreateFromConfig("Object1");
  if object1.isNil:
    result = orxSTATUS_FAILURE
  object2 = objectCreateFromConfig("Object2");
  if object2.isNil:
    result = orxSTATUS_FAILURE
  
  # Creates two user clocks: a 100Hz and a 5Hz
  clock1 = clockCreateFromConfig("Clock1")
  clock2 = clockCreateFromConfig("Clock2")

  #[ Registers our update callback to these clocks with both object as context.
     The module ID is used to skip the call to this callback if the corresponding module
     is either not loaded or paused, which won't happen in this tutorial. ]#
  var status = register( clock1, Update, object1, orxMODULE_ID_MAIN, orxCLOCK_PRIORITY_NORMAL)
  # you can also call register with clock2 as first implicit parameter.
  status = clock2.register( Update, object2, orxMODULE_ID_MAIN, orxCLOCK_PRIORITY_NORMAL)
  
  clock_main = clockGet(orxCLOCK_KZ_CORE) #or clock_get if you prefer snake_case
  
  #[ Registers our input update callback to it
    !!IMPORTANT!! *DO NOT* handle inputs in clock callbacks that are *NOT* registered to the main clock
     you might miss input status updates if the user clock runs slower than the main one ]#
  status = register( clock_main, inputUpdate, nil, orxMODULE_ID_MAIN, orxCLOCK_PRIORITY_NORMAL);

  # Done !
  result = orxSTATUS_SUCCESS


proc run(): orxSTATUS {.cdecl.} =
  result = orxSTATUS_SUCCESS #by default, won't quit
  if (input.isActive("Quit")):
    # Updates result
    result = orxSTATUS_FAILURE


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

