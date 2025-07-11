import os, macros, algorithm, std/dirs, sequtils, futhark, strutils, regex, times

const orxRoot = currentSourcePath.parentDir.parentDir / "orx"
const orxInclude = orxRoot / "code" / "include"
const norxRoot = currentSourcePath.parentDir.parentDir / "src"
const wrapperPath = norxRoot / "wrapper.nim"
const scriptPath = currentSourcePath.parentDir

const commentRe = re2(r"\s*## Generated based on .+$", {regexMultiline})

var tempDir: string

proc copyToTemp*(filePath: string): string =
  ## Copy a file to a temporary directory and return the temp file path
  if tempDir.len == 0:
    tempDir = getTempDir() / "norx_wrapper_" & $getTime().toUnix()
    createDir(tempDir)
  let fileName = extractFilename(filePath)
  result = tempDir / fileName
  copyFile(filePath, result)

proc cleanupTemp*() =
  ## Clean up the temporary directory
  if tempDir.len > 0 and dirExists(tempDir):
    removeDir(tempDir)
    tempDir = "" 

# These names are not unique enough so we protect them so they will keep the module name as prefix
const protectedNames = ["Setup", "Init", "Exit", "Create", "Update", "Delete", "CreateFromConfig",
  "Get", "Register", "Send", "SendShort", "Bind", "Unbind",
  "Set", "Mod", "Div", "Yield", # These are reserved words in nim
  "Load", "ClearCache", "Raycast", "StartRecording", # These caused collisions due to same argument types
  "StopRecording", "HasRecordingSupport"] # These caused collisions due to same argument types

# These modules will not have their proc names shortened
const shortenedModules = [
  "anim", "animPointer", "animSet",
  "module",
  "clock", "command", "config", "console", "event", "locale", "resource", "system", "thread", 
  "debug", "fPS", "profiler",
  "display", "font", "graphic", "screenshot", "text", "texture", "color",
  "file", "input", "joystick", "keyboard", "mouse",
  "param",
  "aabox", "math", "obox", "vector",
  "bank", "memory",
  "frame", "fX", "fXPointer", "object", "spawner", "structure", "timeline", "trigger",
  "body", "physics",
  "plugin",
  "camera", "render", "shader", "shaderPointer", "viewport",
  "sound", "soundPointer", "soundSystem",
  "hashTable", "linkList", "string", "tree", "timeLine",
  "orx" ]

proc replace(filePath: string, patterns: seq[(string, string)]) =
  ## Replace patterns in a file
  var content = readFile(filePath)
  for (search, replacement) in patterns:
    content = content.replace(search, replacement)
  writeFile(filePath, content)

proc replaceLines(filePath: string, startPattern: string, numLines: int, replacement: string = "") =
  ## Replace numLines starting from the line containing startPattern
  var lines = readFile(filePath).split('\n')
  var found = false
  for i in 0..<lines.len:
    if startPattern in lines[i]:
      # Replace the found line and the next numLines-1 lines
      let endIdx = min(i + numLines - 1, lines.len - 1)
      if replacement.len > 0:
        lines[i] = replacement
        # Remove the subsequent lines
        for j in countdown(endIdx, i + 1):
          lines.delete(j)
      else:
        # Remove all the lines
        for j in countdown(endIdx, i):
          lines.delete(j)
      found = true
      break
  
  if not found:
    echo "Warning: Pattern '", startPattern, "' not found in ", filePath
  
  writeFile(filePath, lines.join("\n"))

proc c2nim(header: string, outfile: string, prefix: string = "") =
  echo "Running: c2nim --reordercomments --prefix:", prefix, " ", scriptPath / "common.c2nim ", header , " -o:" , outfile
  if os.execShellCmd("c2nim --reordercomments --prefix:" & prefix & " " & scriptPath / "common.c2nim " & header & " -o:" & outfile) != 0:
    echo "Failed to run c2nim on ", header
    quit(1)
  else:
    echo "Ran c2nim on ", header, " generating ", outfile

