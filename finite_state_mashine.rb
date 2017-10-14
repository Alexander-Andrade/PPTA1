require_relative 'grammar_regexp'

class FSM
  include GrammarRegexp
  # Q - states set
  # T - input symbols set
  # F - transition func QxT
  # H - initial states set
  # Z - finish states set

  attr_accessor :rules

  def initialize(grammar)
    @grammar = grammar
    @rules = @grammar.parse_rules

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
    @rules.each do |left_chain, right_rules|
      term_rules = right_rules.select { |r| r =~ /^#{T}$/ }
      nonterm_rules = right_rules - term_rules
      term_rules.each do |term_rule|
        unless nonterm_rules.find { |rules| rules =~ /^#{term_rule}#{N}$/ }
          right_rules.push("#{term_rule}#{new_N}")
        end
      end
    end
  end

  private

end