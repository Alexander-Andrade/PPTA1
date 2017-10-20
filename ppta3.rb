require 'csv'
require_relative 'finite_state_mashine'

begin
  fsm = FSM.new({
                  H: "X",
                  Z: %w(N),
                  state_transition_file: 'state_transition_function.csv'
                })

  fsm.console
  fsm.output("graph")

  2.times{ puts; }

  fsm.eliminate_unreachable_states
  fsm.merge_equivalent_states
  fsm.console
rescue => e
  puts e
  exit
end