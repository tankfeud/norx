# Game controls mapping module with mapping steps state machine
# This module should have no dependencies

# How is mapping confirmed before entering next step?
type NextStepMode* = enum
  ButtonRelease, # Wait for release of button/axis before entering next step
  ActionButton   # Wait for confirmation or re-do step by special Action buttons <Accept/OK>,<Recject/Back/NO>

type CtrlType* = enum JOY_BTN, JOY_AXIS, JOY_ANY

type InputWarn* = enum WARN_NONE, WARN_MULTIPLE_ACTIVE, WARN_BTN_ACTIVE, WARN_AXIS_ACTIVE, WARN_CTRL_OCCUPIED

type MapStep* = ref object
  id*: string
  desc*: string
  ctrlType*: CtrlType # type of control required; button,axis or any
  oppositePrev*: bool # is opposite direction of prevkous step

type MapRequest* = ref object
  joystickNrs*: seq[int]
  steps*: seq[MapStep]
  stableCount*: int
  run*: bool

type MapStatus* = enum Inactive, Init, Mapping, WaitNext, Done

type MapResult* = ref object
  inputType*: CtrlType
  inputID*: int
  axisDir*: int

type MapStepState* = ref object
  joyNr*: int
  status*: MapStatus
  stepIdx*: int
  results*: seq[MapResult]
  lastBtnCount: int
  stableCount: int
  lastBtnId*: int
  warn*: InputWarn

proc newMapStepState*(joyNr: int, stableCount: int): MapStepState =
  new(result)
  result.joyNr = joyNr
  result.status = Init
  result.stepIdx = -1
  result.results = @[]
  result.lastBtnCount = 0
  result.stableCount = stableCount
  result.lastBtnId = -1
  result.warn = WARN_NONE

type MapResponse* = ref object
  states*: seq[MapStepState]

# axis is 0..5 (6 axes) which is the range of joystick axes per joystick (0..orxJOYSTICK_AXIS_SINGLE_NUMBER.ord-1)
type ActiveAxis* = tuple[axis: int, value: float, dir: int]

type ActiveInputs* = ref object
  buttons*: seq[int]
  axes*: seq[ActiveAxis]

type MapControls* = ref object
  mapRequest*: MapRequest
  mapResponse*: MapResponse
  activeInputsGetter: proc(joyNr: int): ActiveInputs

proc setIfStable(state: MapStepState, inputType: CtrlType, inputID: int, axisDir: int) =

  # pos and neg directions are different controls
  var btnIdWithDir = inputID + (if axisDir < 0: 1000 else: 0) # hack to check stable button+dir

  # Already mapped same input controls?
  for result in state.results:
    if result.inputID == inputID and result.inputType == inputType and (result.inputType == JOY_BTN or result.axisDir == axisDir):
      state.warn = WARN_CTRL_OCCUPIED
      state.lastBtnId = btnIdWithDir
      return

  if state.lastBtnId < 0 or btnIdWithDir == state.lastBtnId:
    state.lastBtnCount += 1
  else:
    state.lastBtnCount = 1
  state.lastBtnId = btnIdWithDir
  if (state.lastBtnCount == state.stableCount):
    state.results.add(MapResult(inputType: inputType, inputID: inputID, axisDir: axisDir))
    state.lastBtnCount = 0
    #state.lastBtnId = -1
    state.status = WaitNext

proc setWarning(state: MapStepState, requiredCtrl: CtrlType, active: ActiveInputs) =
    if active.buttons.len > 1 or active.axes.len > 1:
      state.warn = WARN_MULTIPLE_ACTIVE
    elif active.buttons.len > 0 and requiredCtrl == JOY_AXIS:
      # TODO: -> show warning only if >10 times?
      state.warn = WARN_BTN_ACTIVE
    elif active.axes.len > 0 and requiredCtrl == JOY_BTN:
      state.warn = WARN_AXIS_ACTIVE
    else:
      state.warn = WARN_NONE

proc mapJoystick(self: MapControls, state: MapStepState) =
  if state.status == Inactive:
    return
  if state.status == Done:
    # User can now preview new mapping in app. App should bind inputs and let user try new controls
    # TODO: User select <Back>-button to re-run mapping steps again
    return
  if state.status == Init:
    # TODO: initial confirmation - should check inactive inputs before this 2-btn confirmation
    state.stepIdx = -1

    let active = self.activeInputsGetter(state.joyNr)
    if active.buttons.len == 2:
      state.lastBtnCount += 1
    if state.lastBtnCount == state.stableCount*2:
      state.lastBtnCount = 0
      state.status = WaitNext

  if state.status == WaitNext:
    # TODO: use settings NextStepMode - Future improvement other ways to advance to next step
    state.warn = WARN_NONE
    let active = self.activeInputsGetter(state.joyNr)
    if active.buttons.len == 0 and active.axes.len == 0:
      if (state.stepIdx + 1) == self.mapRequest.steps.len:
        state.status = Done
      else:
        state.stepIdx += 1
        state.lastBtnId = -1
        state.status = Mapping
      return
    else:
      # Set warning to indicate user should release button or axis
      if active.buttons.len > 0:
        state.lastBtnId = active.buttons[0]
        state.warn = WARN_BTN_ACTIVE
      if active.axes.len > 0:
        state.lastBtnId = active.axes[0].axis
        state.warn = WARN_AXIS_ACTIVE

  if state.status == Mapping:
    let step = self.mapRequest.steps[state.stepIdx]
    if step.oppositePrev: # For oppositePrev flag we emulate that user selects the opposite direction of same JOY_AXIS as prev step's result
      let prevResult = state.results[state.results.len - 1]
      if prevResult.inputType == JOY_AXIS:
        state.setIfStable(JOY_AXIS, prevResult.inputID, -prevResult.axisDir)
        return

    let active = self.activeInputsGetter(state.joyNr)
    state.setWarning(step.ctrlType, active)
    case step.ctrlType
    of JOY_ANY:
      # Take axis first if any
      if active.axes.len > 0:
        let activeAxis = active.axes[0]
        state.setIfStable(JOY_AXIS, activeAxis.axis, activeAxis.dir)
      elif active.buttons.len > 0:
        var btnId = active.buttons[0]
        state.setIfStable(JOY_BTN, btnId, 0)

    of JOY_BTN:
      if active.buttons.len > 0:
        var btnId = active.buttons[0]
        state.setIfStable(JOY_BTN, btnId, 0)

    of JOY_AXIS:
      if active.axes.len > 0:
        let activeAxis = active.axes[0]
        state.setIfStable(JOY_AXIS, activeAxis.axis, activeAxis.dir)


proc isMappingActive*(self: MapControls): bool =
  return (not isNil self.mapRequest) and self.mapRequest.run

proc resetMapping*(self: MapControls) =
  self.mapRequest = nil
  self.mapResponse = nil

proc mappingUpdateHandler*(self: MapControls) =
  if self.isMappingActive():
    for state in self.mapResponse.states:
      self.mapJoystick(state)

proc initMapping(self: MapControls) =
  var states: seq[MapStepState] = @[]
  for joyNr in self.mapRequest.joystickNrs:
    states.add(newMapStepState(joyNr, self.mapRequest.stableCount))
  self.mapResponse = MapResponse(states: states)

proc newMapControls*(req: MapRequest, getter: proc(joyNr: int): ActiveInputs): MapControls =
  new(result)
  result.mapRequest = req
  result.activeInputsGetter = getter
  result.initMapping()
  echo "newMapControls", req.steps.len
