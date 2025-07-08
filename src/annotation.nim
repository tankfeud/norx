import macros, strutils, sequtils, os, checksums/md5

const projectRoot = currentSourcePath().parentDir.parentDir

## This module provides compile-time support for two things:
## 1. Embedding in source comments, references to code sections from external files.
## 2. Copy code sections from external files.
##
## A reference is used to ensure a code section in another file has not changed since we last
## generated the wrapper. This is a way to ensure that hand coded Nim equivalent code likely does not
## need to change, since the original code it was based on has not changed.
## 
## A reference looks like this:
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
## The second feature is to simply copy code sections from external files and looks like this:
##
## ## @copy orx/code/include/math/orxVector.h:"typedef struct __orxVECTOR_t":28:
##
## It works similarly but if there is no hash, the content is simply copied and added into the source file starting
## at the line below the reference and the hash is calculated from the content and inserted into the annotation.
##
## If there is a hash, the content is only copied if you compile with `-d:updateAnnotations`, and the hash has changed.
## Then the existing content, same number of lines, is replaced and the hash is updated.
##
## Each file with annotations will be processed at compile time if the file has the following lines at the top:
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
  var i = 0
  while i < sourceLines.len:
    let line = sourceLines[i]
    let lineStripped = line.strip()
    if lineStripped.startsWith("## @"):
      let isFileLine = lineStripped.startsWith("## @file")
      let isCopyLine = lineStripped.startsWith("## @copy")
      
      if isFileLine or isCopyLine:
        let (path, marker, lineCount, previousHash) = parseFileAnnotation(line)
        if path == "": continue
        
        # Read and process the referenced file
        let filePath = projectRoot / path
        if not fileExists(filePath):
          warning("Referenced file does not exist: " & path)
          quit(1)
          
        let content = readFile(filePath)
        let markerPos = findMarkerPosition(content, marker)
        
        if markerPos == -1:
          warning("Marker '" & marker & "' not found in " & filePath)
          quit(1)
          
        let lines = content.splitLines()[markerPos ..< (markerPos + lineCount)]
        let contentSlice = lines.join("\n")
        let currentHash = getMD5(contentSlice)
        
        if isCopyLine:
          if previousHash == "":
            # Insert first time or replace the content
            if previousHash == "":
              # First time copy, insert content
              echo "Adding copy hash for ", path, " marker '", marker, "' count ", lineCount
              sourceLines[i] = updateFileAnnotation(line, currentHash)
              sourceEdited = true
              sourceLines.insert(lines, i + 1)
            elif previousHash != currentHash:
              let message = "Copy content changed in " & path & " at marker '" & marker & "' lines " & $markerPos & "-" & $(markerPos + lineCount)
              if defined(errorOnAnnotationChange):
                error(message)
              else:
                warning(message)
              if defined(updateAnnotations):
                echo "Updating copy hash and copying content for ", path, " marker '", marker, "' lines ", markerPos, "-", markerPos + lineCount
                sourceLines[i] = updateFileAnnotation(line, currentHash)
                sourceEdited = true          
                # Replace existing content
                var endLine = i + 1
                while endLine < sourceLines.len and not sourceLines[endLine].strip().startsWith("##"):
                  inc endLine
                sourceLines.delete(i + 1 .. endLine - 1)
                sourceLines.insert(lines, i + 1)
                i += lines.len  # Skip past inserted content            
        else:  # @file case - existing behavior
          if previousHash == "":
            echo "Adding file hash for ", path, " marker '", marker, "' count ", lineCount
            sourceLines[i] = updateFileAnnotation(line, currentHash)
            sourceEdited = true
          elif previousHash != currentHash:
            let message = "File content changed in " & path & " at marker '" & marker & "' lines " & $markerPos & "-" & $(markerPos + lineCount)
            if defined(errorOnAnnotationChange):
              error(message)
            else:
              warning(message)
            if defined(updateAnnotations):
              echo "Updating file hash for ", path, " marker '", marker, "' lines ", markerPos, "-", markerPos + lineCount
              sourceLines[i] = updateFileAnnotation(line, currentHash)
              sourceEdited = true
    inc i

  # If we modified any annotations or content, write back to the source file
  if sourceEdited:
    writeFile(sourcePath, sourceLines.join("\n"))
