require_relative 'grammar_mixin'

class FSM
  include GrammarMixin
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
    @F = Hash.new { |hash, key|  hash[key] = Hash.new }
    @H = []
    @Z = []
  end

  def nfa
    complete_grammar_with_new_N
    form_state_sets
    rules_to_transition_function
    form_final_states
    process_init_grammar_sym
  end

  def dfa
    nfa
    return if deterministic?
    nfa_to_dfa
  end

  def nfa_to_dfa
    new_Q = Marshal.load(Marshal.dump(@Q))
    new_F = Hash.new { |hash, key|  hash[key] = Hash.new }
    new_Z = []
    states_map = {}

    states_map[@H] = generate_nonterm_in(new_Q)

    @T.each do |term|
      transition_set = []
      @H.each do |state|
        transition_set.push(*@F[state][term])
      end
      states_map[transition_set] = generate_nonterm_in(new_Q)
    end
  end

  def new_N
    @new_N ||= generate_nonterm(@grammar.N)
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
    @Q.push(*(@grammar.N + [new_N]))
    @T.push(*@grammar.T)
  end

  def rules_to_transition_function
    @rules.each do |left_nonterm, right_rules|
      right_rules.each do |right_rule|
        right_term = right_rule[0]
        right_nonterm = right_rule[1]
        @F[left_nonterm][right_term] = [] if @F[left_nonterm][right_term].nil?
        @F[left_nonterm][right_term] << right_nonterm
      end
    end
  end

  def form_final_states
    @Z.push(new_N) unless @new_N.nil?
  end

  def process_init_grammar_sym
    @Z.push(@grammar.S) if @grammar.rules[@grammar.S].include?('ε')
  end

  def has_void_chain_transitions?
    @rules.keys.all? { |left_nonterm| !@rules[left_nonterm].include?('ε') }
  end

  def has_state_transitions_with_one_sym?
    @rules.keys.any? do |left_nonterm|
      right_terms = @rules[left_nonterm].map { |rule| rule[0] }
      right_terms.uniq.length != right_terms.length
    end
  end

  def deterministic?
    !has_void_chain_transitions? && !has_state_transitions_with_one_sym?
  end

  private

end