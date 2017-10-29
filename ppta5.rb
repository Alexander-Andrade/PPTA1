require 'json'
require_relative 'grammar'
require_relative 'pushdown_automaton'

# G=(T, N, P, S)
# G=({Q, A, B, C, D}, {a, b, c, d}, P, Q)

grammar_definition = JSON.load File.new("grammar.json")
grammar = Grammar.new(grammar_definition)
pushdown_automaton = PushdownAutomaton.new(grammar)
puts pushdown_automaton.F
puts "is the string is accepted? #{pushdown_automaton.recognize('aca')}"