require_relative 'grammar'
require_relative 'finite_state_mashine'

# G=(T, N, P, S)
# G=({X, Y, Z, W, V}, {0, 1, ~, #, &}, P, X)

raw_rules = IO.readlines("regular_grammar.txt")

grammar = Grammar.new({
                          T: %w(0 1 ~ # &),
                          N: %w(X Y Z W V),
                          P: raw_rules,
                          S: "X"
                      })

nfa = NFA.new(grammar)
puts "is deterministic? #{nfa.deterministic?}"
nfa.output("nfa")
nfa.console

2.times { puts }

dfa = DFA.new(nfa)
dfa.output("dfa")
dfa.console
