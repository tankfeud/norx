when defined(release):
  const suffix = ""
elif defined(profile):
  const suffix = "p"
else:
  const suffix = "d"

when defined(windows):
  const
    libORX* = "liborx" & suffix & ".dll"
elif defined(macosx):
  const
    libORX* = "liborx" & suffix & ".dylib"
else:
  const
    libORX* = "liborx" & suffix & ".so"