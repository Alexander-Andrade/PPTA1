require_relative 'grammar_classifier'

class Grammar

  attr_accessor :grammar_classifier
  delegate :valid?, to: :grammar_classifier

  def initialize(params)
    @T = params[:T]
    @N = params[:N]
    @P = params[:P]
    @S = params[:S]

    @grammar_classifier = GrammarClassifier.new(@P)
  end

end