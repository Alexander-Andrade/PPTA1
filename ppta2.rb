require_relative 'grammar'

# G=(T, N, P, S)
# G=({X, Y, Z, W, V}, {0, 1, ~, #, &}, P, X)

begin
  raw_rules = IO.readlines(ARGV[0])

  grammar = Grammar.new({
                            T: %w(X Y Z W V),
                            N: %w(0 1 ~ # &),
                            P: raw_rules,
                            S: "X"
                        })

  puts(grammar.valid?)
  puts(grammar.regular?)
rescue => e
  puts e
  exit
end