##  Orx - Portable Game Engine
##
##  Copyright (c) 2008-2020 Orx-Project
##
##  This software is provided 'as-is', without any express or implied
##  warranty. In no event will the authors be held liable for any damages
##  arising from the use of this software.
##
##  Permission is granted to anyone to use this software for any purpose,
##  including commercial applications, and to alter it and redistribute it
##  freely, subject to the following restrictions:
##
##     1. The origin of this software must not be misrepresented; you must not
##     claim that you wrote the original software. If you use this software
##     in a product, an acknowledgment in the product documentation would be
##     appreciated but is not required.
##
##     2. Altered source versions must be plainly marked as such, and must not be
##     misrepresented as being the original software.
##
##     3. This notice may not be removed or altered from any source
##     distribution.

import incl

## * Misc
##

const
  orxRESOURCE_KC_LOCATION_SEPARATOR* = ':'
  orxRESOURCE_KZ_DEFAULT_STORAGE* = "."
  orxRESOURCE_KZ_TYPE_TAG_FILE* = "file"

## * Resource asynchronous operation callback function
##

type
  orxRESOURCE_OP_FUNCTION* = proc (hResource: orxHANDLE; s64Size: orxS64;
                                pBuffer: pointer; pContext: pointer) {.cdecl.}

## * Resource handlers
##

type
  orxRESOURCE_FUNCTION_LOCATE* = proc (zStorage: cstring; zName: cstring;
                                    bRequireExistence: orxBOOL): cstring {.cdecl.}
  orxRESOURCE_FUNCTION_GET_TIME* = proc (zLocation: cstring): orxS64 {.cdecl.}
  orxRESOURCE_FUNCTION_OPEN* = proc (zLocation: cstring; bEraseMode: orxBOOL): orxHANDLE {.
      cdecl.}
  orxRESOURCE_FUNCTION_CLOSE* = proc (hResource: orxHANDLE) {.cdecl.}
  orxRESOURCE_FUNCTION_GET_SIZE* = proc (hResource: orxHANDLE): orxS64 {.cdecl.}
  orxRESOURCE_FUNCTION_SEEK* = proc (hResource: orxHANDLE; s64Offset: orxS64;
                                  eWhence: orxSEEK_OFFSET_WHENCE): orxS64 {.cdecl.}
  orxRESOURCE_FUNCTION_TELL* = proc (hResource: orxHANDLE): orxS64 {.cdecl.}
  orxRESOURCE_FUNCTION_READ* = proc (hResource: orxHANDLE; s64Size: orxS64;
                                  pBuffer: pointer): orxS64 {.cdecl.}
  orxRESOURCE_FUNCTION_WRITE* = proc (hResource: orxHANDLE; s64Size: orxS64;
                                   pBuffer: pointer): orxS64 {.cdecl.}
  orxRESOURCE_FUNCTION_DELETE* = proc (zLocation: cstring): orxSTATUS {.cdecl.}

## * Resource type info
##

type
  orxRESOURCE_TYPE_INFO* {.bycopy.} = object
    zTag*: cstring          ## *< Unique tag, mandatory
    pfnLocate*: orxRESOURCE_FUNCTION_LOCATE ## *< Locate function, mandatory
    pfnGetTime*: orxRESOURCE_FUNCTION_GET_TIME ## *< GetTime function, optional, for hotload support
    pfnOpen*: orxRESOURCE_FUNCTION_OPEN ## *< Open function, mandatory
    pfnClose*: orxRESOURCE_FUNCTION_CLOSE ## *< Close function, mandatory
    pfnGetSize*: orxRESOURCE_FUNCTION_GET_SIZE ## *< GetSize function, mandatory
    pfnSeek*: orxRESOURCE_FUNCTION_SEEK ## *< Seek function, mandatory
    pfnTell*: orxRESOURCE_FUNCTION_TELL ## *< Tell function, mandatory
    pfnRead*: orxRESOURCE_FUNCTION_READ ## *< Read function, mandatory
    pfnWrite*: orxRESOURCE_FUNCTION_WRITE ## *< Write function, optional, for write support
    pfnDelete*: orxRESOURCE_FUNCTION_DELETE ## *< Delete function, optional, for deletion support


## * Event enum
##

type
  orxRESOURCE_EVENT* {.size: sizeof(cint).} = enum
    orxRESOURCE_EVENT_UPDATE = 0, orxRESOURCE_EVENT_ADD, orxRESOURCE_EVENT_REMOVE,
    orxRESOURCE_EVENT_NUMBER, orxRESOURCE_EVENT_NONE = orxENUM_NONE


## * Event payload
##

type
  orxRESOURCE_EVENT_PAYLOAD* {.bycopy.} = object
    s64Time*: orxS64           ## *< New resource time : 8
    zLocation*: cstring     ## *< Resource location : 12 / 16
    pstTypeInfo*: ptr orxRESOURCE_TYPE_INFO ## *< Type info : 16 / 24
    stGroupID*: orxSTRINGID    ## *< Group ID : 20 / 28
    stNameID*: orxSTRINGID     ## *< Name ID : 24 / 32


