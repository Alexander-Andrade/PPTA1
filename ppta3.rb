require 'csv'
require_relative 'finite_state_mashine'

begin
  fsm = FSM.new({
                  Q: %w(X Y Z I J K L N M),
                  T: %w(n m i j ! /),
                  H: %w(X),
                  Z: %w(N),
                  state_transition_file: 'state_transition_function.csv'
                })

  state_transition.ea do |row|
    puts row["A"]
  end

rescue => e
  puts e
  exit
end