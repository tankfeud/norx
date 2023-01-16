import std/unittest

import norx/extras/[map_controls]

suite "Testsuite for map_controls":

  var mapControls: MapControls
  var mapRequest: MapRequest
  var mapResponse: MapResponse

  var joyNrSeq: seq[int] = @[1,2]

  var mapsteps1: seq[MapStep] = @[
    MapStep(id:"s1", desc:"Key1", ctrlType: JOY_BTN),
    MapStep(id:"s2", desc:"Axis2", ctrlType: JOY_AXIS),
    MapStep(id:"s3", desc:"KeyOrAxis3", ctrlType: JOY_ANY)
  ]

  var buttons1: seq[int] = @[]
  var buttons2: seq[int] = @[]
  var activeButtons: seq[seq[int]] = @[ buttons1, buttons2 ]

  var axes1: seq[ActiveAxis] = @[]
  var axes2: seq[ActiveAxis] = @[]
  var activeAxes: seq[seq[ActiveAxis]] = @[axes1, axes2]

  proc activeInputsGetter(joyNr: int): ActiveInputs =
    require(joyNr >= 1)
    require(joyNr < 3)
    #echo "activeButtons: " & $joyNr & " :" & $activeButtons[joyNr-1].len
    return ActiveInputs(
        buttons: activeButtons[joyNr-1],
        axes: activeAxes[joyNr-1])

  let LX_Zero: ActiveAxis = (0, 0.0, 0)
  let LX_Neg: ActiveAxis = (axis: 0, value: -1.0, dir: -1)
  let LX_Neg_Threshold: ActiveAxis = (axis: 0, value: -0.17, dir: -1)
  let LX_Neg_Small: ActiveAxis = (axis: 0, value: -0.09, dir: -1)
  let LX_Pos: ActiveAxis = (axis: 0, value: 1.0, dir: 1)
  let LX_Pos_Threshold: ActiveAxis = (axis: 0, value: 0.17, dir: 1)
  let LX_Pos_Small: ActiveAxis = (axis: 0, value: 0.09, dir: 1)
  let LY_Zero: ActiveAxis = (axis: 1, value: 0.0, dir: 0)
  let LY_Neg: ActiveAxis = (axis: 1, value: -1.0, dir: -1)
  let LY_Neg_Threshold: ActiveAxis = (axis: 1, value: -0.17, dir: -1)
  let LY_Neg_Small: ActiveAxis = (axis: 1, value: -0.09, dir: -1)
  let LY_Pos: ActiveAxis = (axis: 1, value: 1.0, dir: 1)
  let LY_Pos_Threshold: ActiveAxis = (axis: 1, value: 0.17, dir: 1)
  let LY_Pos_Small: ActiveAxis = (axis: 1, value: 0.09, dir: 1)

  proc runUpdateBtns(btns1: seq[int] = @[], btns2: seq[int] = @[],
      axes1: seq[ActiveAxis] = @[], axes2: seq[ActiveAxis] = @[]): tuple[s1: MapStepState, s2: MapStepState] =
    activeButtons[0] = btns1
    activeButtons[1] = btns2
    activeAxes[0] = axes1
    activeAxes[1] = axes2
    mapControls.mappingUpdateHandler() # run update with active buttons/axes

    return (mapResponse.states[0], mapResponse.states[1])

  proc setupTest(steps: seq[MapStep]) =
    mapRequest = MapRequest(joystickNrs: joyNrSeq, steps:steps, stableCount: 2, run: true)
    mapControls = newMapControls(mapRequest, activeInputsGetter)
    mapResponse = mapControls.mapResponse

  teardown:
    mapControls.resetMapping()

  test "initMapping":
    setupTest(mapsteps1)

    # give up and stop if this fails
    require(not isNil mapResponse)
    check(mapControls.isMappingActive())

    check(mapResponse.states.len == mapRequest.joystickNrs.len)

    var state1: MapStepState = mapResponse.states[0]
    check state1.status == Init
    check state1.stepIdx == -1
    check state1.results.len == 0

    var state2: MapStepState = mapResponse.states[1]
    check(state2.status == Init)

  test "Step 1 one joystick":
    setupTest(mapsteps1)
    discard runUpdateBtns() # run update with NO active buttons/axes

    var state1,state2: MapStepState
    state1 = mapResponse.states[0]
    check(state1.status == Init)
    check(state1.stepIdx == -1)
    check state1.results.len == 0

    (state1, state2) = runUpdateBtns(@[1,2],@[]) # run update with 2 active buttons
    (state1, state2) = runUpdateBtns(@[1,2],@[]) # run update with 2 active buttons
    (state1, state2) = runUpdateBtns(@[1,2],@[]) # run update with 2 active buttons
    check(state1.status == Init)
    (state1, state2) = runUpdateBtns(@[1,2],@[]) # run update with 2 active buttons
    check(state1.status == WaitNext)

    (state1, state2) = runUpdateBtns(@[],@[]) # run update with no active buttons
    check(state1.status == Mapping)
    check(state1.stepIdx == 0)
    check state1.results.len == 0

    (state1, state2) = runUpdateBtns(@[17],@[]) # run update with active button id:17
    check(state1.stepIdx == 0)

    (state1, state2) = runUpdateBtns(@[2],@[]) # run update with another active button
    check(state1.stepIdx == 0)
    (state1, state2) = runUpdateBtns(@[2],@[]) # run update with same active button 2nd time
    check state1.results.len == 1
    let mapResult: MapResult = state1.results[0]
    check mapResult.inputType == JOY_BTN
    check mapResult.inputID == 2
    check(state1.status == WaitNext) # WaitNext wait for release of button before entering next step
    check(state1.stepIdx == 0)

    (state1, state2) = runUpdateBtns(@[11],@[]) # run update STILL with active buttons/axes
    check(state1.status == WaitNext) # WaitNext wait for release of button before entering next step
    check(state1.stepIdx == 0)

    (state1, state2) = runUpdateBtns(@[],@[]) # run update with NO active buttons/axes
    check(state1.status == Mapping)
    check(state1.stepIdx == 1)

  test "All Steps both joysticks":
    setupTest(mapsteps1)

    var state1,state2: MapStepState

    discard runUpdateBtns() # run update with NO active buttons/axes
    (state1, state2) = runUpdateBtns(@[1,2],@[2,3]) # run update with 2 active buttons
    (state1, state2) = runUpdateBtns(@[1,2],@[2,3]) # run update with 2 active buttons
    (state1, state2) = runUpdateBtns(@[1,2],@[2,3]) # run update with 2 active buttons
    (state1, state2) = runUpdateBtns(@[1,2],@[2,3]) # run update with 2 active buttons
    check(state1.status == WaitNext)
    check(state2.status == WaitNext)

    # Start with active buttons - check we wait for button release at Init
    (state1, state2) = runUpdateBtns(@[10],@[11])
    check(state1.stepIdx == -1)
    check(state2.stepIdx == -1)
    check(state1.status == WaitNext)
    check(state2.status == WaitNext)

    (state1, state2) = runUpdateBtns(@[2],@[])
    check(state1.status == WaitNext) # Init still wait for release of button before entering next step
    check(state2.stepIdx == 0)
    check(state2.status == Mapping)

    (state1, state2) = runUpdateBtns(@[],@[2])
    check(state1.status == Mapping)
    check(state1.stepIdx == 0)
    check state1.results.len == 0
    check(state2.status == Mapping)
    check(state2.stepIdx == 0)
    check state2.results.len == 0
    (state1, state2) = runUpdateBtns(@[2,6],@[2]) # joy #2 2 times -> step 1 done
    check(state1.status == Mapping)
    check state1.results.len == 0
    check(state2.status == WaitNext)
    check state2.results.len == 1
    var mapResult: MapResult = state2.results[0]
    check mapResult.inputType == JOY_BTN
    check mapResult.inputID == 2

    (state1, state2) = runUpdateBtns(@[1,3],@[])
    check(state1.status == Mapping)
    check(state2.status == Mapping)
    check(state2.stepIdx == 1)

    (state1, state2) = runUpdateBtns(@[1,4],@[])
    check(state1.status == WaitNext)
    check state1.results.len == 1
    mapResult = state1.results[0]
    check mapResult.inputType == JOY_BTN
    check mapResult.inputID == 1
    check(state2.status == Mapping)
    check(state2.stepIdx == 1)

    (state1, state2) = runUpdateBtns(@[],@[9])
    check(state1.status == Mapping)
    check(state1.warn == WARN_NONE)
    check(state2.status == Mapping)
    check(state2.stepIdx == 1) # step Axis2
    check(state2.warn == WARN_BTN_ACTIVE)

    # this step #2 is JOY_AXIS
    (state1, state2) = runUpdateBtns(@[],@[9,11], @[LX_Pos_Threshold], @[LX_Neg, LY_Pos])
    check(state1.status == Mapping)
    check(state1.stepIdx == 1)
    check(state1.warn == WARN_NONE)

    check(state2.status == Mapping)
    check(state2.stepIdx == 1) # step Axis2
    check(state2.warn == WARN_MULTIPLE_ACTIVE)

    (state1, state2) = runUpdateBtns(@[],@[9], @[LX_Pos],@[LY_Pos])
    check(state1.stepIdx == 1) # step Axis2 result was JOY_AXIS LX_POS
    check(state1.status == WaitNext)
    check state1.results.len == 2
    mapResult = state1.results[1]
    check mapResult.inputType == JOY_AXIS
    check mapResult.inputID == LX_Pos.axis
    check mapResult.axisDir == LX_Pos.dir

    check(state2.stepIdx == 1)
    check(state2.status == Mapping)
    check(state2.warn == WARN_BTN_ACTIVE)

    (state1, state2) = runUpdateBtns(@[7],@[], @[LX_Pos],@[LY_Neg])
    check(state1.status == WaitNext)
    check(state1.stepIdx == 1) # step Axis2 wait for release axis
    check(state1.warn == WARN_AXIS_ACTIVE or state1.warn == WARN_BTN_ACTIVE)
    check state1.results.len == 2

    check(state2.status == Mapping)
    check(state2.stepIdx == 1) # step Axis2
    check(state2.warn == WARN_NONE)

    (state1, state2) = runUpdateBtns(@[],@[], @[],@[LY_Neg])
    check(state1.status == Mapping)
    check(state1.stepIdx == 2) # step JorOrAxis3

    check(state2.status == WaitNext) # finally 2 in a row LY_Neg -> result
    check state2.results.len == 2
    mapResult = state2.results[1]
    check mapResult.inputType == JOY_AXIS
    check mapResult.inputID == LY_Neg.axis
    check mapResult.axisDir == LY_Neg.dir

    (state1, state2) = runUpdateBtns(@[],@[], @[],@[])
    check(state1.status == Mapping)
    check(state2.status == Mapping)
    check(state1.stepIdx == 2) # step JorOrAxis3
    check(state2.stepIdx == 2) # step JorOrAxis3
    (state1, state2) = runUpdateBtns(@[11],@[12], @[],@[LY_Pos])
    (state1, state2) = runUpdateBtns(@[11],@[12], @[],@[LY_Pos])

    check(state1.status == WaitNext)
    check(state2.status == WaitNext)

    (state1, state2) = runUpdateBtns(@[],@[], @[],@[])
    check(state1.status == Done)
    check(state2.status == Done)

    check state1.results.len == 3
    check state2.results.len == 3

    mapResult = state1.results[2]
    check mapResult.inputType == JOY_BTN
    check mapResult.inputID == 11
    mapResult = state2.results[2]
    check mapResult.inputType == JOY_AXIS
    check mapResult.inputID == 1
    check mapResult.axisDir == 1

  test "Step 1 -> 2 check occupied":
    setupTest(mapsteps1)

    var state1,state2: MapStepState

    discard runUpdateBtns() # run update with NO active buttons/axes
    (state1, state2) = runUpdateBtns(@[1,2],@[]) # run update with 2 active buttons
    (state1, state2) = runUpdateBtns(@[1,2],@[]) # run update with 2 active buttons
    (state1, state2) = runUpdateBtns(@[1,2],@[]) # run update with 2 active buttons
    (state1, state2) = runUpdateBtns(@[1,2],@[]) # run update with 2 active buttons
    check(state1.status == WaitNext)
    discard runUpdateBtns() # run update with NO active buttons/axes

    state1 = mapResponse.states[0]
    check(state1.status == Mapping)
    check(state1.stepIdx == 0)
    check state1.results.len == 0

    (state1, state2) = runUpdateBtns(@[1],@[]) # run update with another active button
    check(state1.stepIdx == 0)
    (state1, state2) = runUpdateBtns(@[1],@[]) # run update with same active button 2nd time
    check state1.results.len == 1
    var mapResult: MapResult = state1.results[0]
    check mapResult.inputID == 1
    check(state1.status == WaitNext) # WaitNext wait for release of button before entering next step
    check(state1.warn == WARN_NONE)

    (state1, state2) = runUpdateBtns(@[],@[]) # run update with NO active buttons/axes
    check(state1.status == Mapping)
    check(state1.stepIdx == 1)
    check(state1.warn == WARN_NONE)

    (state1, state2) = runUpdateBtns(@[1],@[]) # run update with same inputID again
    check(state1.stepIdx == 1)
    check(state1.warn == WARN_BTN_ACTIVE)
    (state1, state2) = runUpdateBtns(@[1],@[]) # run update with same inputID again
    check(state1.stepIdx == 1)
    check(state1.warn == WARN_BTN_ACTIVE)

    (state1, state2) = runUpdateBtns(@[],@[]) # run update with NO active buttons/axes
    check(state1.stepIdx == 1)

    (state1, state2) = runUpdateBtns(@[],@[], @[LY_Pos],@[]) # run update with same inputID(1) again BUT for axis
    check(state1.stepIdx == 1)
    check(state1.warn == WARN_NONE)
    (state1, state2) = runUpdateBtns(@[],@[], @[LY_Pos],@[]) # run update with same inputID(1) again BUT for axis
    check(state1.stepIdx == 1)
    check state1.results.len == 2
    mapResult = state1.results[1]
    check mapResult.inputType == JOY_AXIS
    check mapResult.inputID == 1
    check mapResult.axisDir == 1
    check(state1.status == WaitNext) # WaitNext wait for release of button before entering next step

    (state1, state2) = runUpdateBtns(@[],@[]) # run update with NO active buttons/axes
    check(state1.status == Mapping)
    check(state1.stepIdx == 2)
    check(state1.warn == WARN_NONE)

    # Check occupied if trying to select same button or Axis again
    (state1, state2) = runUpdateBtns(@[],@[], @[LY_Pos],@[]) # run update with same inputID(LY_Pos) again for axis
    check(state1.status == Mapping)
    check(state1.stepIdx == 2)
    check(state1.warn == WARN_CTRL_OCCUPIED)
    (state1, state2) = runUpdateBtns(@[0],@[], @[LY_Neg],@[]) # run update with same inputID but not same axisDir
    check(state1.warn == WARN_NONE)
    (state1, state2) = runUpdateBtns(@[1],@[], @[],@[]) # run update with same inputID(1) again for button
    check(state1.warn == WARN_CTRL_OCCUPIED)
    check(state1.status == Mapping)
    check(state1.stepIdx == 2)
    (state1, state2) = runUpdateBtns(@[],@[], @[LY_Pos],@[]) # run update with same inputID(LY_Pos) again for axis
    check(state1.warn == WARN_CTRL_OCCUPIED)
    check(state1.status == Mapping)
    check(state1.stepIdx == 2)

  test "oppositePrev logic":
    let mapstepsOppositePrev: seq[MapStep] = @[
      MapStep(id:"s1", desc:"Left", ctrlType: JOY_ANY),
      MapStep(id:"s2", desc:"RIGHT", ctrlType: JOY_ANY, oppositePrev: true), # opposite to preivous/Left
      MapStep(id:"s3", desc:"THRUST", ctrlType: JOY_ANY),
    ]
    setupTest(mapstepsOppositePrev)

    var state1,state2: MapStepState
    # Activate
    (state1, state2) = runUpdateBtns(@[1,2]) # run update with 2 active buttons
    (state1, state2) = runUpdateBtns(@[1,2])
    (state1, state2) = runUpdateBtns(@[1,2])
    (state1, state2) = runUpdateBtns(@[1,2])
    check(state1.status == WaitNext)

    # Release
    (state1, state2) = runUpdateBtns(@[],@[], @[])
    check(state1.status == Mapping)

    # Set first step to LY Neg
    (state1, state2) = runUpdateBtns(@[],@[], @[LY_Neg])
    (state1, state2) = runUpdateBtns(@[],@[], @[LY_Neg])
    check(state1.status == WaitNext)
    check state1.results.len == 1
    var mapResult = state1.results[0]
    check mapResult.inputType == JOY_AXIS
    check mapResult.inputID == LY_Neg.axis
    check mapResult.axisDir == LY_Neg.dir

    # Release
    (state1, state2) = runUpdateBtns(@[],@[], @[])
    check(state1.status == Mapping)

    # Let Mepping state run twice to auto-set LY_Pos due to oppositePrev
    (state1, state2) = runUpdateBtns(@[],@[], @[])
    check(state1.status == Mapping)
    (state1, state2) = runUpdateBtns(@[],@[], @[])
    check(state1.status == WaitNext)
    check state1.results.len == 2
    mapResult = state1.results[1]
    check mapResult.inputType == JOY_AXIS
    check mapResult.inputID == LY_Pos.axis
    check mapResult.axisDir == LY_Pos.dir

  # TODO: test threshold"
