import std/os

let rootDir = currentSourcePath().parentDir / "../.."
let orxLibraryDir = normalizedPath(rootDir / "orx/code/lib/dynamic")

switch("path", rootDir / "src")
switch("passL", "-L" & orxLibraryDir)

when defined(linux) or defined(macosx):
  switch("passL", "-Wl,-rpath," & orxLibraryDir)

switch("warning", "[LockLevel]:off")
switch("hints", "off")
switch("linedir", "on")
switch("debuginfo")
switch("stacktrace", "on")
switch("linetrace", "on")

when defined(release):
  switch("passL", "-lorx")
elif defined(profile):
  switch("passL", "-lorxp")
else:
  switch("passL", "-lorxd")
# begin Nimble config (version 2)
when withDir(thisDir(), system.fileExists("nimble.paths")):
  include "nimble.paths"
# end Nimble config
