import wrapper

proc pushSection*(sectionName: string): orxSTATUS {.inline.} =
  ## Pushes a named configuration section.
  wrapper.pushSection(sectionName.cstring)

proc getString*(key: string): cstring {.inline.} =
  ## Gets a borrowed string from the current configuration section.
  wrapper.getString(key.cstring)
