fs   = require 'fs'
path = require 'path'
_    = require 'underscore'
argv = require('yargs').argv

FrozenTrie = require './inc/FrozenTrie'
Combinatorics = require 'js-combinatorics'

class Solver
  scores: JSON.parse fs.readFileSync path.resolve('./data/scores.json'), 'utf-8'
  results: []
  data: JSON.parse fs.readFileSync path.resolve('./data/dict.json'), 'utf-8'
  constructor: (input = 'test') ->
    if typeof input is 'string' then input = input.split ''
    @trie = new FrozenTrie @data.trie, @data.directory, @data.nodeCount
    @perms = Combinatorics.permutationCombination input
  calculate: () ->
    @started = Date.now()
    while y = @perms.next()
      z = y.join ''
      if !~@results.indexOf(z) and @trie.lookup z
        @results.push [z, @getScore(z)]
    @ended = Date.now()
  getResults: () ->
    return @results
  getTime: () ->
    return (@ended - @started) / 1000
  getScore: (word) ->
    score = 0
    word.split('').forEach (letter) =>
      score += @scores[letter.toUpperCase()]
    return score

solver = new Solver argv._[0]

solver.calculate()

console.log solver.getResults()
console.log 'Time taken: ' + solver.getTime()
