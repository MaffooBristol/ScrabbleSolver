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
    @perms = Combinatorics.permutationCombination @input
  calculate: (callback) ->
    @started = Date.now()
    perm = @perms.toArray()
    async.each perm, (wordArray, cb) =>
      word = wordArray.join ''
      if !~_.pluck(@results, 'word').indexOf(word) and @checkDict word
        @results.push word: word, score: @getScore(word)
      cb()
    , (err) =>
      @ended = Date.now()
      callback err, @results
  getResults: () ->
    return @results
  getTime: () ->
    return (@ended - @started) / 1000
  getScore: (word) ->
    score = 0
    word.split('').forEach (letter) =>
      score += @scores[letter.toUpperCase()]
    return score
  checkDict: (word) ->
    return @trie.lookup word

