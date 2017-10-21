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

  def minimize

  end

  def console
    puts "Q: #{@Q}"
    puts "T: #{@T}"
    puts "F: #{@F}"
    puts "H: #{@H}"
    puts "Z: #{@Z}"
  end

  def eliminate_unreachable_states
    @reachable_states = [@H]
    traverse_states(@H)
    unreachable = @Q - @reachable_states
    @Q = @Q & @reachable_states
    @Z = @Z & @reachable_states
    unreachable.each { |state| @F.delete(state) }
  end

  def merge_equivalent_states
    @R = []
    @R[0] = []
    @R[0].push(@Z)
    @R[0].push((@Q - @Z))
    n = 1
    @R[n] = []

    while true do
      partition_matrix = buid_partition_matrix(@R[n-1])
      @R[n] = build_new_partition(partition_matrix)

      break if @R[n-1] == @R[n]

      n += 1
    end

    groups_states_map = get_groups_states_map(@R[n])
    puts groups_states_map
  end

  private

  def get_groups_states_map(partition)
    group_states_map = {}
    partition.each do |group|
      if group.length > 1
        group_states_map[group] = generate_nonterm_in(@Q)
      end
    end
    group_states_map
  end

  def equivalence_class(partition, state)
    partition.find_index { |set| set.include? state }
  end

  def buid_partition_matrix(partition)
    partition_matrix = Hash.new { |hash, key| hash[key] = Hash.new }
    @F.keys.each do |nonterm|
      partition_matrix[nonterm]
      @F[nonterm].keys.each do |term|
        partition_matrix[nonterm][term] = equivalence_class(partition, @F[nonterm][term])
      end
    end
    partition_matrix
  end

  def build_new_partition(partition_matrix)
    grouped = partition_matrix.keys.group_by{ |nonterm| partition_matrix[nonterm] }
    grouped.values
  end

  def traverse_states(state)
    @F[state].each do |term, new_state|
      unless @reachable_states.include? new_state
        @reachable_states.push(new_state)
        traverse_states(new_state)
      end
    end
  end

  def state_transition_function_from_csv
    state_transition = CSV.read('state_transition_function.csv',
                                headers:true, col_sep: ' ', skip_blanks: true)

    @Q = Marshal.load(Marshal.dump(state_transition.headers))[1..-1]
    @T = Marshal.load(Marshal.dump(state_transition['F']))

    @Q.each do |nonterm|
      @T.each_with_index do |term, i|
        value =state_transition[nonterm][i]
        unless value == 'ø'
          @F[nonterm][term] = value
        end
      end
    end
  end

  def generate_nonterm(set)
    (('A'..'Z').to_a - set)[0]
  end

  def generate_nonterm_in(set)
    nonterm = generate_nonterm(set)
    set << nonterm
    nonterm
  end

end