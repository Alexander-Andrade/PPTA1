require_relative 'grammar_mixin'

class PushdownAutomaton
  include GrammarMixin
  # M = (Q, T, N, F, q0, N0, Z)

  attr_accessor :Q, :q0, :Z, :N, :T, :N0, :F

  def initialize(grammar)
    @grammar = grammar
    raise StandardError, 'grammar is not a context free one' unless grammar.context_free?

    @Q = ['q']
    @q0 = 'q'
    @Z = []
    @N = @grammar.T + @grammar.N
    @T = @grammar.T
    @N0 = @grammar.S

    @F = {}


    @q = @q0
    form_store_functions
    load_init_configuration
  end

  def load_init_configuration
    @head = 0
    @stack = [@N0]
    @str = ''
  end

  def form_store_functions
    @grammar.rules.each do |left_nonterm, right_rules|
      key = [@q, 'ε', left_nonterm]
      @F[key] = []
      right_rules.each do |rule|
        @F[key].push([@q, rule])
      end
    end

    @grammar.T.each do |term|
      key = [@q, term, term]
      @F[key] = [@q, 'ε']
    end
  end

  def recognize(str)
    @str = str
  end

  private

  def string_remainder
    @str[@head..-1]
  end

  def configuration
    [@q, string_remainder, @stack.dup]
  end

  def nonterm_on_top?
    /^#{GrammarMixin::N}$/ === @stack.last
  end

  def rule_term_chain(rule)
    GrammarMixin::T.match(rule)
  end

  def rules_with_nonterms(rules)
    rules.select { |rule| /^#{GrammarMixin::T}+#{GrammarMixin::N}+/ === rule }
  end

  def possible_rules(rules)
    str_remainder = string_remainder
    rules_with_nonterms(rules).select { |rule| str_remainder.start_with? rule_term_chain(rule) }
    rules_with_nonterms.sort_by(&:length)
  end

  def choose_rule
    str_remainder = string_remainder
    rules = @F[@stack.last]

    exact_term_rule = rules.find { |rule| rule == str_remainder }
    return exact_term_rule unless exact_term_rule.nil?

    rules_pretenders = possible_rules(rules)

  end

  def replace_nonterm_with_rule

  end

  def recognition_step
    if nonterm_on_top?

    end
  end

end