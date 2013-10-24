{exec} = require "child_process"

REPORTER = "spec"

task "test", "run tests", ->
  exec "NODE_ENV=test
      ./node_modules/.bin/mocha
    ", (err, output) ->
    throw err if err
    console.log output

task "generate-js", ->
  exec "NODE_ENV=test
    ./node_modules/.bin/coffee
    --output lib src/*.coffee
  "

task "remove-js", ->
  exec "rm -rf lib/"
