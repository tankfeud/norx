import lib, typ

## * Public structure definition
##

type
  #INNER_C_UNION_orxVector_72* {.bycopy, union.} = object
  #  fX*: orxFLOAT              ## First coordinate in the cartesian space
  #  fRho*: orxFLOAT            ## First coordinate in the spherical space
  #  fR*: orxFLOAT              ## First coordinate in the RGB color space
  #  fH*: orxFLOAT              ## First coordinate in the HSL/HSV color spaces

  #INNER_C_UNION_orxVector_80* {.bycopy, union.} = object
  #  fY*: orxFLOAT              ## Second coordinate in the cartesian space
  #  fTheta*: orxFLOAT          ## Second coordinate in the spherical space
  #  fG*: orxFLOAT              ## Second coordinate in the RGB color space
  #  fS*: orxFLOAT              ## Second coordinate in the HSL/HSV color spaces

  #INNER_C_UNION_orxVector_88* {.bycopy, union.} = object
  #  fZ*: orxFLOAT              ## Third coordinate in the cartesian space
  #  fPhi*: orxFLOAT            ## Third coordinate in the spherical space
  #  fB*: orxFLOAT              ## Third coordinate in the RGB color space
  #  fL*: orxFLOAT              ## Third coordinate in the HSL color space
  #  fV*: orxFLOAT              ## Third coordinate in the HSV color space

  #orxVECTOR* {.bycopy.} = object
  #  ano_orxVector_76*: INNER_C_UNION_orxVector_72 ## * Coordinates : 12
  #  ano_orxVector_84*: INNER_C_UNION_orxVector_80
  #  ano_orxVector_93*: INNER_C_UNION_orxVector_88

  orxVECTOR* {.bycopy.} = tuple[fX: orxFLOAT, fY: orxFLOAT, fZ: orxFLOAT]
  orxSPVECTOR* {.bycopy.} = tuple[fRho: orxFLOAT, fTheta: orxFLOAT, fPhi: orxFLOAT]
  orxRGBVECTOR* {.bycopy.} = tuple[fR: orxFLOAT, fG: orxFLOAT, fB: orxFLOAT]
  orxHSLVECTOR* {.bycopy.} = tuple[fH: orxFLOAT, fS: orxFLOAT, fL: orxFLOAT]
  orxHSVVECTOR* {.bycopy.} = tuple[fH: orxFLOAT, fS: orxFLOAT, fV: orxFLOAT]
