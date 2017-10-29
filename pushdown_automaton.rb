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
    @cur_stack_id = 0
    @head = 0
    @stack = []
    @str = ''
    @rules_applied = []
    @configurations = []

    put_rule_on_top(@N0)
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

    begin
      while true
        if string_remainder.empty? && @stack.empty?
          return true
        else
          recognition_step
        end
      end
    rescue => e
      puts e.to_s
      return false
    end
  end

  def rules_applied
    @rules_applied.map { |rule| {rule[:left] => rule[:right] } }
  end

  private

  def string_remainder
    @str[@head..-1]
  end

  def input_char
    @str[@head]
  end

  def configuration
    [@q, string_remainder, @stack.dup]
  end

  def remember_config
    @configurations.push(configuration)
  end

  def load_prev_config
    @head = @str.rindex(@configurations.last[1])
    @stack = @configurations.last[2]
    @configurations.pop
  end

  def nonterm_on_top?
    /^#{GrammarMixin::N}$/ === @stack.last[:sym]
  end

  def term_on_top?
    /^#{GrammarMixin::T}$/ === @stack.last[:sym]
  end

  def rule_term_chain(rule)
    GrammarMixin::T.match(rule).to_a.first
  end

  def sorted_possible_rules(rules)
    str_remainder = string_remainder
    rules_with_nonterms = rules.select { |rule| /^#{GrammarMixin::T}+#{GrammarMixin::N}+/ === rule }
    rules_with_nonterms.select! { |rule| str_remainder.start_with? rule_term_chain(rule) }
    rules_with_nonterms.sort_by!(&:length).reverse!
  end

  def put_rule_on_top(rule)
    rule.chars.reverse_each do |sym|
      @stack.push({ id: @cur_stack_id, sym: sym })
      @cur_stack_id += 1
    end
  end

  def rules_for nonterm
    @grammar.rules[nonterm]
  end

  def save_applied_rule(rule)
    @rules_applied.push({ id: @stack.last[:id], left: @stack.last[:sym], right: rule })
  end

  def select_rule
    str_remainder = string_remainder
    rules = rules_for @stack.last[:sym]

    if (!@rules_applied.last.nil?) && (@rules_applied.last[:id] == @stack.last[:id])
      selected = chose_another_rule
    else
      selected = rules.find { |rule| rule == str_remainder }
      selected = 'ε' if str_remainder.empty? && rules.include?('ε')
      selected = sorted_possible_rules(rules)[0] if selected.nil?
    end
    selected
  end

  def replace_nonterm_with_rule
    selected_rule = select_rule

    if selected_rule.nil?
      load_prev_config
    else
      save_applied_rule(selected_rule)
      remember_config
      @stack.pop
      put_rule_on_top(selected_rule) if selected_rule != 'ε'
    end
  end

  def chose_another_rule
    unsuitable_rule = @rules_applied.pop
    possible_rules = sorted_possible_rules(rules_for(@stack.last[:sym]))
    ind = possible_rules.index(unsuitable_rule[:right]) + 1
    if ind >= possible_rules.length
      raise StandardError, 'all rules are unsuitable'
    end
    possible_rules[ind]
  end

  def process_term_on_top
    if input_char == @stack.last[:sym]
      @stack.pop
      @head += 1
    else
      load_prev_config
      chose_another_rule
    end
  end

  def recognition_step
    print_configuration
    if nonterm_on_top?
      replace_nonterm_with_rule
    elsif term_on_top?
      process_term_on_top
    end
  end

  def print_configuration
    config = configuration
    stack = @stack.map { |el| el[:sym] }
    puts "state: #{config[0].to_s.ljust(10)} remainder: #{config[1].ljust(30)} st: #{stack}"
  end

end