import wrapper

proc soundCreateFromConfig*(configId: string): ptr orxSOUND {.inline.} =
  ## Creates a sound from a Nim string configuration ID.
  wrapper.soundCreateFromConfig(configId.cstring)
