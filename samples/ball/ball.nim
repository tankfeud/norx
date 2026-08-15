import norx

var ball: ptr orxOBJECT

proc update(info: ptr orxCLOCK_INFO,
            ctx: pointer) {.cdecl.} =
  let dt = info.fDT.float32
  if isActive("MoveRight"):   # nim bools, nim strings
    let speed = newVector(340.0, 0.0)
    discard ball.setPosition(
      ball.getPosition() + speed * dt)  # value vectors

proc init(): orxSTATUS {.cdecl.} =
  discard viewportCreateFromConfig("MainViewport")
  ball = objectCreateFromConfig("Ball")
  clockRegister(clockGet(CLOCK_KZ_CORE), update,
                nil, MODULE_ID_MAIN,
                CLOCK_PRIORITY_NORMAL)

proc run(): orxSTATUS {.cdecl.} = STATUS_SUCCESS
proc exit() {.cdecl.} = discard

execute(init, run, exit)
