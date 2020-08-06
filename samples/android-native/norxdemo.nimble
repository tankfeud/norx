# Package
version       = "0.1.0"
author        = "Göran Krampe"
license       = "MIT"
description   = "Demo for Android build"
srcDir        = "src"
installDirs   = @["data"]
bin           = @["norxdemo"]

# Dependencies
requires "nim >= 1.2.0"
requires "norx 0.4.3"
