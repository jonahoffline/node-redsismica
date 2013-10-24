fs   = require 'fs'

module.exports.openFixture = (file, callback) ->
  fs.readFile __dirname.concat("/fixtures/#{file}.html"), 'utf-8', (err, data) ->
    return callback err, data unless err