## * Resource module setup
##

proc orxResource_Setup*() {.cdecl, importc: "orxResource_Setup", dynlib: libORX.}
## * Inits the resource module
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxResource_Init*(): orxSTATUS {.cdecl, importc: "orxResource_Init",
                                   dynlib: libORX.}
## * Exits from the resource module
##

proc orxResource_Exit*() {.cdecl, importc: "orxResource_Exit", dynlib: libORX.}
## * Gets number of resource groups
##  @return Number of resource groups
##

proc orxResource_GetGroupCount*(): orxU32 {.cdecl,
    importc: "orxResource_GetGroupCount", dynlib: libORX.}
## * Gets resource group at given index
##  @param[in] _u32Index         Index of resource group
##  @return Resource group if index is valid, nil otherwise
##

proc orxResource_GetGroup*(u32Index: orxU32): cstring {.cdecl,
    importc: "orxResource_GetGroup", dynlib: libORX.}
## * Adds a storage for a given resource group
##  @param[in] _zGroup           Concerned resource group
##  @param[in] _zStorage         Description of the storage, as understood by one of the resource type
##  @param[in] _bAddFirst        If true this storage will be used *before* any already added ones, otherwise it'll be used *after* all those
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxResource_AddStorage*(zGroup: cstring; zStorage: cstring;
                            bAddFirst: orxBOOL): orxSTATUS {.cdecl,
    importc: "orxResource_AddStorage", dynlib: libORX.}
## * Removes a storage for a given resource group
##  @param[in] _zGroup           Concerned resource group
##  @param[in] _zStorage         Concerned storage
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxResource_RemoveStorage*(zGroup: cstring; zStorage: cstring): orxSTATUS {.
    cdecl, importc: "orxResource_RemoveStorage", dynlib: libORX.}
## * Gets number of storages for a given resource group
##  @param[in] _zGroup           Concerned resource group
##  @return Number of storages for this resource group
##

proc orxResource_GetStorageCount*(zGroup: cstring): orxU32 {.cdecl,
    importc: "orxResource_GetStorageCount", dynlib: libORX.}
## * Gets storage at given index for a given resource group
##  @param[in] _zGroup           Concerned resource group
##  @param[in] _u32Index         Index of storage
##  @return Storage if index is valid, nil otherwise
##

proc orxResource_GetStorage*(zGroup: cstring; u32Index: orxU32): cstring {.
    cdecl, importc: "orxResource_GetStorage", dynlib: libORX.}
## * Reloads storage from config
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxResource_ReloadStorage*(): orxSTATUS {.cdecl,
    importc: "orxResource_ReloadStorage", dynlib: libORX.}
## * Gets the location of an *existing* resource for a given group, location gets cached if found
##  @param[in] _zGroup           Concerned resource group
##  @param[in] _zName            Name of the resource to locate
##  @return Location string if found, nil otherwise
##

proc orxResource_Locate*(zGroup: cstring; zName: cstring): cstring {.cdecl,
    importc: "orxResource_Locate", dynlib: libORX.}
## * Gets the location for a resource (existing or not) in a *specific storage*, for a given group. The location doesn't get cached and thus needs to be copied by the caller before the next call
##  @param[in] _zGroup           Concerned resource group
##  @param[in] _zStorage         Concerned storage, if nil then the highest priority storage will be used
##  @param[in] _zName            Name of the resource
##  @return Location string if found, nil otherwise
##

proc orxResource_LocateInStorage*(zGroup: cstring; zStorage: cstring;
                                 zName: cstring): cstring {.cdecl,
    importc: "orxResource_LocateInStorage", dynlib: libORX.}
## * Gets the resource path from a location
##  @param[in] _zLocation        Location of the concerned resource
##  @return Path string if valid, orxSTRING_EMPTY otherwise
##

proc orxResource_GetPath*(zLocation: cstring): cstring {.cdecl,
    importc: "orxResource_GetPath", dynlib: libORX.}
## * Gets the resource type from a location
##  @param[in] _zLocation        Location of the concerned resource
##  @return orxRESOURCE_TYPE_INFO if valid, nil otherwise
##

proc orxResource_GetType*(zLocation: cstring): ptr orxRESOURCE_TYPE_INFO {.cdecl,
    importc: "orxResource_GetType", dynlib: libORX.}
## * Gets the time of last modification of a resource
##  @param[in] _zLocation        Location of the concerned resource
##  @return Time of last modification, in seconds since epoch, if found, 0 otherwise
##

proc orxResource_GetTime*(zLocation: cstring): orxS64 {.cdecl,
    importc: "orxResource_GetTime", dynlib: libORX.}
## * Opens the resource at the given location
##  @param[in] _zLocation        Location of the resource to open
##  @param[in] _bEraseMode       If true, the file will be erased if existing or created otherwise, if false, no content will get destroyed when opening
##  @return Handle to the open location, orxHANDLE_UNDEFINED otherwise
##

proc orxResource_Open*(zLocation: cstring; bEraseMode: orxBOOL): orxHANDLE {.cdecl,
    importc: "orxResource_Open", dynlib: libORX.}
