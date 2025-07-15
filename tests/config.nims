switch("path", "$projectDir/../src")
when defined(release):
  switch("passL", "-lorx")
elif defined(profile):
  switch("passL", "-lorxp") 
else:
  switch("passL", "-lorxd")