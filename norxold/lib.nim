when defined(release):
  const suffix = ""
elif defined(profile):
  const suffix = "p"
else:
  const suffix = "d"

when defined(Windows):
  const
    libORX* = "liborx" & suffix & ".dll"
elif defined(MacOSX):
  const
    libORX* = "liborx" & suffix & ".dylib"
else:
  const
    libORX* = "liborx" & suffix & ".so"