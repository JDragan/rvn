# rvn

A simple microframework written in [nim](https://nim-lang.org/) with zero dependencies.

Inspired by [Flask](https://github.com/pallets/flask), [httprouter](https://github.com/julienschmidt/httprouter) and [nest](https://github.com/kedean/nest).


## Example

```nim
import core/rvn

var app = initApp()

app.router.addRoute("/", "Hello multiverse!")
app.run() # Started on http://127.0.0.1:3000/

```
