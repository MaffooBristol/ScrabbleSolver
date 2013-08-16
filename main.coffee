rootPath = '/Users/matt/Documents/Programming/scrabblesolver/'

fs = require 'fs'
require rootPath + '/trie-js/dict/suffix.js'
args = process.argv.splice(2)

dict = fs.readFileSync rootPath + 'ospd3.txt', 'utf8'
dict = dict.split('\n')

sortWord = (_word) ->
    return _word.split('').sort().join('').toUpperCase()

getScore = (_word) ->
    return _word

findTrieWord = (word, cur) ->
    # Get the root to start from
    cur = cur || dict3

    # Go through every leaf
    for node of cur
        # If the start of the word matches the leaf
        if (word.indexOf(node) == 0)

            # If it's a number
            if (typeof cur[node] == "number" && cur[node])
                # Substitute in the removed suffix object
                val = dict3.$[cur[node]]
            else
                # Otherwise use the current value
                val = cur[node]

            # If this leaf finishes the word
            if (node.length == word.length)
                # Return 'true' only if we've reached a final leaf
                return val == 0 || val.$ == 0

            # Otherwise continue traversing deeper
            # down the tree until we find a match
            else
                return findTrieWord(word.slice(node.length), val)


    return false;

scores =
    1: ["E", "A", "I", "O", "N", "R", "T", "L", "S", "U"]
    2: ["D", "G"]
    3: ["B", "C", "M", "P"]
    4: ["F", "H", "V", "W", "Y"]
    5: ["K"]
    8: ["J", "X"]
    10: ["Q", "Z"]

availableTiles = ['A', 'T', 'U', 'A', 'F', 'A', 'J']

results = []

scrabble = (str, pos) ->

    if (pos == undefined)
        pos = 0

    for dictWord, i in dict

        if (sortWord(dictWord) == sortWord(str))
            score = getScore(dictWord)
            results.push dict[i]
        # scrabble(str, pos + 1)

scrabble(args[0])

console.log findTrieWord(args[0])

# console.log results



console.log '\n---------\ncomplete!\n---------\n\n'
