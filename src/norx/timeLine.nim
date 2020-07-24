import incl, structure

## * Internal TimeLine structure
##

type orxTIMELINE* = object
## * Event enum
##

type
  orxTIMELINE_EVENT* {.size: sizeof(cint).} = enum
    orxTIMELINE_EVENT_TRACK_START = 0, ## Event sent when a track starts
    orxTIMELINE_EVENT_TRACK_STOP, ## Event sent when a track stops
    orxTIMELINE_EVENT_TRACK_ADD, ## Event sent when a track is added
    orxTIMELINE_EVENT_TRACK_REMOVE, ## Event sent when a track is removed
    orxTIMELINE_EVENT_LOOP,   ## Event sent when a track is looping
    orxTIMELINE_EVENT_TRIGGER, ## Event sent when an event is triggered
    orxTIMELINE_EVENT_NUMBER, orxTIMELINE_EVENT_NONE = orxENUM_NONE


## * TimeLine event payload
##

type
  orxTIMELINE_EVENT_PAYLOAD* {.bycopy.} = object
    pstTimeLine*: ptr orxTIMELINE ## TimeLine reference : 4
    zTrackName*: cstring    ## Track name : 8
    zEvent*: cstring        ## Event text : 12
    fTimeStamp*: orxFLOAT      ## Event time : 16


proc timeLineSetup*() {.cdecl, importc: "orxTimeLine_Setup", dynlib: libORX.}
  ## TimeLine module setup

proc timeLineInit*(): orxSTATUS {.cdecl, importc: "orxTimeLine_Init",
                                   dynlib: libORX.}
  ## Inits the TimeLine module
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc timeLineExit*() {.cdecl, importc: "orxTimeLine_Exit", dynlib: libORX.}
  ## Exits from the TimeLine module

proc timeLineCreate*(): ptr orxTIMELINE {.cdecl, importc: "orxTimeLine_Create",
    dynlib: libORX.}
  ## Creates an empty TimeLine
  ##  @return orxTIMELINE / nil

proc delete*(pstTimeLine: ptr orxTIMELINE): orxSTATUS {.cdecl,
    importc: "orxTimeLine_Delete", dynlib: libORX.}
  ## Deletes a TimeLine
  ##  @param[in] _pstTimeLine            Concerned TimeLine
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc clearCache*(): orxSTATUS {.cdecl,
    importc: "orxTimeLine_ClearCache", dynlib: libORX.}
  ## Clears cache (if any TimeLine track is still in active use, it'll remain in memory until not referenced anymore)
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc enable*(pstTimeLine: ptr orxTIMELINE; bEnable: orxBOOL) {.cdecl,
    importc: "orxTimeLine_Enable", dynlib: libORX.}
  ## Enables/disables a TimeLine
  ##  @param[in]   _pstTimeLine          Concerned TimeLine
  ##  @param[in]   _bEnable              Enable / disable

proc isEnabled*(pstTimeLine: ptr orxTIMELINE): orxBOOL {.cdecl,
    importc: "orxTimeLine_IsEnabled", dynlib: libORX.}
  ## Is TimeLine enabled?
  ##  @param[in]   _pstTimeLine          Concerned TimeLine
  ##  @return      orxTRUE if enabled, orxFALSE otherwise

proc addTrackFromConfig*(pstTimeLine: ptr orxTIMELINE;
                                    zTrackID: cstring): orxSTATUS {.cdecl,
    importc: "orxTimeLine_AddTrackFromConfig", dynlib: libORX.}
  ## Adds a track to a TimeLine from config
  ##  @param[in]   _pstTimeLine          Concerned TimeLine
  ##  @param[in]   _zTrackID             Config ID
  ##  return       orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc removeTrackFromConfig*(pstTimeLine: ptr orxTIMELINE;
                                       zTrackID: cstring): orxSTATUS {.cdecl,
    importc: "orxTimeLine_RemoveTrackFromConfig", dynlib: libORX.}
  ## Removes a track using its config ID
  ##  @param[in]   _pstTimeLine          Concerned TimeLine
  ##  @param[in]   _zTrackID             Config ID of the track to remove
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getCount*(pstTimeLine: ptr orxTIMELINE): orxU32 {.cdecl,
    importc: "orxTimeLine_GetCount", dynlib: libORX.}
  ## Gets how many tracks are currently in use
  ##  @param[in]   _pstTimeLine          Concerned TimeLine
  ##  @return      orxU32

proc getTrackDuration*(zTrackID: cstring): orxFLOAT {.cdecl,
    importc: "orxTimeLine_GetTrackDuration", dynlib: libORX.}
  ## Gets a track duration using its config ID
  ##  @param[in]   _zTrackID             Config ID of the concerned track
  ##  @return      Duration if found, -orxFLOAT_1 otherwise

