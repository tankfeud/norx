import norx/typ

##  *** Core plugin id enum ***

type
  orxPLUGIN_CORE_ID* {.size: sizeof(cint).} = enum
    orxPLUGIN_CORE_ID_DISPLAY = 0, orxPLUGIN_CORE_ID_JOYSTICK,
    orxPLUGIN_CORE_ID_KEYBOARD, orxPLUGIN_CORE_ID_MOUSE,
    orxPLUGIN_CORE_ID_PHYSICS, orxPLUGIN_CORE_ID_RENDER,
    orxPLUGIN_CORE_ID_SOUNDSYSTEM, orxPLUGIN_CORE_ID_NUMBER,
    orxPLUGIN_CORE_ID_NONE = orxENUM_NONE

