## Port of the official ORX tutorial: localization.
## Adapted to Nim by jseb at finiderire.com, modernized for Norx.

#[
  Displays the ORX logo and a localized legend. Space (or the left mouse
  button) cycles through the available languages for the legend text.

  Notes from the original tutorial:
  - run() must not contain any logic code; it is only a backbone for default
    behaviors such as tracking exit or changing locale.
  - When an event handler returns STATUS_SUCCESS no other handler is called
    for that event; returning STATUS_FAILURE lets processing continue.
  - We monitor locale events to log when the selected language changes.
]#

import strformat
import norx
import os

import S_commons

{.push cdecl.}

var languageIndex: orxU32 = 0

proc localeHandler(event: ptr orxEVENT): orxSTATUS {.cdecl.} =
  if event.eID == ord(LOCALE_EVENT_SELECT_LANGUAGE):
    let payload = cast[ptr orxLOCALE_EVENT_PAYLOAD](event.pstPayload)
    echo fmt"Switching to {payload.zLanguage}"
  result = STATUS_SUCCESS

proc init(): orxSTATUS =
  if addHandler(EVENT_TYPE_LOCALE, localeHandler).isFailure:
    return STATUS_FAILURE

  # Create the logo and log its config-created child.
  let logo = objectCreateFromConfig("Logo")
  echo "=== We can get children from code: ", getChild(logo).repr

  # Display the available languages.
  var availableLanguages: seq[string]
  for i in 0 ..< getLanguageCount():
    availableLanguages.add $getLanguage(i)
  echo "=== Available languages: ", availableLanguages.repr

  if viewportCreateFromConfig("Viewport").isNil:
    return STATUS_FAILURE

  echo fmt"""
{bindingName("Quit")} will exit from this tutorial
{bindingName("CycleLanguage")} will cycle through all the available languages
*** The legend under the logo is always displayed in the current language ***"""

  result = STATUS_SUCCESS

proc run(): orxSTATUS {.cdecl.} =
  # This tutorial polls input in the main loop instead of a clock callback.
  if isActive("CycleLanguage") and hasNewStatus("CycleLanguage"):
    inc languageIndex
    if languageIndex == getLanguageCount():
      languageIndex = 0
    discard selectLanguage(getLanguage(languageIndex), nil)

  if isActive("Quit"):
    echo "Quit action triggered, exiting!"
    return STATUS_FAILURE
  result = STATUS_SUCCESS

proc bootstrap(): orxSTATUS =
  result = addStorage(CONFIG_KZ_RESOURCE_GROUP, getAppDir(), false)
  if result.isFailure:
    echo "Could not add config storage"

discard setBootstrap(bootstrap)
execute(init, run, exit)
