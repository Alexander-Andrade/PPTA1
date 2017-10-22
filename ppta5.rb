require 'json'
require_relative 'grammar'
require_relative 'stack_memory_machine'

# G=(T, N, P, S)
# G=({Q, A, B, C, D}, {a, b, c, d}, P, Q)

grammar_definition = JSON.load File.new("grammar.json")
grammar = Grammar.new(grammar_definition)
stack_memory_machine = StackMemoryMachine.new(grammar)
puts stack_memory_machine.F