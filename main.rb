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
    info = {class: 0, name: 'unrestricted grammar'}

  end

  def valid?
    @lines.all? { |line| !RULE.match(line).nil? }
  end

  alias unrestricted? valid?

  def noncontracting?
    @rules.all? { |left, right| left.length <= right.length }
  end

  def context_sensitive?

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
  puts(grammar.unrestricted?)
rescue => e
  puts e
  exit
end