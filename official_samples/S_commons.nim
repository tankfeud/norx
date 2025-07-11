#[ From sample 05 (S05_Viewport.nim) , i decided to put commons sample functions
   in a Nim module.
   Thus, readability should be improved, as sample code will be centered on new notions.
]#

import norx
import strformat

proc run*(): orxSTATUS {.cdecl.} =
  result = STATUS_SUCCESS #by default, won't quit
  if (isActive("Quit")):
    # Updates result
    result = STATUS_FAILURE

proc exit*() {.cdecl.} =
  # We're a bit lazy here so we let orx clean all our mess! :)
  quit(0)


proc get_input_name*(input_name: string) :cstring =
  ## Returns the keycode corresponding to the physical key defined in .ini
  var eType: orxINPUT_TYPE
  var eID: orxENUM
  var eMode: orxINPUT_MODE

  var is_ok = getBinding(input_name, 0 #[index of desired binding]#, addr eType, addr eID, addr eMode)
  if is_ok == STATUS_SUCCESS:
    result = getBindingName( eType, eID, eMode)
    #echo fmt"[get_input_name] asked for {input_name}, got binding: {binding_name}"
  else:
    echo "couldn't get binding"
    result = fmt"key {input_name} not found"

