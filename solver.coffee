fs    = require 'fs'
path  = require 'path'
_     = require 'underscore'
async = require 'async'

FrozenTrie    = require './inc/FrozenTrie'
Combinatorics = require 'js-combinatorics'

module.exports = class Solver
  scores: JSON.parse fs.readFileSync path.resolve('./data/scores.json'), 'utf-8'
  results: []
  data: JSON.parse fs.readFileSync path.resolve('./data/dict.json'), 'utf-8'
  constructor: (@input = 'test') ->
    if typeof @input is 'string' then @input = @input.split ''
    @trie = new FrozenTrie @data.trie, @data.directory, @data.nodeCount
  _calculate: (input, type, placements = [], callback) ->
    perms = Combinatorics.permutationCombination input
    perm = perms.toArray()
    async.each perm, (wordArray, cb) =>
      word = wordArray.join ''
      if !~_.pluck(@results, 'word').indexOf(word) and @checkDict word
        score = @getScore word
        async.each placements, (placement, cb2) ->
          placement.scoreNew = placement.score + score
          cb2()
        , () =>
          @results.push {word, score, type, placements}
          cb()
      else
        cb()
    , (err) =>
      @ended = Date.now()
      callback.bind(@)(err, @results)
  calculate: (callback) ->
    @started = Date.now()
    @_calculate @input, 0, null, (err, results) =>
      callback.bind(@)(err, @results)
  getResults: () ->
    return @results
  getTime: () ->
    return (@ended - @started) / 1000
  getScore: (word, lenMultipliers = false) ->
    score = 0
    word.split('').forEach (letter) =>
      score += @scores[letter.toUpperCase()]
    if lenMultipliers
      if word.length is 6 then score += 10
      if word.length is 7 then score += 20
      if word.length is 8 then score += 30
      if word.length > 8 then score += 40
    return score
  checkDict: (word) ->
    return @trie.lookup word
  getChildren: (word) ->
    return @trie.getChildren word
  findEndHooks: (results = [], lodgers = [], callback) ->
    lodgers.forEach (lodger) =>
      children = @getChildren lodger
      if !children then return
      results.forEach (result) =>
        children.forEach (child) =>
          letter = child.letter
          lodgerNew = lodger + letter
          if child.final and ~result.word.indexOf child.letter
            score = @getScore lodgerNew
            scoreNew = result.score + score
            result.placements.push {type: 'end', lodger, lodgerNew, letter, score, scoreNew}
    callback()
  findCrossHooks: (results = [], lodgers = [], callback) ->
    letters = _.sortBy _.uniq lodgers.join('').split('')

    async.each letters, (letter, cb) =>
      input = @input.concat [letter]
      placements = []
      lodgers.forEach (lodger) =>
        if ~lodger.indexOf letter
          score = @getScore lodger, false
          placements.push {type: 'cross', lodger, lodgerNew: false, letter, score, scoreNew: false}
      @_calculate input, 1, placements, () =>
        #
        cb()
    , (err, results) =>
      callback err, results

