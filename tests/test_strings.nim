import std/unittest
import norx

suite "Norx string arguments":
  test "dynamic Nim strings select safe ORX overloads":
    static:
      doAssert compiles(block:
        var
          gameObject: ptr orxOBJECT
          inputType: orxINPUT_TYPE
          inputId: orxENUM
          inputMode: orxINPUT_MODE
        let value = "dynamic" & " value"
        discard isActive(value)
        discard hasBeenActivated(value)
        discard hasBeenDeactivated(value)
        discard hasNewStatus(value)
        discard getValue(value)
        discard getBinding(value, 0, addr inputType, addr inputId,
                           addr inputMode)
        discard pushSection(value)
        discard getString(value)
        discard addStorage(value, value, false)
        discard objectCreateFromConfig(value)
        discard gameObject.setTextString(value)
        discard gameObject.addFX(value)
        discard gameObject.addSound(value)
        discard soundCreateFromConfig(value))
