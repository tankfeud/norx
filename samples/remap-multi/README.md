

TODO:
Gör klart sample enligt tutorials/remapping_inputs med remap_OneAtATime

Gör nytt sample genom att visa använding av remap-module
- Visa rad för förväntad action: 
    Init: Press 2 btns to start
    Map: Press BTN/Steer axis  (Highlighta raden för steget - invertera texten a la CBM64)
    Done: Try it! 
- klara joy add/remove under tiden: Faktorera  map_control: 


Re-mapping scenario
-------------------
The game initiates remapping flow for one or several game controllers.

Alt1; confirmation buttons for each step:
---------------
It displays some info from start and ask user to choose buttons/gestures for accept/OK/Yes and cancel/No.
These are to be used during the remapping for special actions:
-accept/OK/Yes:  ok/next; save the current step's mapping and goto next step, at end Yes will save and end remapping.
-cancel/NO: undo(current mapping reverts to previous of any), undo again: abort remapping. at end NO will redo mapping steps from start.
Remapping actions are short-press only so that the same button can be used for any actual mapping using long-press.

Game initializes remap module with steps, setting: next-step-mode: Action/ButtonRelease
First phase of mapping flow user selects the action controls:
"Choose button for Accept/OK; default [B]"
"... sensing...or timeout.....5,4,3,2,1"
"Using key 2 <B> as Accept/OK (long press for use in mapping)"
"Choose button for Cancel/No; default [A]"
"... sensing...or timeout.....5,4,3,2,1"
"Using key 1 <A> as Cancel/No (long press for use in mapping)"

Then the actual mapping flow starts:
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

