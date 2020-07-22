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

import norx, norx/[incl, config, viewport, obj, input]


proc init(): orxSTATUS {.cdecl.} =
  result = orxSTATUS_SUCCESS
  # for getting logs in a file , as well as terminal output, compile in debug.
  # Displays a small hint in console.
  orxLOG("""
* Press '%s' to toggle log display

* To stretch time for the first clock (updating the box):
* Press key '%s' to set it 4 times faster
* Press key '%s' to set it 4 times slower
* Press key '%s' to set it back to normal""")
         #, zInputLog,  zInputFaster, zInputSlower, zInputNormal);


  # Creates viewport
  #orxViewport_CreateFromConfig("Viewport");
  var vres = viewportCreateFromConfig("Viewport");
  if vres.isNil:
    result = orxSTATUS_FAILURE

  # Creates object
  var ores = objectCreateFromConfig("Object");
  if ores.isNil:
    result = orxSTATUS_FAILURE


proc run(): orxSTATUS {.cdecl.} =
  result = orxSTATUS_SUCCESS

  # Should quit?
  if (input.isActive("Quit")):
    # Updates result
    result = orxSTATUS_FAILURE;


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


#[


/** Update callback
 */
void orxFASTCALL Update(const orxCLOCK_INFO *_pstClockInfo, void *_pstContext)
{
  orxOBJECT *pstObject;

  /* *** LOG DISPLAY SECTION *** */

  /* Pushes main config section */
  orxConfig_PushSection("Main");

  /* Should display log? */
  if(orxConfig_GetBool("DisplayLog"))
  {
    /* Displays info in log and console */
    orxLOG("<%s>: Time = %.3f / DT = %.3f", orxClock_GetName(orxClock_GetFromInfo(_pstClockInfo)), _pstClockInfo->fTime, _pstClockInfo->fDT);
  }

  /* Pops config section */
  orxConfig_PopSection();

  /* *** OBJECT UPDATE SECTION *** */

  /* Gets object from context.
   * The helper macro orxOBJECT() will verify if the pointer we want to cast
   * is really an orxOBJECT.
   */
  pstObject = orxOBJECT(_pstContext);

  /* Rotates it according to elapsed time (complete rotation every 2 seconds) */
  orxObject_SetRotation(pstObject, orxMATH_KF_PI * _pstClockInfo->fTime);
}

/** Input update callback
 */
void orxFASTCALL InputUpdate(const orxCLOCK_INFO *_pstClockInfo, void *_pstContext)
{
  orxCLOCK *pstClock;

  /* *** LOG DISPLAY SECTION *** */

  /* Pushes main config section */
  orxConfig_PushSection("Main");

  /* Is log input newly active? */
  if(orxInput_HasBeenActivated("Log"))
  {
    /* Toggles logging */
    orxConfig_SetBool("DisplayLog", !orxConfig_GetBool("DisplayLog"));
  }

  /* Pops config section */
  orxConfig_PopSection();

  /* *** CLOCK TIME STRETCHING SECTION *** */

  /* Finds clock1.
   * We could have stored the clock at creation, of course, but this is done here for didactic purpose. */
  pstClock = orxClock_Get("Clock1");

  /* Success? */
  if(pstClock)
  {
    /* Is faster input active? */
    if(orxInput_IsActive("Faster"))
    {
      /* Makes this clock go four time faster */
      orxClock_SetModifier(pstClock, orxCLOCK_MOD_TYPE_MULTIPLY, orx2F(4.0f));
    }
    /* Is slower input active? */
    else if(orxInput_IsActive("Slower"))
    {
      /* Makes this clock go four time slower */
      orxClock_SetModifier(pstClock, orxCLOCK_MOD_TYPE_MULTIPLY, orx2F(0.25f));
    }
    /* Is normal input active? */
    else if(orxInput_IsActive("Normal"))
    {
      /* Removes modifier from this clock */
      orxClock_SetModifier(pstClock, orxCLOCK_MOD_TYPE_NONE, orxFLOAT_0);
    }
  }
}


