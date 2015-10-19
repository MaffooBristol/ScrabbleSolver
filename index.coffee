argv  = require('yargs').argv

Solver = require './solver'

solver = new Solver argv._[0]

solver.calculate (err, results) ->
  console.log results
  console.log 'Time taken: ' + solver.getTime()
