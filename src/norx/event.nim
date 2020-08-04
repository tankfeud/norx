
import incl

## Helper defines
template orxEVENT_GET_FLAG*(ID: untyped): untyped =
  ((orxU32)(1 shl (orxU32)(ID)))

const
  orxEVENT_KU32_FLAG_ID_NONE* = 0x00000000
  orxEVENT_KU32_MASK_ID_ALL* = 0xFFFFFFFF

type
  orxEVENT_TYPE* {.size: sizeof(cint).} = enum
    ## Event type enum
    orxEVENT_TYPE_ANIM = 0, orxEVENT_TYPE_CLOCK, orxEVENT_TYPE_CONFIG,
    orxEVENT_TYPE_DISPLAY, orxEVENT_TYPE_FX, orxEVENT_TYPE_INPUT,
    orxEVENT_TYPE_LOCALE, orxEVENT_TYPE_OBJECT, orxEVENT_TYPE_RENDER,
    orxEVENT_TYPE_PHYSICS, orxEVENT_TYPE_RESOURCE, orxEVENT_TYPE_SHADER,
    orxEVENT_TYPE_SOUND, orxEVENT_TYPE_SPAWNER, orxEVENT_TYPE_SYSTEM,
    orxEVENT_TYPE_TEXTURE, orxEVENT_TYPE_TIMELINE, orxEVENT_TYPE_VIEWPORT,
    orxEVENT_TYPE_CORE_NUMBER, orxEVENT_TYPE_LAST_RESERVED = 255,
    orxEVENT_TYPE_USER_DEFINED, orxEVENT_TYPE_NONE = orxENUM_NONE

const
  orxEVENT_TYPE_FIRST_RESERVED* = orxEVENT_TYPE_CORE_NUMBER

type
  orxEVENT* {.bycopy.} = object
    ## Public event structure
    eType*: orxEVENT_TYPE      ## Event type : 4
    eID*: orxENUM              ## Event ID : 8
    hSender*: orxHANDLE        ## Sender handle : 12
    hRecipient*: orxHANDLE     ## Recipient handle : 16
    pstPayload*: pointer       ## Event payload : 20
    pContext*: pointer         ## Optional user-provided context : 24

type
  orxEVENT_HANDLER* = proc (pstEvent: ptr orxEVENT): orxSTATUS {.cdecl.}
  ##  Event handler type / return orxSTATUS_FAILURE if events processing should be stopped for the current event, orxSTATUS_FAILURE otherwise

proc eventSetup*() {.cdecl, importc: "orxEvent_Setup", dynlib: libORX.}
  ## Event module setup

proc eventInit*(): orxSTATUS {.cdecl, importc: "orxEvent_Init",
                                dynlib: libORX.}
  ## Initializes the event Module
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc eventExit*() {.cdecl, importc: "orxEvent_Exit", dynlib: libORX.}
  ## Exits from the event Module

proc addHandler*(eEventType: orxEVENT_TYPE;
                         pfnEventHandler: orxEVENT_HANDLER): orxSTATUS {.cdecl,
    importc: "orxEvent_AddHandler", dynlib: libORX.}
  ## Adds an event handler
  ##  @param[in] _eEventType           Concerned type of event
  ##  @param[in] _pfnEventHandler      Event handler to add
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc addHandlerWithContext*(eEventType: orxEVENT_TYPE;
                                    pfnEventHandler: orxEVENT_HANDLER;
                                    pContext: pointer): orxSTATUS {.cdecl,
    importc: "orxEvent_AddHandlerWithContext", dynlib: libORX.}
  ## Adds an event handler with user-defined context
  ##  @param[in] _eEventType           Concerned type of event
  ##  @param[in] _pfnEventHandler      Event handler to add
  ##  @param[in] _pContext             Context that will be stored in events sent to this handler
  ##  return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc removeHandler*(eEventType: orxEVENT_TYPE;
                            pfnEventHandler: orxEVENT_HANDLER): orxSTATUS {.cdecl,
    importc: "orxEvent_RemoveHandler", dynlib: libORX.}
  ## Removes an event handler
  ##  @param[in] _eEventType           Concerned type of event
  ##  @param[in] _pfnEventHandler      Event handler to remove
  ##  return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc removeHandlerWithContext*(eEventType: orxEVENT_TYPE;
                                       pfnEventHandler: orxEVENT_HANDLER;
                                       pContext: pointer): orxSTATUS {.cdecl,
    importc: "orxEvent_RemoveHandlerWithContext", dynlib: libORX.}
  ## Removes an event handler which matches given context
  ##  @param[in] _eEventType           Concerned type of event
  ##  @param[in] _pfnEventHandler      Event handler to remove
  ##  @param[in] _pContext             Context of the handler to remove, nil for removing all occurrences regardless of their context
  ##  return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc setHandlerIDFlags*(pfnEventHandler: orxEVENT_HANDLER;
                                eEventType: orxEVENT_TYPE; pContext: pointer;
                                u32AddIDFlags: orxU32; u32RemoveIDFlags: orxU32): orxSTATUS {.
    cdecl, importc: "orxEvent_SetHandlerIDFlags", dynlib: libORX.}
  ## Sets an event handler's ID flags (use orxEVENT_GET_FLAG(ID) in order to get the flag that matches an ID)
  ##  @param[in] _pfnEventHandler      Concerned event handler, must have been previously added for the given type
  ##  @param[in] _eEventType           Concerned type of event
  ##  @param[in] _pContext             Context of the handler to update, nil for updating all occurrences regardless of their context
  ##  @param[in] _u32AddIDFlags        ID flags to add
  ##  @param[in] _u32RemoveIDFlags     ID flags to remove
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc send*(pstEvent: ptr orxEVENT): orxSTATUS {.cdecl,
    importc: "orxEvent_Send", dynlib: libORX.}
  ## Sends an event
  ##  @param[in] _pstEvent             Event to send
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc sendShort*(eEventType: orxEVENT_TYPE; eEventID: orxENUM): orxSTATUS {.
    cdecl, importc: "orxEvent_SendShort", dynlib: libORX.}
  ## Sends a simple event
  ##  @param[in] _eEventType           Event type
  ##  @param[in] _eEventID             Event ID
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc isSending*(): orxBOOL {.cdecl, importc: "orxEvent_IsSending",
                                   dynlib: libORX.}
  ## Is currently sending an event?
  ##  @return orxTRUE / orxFALSE

template orxEVENT_SEND_MACRO*(TYPE, ID, SENDER, RECIPIENT, PAYLOAD: untyped): void =
  var stEvent: orxEVENT
  stEvent.eType = cast[orxEVENT_TYPE](TYPE)
  stEvent.eID = cast[orxENUM](ID)
  stEvent.hSender = cast[orxHANDLE](SENDER)
  stEvent.hRecipient = cast[orxHANDLE](RECIPIENT)
  stEvent.pstPayload = cast[pointer](PAYLOAD)
  discard send(addr(stEvent))