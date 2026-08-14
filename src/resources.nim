import wrapper

proc addStorage*(group, storage: string; addFirst: bool): orxSTATUS {.inline.} =
  ## Adds a Nim string path to an ORX resource group.
  wrapper.addStorage(group.cstring, storage.cstring,
                     orxBOOL(if addFirst: 1 else: 0))
