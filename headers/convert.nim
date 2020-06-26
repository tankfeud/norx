import os, strutils

# Run with "nim c -r convert" and it will populate the include tree with .nim files

proc exec(cmd: string) =
  if os.execShellCmd(cmd) != 0:
    echo "FAILURE ", cmd
  else:
    echo "SUCCESS ", cmd

proc main(dir: string) =
  for kind, file in walkDir(dir):
    case kind
    of pcDir:
      main(file)
    of pcFile:
      var cmd = "c2nim common.c2nim " & file
      echo cmd
      if file.endswith(".h"): exec(cmd)
    else: discard

main(getCurrentDir())
