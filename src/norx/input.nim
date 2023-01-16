import oinput #, incl, joystick, keyboard, mouse

export oinput

template isActive*(zInputName: string): bool =
    ## Has input been newly activated since last frame?
    oinput.isActive(cstring(zInputName)).bool