## * Closes a resource
##  @param[in] _hResource        Concerned resource
##

proc orxResource_Close*(hResource: orxHANDLE) {.cdecl, importc: "orxResource_Close",
    dynlib: libORX.}
## * Gets the literal location of a resource
##  @param[in] _hResource        Concerned resource
##  @return Literal location string
##

proc orxResource_GetLocation*(hResource: orxHANDLE): cstring {.cdecl,
    importc: "orxResource_GetLocation", dynlib: libORX.}
## * Gets the size, in bytes, of a resource
##  @param[in] _hResource        Concerned resource
##  @return Size of the resource, in bytes
##

proc orxResource_GetSize*(hResource: orxHANDLE): orxS64 {.cdecl,
    importc: "orxResource_GetSize", dynlib: libORX.}
## * Seeks a position in a given resource (moves cursor)
##  @param[in] _hResource        Concerned resource
##  @param[in] _s64Offset        Number of bytes to offset from 'origin'
##  @param[in] _eWhence          Starting point for the offset computation (start, current position or end)
##  @return Absolute cursor position
##

proc orxResource_Seek*(hResource: orxHANDLE; s64Offset: orxS64;
                      eWhence: orxSEEK_OFFSET_WHENCE): orxS64 {.cdecl,
    importc: "orxResource_Seek", dynlib: libORX.}
## * Tells the position of the cursor in a given resource
##  @param[in] _hResource        Concerned resource
##  @return Position (offset), in bytes
##

proc orxResource_Tell*(hResource: orxHANDLE): orxS64 {.cdecl,
    importc: "orxResource_Tell", dynlib: libORX.}
## * Reads data from a resource
##  @param[in] _hResource        Concerned resource
##  @param[in] _s64Size          Size to read (in bytes)
##  @param[out] _pBuffer         Buffer that will be filled by the read data
##  @param[in] _pfnCallback      Callback that will get called after asynchronous operation; if nil, operation will be synchronous
##  @param[in] _pContext         Context that will be transmitted to the callback when called
##  @return Size of the read data, in bytes or -1 for successful asynchronous call
##

proc orxResource_Read*(hResource: orxHANDLE; s64Size: orxS64; pBuffer: pointer;
                      pfnCallback: orxRESOURCE_OP_FUNCTION; pContext: pointer): orxS64 {.
    cdecl, importc: "orxResource_Read", dynlib: libORX.}
## * Writes data to a resource
##  @param[in] _hResource        Concerned resource
##  @param[in] _s64Size          Size to write (in bytes)
##  @param[out] _pBuffer         Buffer that will be written
##  @param[in] _pfnCallback      Callback that will get called after asynchronous operation; if nil, operation will be synchronous
##  @param[in] _pContext         Context that will be transmitted to the callback when called
##  @return Size of the written data, in bytes, 0 if nothing could be written/no write support for this resource type or -1 for successful asynchronous call
##

proc orxResource_Write*(hResource: orxHANDLE; s64Size: orxS64; pBuffer: pointer;
                       pfnCallback: orxRESOURCE_OP_FUNCTION; pContext: pointer): orxS64 {.
    cdecl, importc: "orxResource_Write", dynlib: libORX.}
## * Deletes a resource, given its location
##  @param[in] _zLocation        Location of the resource to delete
##  @return orxSTATUS_SUCCESS upon success, orxSTATUS_FAILURE otherwise
##

proc orxResource_Delete*(zLocation: cstring): orxSTATUS {.cdecl,
    importc: "orxResource_Delete", dynlib: libORX.}
## * Gets pending operation count for a given resource
##  @param[in] _hResource        Concerned resource
##  @return Number of pending asynchronous operations for that resource
##

proc orxResource_GetPendingOpCount*(hResource: orxHANDLE): orxU32 {.cdecl,
    importc: "orxResource_GetPendingOpCount", dynlib: libORX.}
## * Gets total pending operation count
##  @return Number of total pending asynchronous operations
##

proc orxResource_GetTotalPendingOpCount*(): orxU32 {.cdecl,
    importc: "orxResource_GetTotalPendingOpCount", dynlib: libORX.}
## * Registers a new resource type
##  @param[in] _pstInfo          Info describing the new resource type and how to handle it
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxResource_RegisterType*(pstInfo: ptr orxRESOURCE_TYPE_INFO): orxSTATUS {.
    cdecl, importc: "orxResource_RegisterType", dynlib: libORX.}
## * Gets number of registered resource types
##  @return Number of registered resource types
##

proc orxResource_GetTypeCount*(): orxU32 {.cdecl,
                                        importc: "orxResource_GetTypeCount",
                                        dynlib: libORX.}
## * Gets registered type info at given index
##  @param[in] _u32Index         Index of storage
##  @return Type tag string if index is valid, nil otherwise
##

proc orxResource_GetTypeTag*(u32Index: orxU32): cstring {.cdecl,
    importc: "orxResource_GetTypeTag", dynlib: libORX.}
## * Clears cache
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxResource_ClearCache*(): orxSTATUS {.cdecl,
    importc: "orxResource_ClearCache", dynlib: libORX.}
## * @}
