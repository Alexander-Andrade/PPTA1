require 'csv'
require_relative 'finite_state_mashine'

begin
  fsm = FSM.new({
                  H: %w(X),
                  Z: %w(N),
                  state_transition_file: 'state_transition_function.csv'
                })

  fsm.console
rescue => e
  puts e
  exit
end