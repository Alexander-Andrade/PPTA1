require_relative 'grammar_classifier'

begin
  lines = IO.readlines(ARGV[0])

  grammar = GrammarClassifier.new(lines)
  puts(grammar.rules)
  puts(grammar.classify)
  puts("regular: #{grammar.regular?}")
rescue => e
  puts e
  exit
end