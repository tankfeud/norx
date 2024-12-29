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