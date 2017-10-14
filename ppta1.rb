require 'grammar'

begin
  lines = IO.readlines(ARGV[0])

  grammar = Grammar.new(lines)
  puts(grammar.rules)
  puts(grammar.classify)
rescue => e
  puts e
  exit
end