import incl

const
  orxTHREAD_KU32_MAIN_THREAD_ID* = 0
  orxTHREAD_KU32_MAX_THREAD_NUMBER* = 16
  orxTHREAD_KU32_FLAG_NONE* = 0
  orxTHREAD_KU32_MASK_ALL* = (((1 shl orxTHREAD_KU32_MAX_THREAD_NUMBER) - 1) and
      not (1 shl orxTHREAD_KU32_MAIN_THREAD_ID)) ##  Mask all (for orxThread_Enable)

template orxTHREAD_GET_FLAG_FROM_ID*(ID: untyped): untyped =
  (1 shl (ID))                  ## Gets thread flag from ID

## * Semaphore structure

type orxTHREAD_SEMAPHORE* = object
## * Thread run function type

type
  orxTHREAD_FUNCTION* = proc (pContext: pointer): orxSTATUS {.cdecl.}

proc threadSetup*() {.cdecl, importc: "orxThread_Setup", dynlib: libORX.}
  ## Thread module setup

proc threadInit*(): orxSTATUS {.cdecl, importc: "orxThread_Init",
                                 dynlib: libORX.}
  ## Inits the thread module
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc threadExit*() {.cdecl, importc: "orxThread_Exit", dynlib: libORX.}
  ## Exits from the thread module

proc start*(pfnRun: orxTHREAD_FUNCTION; zName: cstring;
                     pContext: pointer): orxU32 {.cdecl, importc: "orxThread_Start",
    dynlib: libORX.}
  ## Starts a new thread
  ##  @param[in]   _pfnRun                               Function to run on the new thread
  ##  @param[in]   _zName                                Thread's name
  ##  @param[in]   _pContext                             Context that will be transmitted to the function when called
  ##  @return      Thread ID if successful, orxU32_UNDEFINED otherwise

proc join*(u32ThreadID: orxU32): orxSTATUS {.cdecl,
    importc: "orxThread_Join", dynlib: libORX.}
  ## Joins a thread (blocks & waits until the other thread finishes)
  ##  @param[in]   _u32ThreadID                          ID of the thread for which to wait
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc joinAll*(): orxSTATUS {.cdecl, importc: "orxThread_JoinAll",
                                    dynlib: libORX.}
  ## Joins all threads (blocks & waits until the other threads finish)
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getName*(u32ThreadID: orxU32): cstring {.cdecl,
    importc: "orxThread_GetName", dynlib: libORX.}
  ## Gets a thread name
  ##  @param[in]   _u32ThreadID                          ID of the concerned thread
  ##  @return      Thread name

proc enable*(u32EnableThreads: orxU32; u32DisableThreads: orxU32): orxSTATUS {.
    cdecl, importc: "orxThread_Enable", dynlib: libORX.}
  ## Enables / disables threads
  ##  @param[in]   _u32EnableThreads   Mask of threads to enable (1 << ThreadID)
  ##  @param[in]   _u32DisableThreads  Mask of threads to disable (1 << ThreadID)
  ##  @return orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getCurrent*(): orxU32 {.cdecl, importc: "orxThread_GetCurrent",
                                    dynlib: libORX.}
  ## Gets current thread ID
  ##  @return      Current thread ID

proc threadYield*() {.cdecl, importc: "orxThread_Yield", dynlib: libORX.}
  ## Yields to other threads

proc createSemaphore*(u32Value: orxU32): ptr orxTHREAD_SEMAPHORE {.cdecl,
    importc: "orxThread_CreateSemaphore", dynlib: libORX.}
  ## Inits a semaphore with a given value
  ##  @param[in]   _u32Value                             Value with which to init the semaphore
  ##  @return      orxTHREAD_SEMAPHORE / nil

proc deleteSemaphore*(pstSemaphore: ptr orxTHREAD_SEMAPHORE): orxSTATUS {.
    cdecl, importc: "orxThread_DeleteSemaphore", dynlib: libORX.}
  ## Deletes a semaphore
  ##  @param[in]   _pstSemaphore                         Concerned semaphore
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc waitSemaphore*(pstSemaphore: ptr orxTHREAD_SEMAPHORE): orxSTATUS {.
    cdecl, importc: "orxThread_WaitSemaphore", dynlib: libORX.}
  ## Waits for a semaphore
  ##  @param[in]   _pstSemaphore                         Concerned semaphore
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc signalSemaphore*(pstSemaphore: ptr orxTHREAD_SEMAPHORE): orxSTATUS {.
    cdecl, importc: "orxThread_SignalSemaphore", dynlib: libORX.}
  ## Signals a semaphore
  ##  @param[in]   _pstSemaphore                         Concerned semaphore
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc runTask*(pfnRun: orxTHREAD_FUNCTION; pfnThen: orxTHREAD_FUNCTION;
                       pfnElse: orxTHREAD_FUNCTION; pContext: pointer): orxSTATUS {.
    cdecl, importc: "orxThread_RunTask", dynlib: libORX.}
  ## Runs an asynchronous task and optional follow-ups
  ##  @param[in]   _pfnRun                               Asynchronous task to run, executed on a different thread dedicated to tasks, if nil defaults to an empty task that always succeed
  ##  @param[in]   _pfnThen                              Executed (on the main thread) if Run does *not* return orxSTATUS_FAILURE, can be nil
  ##  @param[in]   _pfnElse                              Executed (on the main thread) if Run returns orxSTATUS_FAILURE, can be nil
  ##  @param[in]   _pContext                             Context that will be transmitted to all the task functions
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

proc getTaskCount*(): orxU32 {.cdecl, importc: "orxThread_GetTaskCount",
                                      dynlib: libORX.}
  ## Gets number of pending asynchronous tasks awaiting full completion (might pump task notifications if called from main thread)
  ##  @return      Number of pending asynchronous tasks

proc setCallbacks*(pfnStart: orxTHREAD_FUNCTION;
                            pfnStop: orxTHREAD_FUNCTION; pContext: pointer): orxSTATUS {.
    cdecl, importc: "orxThread_SetCallbacks", dynlib: libORX.}
  ## Sets callbacks to run when starting and stopping new threads
  ##  @param[in]   _pfnStart                             Function to run whenever a new thread is started
  ##  @param[in]   _pfnStop                              Function to run whenever a thread is stopped
  ##  @param[in]   _pContext                             Context that will be transmitted to each callback
  ##  @return      orxSTATUS_SUCCESS / orxSTATUS_FAILURE

