require_relative 'grammar_classifier'
require 'forwardable'

class Grammar
  extend Forwardable

  attr_accessor :T, :N, :P, :S ,:grammar_classifier
  def_delegators :@grammar_classifier, :valid?

  def initialize(params)
    @T = params[:T]
    @N = params[:N]
    @P = params[:P]
    @S = params[:S]

    @grammar_classifier = GrammarClassifier.new(@P)
  end

end