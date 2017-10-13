class Grammar

  RULE = /^(?<left>[a-z]+)->(?<right>[a-zλ]+(\|[a-zλ]+)*)$/i

  attr_accessor :rules

  def initialize(lines)
    @lines = lines
    @rules = Hash.new { |hash, key|  hash[key] = Array.new }
    trim
    raise StandardError, "Given grammar contains errors" unless valid?
    parse
  end


  def classify
    info = {class: 0, name: 'unrestricted grammar'}

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
    end
  end

  alias :valid? :unrestricted?
  
  def noncontracting?
    @rules.all? { |left, right| left.length <= right.length }
  end

  def klass_2?

  end

end

begin
  lines = IO.readlines(ARGV[0])

  grammar = Grammar.new(lines)
  puts(grammar.rules)
rescue => e
  puts e
  exit
end