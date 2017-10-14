require_relative 'grammar_classifier'
require_relative 'grammar_regexp'
require 'forwardable'

class Grammar
  extend Forwardable
  include GrammarRegexp

  attr_accessor :T, :N, :P, :S ,:grammar_classifier
  def_delegators :@grammar_classifier, :regular?

  def initialize(params)
    @T = params[:T]
    @N = params[:N]
    @P = params[:P]
    @S = params[:S]

    trim
    raise StandardError, "Grammar contains errors" unless valid?

    @grammar_classifier = GrammarClassifier.new(@P)
  end

  def valid?
    @P.all? { |line| !RULE.match(line).nil? }
  end

  private

  def trim
    @P.each { |line| line.gsub!(/\s+/,'') }
  end

end