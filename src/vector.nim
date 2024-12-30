import wrapper

template orxVECTOR*(x, y, z: untyped): orxVECTOR =
  var v: orxVECTOR
  v.anon0.fX = x.orxFLOAT
  v.anon1.fY = y.orxFLOAT
  v.anon2.fZ = z.orxFLOAT
  v

template orxSPVECTOR*(rho, theta, phi: untyped): orxVECTOR =
  var v: orxVECTOR
  v.anon0.fRho = rho.orxFLOAT
  v.anon1.fTheta = theta.orxFLOAT
  v.anon2.fPhi = phi.orxFLOAT
  v

template orxRGBVECTOR*(r, g, b: untyped): orxVECTOR =
  var v: orxVECTOR
  v.anon0.fR = r.orxFLOAT
  v.anon1.fG = g.orxFLOAT
  v.anon2.fB = b.orxFLOAT
  v

template orxHSLVECTOR*(h, s, l: untyped): orxVECTOR =
  var v: orxVECTOR
  v.anon0.fH = h.orxFLOAT
  v.anon1.fS = s.orxFLOAT
  v.anon2.fL = l.orxFLOAT
  v

template orxHSVVECTOR*(h, s, v: untyped): orxVECTOR =
  var v: orxVECTOR
  v.anon0.fH = h.orxFLOAT
  v.anon1.fS = s.orxFLOAT
  v.anon2.fV = v.orxFLOAT
  v