import std/os

let rootDir = currentSourcePath().parentDir / ".."
let orxLibraryDir = normalizedPath(rootDir / "orx/code/lib/dynamic")

switch("path", rootDir / "src")
switch("passL", "-L" & orxLibraryDir)

when defined(linux) or defined(macosx):
  switch("passL", "-Wl,-rpath," & orxLibraryDir)

when defined(release):
  switch("passL", "-lorx")
elif defined(profile):
  switch("passL", "-lorxp")
else:
  switch("passL", "-lorxd")
