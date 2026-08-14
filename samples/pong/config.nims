import std/os

let sampleDir = currentSourcePath().parentDir
let orxLibraryDir = normalizedPath(sampleDir / "../../orx/code/lib/dynamic")

switch("path", sampleDir / "../../src")
switch("passL", "-L" & orxLibraryDir)

when defined(linux) or defined(macosx):
  switch("passL", "-Wl,-rpath," & orxLibraryDir)

when defined(release):
  switch("passL", "-lorx")
elif defined(profile):
  switch("passL", "-lorxp")
else:
  switch("passL", "-lorxd")
