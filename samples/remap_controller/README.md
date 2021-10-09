# Remapping Inputs
# From https://wiki.orx-project.org/en/tutorials/remapping_inputs

# Install
First install ORX, Nim and Norx as described in top README.

Then run `nimble install` in this directory which will compile and install the binary in release mode.

After that you can run `./remap`. ESC quits. Pressing the key below ESC (may be different depending on your keyboard, on mine it's "§" but evidently "`" on others I guess) opens the ORX console.

# Compiling
A Nim debug build will use `liborxd.so|dylib|dll`, a release build will use `liborx.so|dylib|dll` and if you build with `nim c -d:profile` it will use `liborxp.so|dylib|dll`.


TODO:
Gör klart sample enligt tutorials/remapping_inputs med remap_OneAtATime


Gör remap-module i norx som kan använda flera samtidiga och
    skall använda mapping lista med input som har typ button/axis/båda som kravtyp
    ny getActiveAxes(joyId): seq[tuple[eID: int, value: float]] 
Gör nytt sample genom att visa använding av remap-module

med 

Re-mapping scenario
-------------------
The game initiates remapping flow for one or several game controllers.
It displays some info from start and ask user to choose buttons/gestures for accept/OK/Yes and cancel/No.
These are to be used during the remapping for special actions:
-accept/OK/Yes:  ok/next; save the current step's mapping and goto next step, at end Yes will save and end remapping.
-cancel/NO: undo(current mapping reverts to previous of any), undo again: abort remapping. at end NO will redo mapping steps from start.
Remapping actions are short-press only so that the same button can be used for any actual mapping using long-press.


"Choose button for Accept/OK; default [B]"
"... sensing...or timeout.....5,4,3,2,1"
"Using key 51 <B> as Accept/OK (long press for use in mapping)"
"Choose button for Cancel/No; default [A]"
"... sensing...or timeout.....5,4,3,2,1"
"Using key 51 <A> as Cancel/No (long press for use in mapping)"

Then the actual mapping flow starts:
Game initializes remap module with steps, AcceptButton, CancelButton, mapDone Callback
Game shows section/box with controller name and text, e.g. "Re-mapping game controls"


re-mapping:
starting from step 0:
senses controller and if button/axis is active >0.3s then call 
  if NOT action button (short press):
    mapSet-callback game->mapSet(deviceNr, stepNr, mapping/buttonId) (and saves mapping for step? )
    Game displays the "new" mapping button/axis, with image etc
  If action button accept/OK goto next step: 
    check that step has mapping else prompt with info about long press for action button or how to abort
    if all steps done:
        game->endConfirm();  Display "Press OK to save and end"
    else:
        stepNext-callback: game->stepNext(++stepNr);
  If action was cancel/No then undo to empty or previous mapping

senses if Accept/Ok was pressed: then call mapDone callback game->mapDone(deviceNr, stepNr)
next: step: until all steps done

Quick re-maping - no accept buttons:
=======
Each step: 
1. display "release button..." and wait for release...or blink "Release buttons"
2. display "Map <control>" "Map forward" show image etc: Wait for button/axis stable for 1s
    2b. show button/axis value directly when stable for 0.3s
    2c. If BACK-button: reset step
3. Store mapping and set mapping result



remap-module
Used by app to perform remapping in game.

initialized and activated/passivated per device or auto by game.
Uses current devices attached to start a remapping flow. when a mapping result is returned to game.

Game provides steps that contains:
- ID:step nr
- Name - for debugging
- required input type(s): button, axis, key, mouse or any (array of orxINPUT_TYPE)
- current binding
- updated binding (result, null from start) 


Game should be able to use ongoing mapping to visualize game controls affecting moving game object in real time.

