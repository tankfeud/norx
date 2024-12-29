import os, macros, algorithm, std/dirs, sequtils, futhark, strutils, regex

const orxRoot = currentSourcePath.parentDir.parentDir / "orx"
const norxRoot = currentSourcePath.parentDir.parentDir / "src"
const wrapperPath = norxRoot / "wrapper.nim"
const default_prefix = """
# This was generated by futhark, and should not be edited directly.

"""

const commentRe = re2(r"\s*## Generated based on .+$", {regexMultiline}) 

# These names are too short so we protect them so they will be renamed with the module name as prefix
const protectedNames = ["Setup", "Init", "Exit", "Create", "CreateFromConfig",
  "Get", "Register", "Send", "SendShort", "Update"]
# These modules will 
const shortenedModules = ["input", "system", "object", "event", "clock",
  "resource", "module"]

# Rename logic
proc renameCallback(n, k: string, p = ""): string =
  # For enumval and const we just remove the orx prefix
  if k == "enumval" or k == "const":
    if n.startsWith("orx"):
      return n[3..^1]
    else:
      return n
  # We don't want to rename anything that starts with an underscore
  if n.startsWith("_"):
    return n
  # Split out the module name
  let splits = n.split("_", maxsplit=1)
  if splits.len == 1:
    return n
  var module = splits[0]
  # Remove the orx prefix of the module name
  if module.len > 3 and module.startsWith("orx"):
    module = module[3..^1]

  # Ensure the first module character is lowercase
  module[0] = module[0].toLowerAscii()
  let name = splits[1]
  # Treat protected names by prepending module name.
  if name in protectedNames:
    return module & name

  # For these modules we use just the name
  if module in shortenedModules:
    result = name
  else:
    result = n
  # Ensure the first character is lowercase
  result[0] = result[0].toLowerAscii()


macro generateImportcCall(): untyped =
  # Create the complete importc call programmatically so that we can add the headers
  # as arguments to the call as we need to do this dynamically
  result = nnkCall.newTree(
    ident"importc",
    nnkCommand.newTree(ident"path", newStrLitNode(orxRoot / "code" / "include")),
    nnkCommand.newTree(ident"outputPath", newStrLitNode(wrapperPath)), 
    nnkCommand.newTree(ident"renameCallback", ident"renameCallback")
  )

  # Function to recursively find .h files
  proc findHeaders(dir: string): seq[string] =
    for kind, path in walkDir(dir):
      case kind
      of pcDir:
        result = concat(result, findHeaders(path))
      of pcFile:
        if path.endsWith(".h"):
          let relPath = path.replace(orxRoot & "/code/include/", "")
          result.add(relPath)
      else: discard
    
    result.sort do (a, b: string) -> int:
      if a.startsWith("base/") and not b.startsWith("base/"):
        return -1
      elif not a.startsWith("base/") and b.startsWith("base/"):
        return 1
      return cmp(a, b)

  # Add each header as an argument
  var headers = findHeaders(orxRoot / "code" / "include")
  # Remove selected headers
  headers.delete(headers.find("main/android/orxAndroid.h"))
  headers.delete(headers.find("main/android/orxAndroidActivity.h"))

  # Add all headers as arguments to the importc call
  for header in headers:
    result.add newStrLitNode(header)


generateImportcCall()


proc processWrapperFile*(prefix: string = default_prefix) = 
  var content = readFile(wrapperPath)
  content = content.replace(commentRe, "")
  let outF = open(wrapperPath, fmWrite)
  defer: outF.close
  outF.write(prefix & content)


processWrapperFile("""
# This was generated by futhark, and should not be edited directly.

## This file should not be imported/included directly, instead import `norx`.
""")
