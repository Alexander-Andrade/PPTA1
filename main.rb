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
    @rules = Hash.new([])
    trim
    raise StandardError, "Given grammar contains errors" unless valid?
    parse
  end

  private

  def trim
    @lines.each { |line| line.gsub!(/\s+/,'') }
  end

  def valid?
    @lines.all { |line| !RULE.match(line).nil? }
  end

  def parse
    @lines.each do |line|
      match_data = RULE.match(line)
      left = match_data[:left]
      right = match_data[:right].split('|')
      @rules[left] << right
    end
  end

end

grammar = Grammar.new(lines)