import macros, strutils, os, checksums/md5

const projectRoot = currentSourcePath().parentDir.parentDir

## This module provides compile-time support for embedding references to code snippets
## from external files into source code comments like this:
## 
## ## @file path:"marker":count:hash
## 
## Where:
## - path is the path to the file to reference relative to the project root
## - marker is the string to match at start of line, within quotes
## - count is the number of lines to include from the line where marker is found
## - hash is the MD5 hash of the content of the referenced lines (and can be empty from the start)
## 
## An example from vector.nim:
## 
## ## @file orx/code/include/math/orxVector.h:"typedef struct __orxVECTOR_t":28:8a7559931c2824bb9ef4556d058b7c7a
## 
## You can start with an empty hash and it will be updated with the first compile, like this:
## 
## ## @file orx/code/include/math/orxVector.h:"typedef struct __orxVECTOR_t":28:
## 
## Note that you need the last colon to be present.
## 
## If you compile with `-d:updateAnnotations` all file annotations with outdated hashes will be updated.
## Only do this when you are sure you have made the necessary changes based on the referenced content.
##
## Every file with these annotations will be processed at compile time if the file has the following lines:
## ```
## when defined(processAnnotations):
##   import annotation
##   static: processAnnotations(currentSourcePath())
## ```

type
  FileReference = object
    path: string
    marker: string    # The string to match at start
    lineCount: int    # Number of lines to include
    hash: string      # Content hash
    
proc findMarkerPosition(content: string, marker: string): int =
  ## Find the line number where marker appears at start of line
  let lines = content.splitLines()
  for i, line in lines:
    if line.strip().startsWith(marker):
      return i
  return -1

proc parseFileAnnotation(line: string): tuple[path: string, marker: string, lineCount: int, hash: string] =
  ## Parses: ## @file path:"marker":count:hash
  try:
    let content = line.splitWhitespace(maxSplit = 2)[2]
    var parts = content.split({':'}, maxSplit = 1)
    let path = parts[0]
    parts = parts[1].rsplit({':'}, maxSplit = 2)
    if parts.len < 3:
      raise newException(Exception, "Too few ':' in file reference")
    let marker = parts[0].strip(chars = {'"'})
    let lineCount = parseInt(parts[1])
    let hash = parts[2]
    result = (path, marker, lineCount, hash)
  except Exception as e:
    error("Invalid file reference format: " & line & "\n" & e.msg)

proc updateFileAnnotation(docComment: string, newHash: string): string =
  ## Updates the file annotation with the new hash
  let parts = docComment.rsplit(':', maxSplit = 1)
  result = parts[0] & ":" & newHash

proc processAnnotations*(sourcePath: string) {.compileTime.} =
  var sourceEdited = false
  var sourceContent = readFile(sourcePath)
  var sourceLines = sourceContent.splitLines()
  for i, line in sourceLines:
    if line.strip().startsWith("## @file"):
      let (path, marker, lineCount, previousHash) = parseFileAnnotation(line)
      if path == "": continue
      
      # Read and process the referenced file
      let filePath = projectRoot / path
      if not fileExists(filePath):
        warning("Referenced file does not exist: " & path)
        continue
        
      let content = readFile(filePath)
      let markerPos = findMarkerPosition(content, marker)
      
      if markerPos == -1:
        warning("Marker '" & marker & "' not found in " & filePath)
        continue
        
      let lines = content.splitLines()[markerPos ..< (markerPos + lineCount)]
      let contentSlice = lines.join("\n")
      let currentHash = getMD5(contentSlice)
      
      if previousHash == "":
        # First time seeing this file reference, add the hash
        echo "Adding hash for ", path, " marker '", marker, "' count ", lineCount
        sourceLines[i] = updateFileAnnotation(line, currentHash)
        sourceEdited = true
      elif previousHash != currentHash:
        # Content has changed
        let message = "Content changed in " & path & " at marker '" & marker & "' lines " & $markerPos & "-" & $(markerPos + lineCount) &
                "\nPrevious hash: " & previousHash & "current hash: " & currentHash
        if defined(errorOnAnnotationChange):
          error(message)
        else:
          warning(message)
        # Update the hash if updateAnnotations is defined
        if defined(updateAnnotations):
          echo "Updating hash for ", path, " marker '", marker, "' lines ", markerPos, "-", markerPos + lineCount
          sourceLines[i] = updateFileAnnotation(line, currentHash)
          sourceEdited = true

  # If we modified any annotations, write back to the source file
  if sourceEdited:
    writeFile(sourcePath, sourceLines.join("\n"))
