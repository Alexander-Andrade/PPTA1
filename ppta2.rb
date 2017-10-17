require_relative 'grammar'
require_relative 'finite_state_mashine'

# G=(T, N, P, S)
# G=({X, Y, Z, W, V}, {0, 1, ~, #, &}, P, X)

begin
  raw_rules = IO.readlines(ARGV[0])

  grammar = Grammar.new({
                            T: %w(0 1 ~ # &),
                            N: %w(X Y Z W V),
                            P: raw_rules,
                            S: "X"
                        })

  nfa = NFA.new(grammar)
  nfa.output("nfa")
  nfa.console

  2.times { puts }

  dfa = DFA.new(nfa)
  dfa.output("dfa")
  dfa.console

rescue => e
  puts e
  exit
end