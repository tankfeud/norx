import incl, typ

const
  orxFILE_KU32_FLAG_INFO_NORMAL* = 0x00000001
  orxFILE_KU32_FLAG_INFO_READONLY* = 0x00000002
  orxFILE_KU32_FLAG_INFO_HIDDEN* = 0x00000004
  orxFILE_KU32_FLAG_INFO_DIRECTORY* = 0x00000008
  orxFILE_KU32_FLAG_OPEN_READ* = 0x10000000
  orxFILE_KU32_FLAG_OPEN_WRITE* = 0x20000000
  orxFILE_KU32_FLAG_OPEN_APPEND* = 0x40000000
  orxFILE_KU32_FLAG_OPEN_BINARY* = 0x80000000

## * File info structure

type
  orxFILE_INFO* {.bycopy.} = object
    s64Size*: orxS64           ## File's size (in bytes)
    s64TimeStamp*: orxS64      ## Timestamp of the last modification
    u32Flags*: orxU32          ## File attributes (cf. list of available flags)
    hInternal*: orxHANDLE      ## Internal use handle
    zName*: array[256, orxCHAR] ## File's name
    zPattern*: array[256, orxCHAR] ## Search pattern
    zPath*: array[1024, orxCHAR] ## Directory's name where is stored the file
    zFullName*: array[1280, orxCHAR] ## Full file name


## * Internal File structure
##

type orxFILE* = object

proc fileSetup*() {.cdecl, importc: "orxFile_Setup", dynlib: libORX.}
  ## File module setup

proc fileInit*(): orxSTATUS {.cdecl, importc: "orxFile_Init", dynlib: libORX.}
  ## Inits the File Module

proc fileExit*() {.cdecl, importc: "orxFile_Exit", dynlib: libORX.}
  ## Exits from the File Module

proc getHomeDirectory*(zSubPath: cstring): cstring {.cdecl,
    importc: "orxFile_GetHomeDirectory", dynlib: libORX.}
  ## Gets current user's home directory using linux separators (without trailing separator)
  ##  @param[in] _zSubPath                     Sub-path to append to the home directory, nil for none
  ##  @return Current user's home directory, use it immediately or copy it as will be modified by the next call to orxFile_GetHomeDirectory() or orxFile_GetApplicationSaveDirectory()

proc getApplicationSaveDirectory*(zSubPath: cstring): cstring {.cdecl,
    importc: "orxFile_GetApplicationSaveDirectory", dynlib: libORX.}
  ## Gets current user's application save directory using linux separators (without trailing separator)
  ##  @param[in] _zSubPath                     Sub-path to append to the application save directory, nil for none
  ##  @return Current user's application save directory, use it immediately or copy it as it will be modified by the next call to orxFile_GetHomeDirectory() or orxFile_GetApplicationSaveDirectory()

proc exists*(zFileName: cstring): orxBOOL {.cdecl,
    importc: "orxFile_Exists", dynlib: libORX.}
  ## Checks if a file/directory exists
  ##  @param[in] _zFileName           Concerned file/directory
  ##  @return orxFALSE if _zFileName doesn't exist, orxTRUE otherwise

proc findFirst*(zSearchPattern: cstring; pstFileInfo: ptr orxFILE_INFO): orxSTATUS {.
    cdecl, importc: "orxFile_FindFirst", dynlib: libORX.}
  ## Starts a new file search: finds the first file/directory that will match to the given pattern (ex: /bin/foo*)
  ##  @param[in] _zSearchPattern      Pattern used for file/directory search
  ##  @param[out] _pstFileInfo        Information about the first file found
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc findNext*(pstFileInfo: ptr orxFILE_INFO): orxSTATUS {.cdecl,
    importc: "orxFile_FindNext", dynlib: libORX.}
  ## Continues a file search: finds the next occurrence of a pattern, the search has to be started with orxFile_FindFirst
  ##  @param[in,out] _pstFileInfo      Information about the last found file/directory
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc findClose*(pstFileInfo: ptr orxFILE_INFO) {.cdecl,
    importc: "orxFile_FindClose", dynlib: libORX.}
  ## Closes a search (frees the memory allocated for this search)
  ##  @param[in] _pstFileInfo         Information returned during search

