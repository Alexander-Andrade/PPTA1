require 'json'
require_relative 'grammar'

# G=(T, N, P, S)
# G=({Q, A, B, C, D}, {a, b, c, d}, P, Q)

grammar_definitin = JSON.load File.new("grammar.json")

puts grammar_definitin

grammar = Grammar.new({
                          T: grammar_definitin["T"],
                          N: grammar_definitin["N"],
                          P: grammar_definitin["P"],
                          S: grammar_definitin["S"]
                      })

puts grammar.context_free?