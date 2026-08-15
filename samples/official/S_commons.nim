## Shared helpers for the official ORX tutorial ports.

import strformat
import norx

proc bindingName*(action: string): string =
  ## Returns the display name of the key bound to an input action.
  var
    inputType: orxINPUT_TYPE
    inputId: orxENUM
    inputMode: orxINPUT_MODE
  if getBinding(action, 0, addr inputType, addr inputId, addr inputMode).isSuccess:
    result = $getBindingName(inputType, inputId, inputMode)
  else:
    result = fmt"key '{action}' not found"

proc run*(): orxSTATUS {.cdecl.} =
  ## Default run function: quits when the Quit input is active.
  if isActive("Quit"): STATUS_FAILURE else: STATUS_SUCCESS

proc exit*() {.cdecl.} =
  ## ORX cleans up the objects created by the tutorials.
