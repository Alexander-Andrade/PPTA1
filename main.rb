begin
  lines = IO.readlines(ARGV[0])
rescue => e
  puts e
  exit
end

class Grammar

  RULE = /^(?<left>[a-z]+)->(?<right>[a-zλ]+(\|[a-zλ]+)*)$/i

  def initialize(lines)
    @lines = lines
    trim
    raise StandardError, "Given grammar contains errors" unless valid?
  end


  private

  def trim
    @lines.each { |line| line.gsub!(/\s+/,'') }
  end

  def valid?
    @lines.all { |line| !RULE.match(line).nil? }
  end

  def parse

  end

end



#test.gsub!(/\s+/,'')
# test = "aA->bB|aB|cCD|cA|aA"
#
# match_data = RULE.match(test)
# puts(match_data.nil?)
# puts(match_data[:left])
# puts(match_data[:right])
#
# rules = Hash.new