import std/unittest
import norx, norx/[incl, structure, obj, config]

proc orx_init(): orxSTATUS {.cdecl.} =
  result = orxSTATUS_SUCCESS

proc orx_exit() {.cdecl.} =
  discard

proc config_bootstrap(): orxSTATUS {.cdecl.} =
  # Return orxSTATUS_FAILURE to prevent orx from loading the default config file
  return orxSTATUS_FAILURE

proc initORXforTest*() =
  # Initialize ORX without starting it, see norx.nim
  discard setBootstrap(config_bootstrap)
  orxDEBUG_INIT_MACRO()
  register(orxMODULE_ID_MAIN, "MAIN", orx_MainSetup, orx_init, orx_exit)
  require moduleInit(orxMODULE_ID_MAIN) == orxSTATUS_SUCCESS

suite "Suite ORX Object":

  initORXforTest()

  test "ptr orxSTRUCTURE invalid":
    let a = "aString"
    let invalidObjectPointer: ptr orxSTRUCTURE = cast[ptr orxSTRUCTURE](unsafeAddr(a))
    check getPointer(invalidObjectPointer, orxSTRUCTURE_ID_OBJECT) == nil

  test "Can detect if Object is deleted":

    var objectPtr: ptr orxOBJECT;

    # returns nil if invalid
    var strPtr: ptr orxSTRUCTURE = getPointer(objectPtr, orxSTRUCTURE_ID_OBJECT)
    require strPtr.isNil

    objectPtr = objectCreate()

    require not objectPtr.isNil
    require objectPtr.isEnabled() == orxTRUE
    strPtr = getPointer(objectPtr, orxSTRUCTURE_ID_OBJECT)
    require not strPtr.isNil

    let status = objectPtr.delete()

    require status == orxSTATUS_SUCCESS
    strPtr = getPointer(objectPtr, orxSTRUCTURE_ID_OBJECT)
    require strPtr.isNil

