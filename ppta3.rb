require 'csv'
require_relative 'finite_state_mashine'

fsm = FSM.new({
                H: "X",
                Z: %w(N),
                state_transition_file: 'state_transition_function.csv'
              })

fsm.console
fsm.output("graph")

2.times{ puts; }

fsm.minimize
fsm.console
fsm.output("minimized_graph")
puts "partition: #{fsm.partition}"
puts "group states map: #{fsm.group_states_map}"