proc getInfo*(zFileName: cstring; pstFileInfo: ptr orxFILE_INFO): orxSTATUS {.
    cdecl, importc: "orxFile_GetInfo", dynlib: libORX.}
  ## Retrieves a file/directory information
  ##  @param[in] _zFileName            Concerned file/directory name
  ##  @param[out] _pstFileInfo         Information of the file/directory
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc remove*(zFileName: cstring): orxSTATUS {.cdecl,
    importc: "orxFile_Remove", dynlib: libORX.}
  ## Removes a file or an empty directory
  ##  @param[in] _zFileName            Concerned file / directory
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc makeDirectory*(zName: cstring): orxSTATUS {.cdecl,
    importc: "orxFile_MakeDirectory", dynlib: libORX.}
  ## Makes a directory, works recursively if needed
  ##  @param[in] _zName                Name of the directory to make
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc open*(zFileName: cstring; u32OpenFlags: orxU32): ptr orxFILE {.cdecl,
    importc: "orxFile_Open", dynlib: libORX.}
  ## Opens a file for later read or write operation
  ##  @param[in] _zFileName           Full file's path to open
  ##  @param[in] _u32OpenFlags        List of used flags when opened
  ##  @return a File pointer (or nil if an error has occurred)

proc read*(pReadData: pointer; s64ElemSize: orxS64; s64NbElem: orxS64;
                  pstFile: ptr orxFILE): orxS64 {.cdecl, importc: "orxFile_Read",
    dynlib: libORX.}
  ## Reads data from a file
  ##  @param[out] _pReadData          Buffer that will contain read data
  ##  @param[in] _s64ElemSize         Size of 1 element
  ##  @param[in] _s64NbElem           Number of elements
  ##  @param[in] _pstFile             Pointer to the file descriptor
  ##  @return Returns the number of read elements (not bytes)

proc write*(pDataToWrite: pointer; s64ElemSize: orxS64; s64NbElem: orxS64;
                   pstFile: ptr orxFILE): orxS64 {.cdecl, importc: "orxFile_Write",
    dynlib: libORX.}
  ## Writes data to a file
  ##  @param[in] _pDataToWrite        Buffer that contains the data to write
  ##  @param[in] _s64ElemSize         Size of 1 element
  ##  @param[in] _s64NbElem           Number of elements
  ##  @param[in] _pstFile             Pointer to the file descriptor
  ##  @return Returns the number of written elements (not bytes)

proc delete*(zFileName: cstring): orxSTATUS {.cdecl,
    importc: "orxFile_Delete", dynlib: libORX.}
  ## Deletes a file
  ##  @param[in] _zFileName           Full file's path to delete
  ##  @return orxSTATUS_SUCCESS upon success, orxSTATUS_FAILURE otherwise

proc seek*(pstFile: ptr orxFILE; s64Position: orxS64;
                  eWhence: orxSEEK_OFFSET_WHENCE): orxS64 {.cdecl,
    importc: "orxFile_Seek", dynlib: libORX.}
  ## Seeks to a position in the given file
  ##  @param[in] _pstFile              Concerned file
  ##  @param[in] _s64Position          Position (from start) where to set the indicator
  ##  @param[in] _eWhence              Starting point for the offset computation (start, current position or end)
  ##  @return Absolute cursor position if successful, -1 otherwise

proc tell*(pstFile: ptr orxFILE): orxS64 {.cdecl, importc: "orxFile_Tell",
    dynlib: libORX.}
  ## Tells the current position of the indicator in a file
  ##  @param[in] _pstFile              Concerned file
  ##  @return Returns the current position of the file indicator, -1 is invalid

proc getSize*(pstFile: ptr orxFILE): orxS64 {.cdecl,
    importc: "orxFile_GetSize", dynlib: libORX.}
  ## Retrieves a file's size
  ##  @param[in] _pstFile              Concerned file
  ##  @return Returns the length of the file, <= 0 if invalid

proc getTime*(pstFile: ptr orxFILE): orxS64 {.cdecl,
    importc: "orxFile_GetTime", dynlib: libORX.}
  ## Retrieves a file's time of last modification
  ##  @param[in] _pstFile              Concerned file
  ##  @return Returns the time of the last modification, in seconds, since epoch

proc print*(pstFile: ptr orxFILE; zString: cstring): orxS32 {.varargs, cdecl,
    importc: "orxFile_Print", dynlib: libORX.}
  ## Prints a formatted string to a file
  ##  @param[in] _pstFile             Pointer to the file descriptor
  ##  @param[in] _zString             Formatted string
  ##  @return Returns the number of written characters

proc close*(pstFile: ptr orxFILE): orxSTATUS {.cdecl,
    importc: "orxFile_Close", dynlib: libORX.}
  ## Closes an oppened file
  ##  @param[in] _pstFile             File's pointer to close
  ##  @return Returns the status of the operation

