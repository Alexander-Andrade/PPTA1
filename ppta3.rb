require 'csv'
require_relative 'finite_state_mashine'

# begin
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
# rescue => e
#   puts e
#   exit
# end