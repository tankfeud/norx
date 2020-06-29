import oinput #, incl, joystick, keyboard, mouse

export oinput

template isActive*(zInputName: cstring): bool =
    ## Has input been newly activated since last frame?
    orxInput_IsActive(zInputName).bool