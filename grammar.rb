require_relative 'grammar_classifier'
require_relative 'grammar_regexp'
require 'forwardable'

class Grammar
  extend Forwardable
  include GrammarRegexp

  attr_accessor :T, :N, :P, :S ,:grammar_classifier, :rules
  def_delegators :@grammar_classifier, :regular?, :right_regular?, :classify

  def initialize(params)
    @T = params[:T]
    @N = params[:N]
    @P = params[:P]
    @S = params[:S]

    trim_spaces_in_rules
    raise StandardError, "Grammar contains errors" unless valid?

    @rules = parse_rules
    @grammar_classifier = GrammarClassifier.new(self)
  end

  def valid?
    @P.all? { |line| !RULE.match(line).nil? }
  end

  def parse_rules
    rules = Hash.new { |hash, key|  hash[key] = Array.new }
    @P.each do |line|
      match_data = RULE.match(line)
      left = match_data[:left]
      right = match_data[:right].split('|')
      rules[left].push(*right)
    end
    rules
  end

  private

  def trim_spaces_in_rules
    @P.each { |line| line.gsub!(/\s+/,'') }
  end

end