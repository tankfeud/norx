import incl, vector, obj

## * Slot flags
##

const
  orxFX_SLOT_KU32_FLAG_ABSOLUTE* = 0x00000100
  orxFX_SLOT_KU32_FLAG_USE_ROTATION* = 0x00000200
  orxFX_SLOT_KU32_FLAG_USE_SCALE* = 0x00000400

## * FX curve enum
##

type
  orxFX_CURVE* {.size: sizeof(cint).} = enum
    orxFX_CURVE_LINEAR = 0, orxFX_CURVE_SMOOTH, orxFX_CURVE_SMOOTHER,
    orxFX_CURVE_TRIANGLE, orxFX_CURVE_SINE, orxFX_CURVE_SQUARE, orxFX_CURVE_NUMBER,
    orxFX_CURVE_NONE = orxENUM_NONE


## * Internal FX structure
##

type orxFX* = object
## * Event enum
##

type
  orxFX_EVENT* {.size: sizeof(cint).} = enum
    orxFX_EVENT_START = 0,      ## *< Event sent when a FX starts
    orxFX_EVENT_STOP,         ## *< Event sent when a FX stops
    orxFX_EVENT_ADD,          ## *< Event sent when a FX is added
    orxFX_EVENT_REMOVE,       ## *< Event sent when a FX is removed
    orxFX_EVENT_LOOP,         ## *< Event sent when a FX is looping
    orxFX_EVENT_NUMBER, orxFX_EVENT_NONE = orxENUM_NONE


## * FX event payload
##

type
  orxFX_EVENT_PAYLOAD* {.bycopy.} = object
    pstFX*: ptr orxFX           ## *< FX reference : 4
    zFXName*: cstring       ## *< FX name : 8


proc FXSetup*() {.cdecl, importc: "orxFX_Setup", dynlib: libORX.}
  ## FX module setup

proc FXInit*(): orxSTATUS {.cdecl, importc: "orxFX_Init", dynlib: libORX.}
  ## Inits the FX module
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc FXExit*() {.cdecl, importc: "orxFX_Exit", dynlib: libORX.}
  ## Exits from the FX module

proc FXCreate*(): ptr orxFX {.cdecl, importc: "orxFX_Create", dynlib: libORX.}
  ## Creates an empty FX
  ##  @return orxFX / nil

proc FXCreateFromConfig*(zConfigID: cstring): ptr orxFX {.cdecl,
    importc: "orxFX_CreateFromConfig", dynlib: libORX.}
  ## Creates an FX from config
  ##  @param[in]   _zConfigID    Config ID
  ##  @ return orxFX / nil

proc delete*(pstFX: ptr orxFX): orxSTATUS {.cdecl, importc: "orxFX_Delete",
    dynlib: libORX.}
  ## Deletes an FX
  ##  @param[in] _pstFX            Concerned FX
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc clearCache*(): orxSTATUS {.cdecl, importc: "orxFX_ClearCache",
                                   dynlib: libORX.}
  ## Clears cache (if any FX is still in active use, it'll remain in memory until not referenced anymore)
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc apply*(pstFX: ptr orxFX; pstObject: ptr orxOBJECT; fStartTime: orxFLOAT;
                 fEndTime: orxFLOAT): orxSTATUS {.cdecl, importc: "orxFX_Apply",
    dynlib: libORX.}
  ## Applies FX on object
  ##  @param[in] _pstFX            FX to apply
  ##  @param[in] _pstObject        Object on which to apply the FX
  ##  @param[in] _fStartTime       FX local application start time
  ##  @param[in] _fEndTime         FX local application end time
  ##  @return    orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc enable*(pstFX: ptr orxFX; bEnable: orxBOOL) {.cdecl,
    importc: "orxFX_Enable", dynlib: libORX.}
  ## Enables/disables an FX
  ##  @param[in]   _pstFX          Concerned FX
  ##  @param[in]   _bEnable        Enable / disable

