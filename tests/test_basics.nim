import std/unittest
import norx

suite "Norx basic types":
  test "ORX booleans interoperate with Nim booleans":
    check orxTRUE
    check not orxFALSE

    var enabled: orxBOOL = true
    check enabled
    enabled = false
    check not enabled

  test "ORX booleans retain their C representation":
    check sizeof(orxBOOL) == sizeof(orxU32)

  test "Nim booleans do not convert to arbitrary ORX integers":
    static:
      doAssert not compiles(block:
        var value: orxU32 = true
        discard value)
