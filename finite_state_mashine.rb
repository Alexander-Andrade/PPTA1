class FSM

  # Q - states set
  # T - input symbols set
  # F - transition func QxT
  # H - initial states set
  # Z - finish states set

  def initialize(grammar)
    @grammar = grammar

    @Q = []
    @T = []
    @F = []
    @H = []
    @Z = []
  end

  def build_nondeterministic

  end



  def new_N
    @new_N ||= (('A'..'Z').to_a - @grammar.N)[0]
  end

  def complete_grammar_with_new_N
    @grammar.rules.each do |left_chain, right_rules|
      simple_rules = right_rules.select { |r| r =~ /#{T}/ }
    end
  end

  private

end