proc isEnabled*(pstFX: ptr orxFX): orxBOOL {.cdecl, importc: "orxFX_IsEnabled",
    dynlib: libORX.}
  ## Is FX enabled?
  ##  @param[in]   _pstFX          Concerned FX
  ##  @return      orxTRUE if enabled, orxFALSE otherwise

proc addAlpha*(pstFX: ptr orxFX; fStartTime: orxFLOAT; fEndTime: orxFLOAT;
                    fCyclePeriod: orxFLOAT; fCyclePhase: orxFLOAT;
                    fAmplification: orxFLOAT; fAcceleration: orxFLOAT;
                    fStartAlpha: orxFLOAT; fEndAlpha: orxFLOAT; eCurve: orxFX_CURVE;
                    fPow: orxFLOAT; u32Flags: orxU32): orxSTATUS {.cdecl,
    importc: "orxFX_AddAlpha", dynlib: libORX.}
  ## Adds alpha to an FX
  ##  @param[in]   _pstFX          Concerned FX
  ##  @param[in]   _fStartTime     Time start
  ##  @param[in]   _fEndTime       Time end
  ##  @param[in]   _fCyclePeriod   Cycle period
  ##  @param[in]   _fCyclePhase    Cycle phase (at start)
  ##  @param[in]   _fAmplification Curve linear amplification over time (1.0 for none)
  ##  @param[in]   _fAcceleration  Curve linear acceleration over time (1.0 for none)
  ##  @param[in]   _fStartAlpha    Starting alpha value
  ##  @param[in]   _fEndAlpha      Ending alpha value
  ##  @param[in]   _eCurve         Blending curve type
  ##  @param[in]   _fPow           Blending curve exponent
  ##  @param[in]   _u32Flags       Param flags
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc addRGB*(pstFX: ptr orxFX; fStartTime: orxFLOAT; fEndTime: orxFLOAT;
                  fCyclePeriod: orxFLOAT; fCyclePhase: orxFLOAT;
                  fAmplification: orxFLOAT; fAcceleration: orxFLOAT;
                  pvStartColor: ptr orxVECTOR; pvEndColor: ptr orxVECTOR;
                  eCurve: orxFX_CURVE; fPow: orxFLOAT; u32Flags: orxU32): orxSTATUS {.
    cdecl, importc: "orxFX_AddRGB", dynlib: libORX.}
  ## Adds RGB color to an FX
  ##  @param[in]   _pstFX          Concerned FX
  ##  @param[in]   _fStartTime     Time start
  ##  @param[in]   _fEndTime       Time end
  ##  @param[in]   _fCyclePeriod   Cycle period
  ##  @param[in]   _fCyclePhase    Cycle phase (at start)
  ##  @param[in]   _fAmplification Curve linear amplification over time (1.0 for none)
  ##  @param[in]   _fAcceleration  Curve linear acceleration over time (1.0 for none)
  ##  @param[in]   _pvStartColor   Starting color value
  ##  @param[in]   _pvEndColor     Ending color value
  ##  @param[in]   _eCurve         Blending curve type
  ##  @param[in]   _fPow           Blending curve exponent
  ##  @param[in]   _u32Flags       Param flags
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc addHSL*(pstFX: ptr orxFX; fStartTime: orxFLOAT; fEndTime: orxFLOAT;
                  fCyclePeriod: orxFLOAT; fCyclePhase: orxFLOAT;
                  fAmplification: orxFLOAT; fAcceleration: orxFLOAT;
                  pvStartColor: ptr orxVECTOR; pvEndColor: ptr orxVECTOR;
                  eCurve: orxFX_CURVE; fPow: orxFLOAT; u32Flags: orxU32): orxSTATUS {.
    cdecl, importc: "orxFX_AddHSL", dynlib: libORX.}
  ## Adds HSL color to an FX
  ##  @param[in]   _pstFX          Concerned FX
  ##  @param[in]   _fStartTime     Time start
  ##  @param[in]   _fEndTime       Time end
  ##  @param[in]   _fCyclePeriod   Cycle period
  ##  @param[in]   _fCyclePhase    Cycle phase (at start)
  ##  @param[in]   _fAmplification Curve linear amplification over time (1.0 for none)
  ##  @param[in]   _fAcceleration  Curve linear acceleration over time (1.0 for none)
  ##  @param[in]   _pvStartColor   Starting color value
  ##  @param[in]   _pvEndColor     Ending color value
  ##  @param[in]   _eCurve         Blending curve type
  ##  @param[in]   _fPow           Blending curve exponent
  ##  @param[in]   _u32Flags       Param flags
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc addHSV*(pstFX: ptr orxFX; fStartTime: orxFLOAT; fEndTime: orxFLOAT;
                  fCyclePeriod: orxFLOAT; fCyclePhase: orxFLOAT;
                  fAmplification: orxFLOAT; fAcceleration: orxFLOAT;
                  pvStartColor: ptr orxVECTOR; pvEndColor: ptr orxVECTOR;
                  eCurve: orxFX_CURVE; fPow: orxFLOAT; u32Flags: orxU32): orxSTATUS {.
    cdecl, importc: "orxFX_AddHSV", dynlib: libORX.}
  ## Adds HSV color to an FX
  ##  @param[in]   _pstFX          Concerned FX
  ##  @param[in]   _fStartTime     Time start
  ##  @param[in]   _fEndTime       Time end
  ##  @param[in]   _fCyclePeriod   Cycle period
  ##  @param[in]   _fCyclePhase    Cycle phase (at start)
  ##  @param[in]   _fAmplification Curve linear amplification over time (1.0 for none)
  ##  @param[in]   _fAcceleration  Curve linear acceleration over time (1.0 for none)
  ##  @param[in]   _pvStartColor   Starting color value
  ##  @param[in]   _pvEndColor     Ending color value
  ##  @param[in]   _eCurve         Blending curve type
  ##  @param[in]   _fPow           Blending curve exponent
  ##  @param[in]   _u32Flags       Param flags
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc addRotation*(pstFX: ptr orxFX; fStartTime: orxFLOAT; fEndTime: orxFLOAT;
                       fCyclePeriod: orxFLOAT; fCyclePhase: orxFLOAT;
                       fAmplification: orxFLOAT; fAcceleration: orxFLOAT;
                       fStartRotation: orxFLOAT; fEndRotation: orxFLOAT;
                       eCurve: orxFX_CURVE; fPow: orxFLOAT; u32Flags: orxU32): orxSTATUS {.
    cdecl, importc: "orxFX_AddRotation", dynlib: libORX.}
  ## Adds rotation to an FX
  ##  @param[in]   _pstFX          Concerned FX
  ##  @param[in]   _fStartTime     Time start
  ##  @param[in]   _fEndTime       Time end
  ##  @param[in]   _fCyclePeriod   Cycle period
  ##  @param[in]   _fCyclePhase    Cycle phase (at start)
  ##  @param[in]   _fAmplification Curve linear amplification over time (1.0 for none)
  ##  @param[in]   _fAcceleration  Curve linear acceleration over time (1.0 for none)
  ##  @param[in]   _fStartRotation Starting rotation value (radians)
  ##  @param[in]   _fEndRotation   Ending rotation value (radians)
  ##  @param[in]   _eCurve         Blending curve type
  ##  @param[in]   _fPow           Blending curve exponent
  ##  @param[in]   _u32Flags       Param flags
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc addScale*(pstFX: ptr orxFX; fStartTime: orxFLOAT; fEndTime: orxFLOAT;
                    fCyclePeriod: orxFLOAT; fCyclePhase: orxFLOAT;
                    fAmplification: orxFLOAT; fAcceleration: orxFLOAT;
                    pvStartScale: ptr orxVECTOR; pvEndScale: ptr orxVECTOR;
                    eCurve: orxFX_CURVE; fPow: orxFLOAT; u32Flags: orxU32): orxSTATUS {.
    cdecl, importc: "orxFX_AddScale", dynlib: libORX.}
  ## Adds scale to an FX
  ##  @param[in]   _pstFX          Concerned FX
  ##  @param[in]   _fStartTime     Time start
  ##  @param[in]   _fEndTime       Time end
  ##  @param[in]   _fCyclePeriod   Cycle period
  ##  @param[in]   _fCyclePhase    Cycle phase (at start)
  ##  @param[in]   _fAmplification Curve linear amplification over time (1.0 for none)
  ##  @param[in]   _fAcceleration  Curve linear acceleration over time (1.0 for none)
  ##  @param[in]   _pvStartScale   Starting scale value
  ##  @param[in]   _pvEndScale     Ending scale value
  ##  @param[in]   _eCurve         Blending curve type
  ##  @param[in]   _fPow           Blending curve exponent
  ##  @param[in]   _u32Flags       Param flags
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc addPosition*(pstFX: ptr orxFX; fStartTime: orxFLOAT; fEndTime: orxFLOAT;
                       fCyclePeriod: orxFLOAT; fCyclePhase: orxFLOAT;
                       fAmplification: orxFLOAT; fAcceleration: orxFLOAT;
                       pvStartTranslation: ptr orxVECTOR;
                       pvEndTranslation: ptr orxVECTOR; eCurve: orxFX_CURVE;
                       fPow: orxFLOAT; u32Flags: orxU32): orxSTATUS {.cdecl,
    importc: "orxFX_AddPosition", dynlib: libORX.}
  ## Adds position to an FX
  ##  @param[in]   _pstFX          Concerned FX
  ##  @param[in]   _fStartTime     Time start
  ##  @param[in]   _fEndTime       Time end
  ##  @param[in]   _fCyclePeriod   Cycle period
  ##  @param[in]   _fCyclePhase    Cycle phase (at start)
  ##  @param[in]   _fAmplification Curve linear amplification over time (1.0 for none)
  ##  @param[in]   _fAcceleration  Curve linear acceleration over time (1.0 for none)
  ##  @param[in]   _pvStartTranslation Starting position value
  ##  @param[in]   _pvEndTranslation Ending position value
  ##  @param[in]   _eCurve         Blending curve type
  ##  @param[in]   _fPow           Blending curve exponent
  ##  @param[in]   _u32Flags       Param flags
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc addSpeed*(pstFX: ptr orxFX; fStartTime: orxFLOAT; fEndTime: orxFLOAT;
                    fCyclePeriod: orxFLOAT; fCyclePhase: orxFLOAT;
                    fAmplification: orxFLOAT; fAcceleration: orxFLOAT;
                    pvStartSpeed: ptr orxVECTOR; pvEndSpeed: ptr orxVECTOR;
                    eCurve: orxFX_CURVE; fPow: orxFLOAT; u32Flags: orxU32): orxSTATUS {.
    cdecl, importc: "orxFX_AddSpeed", dynlib: libORX.}
  ## Adds speed to an FX
  ##  @param[in]   _pstFX          Concerned FX
  ##  @param[in]   _fStartTime     Time start
  ##  @param[in]   _fEndTime       Time end
  ##  @param[in]   _fCyclePeriod   Cycle period
  ##  @param[in]   _fCyclePhase    Cycle phase (at start)
  ##  @param[in]   _fAmplification Curve linear amplification over time (1.0 for none)
  ##  @param[in]   _fAcceleration  Curve linear acceleration over time (1.0 for none)
  ##  @param[in]   _pvStartSpeed   Starting speed value
  ##  @param[in]   _pvEndSpeed     Ending speed value
  ##  @param[in]   _eCurve         Blending curve type
  ##  @param[in]   _fPow           Blending curve exponent
  ##  @param[in]   _u32Flags       Param flags
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc addVolume*(pstFX: ptr orxFX; fStartTime: orxFLOAT; fEndTime: orxFLOAT;
                     fCyclePeriod: orxFLOAT; fCyclePhase: orxFLOAT;
                     fAmplification: orxFLOAT; fAcceleration: orxFLOAT;
                     fStartVolume: orxFLOAT; fEndVolume: orxFLOAT;
                     eCurve: orxFX_CURVE; fPow: orxFLOAT; u32Flags: orxU32): orxSTATUS {.
    cdecl, importc: "orxFX_AddVolume", dynlib: libORX.}
  ## Adds volume to an FX
  ##  @param[in]   _pstFX          Concerned FX
  ##  @param[in]   _fStartTime     Time start
  ##  @param[in]   _fEndTime       Time end
  ##  @param[in]   _fCyclePeriod   Cycle period
  ##  @param[in]   _fCyclePhase    Cycle phase (at start)
  ##  @param[in]   _fAmplification Curve linear amplification over time (1.0 for none)
  ##  @param[in]   _fAcceleration  Curve linear acceleration over time (1.0 for none)
  ##  @param[in]   _fStartVolume   Starting volume value
  ##  @param[in]   _fEndVolume     Ending volume value
  ##  @param[in]   _eCurve         Blending curve type
  ##  @param[in]   _fPow           Blending curve exponent
  ##  @param[in]   _u32Flags       Param flags
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc addPitch*(pstFX: ptr orxFX; fStartTime: orxFLOAT; fEndTime: orxFLOAT;
                    fCyclePeriod: orxFLOAT; fCyclePhase: orxFLOAT;
                    fAmplification: orxFLOAT; fAcceleration: orxFLOAT;
                    fStartPitch: orxFLOAT; fEndPitch: orxFLOAT; eCurve: orxFX_CURVE;
                    fPow: orxFLOAT; u32Flags: orxU32): orxSTATUS {.cdecl,
    importc: "orxFX_AddPitch", dynlib: libORX.}
  ## Adds pitch to an FX
  ##  @param[in]   _pstFX          Concerned FX
  ##  @param[in]   _fStartTime     Time start
  ##  @param[in]   _fEndTime       Time end
  ##  @param[in]   _fCyclePeriod   Cycle period
  ##  @param[in]   _fCyclePhase    Cycle phase (at start)
  ##  @param[in]   _fAmplification Curve linear amplification over time (1.0 for none)
  ##  @param[in]   _fAcceleration  Curve linear acceleration over time (1.0 for none)
  ##  @param[in]   _fStartPitch    Starting pitch value
  ##  @param[in]   _fEndPitch      Ending pitch value
  ##  @param[in]   _eCurve         Blending curve type
  ##  @param[in]   _fPow           Blending curve exponent
  ##  @param[in]   _u32Flags       Param flags
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc addSlotFromConfig*(pstFX: ptr orxFX; zSlotID: cstring): orxSTATUS {.
    cdecl, importc: "orxFX_AddSlotFromConfig", dynlib: libORX.}
  ## Adds a slot to an FX from config
  ##  @param[in]   _pstFX          Concerned FX
  ##  @param[in]   _zSlotID        Config ID
  ##  return       orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getDuration*(pstFX: ptr orxFX): orxFLOAT {.cdecl,
    importc: "orxFX_GetDuration", dynlib: libORX.}
  ## Gets FX duration
  ##  @param[in]   _pstFX          Concerned FX
  ##  @return      orxFLOAT

proc getName*(pstFX: ptr orxFX): cstring {.cdecl, importc: "orxFX_GetName",
    dynlib: libORX.}
  ## Gets FX name
  ##  @param[in]   _pstFX          Concerned FX
  ##  @return      orxSTRING / orxSTRING_EMPTY

proc loop*(pstFX: ptr orxFX; bLoop: orxBOOL): orxSTATUS {.cdecl,
    importc: "orxFX_Loop", dynlib: libORX.}
  ## Set FX loop property
  ##  @param[in]   _pstFX          Concerned FX
  ##  @param[in]   _bLoop          Loop / don't loop
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc isLooping*(pstFX: ptr orxFX): orxBOOL {.cdecl, importc: "orxFX_IsLooping",
    dynlib: libORX.}
  ## Is FX looping
  ##  @param[in]   _pstFX          Concerned FX
  ##  @return      orxTRUE if looping, orxFALSE otherwise

