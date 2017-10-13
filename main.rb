class Grammar

  RULE = /^(?<left>[a-z]+)->(?<right>[a-zλ]+(\|[a-zλ]+)*)$/i

  def initialize(lines)
    @lines = lines
    @rules = Hash.new { |hash, key|  hash[key] = Array.new }
    trim
    raise StandardError, "Given grammar contains errors" unless valid?
    parse
  end

  private

  def trim
    @lines.each { |line| line.gsub!(/\s+/,'') }
  end

  def valid?
    @lines.all? { |line| !RULE.match(line).nil? }
  end

  def parse
    @lines.each do |line|
      match_data = RULE.match(line)
      left = match_data[:left]
      right = match_data[:right].split('|')
      @rules[left].push(*right)
      puts("left #{left}, right #{right} rule #{@rules[left]}")
    end
  end

end

begin
  lines = IO.readlines(ARGV[0])

  grammar = Grammar.new(lines)
rescue => e
  puts e
  exit
end