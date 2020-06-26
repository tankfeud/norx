import incl

## * Event enum
##

type
  orxLOCALE_EVENT* {.size: sizeof(cint).} = enum
    orxLOCALE_EVENT_SELECT_LANGUAGE = 0, ## *< Event sent when selecting a language
    orxLOCALE_EVENT_SET_STRING, ## *< Event sent when setting a string
    orxLOCALE_EVENT_NUMBER, orxLOCALE_EVENT_NONE = orxENUM_NONE


## * Locale event payload
##

type
  orxLOCALE_EVENT_PAYLOAD* {.bycopy.} = object
    zLanguage*: cstring     ## *< Current language : 4
    zStringKey*: cstring    ## *< String key : 8
    zStringValue*: cstring  ## *< String value : 12


## * Locale module setup
##

proc orxLocale_Setup*() {.cdecl, importc: "orxLocale_Setup", dynlib: libORX.}
## * Initializes the Locale Module
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxLocale_Init*(): orxSTATUS {.cdecl, importc: "orxLocale_Init",
                                 dynlib: libORX.}
## * Exits from the Locale Module
##

proc orxLocale_Exit*() {.cdecl, importc: "orxLocale_Exit", dynlib: libORX.}
## * Selects current working language
##  @param[in] _zLanguage        Language to select
##

proc orxLocale_SelectLanguage*(zLanguage: cstring): orxSTATUS {.cdecl,
    importc: "orxLocale_SelectLanguage", dynlib: libORX.}
## * Gets current language
##  @return Current selected language
##

proc orxLocale_GetCurrentLanguage*(): cstring {.cdecl,
    importc: "orxLocale_GetCurrentLanguage", dynlib: libORX.}
## * Has given language? (if not correctly defined, false will be returned)
##  @param[in] _zLanguage        Concerned language
##  @return orxTRUE / orxFALSE
##

proc orxLocale_HasLanguage*(zLanguage: cstring): orxBOOL {.cdecl,
    importc: "orxLocale_HasLanguage", dynlib: libORX.}
## * Gets language count
##  @return Number of languages defined
##

proc orxLocale_GetLanguageCount*(): orxU32 {.cdecl,
    importc: "orxLocale_GetLanguageCount", dynlib: libORX.}
## * Gets language at the given index
##  @param[in] _u32LanguageIndex Index of the desired language
##  @return orxSTRING if exist, orxSTRING_EMPTY otherwise
##

proc orxLocale_GetLanguage*(u32LanguageIndex: orxU32): cstring {.cdecl,
    importc: "orxLocale_GetLanguage", dynlib: libORX.}
## * Has string for the given key?
##  @param[in] _zKey             Key name
##  @return orxTRUE / orxFALSE
##

proc orxLocale_HasString*(zKey: cstring): orxBOOL {.cdecl,
    importc: "orxLocale_HasString", dynlib: libORX.}
## * Reads a string in the current language for the given key
##  @param[in] _zKey             Key name
##  @return The value
##

proc orxLocale_GetString*(zKey: cstring): cstring {.cdecl,
    importc: "orxLocale_GetString", dynlib: libORX.}
## * Writes a string in the current language for the given key
##  @param[in] _zKey             Key name
##  @param[in] _zValue           Value
##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE
##

proc orxLocale_SetString*(zKey: cstring; zValue: cstring): orxSTATUS {.cdecl,
    importc: "orxLocale_SetString", dynlib: libORX.}
## * Gets key count for the current language
##  @return Key count the current language if valid, 0 otherwise
##

proc orxLocale_GetKeyCount*(): orxU32 {.cdecl, importc: "orxLocale_GetKeyCount",
                                     dynlib: libORX.}
## * Gets key for the current language at the given index
##  @param[in] _u32KeyIndex      Index of the desired key
##  @return orxSTRING if exist, nil otherwise
##

proc orxLocale_GetKey*(u32KeyIndex: orxU32): cstring {.cdecl,
    importc: "orxLocale_GetKey", dynlib: libORX.}
## * @}
