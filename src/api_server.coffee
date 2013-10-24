http       = require 'http'
RedSismica = require './redSismica'

redSismica = new RedSismica

http.createServer( (req, res) ->
  res.writeHead 200, { 'Content-Type': 'application/json'}
  redSismica.fetchEvents (data) ->
    res.end(JSON.stringify(data, null, 4))
).listen(4000)
