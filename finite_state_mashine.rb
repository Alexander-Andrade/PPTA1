require_relative 'graph_drawer'

class FSM
  extend Forwardable
  # Q - states set
  # T - input symbols set
  # F - transition func QxT
  # H - initial states set
  # Z - finish states set

  def_delegators :@graph_drawer, :output
  attr_accessor :rules, :Q, :T, :F, :H, :Z

  def initialize(params)
    @state_transition_file = params[:state_transition_file]

    @F = Hash.new { |hash, key| hash[key] = Hash.new }
    @H = params[:H]
    @Z = params[:Z]

    state_transition_function_from_csv

    @graph_drawer = GraphDrawer.new(self)
  end

  def console
    puts "Q: #{@Q}"
    puts "T: #{@T}"
    puts "F: #{@F}"
    puts "H: #{@H}"
    puts "Z: #{@Z}"
  end

  private

  def state_transition_function_from_csv
    state_transition = CSV.read('state_transition_function.csv',
                                headers:true, col_sep: ' ')

    @Q = Marshal.load(Marshal.dump(state_transition.headers))[1..-1]
    @T = Marshal.load(Marshal.dump(state_transition['F']))

    @Q.each do |nonterm|
      @T.each_with_index do |term, i|
        @F[nonterm][term] = state_transition[nonterm][i]
      end
    end
  end

end