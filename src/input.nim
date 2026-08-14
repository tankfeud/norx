import wrapper

proc isActive*(name: string): orxBOOL {.inline.} =
  ## Returns whether a named input is active.
  wrapper.isActive(name.cstring)

proc hasBeenActivated*(name: string): orxBOOL {.inline.} =
  ## Returns whether a named input was activated this frame.
  wrapper.hasBeenActivated(name.cstring)

proc hasBeenDeactivated*(name: string): orxBOOL {.inline.} =
  ## Returns whether a named input was deactivated this frame.
  wrapper.hasBeenDeactivated(name.cstring)

proc hasNewStatus*(name: string): orxBOOL {.inline.} =
  ## Returns whether a named input changed status this frame.
  wrapper.hasNewStatus(name.cstring)

proc getValue*(name: string): orxFLOAT {.inline.} =
  ## Gets a named input's current value.
  wrapper.getValue(name.cstring)

proc getBinding*(name: string; bindingIndex: orxU32;
                 inputType: ptr orxINPUT_TYPE; inputId: ptr orxENUM;
                 inputMode: ptr orxINPUT_MODE): orxSTATUS {.inline.} =
  ## Gets one binding for a named input.
  wrapper.getBinding(name.cstring, bindingIndex, inputType, inputId, inputMode)
