# Package
version       = "0.1.0"
author        = "Jonas Öhrn"
description   = "Display a QR code"
license       = "MIT"
installDirs   = @["data"]
bin           = @["show_qr"]

# Dependencies
requires "nim >= 1.2.0"
requires "norx"
requires "qr"
