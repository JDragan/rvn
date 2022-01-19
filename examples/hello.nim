import ../core/rvn

var app = initApp()

app.router.addRoute("/", "Hello multiverse!")
app.run() # Started on http://127.0.0.1:3000/
