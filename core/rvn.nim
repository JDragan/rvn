# rvn - micro web framework

import asynchttpserver, asyncdispatch
import sugar
import ../router

export asynchttpserver, asyncdispatch
export sugar
export router


type RvnConfig* = object
  appName*:   string
  port*:      Port
  address*:   string
  reusePort*: bool

proc newRvnConfig*(
  port =      3000,
  appName =   "",
  address =   "",
  reusePort = false
) : RvnConfig =
  echo "Server started on port " & $port
  RvnConfig(
    appName: appName,
    port: Port(port),
    address: address,
    reusePort: reusePort
  )

type Rvn* = object
  RvnConfig*:   RvnConfig
  router*:     Router
  httpServer*: AsyncHttpServer

func findRoute*(
  this: Router,
  path: string
) : Handler =
  for route in this.routes.items:
    if route.path == path:
      return route.handler
  return notFoundHandler

proc handleRequest*(
  this: Rvn,
  req: Request
) : Future[void] =
  let hnd = this.router.findRoute(req.url.path)
  return hnd(req)

proc initApp*(RvnConfig: RvnConfig = newRvnConfig()): Rvn =
    Rvn(RvnConfig: RvnConfig)

proc run*(this: var Rvn) =

  let Rvn = this
  this.httpServer  = newAsyncHttpServer(reusePort=false)

  let serveFuture = this.httpServer.serve(
    this.RvnConfig.port,
    (req: Request) => handleRequest(Rvn, req),
    this.RvnConfig.address
  )

  asyncCheck(serveFuture)
  runForever()
