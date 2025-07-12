# Package
version       = "0.7.2"
author        = "Göran Krampe"
description   = "A wrapper of the ORX 2.5D game engine"
license       = "Zlib"
srcDir        = "src"

# Since we test it only with latest stable Nim we like to require that (might work with older)
requires "nim >= 2.2.4"
# These are only used with android targets
requires "https://github.com/yglukhov/android"
requires "jnim"
# These are only used during development
requires "checksums"
requires "regex"

task samples, "Check that all samples compile":
  # Check official samples
  echo "Checking official_samples..."
  exec "find official_samples -name '*.nim' -exec nim check {} \\;"
