## Port of the official ORX tutorial: sound.
## Adapted to Nim by jseb at finiderire.com, modernized for Norx.

#[
  Plays sound effects (samples) and music (streams) - both are orxSOUND,
  the difference is set in config.

  Controls:
  - Up/Down arrows change the music volume, mirrored by the soldier scale.
  - Left/Right arrows change the music pitch, mirrored by the soldier rotation.
  - Left control toggles music pause (and the soldier visibility).
  - Enter plays a default SFX on the soldier, Space a random one.

  Sounds added to an object get spatial positioning for free; music is added
  and played the same way but is streamed from disk. We also register to the
  sound events, which are only sent for sounds played on objects.
]#

import strformat
import norx
import os

import S_commons

{.push cdecl.}

var soldier: ptr orxOBJECT
var music: ptr orxSOUND

proc showHints() =
  echo fmt"""
  {bindingName("VolumeUp")} & {bindingName("VolumeDown")} will change the music volume (+ soldier size).
  {bindingName("PitchUp")} & {bindingName("PitchDown")} will change the music pitch (+ soldier rotation).
  {bindingName("ToggleMusic")} will toggle music (+ soldier display).
  {bindingName("RandomSFX")} will play a random SFX on the soldier (+ change its color).
  {bindingName("DefaultSFX")} will play the default SFX on the soldier (+ restore its color)."""

proc soundHandler(event: ptr orxEVENT): orxSTATUS {.cdecl.} =
  if event.hRecipient == soldier:
    let payload = cast[ptr orxSOUND_EVENT_PAYLOAD](event.pstPayload)
    let soundName = getName(payload.pstSound)
    let recipientName = getName(cast[ptr orxOBJECT](event.hRecipient))
    case event.eID
    of ord(SOUND_EVENT_START):
      echo fmt"Sound {soundName} @ {recipientName} has started!"
    of ord(SOUND_EVENT_STOP):
      echo fmt"Sound {soundName} @ {recipientName} has stopped!"
    else:
      echo "Unknown sound event ", $event.eID
  result = STATUS_SUCCESS

proc update(clockInfo: ptr orxCLOCK_INFO, context: pointer) =
  if hasBeenActivated("RandomSFX"):
    discard soldier.addSound("RandomBip")
    discard pushSection("Tutorial")
    var randomColor: orxVECTOR
    discard getVector("RandomColor", addr randomColor)
    var color = orxCOLOR(anon0: struct_orxCOLOR_t_anon0_t(vRGB: randomColor),
                         fAlpha: 1.0)
    discard soldier.setColor(addr color)
    discard popSection()

  if hasBeenActivated("DefaultSFX"):
    discard soldier.addSound("DefaultBip")
    var white = orxCOLOR(anon0: struct_orxCOLOR_t_anon0_t(vRGB: orxVECTOR_WHITE),
                         fAlpha: 1.0)
    discard soldier.setColor(addr white)

  if hasBeenActivated("ToggleMusic"):
    discard soldier.enable(not soldier.isEnabled)

  if hasBeenActivated("PitchUp"):
    discard music.setPitch(music.getPitch() + 0.01)
    discard soldier.setRotation(soldier.getRotation() + 4.0 * clockInfo.fDT)
  if hasBeenActivated("PitchDown"):
    discard music.setPitch(music.getPitch() - 0.01)
    discard soldier.setRotation(soldier.getRotation() - 4.0 * clockInfo.fDT)

  if hasBeenActivated("VolumeDown"):
    discard music.setVolume(music.getVolume() - 0.05)
    discard soldier.setScale(soldier.getScale() * 0.98)
  if hasBeenActivated("VolumeUp"):
    discard music.setVolume(music.getVolume() + 0.05)
    discard soldier.setScale(soldier.getScale() * 1.02)

proc init(): orxSTATUS =
  showHints()

  if viewportCreateFromConfig("Viewport").isNil:
    return STATUS_FAILURE

  soldier = objectCreateFromConfig("Soldier")
  if soldier.isNil:
    return STATUS_FAILURE

  if clockRegister(clockGet(CLOCK_KZ_CORE), update, nil,
                   MODULE_ID_MAIN, CLOCK_PRIORITY_NORMAL).isFailure:
    return STATUS_FAILURE
  if addHandler(EVENT_TYPE_SOUND, soundHandler).isFailure:
    return STATUS_FAILURE

  discard soldier.addSound("Music")
  music = soldier.getLastAddedSound()
  if music.isNil or music.play().isFailure:
    return STATUS_FAILURE
  result = STATUS_SUCCESS

proc bootstrap(): orxSTATUS =
  result = addStorage(CONFIG_KZ_RESOURCE_GROUP, getAppDir(), false)
  if result.isFailure:
    echo "Could not add config storage"

discard setBootstrap(bootstrap)
execute(init, run, exit)
