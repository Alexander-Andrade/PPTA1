require_relative 'grammar_regexp'

class FSM
  include GrammarRegexp
  # Q - states set
  # T - input symbols set
  # F - transition func QxT
  # H - initial states set
  # Z - finish states set

  attr_accessor :rules, :Q, :T, :F, :H, :Z

  def initialize(grammar)
    @grammar = grammar
    @rules = @grammar.parse_rules
    raise StandardError, 'Grammar is not right-regular' unless @grammar.right_regular?
    @Q = []
    @T = []
    @F = Hash.new
    @H = []
    @Z = []
  end

  def build_nondeterministic
    complete_grammar_with_new_N
    form_state_sets
    rules_to_transition_function
  end

  def new_N
    @new_N ||= (('A'..'Z').to_a - @grammar.N)[0]
  end

  def complete_grammar_with_new_N
    @rules.each do |nonterm, right_rules|
      term_rules = right_rules.select { |r| r =~ /^#{T}$/ }
      nonterm_rules = right_rules - term_rules
      term_rules.each do |term_rule|
        unless nonterm_rules.find { |rules| rules =~ /^#{term_rule}#{N}$/ }
          right_rules.push("#{term_rule}#{new_N}")
        end
      end
    end
  end

  def form_state_sets
    @H.push(*@grammar.S)
    @Q.push(*(@grammar.N + new_N))
    @T.push(*@grammar.T)
  end

  def rules_to_transition_function
    @rules.each do |left_nonterm, right_rules|
      right_rules.each do |right_rule|
        term = right_rule[0]
        right_nonterm = right_rule[1]
        @F[left_nonterm][term] = right_nonterm
      end
    end
  end

  private

end