##  Orx - Portable Game Engine
##
##  Copyright (c) 2008-2020 Orx-Project
##
##  This software is provided 'as-is', without any express or implied
##  warranty. In no event will the authors be held liable for any damages
##  arising from the use of this software.
##
##  Permission is granted to anyone to use this software for any purpose,
##  including commercial applications, and to alter it and redistribute it
##  freely, subject to the following restrictions:
##
##     1. The origin of this software must not be misrepresented; you must not
##     claim that you wrote the original software. If you use this software
##     in a product, an acknowledgment in the product documentation would be
##     appreciated but is not required.
##
##     2. Altered source versions must be plainly marked as such, and must not be
##     misrepresented as being the original software.
##
##     3. This notice may not be removed or altered from any source
##     distribution.

import incl

## * Key enum
##

type
  orxKEYBOARD_KEY* {.size: sizeof(cint).} = enum
    orxKEYBOARD_KEY_0 = 0, orxKEYBOARD_KEY_1, orxKEYBOARD_KEY_2, orxKEYBOARD_KEY_3,
    orxKEYBOARD_KEY_4, orxKEYBOARD_KEY_5, orxKEYBOARD_KEY_6, orxKEYBOARD_KEY_7,
    orxKEYBOARD_KEY_8, orxKEYBOARD_KEY_9, orxKEYBOARD_KEY_A, orxKEYBOARD_KEY_B,
    orxKEYBOARD_KEY_C, orxKEYBOARD_KEY_D, orxKEYBOARD_KEY_E, orxKEYBOARD_KEY_F,
    orxKEYBOARD_KEY_G, orxKEYBOARD_KEY_H, orxKEYBOARD_KEY_I, orxKEYBOARD_KEY_J,
    orxKEYBOARD_KEY_K, orxKEYBOARD_KEY_L, orxKEYBOARD_KEY_M, orxKEYBOARD_KEY_N,
    orxKEYBOARD_KEY_O, orxKEYBOARD_KEY_P, orxKEYBOARD_KEY_Q, orxKEYBOARD_KEY_R,
    orxKEYBOARD_KEY_S, orxKEYBOARD_KEY_T, orxKEYBOARD_KEY_U, orxKEYBOARD_KEY_V,
    orxKEYBOARD_KEY_W, orxKEYBOARD_KEY_X, orxKEYBOARD_KEY_Y, orxKEYBOARD_KEY_Z,
    orxKEYBOARD_KEY_SPACE, orxKEYBOARD_KEY_QUOTE, orxKEYBOARD_KEY_COMMA,
    orxKEYBOARD_KEY_DASH, orxKEYBOARD_KEY_PERIOD, orxKEYBOARD_KEY_SLASH,
    orxKEYBOARD_KEY_SEMICOLON, orxKEYBOARD_KEY_EQUAL, orxKEYBOARD_KEY_LBRACKET,
    orxKEYBOARD_KEY_BACKSLASH, orxKEYBOARD_KEY_RBRACKET,
    orxKEYBOARD_KEY_BACKQUOTE, orxKEYBOARD_KEY_WORLD_1, orxKEYBOARD_KEY_WORLD_2,
    orxKEYBOARD_KEY_ESCAPE, orxKEYBOARD_KEY_ENTER, orxKEYBOARD_KEY_TAB,
    orxKEYBOARD_KEY_BACKSPACE, orxKEYBOARD_KEY_INSERT, orxKEYBOARD_KEY_DELETE,
    orxKEYBOARD_KEY_RIGHT, orxKEYBOARD_KEY_LEFT, orxKEYBOARD_KEY_DOWN,
    orxKEYBOARD_KEY_UP, orxKEYBOARD_KEY_PAGE_UP, orxKEYBOARD_KEY_PAGE_DOWN,
    orxKEYBOARD_KEY_HOME, orxKEYBOARD_KEY_END, orxKEYBOARD_KEY_CAPS_LOCK,
    orxKEYBOARD_KEY_SCROLL_LOCK, orxKEYBOARD_KEY_NUM_LOCK,
    orxKEYBOARD_KEY_PRINT_SCREEN, orxKEYBOARD_KEY_PAUSE, orxKEYBOARD_KEY_F1,
    orxKEYBOARD_KEY_F2, orxKEYBOARD_KEY_F3, orxKEYBOARD_KEY_F4, orxKEYBOARD_KEY_F5,
    orxKEYBOARD_KEY_F6, orxKEYBOARD_KEY_F7, orxKEYBOARD_KEY_F8, orxKEYBOARD_KEY_F9,
    orxKEYBOARD_KEY_F10, orxKEYBOARD_KEY_F11, orxKEYBOARD_KEY_F12,
    orxKEYBOARD_KEY_F13, orxKEYBOARD_KEY_F14, orxKEYBOARD_KEY_F15,
    orxKEYBOARD_KEY_F16, orxKEYBOARD_KEY_F17, orxKEYBOARD_KEY_F18,
    orxKEYBOARD_KEY_F19, orxKEYBOARD_KEY_F20, orxKEYBOARD_KEY_F21,
    orxKEYBOARD_KEY_F22, orxKEYBOARD_KEY_F23, orxKEYBOARD_KEY_F24,
    orxKEYBOARD_KEY_F25, orxKEYBOARD_KEY_NUMPAD_0, orxKEYBOARD_KEY_NUMPAD_1,
    orxKEYBOARD_KEY_NUMPAD_2, orxKEYBOARD_KEY_NUMPAD_3, orxKEYBOARD_KEY_NUMPAD_4,
    orxKEYBOARD_KEY_NUMPAD_5, orxKEYBOARD_KEY_NUMPAD_6, orxKEYBOARD_KEY_NUMPAD_7,
    orxKEYBOARD_KEY_NUMPAD_8, orxKEYBOARD_KEY_NUMPAD_9,
    orxKEYBOARD_KEY_NUMPAD_DECIMAL, orxKEYBOARD_KEY_NUMPAD_DIVIDE,
    orxKEYBOARD_KEY_NUMPAD_MULTIPLY, orxKEYBOARD_KEY_NUMPAD_SUBTRACT,
    orxKEYBOARD_KEY_NUMPAD_ADD, orxKEYBOARD_KEY_NUMPAD_ENTER,
    orxKEYBOARD_KEY_NUMPAD_EQUAL, orxKEYBOARD_KEY_LSHIFT, orxKEYBOARD_KEY_LCTRL,
    orxKEYBOARD_KEY_LALT, orxKEYBOARD_KEY_LSYSTEM, orxKEYBOARD_KEY_RSHIFT,
    orxKEYBOARD_KEY_RCTRL, orxKEYBOARD_KEY_RALT, orxKEYBOARD_KEY_RSYSTEM,
    orxKEYBOARD_KEY_MENU, orxKEYBOARD_KEY_NUMBER,
    orxKEYBOARD_KEY_NONE = orxENUM_NONE


