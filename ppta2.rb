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
  p nfa.F
  p nfa.Z
  puts;puts;
  dfa = DFA.new(nfa)
  p dfa.Q
  puts;
  p dfa.states_map
  puts;
  p dfa.F
  p dfa.Z
rescue => e
  puts e
  exit
end