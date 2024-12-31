import std/unittest
import norx

{.push cdecl.}

proc init(): orxSTATUS =
  STATUS_SUCCESS

proc exit() {.cdecl.} =
  discard

proc bootstrap(): orxSTATUS =
  # Return STATUS_FAILURE to prevent orx from loading the default config file
  STATUS_FAILURE

proc initORXforTest*() =
  # Initialize ORX without starting it, see norx.nim
  discard orxConfig_SetBootstrap(bootstrap)
  debugInitMacro()
  moduleRegister(MODULE_ID_MAIN, "MAIN", mainSetup, init, exit)
  require moduleInit(MODULE_ID_MAIN) == STATUS_SUCCESS

suite "Suite ORX Object":

  initORXforTest()

  test "ptr orxSTRUCTURE invalid":
    let a = "aString"
    let invalidObjectPointer: ptr orxSTRUCTURE = cast[ptr orxSTRUCTURE](unsafeAddr(a))
    check getPointer(invalidObjectPointer, STRUCTURE_ID_OBJECT) == nil

  test "Can detect if Object is deleted":

    var objectPtr: ptr orxOBJECT;

    # returns nil if invalid
    var strPtr: ptr orxSTRUCTURE = getPointer(objectPtr, STRUCTURE_ID_OBJECT)
    require strPtr.isNil

    objectPtr = objectCreate()

    require not objectPtr.isNil
    require objectPtr.isEnabled() == orxTRUE
    strPtr = getPointer(objectPtr, STRUCTURE_ID_OBJECT)
    require not strPtr.isNil

    let status = objectPtr.objectDelete()

    require status == STATUS_SUCCESS
    strPtr = getPointer(objectPtr, STRUCTURE_ID_OBJECT)
    require strPtr.isNil

