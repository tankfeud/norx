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
  discard setBootstrap(bootstrap)
  debugInitMacro()
  moduleRegister(MODULE_ID_MAIN, "MAIN", norxMainSetup, init, exit)
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

  test "Can ceil vector components":
    var input = newVECTOR(1.2, -1.2, 0.0)
    var output: orxVECTOR

    require ceilv(addr(output), addr(input)) == addr(output)
    check output == newVECTOR(2.0, -1.0, 0.0)

  test "Can use object vector value overloads":
    static:
      doAssert compiles(block:
        var gameObject: ptr orxOBJECT
        let value = newVector(1, 2, 3)
        discard gameObject.setPivot(value)
        discard gameObject.getPivot()
        discard gameObject.setOrigin(value)
        discard gameObject.getOrigin()
        discard gameObject.setSize(value)
        discard gameObject.getSize()
        discard gameObject.setPosition(value)
        discard gameObject.getPosition()
        discard gameObject.setWorldPosition(value)
        discard gameObject.getWorldPosition()
        discard gameObject.setScale(value)
        discard gameObject.getScale()
        discard gameObject.setWorldScale(value)
        discard gameObject.getWorldScale()
        discard gameObject.setSpeed(value)
        discard gameObject.getSpeed())
