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

## * Helper defines
##

template orxEVENT_SEND_MACRO*(TYPE, ID, SENDER, RECIPIENT, PAYLOAD: untyped): void =
  var stEvent: orxEVENT
  stEvent.eType = cast[orxEVENT_TYPE](TYPE)
  stEvent.eID = cast[orxENUM](ID)
  stEvent.hSender = cast[orxHANDLE](SENDER)
  stEvent.hRecipient = cast[orxHANDLE](RECIPIENT)
  stEvent.pstPayload = cast[pointer](PAYLOAD)
  discard orxEvent_Send(addr(stEvent))

template orxEVENT_GET_FLAG*(ID: untyped): untyped =
  ((orxU32)(1 shl (orxU32)(ID)))

const
  orxEVENT_KU32_FLAG_ID_NONE* = 0x00000000
  orxEVENT_KU32_MASK_ID_ALL* = 0xFFFFFFFF

## * Event type enum
##

type
  orxEVENT_TYPE* {.size: sizeof(cint).} = enum
    orxEVENT_TYPE_ANIM = 0, orxEVENT_TYPE_CLOCK, orxEVENT_TYPE_CONFIG,
    orxEVENT_TYPE_DISPLAY, orxEVENT_TYPE_FX, orxEVENT_TYPE_INPUT,
    orxEVENT_TYPE_LOCALE, orxEVENT_TYPE_OBJECT, orxEVENT_TYPE_RENDER,
    orxEVENT_TYPE_PHYSICS, orxEVENT_TYPE_RESOURCE, orxEVENT_TYPE_SHADER,
    orxEVENT_TYPE_SOUND, orxEVENT_TYPE_SPAWNER, orxEVENT_TYPE_SYSTEM,
    orxEVENT_TYPE_TEXTURE, orxEVENT_TYPE_TIMELINE, orxEVENT_TYPE_VIEWPORT,
    orxEVENT_TYPE_CORE_NUMBER, orxEVENT_TYPE_LAST_RESERVED = 255,
    orxEVENT_TYPE_USER_DEFINED, orxEVENT_TYPE_NONE = orxENUM_NONE

const
  orxEVENT_TYPE_FIRST_RESERVED = orxEVENT_TYPE_CORE_NUMBER

## * Public event structure
##

type
  orxEVENT* {.bycopy.} = object
    eType*: orxEVENT_TYPE      ## *< Event type : 4
    eID*: orxENUM              ## *< Event ID : 8
    hSender*: orxHANDLE        ## *< Sender handle : 12
    hRecipient*: orxHANDLE     ## *< Recipient handle : 16
    pstPayload*: pointer       ## *< Event payload : 20
    pContext*: pointer         ## *< Optional user-provided context : 24


## *
##  Event handler type / return orxSTATUS_FAILURE if events processing should be stopped for the current event, orxSTATUS_FAILURE otherwise
##

type
  orxEVENT_HANDLER* = proc (pstEvent: ptr orxEVENT): orxSTATUS {.cdecl.}

## * Event module setup
##

proc orxEvent_Setup*() {.cdecl, importc: "orxEvent_Setup", dynlib: libORX.}
## * Initializes the event Module
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxEvent_Init*(): orxSTATUS {.cdecl, importc: "orxEvent_Init",
                                dynlib: libORX.}
## * Exits from the event Module
##

proc orxEvent_Exit*() {.cdecl, importc: "orxEvent_Exit", dynlib: libORX.}
## * Adds an event handler
##  @param[in] _eEventType           Concerned type of event
##  @param[in] _pfnEventHandler      Event handler to add
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxEvent_AddHandler*(eEventType: orxEVENT_TYPE;
                         pfnEventHandler: orxEVENT_HANDLER): orxSTATUS {.cdecl,
    importc: "orxEvent_AddHandler", dynlib: libORX.}
## * Adds an event handler with user-defined context
##  @param[in] _eEventType           Concerned type of event
##  @param[in] _pfnEventHandler      Event handler to add
##  @param[in] _pContext             Context that will be stored in events sent to this handler
##  return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxEvent_AddHandlerWithContext*(eEventType: orxEVENT_TYPE;
                                    pfnEventHandler: orxEVENT_HANDLER;
                                    pContext: pointer): orxSTATUS {.cdecl,
    importc: "orxEvent_AddHandlerWithContext", dynlib: libORX.}
## * Removes an event handler
##  @param[in] _eEventType           Concerned type of event
##  @param[in] _pfnEventHandler      Event handler to remove
##  return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxEvent_RemoveHandler*(eEventType: orxEVENT_TYPE;
                            pfnEventHandler: orxEVENT_HANDLER): orxSTATUS {.cdecl,
    importc: "orxEvent_RemoveHandler", dynlib: libORX.}
## * Removes an event handler which matches given context
##  @param[in] _eEventType           Concerned type of event
##  @param[in] _pfnEventHandler      Event handler to remove
##  @param[in] _pContext             Context of the handler to remove, nil for removing all occurrences regardless of their context
##  return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxEvent_RemoveHandlerWithContext*(eEventType: orxEVENT_TYPE;
                                       pfnEventHandler: orxEVENT_HANDLER;
                                       pContext: pointer): orxSTATUS {.cdecl,
    importc: "orxEvent_RemoveHandlerWithContext", dynlib: libORX.}
## * Sets an event handler's ID flags (use orxEVENT_GET_FLAG(ID) in order to get the flag that matches an ID)
##  @param[in] _pfnEventHandler      Concerned event handler, must have been previously added for the given type
##  @param[in] _eEventType           Concerned type of event
##  @param[in] _pContext             Context of the handler to update, nil for updating all occurrences regardless of their context
##  @param[in] _u32AddIDFlags        ID flags to add
##  @param[in] _u32RemoveIDFlags     ID flags to remove
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxEvent_SetHandlerIDFlags*(pfnEventHandler: orxEVENT_HANDLER;
                                eEventType: orxEVENT_TYPE; pContext: pointer;
                                u32AddIDFlags: orxU32; u32RemoveIDFlags: orxU32): orxSTATUS {.
    cdecl, importc: "orxEvent_SetHandlerIDFlags", dynlib: libORX.}
## * Sends an event
##  @param[in] _pstEvent             Event to send
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxEvent_Send*(pstEvent: ptr orxEVENT): orxSTATUS {.cdecl,
    importc: "orxEvent_Send", dynlib: libORX.}
## * Sends a simple event
##  @param[in] _eEventType           Event type
##  @param[in] _eEventID             Event ID
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxEvent_SendShort*(eEventType: orxEVENT_TYPE; eEventID: orxENUM): orxSTATUS {.
    cdecl, importc: "orxEvent_SendShort", dynlib: libORX.}
## * Is currently sending an event?
##  @return orxTRUE / orxFALSE
##

proc orxEvent_IsSending*(): orxBOOL {.cdecl, importc: "orxEvent_IsSending",
                                   dynlib: libORX.}
## * @}
