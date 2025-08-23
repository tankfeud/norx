# Package
version       = "1.0.0"
author        = "Claude"
description   = "Classic Pong game using Norx/ORX"
license       = "MIT"

# Dependencies
requires "nim >= 1.6.0"
requires "norx"

srcDir = "."
bin = @["pong"]