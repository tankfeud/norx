import norx/typ

type
  orxPLUGIN_FUNCTION_BASE_ID_MOUSE* {.size: sizeof(cint).} = enum
    orxPLUGIN_FUNCTION_BASE_ID_MOUSE_INIT = 0,
    orxPLUGIN_FUNCTION_BASE_ID_MOUSE_EXIT,
    orxPLUGIN_FUNCTION_BASE_ID_MOUSE_SET_POSITION,
    orxPLUGIN_FUNCTION_BASE_ID_MOUSE_GET_POSITION,
    orxPLUGIN_FUNCTION_BASE_ID_MOUSE_IS_BUTTON_PRESSED,
    orxPLUGIN_FUNCTION_BASE_ID_MOUSE_GET_MOVE_DELTA,
    orxPLUGIN_FUNCTION_BASE_ID_MOUSE_GET_WHEEL_DELTA,
    orxPLUGIN_FUNCTION_BASE_ID_MOUSE_SHOW_CURSOR,
    orxPLUGIN_FUNCTION_BASE_ID_MOUSE_GRAB,
    orxPLUGIN_FUNCTION_BASE_ID_MOUSE_NUMBER,
    orxPLUGIN_FUNCTION_BASE_ID_MOUSE_NONE = orxENUM_NONE
