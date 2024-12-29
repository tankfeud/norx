import
  incl, display, viewport, vector

## * Misc defines
##

const
  orxRENDER_KZ_CONFIG_SECTION* = "Render"
  orxRENDER_KZ_CONFIG_SHOW_FPS* = "ShowFPS"
  orxRENDER_KZ_CONFIG_SHOW_PROFILER* = "ShowProfiler"
  orxRENDER_KZ_CONFIG_MIN_FREQUENCY* = "MinFrequency"
  orxRENDER_KZ_CONFIG_PROFILER_ORIENTATION* = "ProfilerOrientation"
  orxRENDER_KZ_CONFIG_CONSOLE_COLOR* = "ConsoleColor"
  orxRENDER_KZ_CONFIG_CONSOLE_ALPHA* = "ConsoleAlpha"
  orxRENDER_KZ_CONFIG_CONSOLE_BACKGROUND_COLOR* = "ConsoleBackgroundColor"
  orxRENDER_KZ_CONFIG_CONSOLE_BACKGROUND_ALPHA* = "ConsoleBackgroundAlpha"
  orxRENDER_KZ_CONFIG_CONSOLE_SEPARATOR_COLOR* = "ConsoleSeparatorColor"
  orxRENDER_KZ_CONFIG_CONSOLE_SEPARATOR_ALPHA* = "ConsoleSeparatorAlpha"
  orxRENDER_KZ_CONFIG_CONSOLE_INPUT_COLOR* = "ConsoleInputColor"
  orxRENDER_KZ_CONFIG_CONSOLE_INPUT_ALPHA* = "ConsoleInputAlpha"
  orxRENDER_KZ_CONFIG_CONSOLE_COMPLETION_COLOR* = "ConsoleCompletionColor"
  orxRENDER_KZ_CONFIG_CONSOLE_COMPLETION_ALPHA* = "ConsoleCompletionAlpha"
  orxRENDER_KZ_CONFIG_CONSOLE_LOG_COLOR* = "ConsoleLogColor"
  orxRENDER_KZ_CONFIG_CONSOLE_LOG_ALPHA* = "ConsoleLogAlpha"

## * Inputs
##

const
  orxRENDER_KZ_INPUT_SET* = "-=RenderSet=-"
  orxRENDER_KZ_INPUT_PROFILER_TOGGLE_HISTORY* = "ProfilerToggleHistory"
  orxRENDER_KZ_INPUT_PROFILER_PAUSE* = "ProfilerPause"
  orxRENDER_KZ_INPUT_PROFILER_PREVIOUS_FRAME* = "ProfilerPreviousFrame"
  orxRENDER_KZ_INPUT_PROFILER_NEXT_FRAME* = "ProfilerNextFrame"
  orxRENDER_KZ_INPUT_PROFILER_PREVIOUS_DEPTH* = "ProfilerPreviousDepth"
  orxRENDER_KZ_INPUT_PROFILER_NEXT_DEPTH* = "ProfilerNextDepth"
  orxRENDER_KZ_INPUT_PROFILER_PREVIOUS_THREAD* = "ProfilerPreviousThread"
  orxRENDER_KZ_INPUT_PROFILER_NEXT_THREAD* = "ProfilerNextThread"

## * Event enum
##

type
  orxRENDER_EVENT* {.size: sizeof(cint).} = enum
    orxRENDER_EVENT_START = 0,  ## Event sent when rendering starts
    orxRENDER_EVENT_STOP,     ## Event sent when rendering stops
    orxRENDER_EVENT_VIEWPORT_START, ## Event sent when a viewport rendering starts
    orxRENDER_EVENT_VIEWPORT_STOP, ## Event sent when a viewport rendering stops
    orxRENDER_EVENT_OBJECT_START, ## Event sent when an object rendering starts
    orxRENDER_EVENT_OBJECT_STOP, ## Event sent when an object rendering stops
    orxRENDER_EVENT_CONSOLE_START, ## Event sent when console rendering starts
    orxRENDER_EVENT_CONSOLE_STOP, ## Event sent when console rendering stops
    orxRENDER_EVENT_PROFILER_START, ## Event sent when profiler rendering starts
    orxRENDER_EVENT_PROFILER_STOP, ## Event sent when profiler rendering stops
    orxRENDER_EVENT_NUMBER, orxRENDER_EVENT_NONE = orxENUM_NONE


## * Event payload
##

type
  INNER_C_STRUCT_orxRender_124* {.bycopy.} = object
    pstTransform*: ptr orxDISPLAY_TRANSFORM ## Object display transform : 4 / 8

  orxRENDER_EVENT_PAYLOAD* {.bycopy.} = object
    stObject*: INNER_C_STRUCT_orxRender_124


## **************************************************************************
##  Functions directly implemented by orx core
## *************************************************************************

proc renderSetup*() {.cdecl, importc: "orxRender_Setup", dynlib: libORX.}
  ## Render module setup

## **************************************************************************
##  Functions extended by plugins
## *************************************************************************

proc renderInit*(): orxSTATUS {.cdecl, importc: "orxRender_Init",
                                 dynlib: libORX.}
  ## Inits the render module
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc renderExit*() {.cdecl, importc: "orxRender_Exit", dynlib: libORX.}
  ## Exits from the render module

proc getWorldPosition*(pvScreenPosition: ptr orxVECTOR;
                                pstViewport: ptr orxVIEWPORT;
                                pvWorldPosition: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxRender_GetWorldPosition", dynlib: libORX.}
  ## Get a world position given a screen one (absolute picking)
  ##  @param[in]   _pvScreenPosition                     Concerned screen position
  ##  @param[in]   _pstViewport                          Concerned viewport, if nil then either the last viewport that contains the position (if any), or the last viewport with a camera in the list if none contains the position
  ##  @param[out]  _pvWorldPosition                      Corresponding world position
  ##  @return      orxVECTOR if found *inside* the display surface, nil otherwise

proc getScreenPosition*(pvWorldPosition: ptr orxVECTOR;
                                 pstViewport: ptr orxVIEWPORT;
                                 pvScreenPosition: ptr orxVECTOR): ptr orxVECTOR {.
    cdecl, importc: "orxRender_GetScreenPosition", dynlib: libORX.}
  ## Get a screen position given a world one and a viewport (rendering position)
  ##  @param[in]   _pvWorldPosition                      Concerned world position
  ##  @param[in]   _pstViewport                          Concerned viewport, if nil then the last viewport with a camera will be used
  ##  @param[out]  _pvScreenPosition                     Corresponding screen position
  ##  @return      orxVECTOR if found (can be off-screen), nil otherwise

