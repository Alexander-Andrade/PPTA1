class Grammar

  RULE = /^(?<left>[a-z]+)->(?<right>[a-zλ]+(\|[a-zλ]+)*)$/i
  N = /[A-Z]/
  T = /[a-zλ]/

  attr_accessor :rules

  def initialize(lines)
    @lines = lines
    @rules = Hash.new { |hash, key|  hash[key] = Array.new }
    trim
    raise StandardError, "Given grammar contains errors" unless valid?
    parse
  end

  def classify
    info = Array.new
    info.push({class: 0, name: 'unrestricted grammar'})
    info.push({class: 1, name: 'noncontracting grammar'}) if noncontracting?
    info.push({class: 1, name: 'context-sensitive grammar'}) if context_sensitive?
    info
  end

  def valid?
    @lines.all? { |line| !RULE.match(line).nil? }
  end

  alias unrestricted? valid?

  def noncontracting?
    @rules.all? { |left, right| left.length <= right.length }
  end

  def context_sensitive?
    @rules.all? { |left, right| !N.match(left).nil? }
  end

  private

  def trim
    @lines.each { |line| line.gsub!(/\s+/,'') }
  end

  def parse
    @lines.each do |line|
      match_data = RULE.match(line)
      left = match_data[:left]
      right = match_data[:right].split('|')
      @rules[left].push(*right)
    end
  end

end

begin
  lines = IO.readlines(ARGV[0])

  grammar = Grammar.new(lines)
  puts(grammar.rules)
  puts(grammar.classify)
rescue => e
  puts e
  exit
end