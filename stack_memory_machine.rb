class StackMemoryMachine
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
    @stack = [@N0]
    @head = 0
    @q = @q0
    form_store_functions
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

  end

  private

  def configuration(str)
    [@q, str[@head..-1], @stack]
  end

end