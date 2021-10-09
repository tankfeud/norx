import norx, norx/[input, joystick, incl, clock, event, system, config, resource, viewport, obj, physics, spawner, vector, display, sound]

var
  infoOrxObject: ptr orxOBJECT
  remapMode = false

proc inputEventHandler*(pstEvent: ptr orxEVENT): orxSTATUS {.cdecl.} =
  if (pstEvent.eID.ord == orxINPUT_EVENT_ON.ord):
    var payload = cast[ptr orxINPUT_EVENT_PAYLOAD](pstEvent.pstPayload)
    orxLOG("orxINPUT_EVENT_ON: " & $payload.zSetName & " Value: " & $payload.zInputName & " ID " & $payload.aeID[0] & " val " & $payload.afValue[0])

  return orxSTATUS_SUCCESS

# Re-bind named input to new ID of button or axis
proc rebindInput(inputName: string, inputType: orxINPUT_TYPE, inputID: orxENUM) =

    #Get all inputs and buttonIDs assigned to XButton
    var inputTypes: array[orxINPUT_KU32_BINDING_NUMBER, orxINPUT_TYPE]
    var bindingButtonIDs: array[orxINPUT_KU32_BINDING_NUMBER, orxENUM]
    var inputModes: array[orxINPUT_KU32_BINDING_NUMBER, orxINPUT_MODE]
    discard input.getBindingList(inputName, inputTypes, bindingButtonIDs, inputModes);

    #unbind all existing joystick buttons bound to inputName
    for i in (0..orxINPUT_KU32_BINDING_NUMBER-1):
      if inputTypes[i] == inputType:
        #echo "bindingButtonID before: ",$bindingButtonIDs[i].ord
        discard inputUnbind(inputName, cast[cint](i))  #remove old joystick binding

    discard inputBind(inputName, inputType, inputID, orxINPUT_MODE_FULL, -1);
    orxLOG("Bound to button " & $inputID);

proc remap() =
  var inputType: orxINPUT_TYPE
  var buttonID: orxENUM
  var value: orxFLOAT

  # Get a button press. This will be the one assigned to 'XButton'
  if input.getActiveBinding(addr(inputType), addr(buttonID), addr(value)) == orxSTATUS_SUCCESS:
    if inputType == orxINPUT_TYPE_JOYSTICK_BUTTON or inputType == orxINPUT_TYPE_JOYSTICK_AXIS: # only allow if it's a joystick button press
        orxLOG("Remapping  Joystick button ID: " & $buttonID.ord & " Value: " & $value)

        #do the remap here.
        rebindInput("XButton", inputType, buttonID)
        remapMode = false

proc update(pstClockInfo: ptr orxCLOCK_INFO, pContext: pointer) {.cdecl.} =
  ## Update function, it has been registered to be called every tick of the core clock

  ## Should quit?
  if isActive("Quit"):
     # Updates result
     #  eResult = orxSTATUS_FAILURE;
    discard sendShort(orxEVENT_TYPE_SYSTEM, orxSYSTEM_EVENT_CLOSE.orxU32)
    return

  if hasBeenActivated("XButton"):
    orxLOG("X Button")

  if hasBeenActivated("Remap"):
    orxLOG("Remap mode is on.")
    remapMode = true
    discard infoOrxObject.setTextString("Press new button")

  if remapMode:
    remap()
    if not remapMode:
      discard infoOrxObject.setTextString("Press enter to remap")


proc init(): orxSTATUS {.cdecl.} =
  orxLOG("App starting")

  # Creates viewport
  var vres = viewportCreateFromConfig("Viewport");
  if vres.isNil:
    result = orxSTATUS_FAILURE

  infoOrxObject = objectCreateFromConfig("InfoOverlay")

  discard objectCreateFromConfig("Scene")

  # Event handlers
  discard addHandler(orxEVENT_TYPE_INPUT, inputEventHandler); # Show event data for input 

  discard infoOrxObject.setTextString("Press Enter to remap joystick input")

  # Register the Update function to the core clock
  let clock = clockGet(orxCLOCK_KZ_CORE)
  var status = clock.register(update, nil, orxMODULE_ID_MAIN, orxCLOCK_PRIORITY_NORMAL)
  if status == orxSTATUS_SUCCESS:
    return orxSTATUS_SUCCESS
  return orxSTATUS_FAILURE

proc run(): orxSTATUS {.cdecl.} =
  return orxSTATUS_SUCCESS

proc exit() {.cdecl.} =
  ## Exit function, it is called before exiting from orx
  discard

proc bootstrap(): orxSTATUS {.cdecl.} =
  discard addStorage(orxCONFIG_KZ_RESOURCE_GROUP, "data/config", false)
  return orxSTATUS_SUCCESS

when isMainModule:
  discard setBootstrap(bootstrap)

  execute(init, run, exit)

  quit(0)
