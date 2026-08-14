import std/unittest
import norx

suite "Norx vectors":
  test "construct vector values":
    check newVector() == newVector(0, 0, 0)
    check newVector(1, 2) == newVector(1, 2, 0)

    let spherical = newSpVector(1, 2, 3)
    check spherical.fRho == 1
    check spherical.fTheta == 2
    check spherical.fPhi == 3

    let rgb = newRgbVector(0.1, 0.2, 0.3)
    check rgb.fR == 0.1'f32
    check rgb.fG == 0.2'f32
    check rgb.fB == 0.3'f32

    let hsl = newHslVector(0.4, 0.5, 0.6)
    check hsl.fH == 0.4'f32
    check hsl.fS == 0.5'f32
    check hsl.fL == 0.6'f32

    let hsv = newHsvVector(0.7, 0.8, 0.9)
    check hsv.fH == 0.7'f32
    check hsv.fS == 0.8'f32
    check hsv.fV == 0.9'f32

  test "use value-oriented vector operations":
    let horizontal = newVector(3, 0)
    let vertical = newVector(0, 4)
    let sum = horizontal + vertical

    check sum == newVector(3, 4)
    check sum.getSquareSize == 25
    check sum.getSize == 5
    check horizontal.getDistance(vertical) == 5
    check horizontal.dot(vertical) == 0
    check horizontal.dot2D(vertical) == 0
    check horizontal.cross(vertical) == newVector(0, 0, 12)
    check mul(horizontal, newVector(2, 3, 4)) == newVector(6, 0, 0)
    check -horizontal == newVector(-3, 0)
    check horizontal * 2.0'f32 == newVector(6, 0)
    check 2.0'f32 * vertical == newVector(0, 8)
    check vertical / 2.0'f32 == newVector(0, 2)
    check newVector().isNull
    check newVector(1, 2).areEqual(newVector(1, 2))

  test "update vector values in place":
    var value = newVector(1, 2, 3)
    value += newVector(3, 2, 1)
    check value == newVector(4, 4, 4)
    value -= newVector(1, 2, 3)
    check value == newVector(3, 2, 1)
    value *= 2.0'f32
    check value == newVector(6, 4, 2)
    value /= 2.0'f32
    check value == newVector(3, 2, 1)

  test "normalize and rotate vector values":
    let normalized = newVector(3, 4).normalize
    check abs(normalized.fX - 0.6'f32) < 0.00001'f32
    check abs(normalized.fY - 0.8'f32) < 0.00001'f32

    let rotated = newVector(1, 0).rotate2D(PI_BY_2)
    check abs(rotated.fX) < EPSILON
    check abs(rotated.fY - 1.0'f32) < EPSILON