# Rename logic
proc renameCallback(n, k: string, allowReuse: var bool, p = ""): string =
  # For enumval and const we just remove the orx prefix
  allowReuse = false
  # We do not change the name of typedefs
  if k == "typedef":
    return n
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
  # Remove the orx prefix of the module name and ensure
  # the first module character is lowercase
  if module.len > 3 and module.startsWith("orx"):
    module = module[3..^1]
  module[0] = module[0].toLowerAscii()
  let name = splits[1]
  # Treat protected names by prepending module name.
  if name in protectedNames:
    return module & name
  allowReuse = true
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

  # Find all headers
  var headers = findHeaders(orxInclude)
 
  # Remove selected headers
  headers.delete(headers.find("main/android/orxAndroid.h"))
  headers.delete(headers.find("main/android/orxAndroidActivity.h"))
  # Add all headers as arguments to the importc call
  for header in headers:
    result.add newStrLitNode(header)

 
#
#c2nim(orxInclude / "object/orxStructure.h", norxRoot / "orxStructure.nim")
#
# Removed all about orxMath.h, it only has "regular" math functions that we
# instead rely on Nim for.
#
#c2nim(orxInclude / "math/orxMath.h", norxRoot / "orxMath.nim", "orxMath_")
#replace(norxRoot / "orxMath.nim", @[
#  ("orxASSERT", "assert"),
#  ("builtin_popcount", "countSetBits"), 
#  ("builtin_ctzll","countTrailingZeroBits"),
#  ("builtin_ctz","countTrailingZeroBits"), ("div", "/"), ("orx2F", "orxFLOAT") ])

generateImportcCall()

#[ This variant creates one nim file for each header file.
importc:
  path orxInclude
  outputPath norxRoot
  renameCallback renameCallback
]#

proc processWrapperFile*(prefix: string) = 
  var content = readFile(wrapperPath)
  content = content.replace(commentRe, "")
  let outF = open(wrapperPath, fmWrite)
  defer: outF.close
  outF.write(prefix & content)

proc prepareFiles() =
  ## Make initial replacements and c2nim executions.
  ## NOTE: We do not use these techniques now.

  # Ensure temp directory is cleaned up when script exits
  #defer: cleanupTemp()

  # Run replacements and c2nim on specific headers so that we can later include
  # parts from in the high level nim files.
  # var orxVector = copyToTemp(orxInclude / "math/orxVector.h")
  # replace(orxVector, @[
  #  ("orxASSERT", "assert"), # Nim assert instead
  #  ("orxINLINE", "inline"), # Do not confuse c2nim
  #  ("orxCLAMP", "clamp"),   # Nim clamp instead
  #  ("orxMIN", "min"),       # Nim min instead
  #  ("orxMAX", "max"),       # Nim max instead
  #  ("orxLERP", "lerp"),     # Norx lerp
  #  ("orxREMAP", "remap"),   # Norx remap
  #  ("orxDLLAPI", ""),       # Do not confuse c2nim
  #  ("orxFASTCALL", ""),     # Do not confuse c2nim
  #  ("orxVector_", ""),      # Strip prefix
  #  ("orxFLOAT_0", "0.0"),   # 0.0 is fine
  #  ("orxFLOAT_1", "1.0"),   # 1.0 is fine
  #  ("2DRotate", "rotate2D"),# Can not start with "2"
  #  ("2DDot", "dot2D"),      # Can not start with "2"
  #  ])               
  #replaceLines(orxVector, "#include \"display/orxColorList.inc\"", 9)

proc postProcess() =
  ## Final tweaks to wrapper.nim and other files
  replaceLines(norxRoot / "wrapper.nim", "struct_orxVECTOR_t_anon0_t* {.union, bycopy.} = object", 21,
  """
  ## Following 5 types replace the complicated nested union Futhark generates
  orxVECTOR* {.bycopy.} = tuple[fX: orxFLOAT, fY: orxFLOAT, fZ: orxFLOAT]
  orxSPVECTOR* {.bycopy.} = tuple[fRho: orxFLOAT, fTheta: orxFLOAT, fPhi: orxFLOAT]
  orxRGBVECTOR* {.bycopy.} = tuple[fR: orxFLOAT, fG: orxFLOAT, fB: orxFLOAT]
  orxHSLVECTOR* {.bycopy.} = tuple[fH: orxFLOAT, fS: orxFLOAT, fL: orxFLOAT]
  orxHSVVECTOR* {.bycopy.} = tuple[fH: orxFLOAT, fS: orxFLOAT, fV: orxFLOAT]""")

when isMainModule:
  #prepareFiles()
  processWrapperFile("""
# This was generated by futhark, and should not be edited directly.

## This file should not be imported/included directly, instead import `norx`.
""")
  postProcess()