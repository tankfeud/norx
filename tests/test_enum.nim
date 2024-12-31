import std/unittest
import norx

suite "Test orx enums":

  test "test received ENUM_NONE value equals orxJOYSTICK_BUTTON_NONE":
    var eID_NONE: orxENUM = cast[orxU32](ENUM_NONE)
    check cast[orxJOYSTICK_BUTTON](eID_NONE) == JOYSTICK_BUTTON_NONE
    check eID_NONE.ord == cast[int](cast[orxU32](JOYSTICK_BUTTON_NONE.ord))
    check INPUT_TYPE_NONE.ord == ENUM_NONE

  test "can construct enum from ordinal":
    var button = JOYSTICK_BUTTON_X_3
    var eID: orxENUM = cast[orxU32](button.ord)
    check orxJOYSTICK_BUTTON(eID) == button