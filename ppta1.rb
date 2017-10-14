require_relative 'grammar_classifier'

begin
  rules = IO.readlines(ARGV[0])

  grammar = GrammarClassifier.new(rules)
  puts(grammar.classify)
rescue => e
  puts e
  exit
end