require_relative 'grammar'

# G=(T, N, P, S)
# G=({Q, A, B, C, D}, {a, b, c, d}, P, Q)

raw_rules = IO.readlines("grammar_rules.txt")

grammar = Grammar.new({
                          T: %w(a b c d),
                          N: %w(Q A B C D),
                          P: raw_rules,
                          S: "X"
                      })
