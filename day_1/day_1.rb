# https://adventofcode.com/2023/day/1
# --- Day 1: Trebuchet?! ---

input = File.read("#{File.dirname(__FILE__)}/day_1.input").split("\n")
# --- Part One ---
p input.map { |line| line.scan(/\d/) }.map { [_1[0], _1[-1]].join.to_i }.sum
# 53651

# --- Part Two ---
digits = %w(_ one two three four five six seven eight nine)
p input.sum { |line|
  first = line.scan(/#{digits.join('|')}|[1-9]/)[0] # first digit
  last = line.reverse.scan(/#{digits.map { _1.reverse }.join('|')}|[1-9]/)[0] # last digit
  [digits.index(first) || first, digits.index(last.reverse) || last].join.to_i
}
# 53894
