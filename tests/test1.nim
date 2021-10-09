# This is just an example to get you started. You may wish to put all of your
# tests into a single file, or separate them into multiple `test1`, `test2`
# etc. files (better names are recommended, just make sure the name starts with
# the letter 't').
#
# To run these tests, simply execute `nimble test`.

import std/unittest

import norx/[incl, structure]

suite "Suite 1":

  orxLog("Hello from test")

  test "can add":
    check 5+5 == 10

  test "ptr orxSTRUCTURE invalid":
    let a = "aString"
    let invalidObjectPointer: ptr orxSTRUCTURE = cast[ptr orxSTRUCTURE](unsafeAddr(a))
    check getPointer(invalidObjectPointer, orxSTRUCTURE_ID_OBJECT) == nil