## **************************************************************************
##  Functions directly implemented by orx core
## *************************************************************************
## * Keyboard module setup
##

proc orxKeyboard_Setup*() {.cdecl, importc: "orxKeyboard_Setup", dynlib: libORX.}
## **************************************************************************
##  Functions extended by plugins
## *************************************************************************
## * Inits the keyboard module
##

proc orxKeyboard_Init*(): orxSTATUS {.cdecl, importc: "orxKeyboard_Init",
                                   dynlib: libORX.}
## * Exits from the keyboard module
##

proc orxKeyboard_Exit*() {.cdecl, importc: "orxKeyboard_Exit", dynlib: libORX.}
## * Is key pressed?
##  @param[in] _eKey       Key to check
##  @return orxTRUE if pressed / orxFALSE otherwise
##

proc orxKeyboard_IsKeyPressed*(eKey: orxKEYBOARD_KEY): orxBOOL {.cdecl,
    importc: "orxKeyboard_IsKeyPressed", dynlib: libORX.}
## * Gets key display name, layout-dependent
##  @param[in] _eKey       Concerned key
##  @return UTF-8 encoded key's name if valid, orxSTRING_EMPTY otherwise
##

proc orxKeyboard_GetKeyDisplayName*(eKey: orxKEYBOARD_KEY): cstring {.cdecl,
    importc: "orxKeyboard_GetKeyDisplayName", dynlib: libORX.}
## * Gets the next key from the keyboard buffer and removes it from there
##  @return orxKEYBOARD_KEY, orxKEYBOARD_KEY_NONE if the buffer is empty
##

proc orxKeyboard_ReadKey*(): orxKEYBOARD_KEY {.cdecl,
    importc: "orxKeyboard_ReadKey", dynlib: libORX.}
## * Gets the next UTF-8 encoded string from the keyboard buffer and removes it from there
##  @return UTF-8 encoded string
##

proc orxKeyboard_ReadString*(): cstring {.cdecl,
    importc: "orxKeyboard_ReadString", dynlib: libORX.}
## * Empties the keyboard buffer (both keys and chars)
##

proc orxKeyboard_ClearBuffer*() {.cdecl, importc: "orxKeyboard_ClearBuffer",
                                dynlib: libORX.}
## * Gets key literal name
##  @param[in] _eKey       Concerned key
##  @return Key's name
##

proc orxKeyboard_GetKeyName*(eKey: orxKEYBOARD_KEY): cstring {.cdecl,
    importc: "orxKeyboard_GetKeyName", dynlib: libORX.}
## * Show/Hide the virtual keyboard
##  @param[in]   _bShow          Show/hide virtual keyboard
##  @return orxSTATUS_SUCCESS if supported by platform, orxSTATUS_FAILURE otherwise
##

proc orxKeyboard_Show*(bShow: orxBOOL): orxSTATUS {.cdecl,
    importc: "orxKeyboard_Show", dynlib: libORX.}