/** Inits the tutorial
 */
orxSTATUS orxFASTCALL Init()
{
  orxCLOCK       *pstClock1, *pstClock2, *pstMainClock;
  orxOBJECT      *pstObject1, *pstObject2;
  orxINPUT_TYPE   eType;
  orxENUM         eID;
  orxINPUT_MODE   eMode;
  const orxSTRING zInputLog;
  const orxSTRING zInputFaster;
  const orxSTRING zInputSlower;
  const orxSTRING zInputNormal;

  /* Gets input binding names */
  orxInput_GetBinding("Log", 0, &eType, &eID, &eMode);
  zInputLog     = orxInput_GetBindingName(eType, eID, eMode);

  orxInput_GetBinding("Faster", 0, &eType, &eID, &eMode);
  zInputFaster  = orxInput_GetBindingName(eType, eID, eMode);

  orxInput_GetBinding("Slower", 0, &eType, &eID, &eMode);
  zInputSlower  = orxInput_GetBindingName(eType, eID, eMode);

  orxInput_GetBinding("Normal", 0, &eType, &eID, &eMode);
  zInputNormal  = orxInput_GetBindingName(eType, eID, eMode);

  /* Displays a small hint in console */
  orxLOG("\n- Press '%s' to toggle log display"
         "\n- To stretch time for the first clock (updating the box):"
         "\n . Press numpad '%s' to set it 4 times faster"
         "\n . Press numpad '%s' to set it 4 times slower"
         "\n . Press numpad '%s' to set it back to normal", zInputLog,  zInputFaster, zInputSlower, zInputNormal);

  /* Creates viewport */
  orxViewport_CreateFromConfig("Viewport");

  /* Creates objects */
  pstObject1 = orxObject_CreateFromConfig("Object1");
  pstObject2 = orxObject_CreateFromConfig("Object2");

  /* Creates two user clocks: a 100Hz and a 5Hz */
  pstClock1 = orxClock_CreateFromConfig("Clock1");
  pstClock2 = orxClock_CreateFromConfig("Clock2");

  /* Registers our update callback to these clocks with both object as context.
   * The module ID is used to skip the call to this callback if the corresponding module
   * is either not loaded or paused, which won't happen in this tutorial.
   */
  orxClock_Register(pstClock1, Update, pstObject1, orxMODULE_ID_MAIN, orxCLOCK_PRIORITY_NORMAL);
  orxClock_Register(pstClock2, Update, pstObject2, orxMODULE_ID_MAIN, orxCLOCK_PRIORITY_NORMAL);

  /* Gets main clock */
  pstMainClock = orxClock_Get(orxCLOCK_KZ_CORE);

  /* Registers our input update callback to it
   * !!IMPORTANT!! *DO NOT* handle inputs in clock callbacks that are *NOT* registered to the main clock
   * you might miss input status updates if the user clock runs slower than the main one
   */
  orxClock_Register(pstMainClock, InputUpdate, orxNULL, orxMODULE_ID_MAIN, orxCLOCK_PRIORITY_NORMAL);

  /* Done! */
  return orxSTATUS_SUCCESS;
}

/** Run function
 */
orxSTATUS orxFASTCALL Run()
{
  orxSTATUS eResult = orxSTATUS_SUCCESS;

  /* Should quit? */
  if(orxInput_IsActive("Quit"))
  {
    /* Updates result */
    eResult = orxSTATUS_FAILURE;
  }

  /* Done! */
  return eResult;
}

/** Exit function
 */
void orxFASTCALL Exit()
{
  /* We're a bit lazy here so we let orx clean all our mess! :) */
}

/** Main function
 */
int main(int argc, char **argv)
{
  /* Executes a new instance of tutorial */
  orx_Execute(argc, argv, Init, Run, Exit);

  return EXIT_SUCCESS;
}
]#
