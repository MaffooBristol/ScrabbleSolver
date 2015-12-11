util  = require 'util'
_     = require 'underscore'
argv  = require('yargs').array('a').argv

Solver = require './solver'

solver = new Solver argv._[0]

solver.calculate (err, results) ->

  @findEndHooks results, argv.a, (err) =>
    @findCrossHooks results, argv.a, (err) =>

      console.log util.inspect results, false, null

      maxScore = _.max _.pluck results, 'score'
      topWords = _.where results, score: maxScore
      topWords = _.pluck(topWords, 'word')

      placements = []
      results.forEach (result) ->
        result.placements.forEach (placement) ->
          p = _.extend {}, placement
          p.word = result.word
          placements.push p

      if placements.length
        # placements = _.pluck results, 'placements'
        placements = _.sortBy placements, (placement) -> placement.scoreNew
        console.log _.last placements, 20


      console.log "I would suggest you choose #{topWords.join ' or '} (#{maxScore}pts)."
      # console.log _.max results, (a) -> return a.score
      console.log 'Time taken: ' + solver.getTime()
