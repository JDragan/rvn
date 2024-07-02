import asynchttpserver, asyncfutures
import serde


type Handler* = proc(req: Request): Future[void] {.gcsafe.}

type Route* = object
  path*: string
  handler*: Handler

type Router* = object
  routes*: seq[Route]
  staticroutes*: seq[string]


proc notFoundHandler*(req: Request): Future[void] =
  req.respond(Http404, "Not Found")

proc badRequestHandler*(req: Request): Future[void] =
  req.respond(Http400, "Bad Request")

proc addStatic*(
  this: var Router,
  path: string,
) {.gcsafe.} =
  this.staticroutes.add(path)

proc addRoute*(
  this: var Router,
  path: string,
  handler: Handler
) {.gcsafe.} =
  this.routes.add(Route(path: path, handler: handler))

proc addRoute*(
  this: var Router,
  path: string,
  response: string
) {.gcsafe.} =

  this.addRoute(path, proc(req: Request): Future[void] =

    echo path, " --- ", response
    req.respond(Http200, response)
  )

proc addRoute*[T](
  this: var Router,
  path: string,
  fn: proc,
  params: T
) {.gcsafe.} =

  this.addRoute(path, proc(req: Request): Future[void] {.gcsafe.} =
    echo params
    let paramObj = serde(req.url.query, params)

    if params.typeof is paramObj.typeof:
      req.respond(Http200, fn(paramObj))
    else:
      badRequestHandler(req)
  )

# dynamic routing
import utilities

proc addRoute*(
  this: var Router,
  path: string,
  fun: proc,
) {.gcsafe.} =

  var basepath = parse_url(path)
  echo path
  echo basepath

  this.addRoute(basepath, proc(req: Request): Future[void] {.gcsafe.} =
    # let paramObj = serde(req.url.query, params)
    let params = req.url.path.split_last('/', true)
    echo "query path params ", req.url.path
    echo "           params ", params
    let p2 = "---" & params


    if true:
      req.respond(Http200, fun(params, p2))
    else:
      badRequestHandler(req)
  )
