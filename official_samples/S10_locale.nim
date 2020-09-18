## Adaptation to Nim of the 10th C tutorial, about localization.
## original author of C tutorial: iarwain@orx-project.org
## adaptation: jseb at finiderire.com

#[
  Debug compilation
  nim c S10_locale
  (it will use S10_locale.nim.cfg and liborxd.so loaded at runtime)

  Release compilation
  nim c -d:release --skipProjcfg S10_locale
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

  For details about Orx side , please refer to the localization tutorial (official C++ sample):
  https://wiki.orx-project.org/en/tutorials/localization/locale

 This tutorial simply display orx's logo and a localized legend.
 Press space (or left mouse button) to cycle through all the availables languages for the legend's text.

 At this level of tutorials, you should already know this, but i leave the remarks from original tutorial.

 - Run function:
   Don't put *ANY* logic code here, it's only a backbone where you can handle default core behaviors
   (tracking exit or changing locale, for example) or profile some stuff.
   It's directly called from the main loop.
   It's not part of the clock system, time consistency can't be enforced.
   For your main game execution, please create (or use an existing) clock and register your callback to it.

 - Event handlers:
   When an event handler returns orxSTATUS_SUCCESS, no other handler will be called after it for the same event.
   On the other hand, if orxSTATUS_FAILURE is returned, event processing will continue for this event
   if other handlers are listening this event type.
   We'll monitor locale events to update our legend's text when the selected language is changed.

 - orx_Execute():
   Inits and executes orx using our self-defined functions (Init, Run and Exit).
   We can of course not use this helper and handles everything manually if its
   behavior doesn't suit our needs.
   You can have a look at the content of orx_Execute() (which is implemented in orx.h) to have
   a better idea on how to do this.
]#

import strformat
from strutils import unindent
import norx, norx/[incl, config, viewport, obj, input, keyboard, mouse, clock, math, vector, render, event, anim, camera, display, locale]

# the shared functions
import S_commons

var language_index:orxU32 = 0

proc EventHandler( event:ptr orxEVENT) :orxSTATUS {.cdecl.} =
  return result 

proc init() :orxSTATUS {.cdecl.} =
  result = addHandler( orxEVENT_TYPE_LOCALE, EventHandler)


# in the others tutorials , we were using a generic « run » procedure.
# the I/O polling (keyboard, mouse…) was done in a callback function, defined in « init » proc.
# This time, we don't have callback function , called at a certain rate (Hz) by a clock.
# The I/O polling will be done entirely in the mainloop.
proc mainloop() :orxSTATUS {.cdecl.} =
  # testing both isActive (key detection) and hasNewStatus (for avoiding cycling fast in the languages)
  if isActive("CycleLanguage") and hasNewStatus("CycleLanguage"):
    # update language index
    language_index.inc()
    if language_index == getLanguageCount():
      language_index = 0

    # select it
    discard selectLanguage( getLanguage( language_index))

  if isActive("Quit"):
    orxLOG( "Quit action triggered, exiting!")
    # Sets returned value to orxSTATUS_FAILURE, meaning we want to exit
    result = orxSTATUS_FAILURE


proc main() =
  #[ execute is declared in norx.nim , and needs 3 functions:
      proc execute*(initProc: proc(): orxSTATUS {.cdecl.};
                    runProc: proc(): orxSTATUS {.cdecl.};
                    exitProc: proc() {.cdecl.}
                   )
  ]#
  # NOTE : this time, we call mainloop (see its note) and not the generic « run » function
  execute(init, mainloop, exit)

main()
