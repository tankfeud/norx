import std/unittest
import norx/[incl, input, joystick]

suite "Test orx enums":

  test "test received ENUM_NONE value equals orxJOYSTICK_BUTTON_NONE":
    var eID_NONE: orxENUM = cast[orxU32](orxENUM_NONE)
    check cast[orxJOYSTICK_BUTTON](eID_NONE) == orxJOYSTICK_BUTTON_NONE
    check eID_NONE.ord == cast[int](cast[orxU32](orxJOYSTICK_BUTTON_NONE.ord))
    check orxINPUT_TYPE_NONE.ord == orxENUM_NONE

  test "can construct enum from ordinal":
    var button = orxJOYSTICK_3_BUTTON_X
    var eID: orxENUM = cast[orxU32](button.ord)
    check orxJOYSTICK_BUTTON(eID) == button
