# Package
version       = "0.6.0"
author        = "Göran Krampe"
description   = "A wrapper of the ORX 2.5D game engine"
license       = "Zlib"
srcDir        = "src"

# Dependencies
# Since we test it only with latest stable Nim we like to require that (might work with older)
requires "nim >= 1.6.10"
# These are only used with android targets
requires "https://github.com/yglukhov/android"
requires "jnim"
