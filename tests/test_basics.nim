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

  test "ORX statuses have explicit predicates":
    check STATUS_SUCCESS.isSuccess
    check not STATUS_SUCCESS.isFailure
    check STATUS_FAILURE.isFailure
    check not STATUS_FAILURE.isSuccess
    check not STATUS_NONE.isSuccess
    check not STATUS_NONE.isFailure

  test "RGBA components can be set and extracted":
    let rgba = rgbaSet(0xAA, 0xBB, 0xCC, 0xDD)
    check rgbaR(rgba) == 0xAA
    check rgbaG(rgba) == 0xBB
    check rgbaB(rgba) == 0xCC
    check rgbaA(rgba) == 0xDD
