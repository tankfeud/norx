import wrapper

## Boolean constants
const
  orxFALSE* = 0.orxBOOL
  orxTRUE* = 1.orxBOOL

converter toBool*(x: orxBOOL): bool = cint(x) != 0
  ## Converts orxBOOL to bool

converter toOrxBOOL*(x: bool): orxBOOL = orxBOOL(if x: 1 else: 0)
  ## Converts bool to orxBOOL

converter toCstring*(x: string): cstring = x.cstring

converter fromCstring*(x: cstring): string = $x