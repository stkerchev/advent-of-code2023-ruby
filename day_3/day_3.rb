# https://adventofcode.com/2023/day/3
# --- Day 3: Gear Ratios ---

class EngineSymbol
  attr_reader :row, :col, :value

  def initialize(x, y, value)
    @row = x
    @col = y
    @value = value
  end

end

class EngineNumber
  attr_reader :digit

  def initialize(digit, engine_symbols)
    @digit = digit
    @contact_area = Set.new engine_symbols.map {
      |e| [e.row.to_s + '_' + e.col.to_s,
           ((e.row + 1).to_s + '_' + e.col.to_s),
           ((e.row + 1).to_s + '_' + (e.col + 1).to_s),
           ((e.row + 1).to_s + '_' + (e.col - 1).to_s),
           ((e.row - 1).to_s + '_' + e.col.to_s),
           ((e.row - 1).to_s + '_' + (e.col + 1).to_s),
           ((e.row - 1).to_s + '_' + (e.col - 1).to_s),
           (e.row.to_s + '_' + (e.col + 1).to_s),
           (e.row.to_s + '_' + (e.col - 1).to_s)] }.flatten
  end

  def adjacent_to_symbol?(symbols)
    @contact_area.any? { symbols.include?(_1) }
  end

end

input = File.read("#{File.dirname(__FILE__)}/day_3.input").split("\n").map { _1.split("") }

# parse digits
digits = []
input.each_index do |row_index|
  part_numbers_raw = []
  input[row_index].each_index do |col_index|
    value = input[row_index][col_index]
    part_numbers_raw << EngineSymbol.new(row_index, col_index, value) if value.match?(/\d/)
  end
  digits << part_numbers_raw
              .chunk_while { |current, next_el| current.col.to_i + 1 == next_el.col.to_i }
              .map { |chunk| EngineNumber.new(chunk.map { _1.value }.join.to_i, chunk) }
end

# parse symbols
symbols, gear_symbols = Set.new, Set.new
input.each_index do |row_index|
  input[row_index].each_index do |col_index|
    value = input[row_index][col_index]
    symbols << row_index.to_s + '_' + col_index.to_s unless value.match?(/\d|\./)
    gear_symbols << row_index.to_s + '_' + col_index.to_s if value.match?(/\*/)
  end
end

flatten_digits = digits.flatten
p flatten_digits.sum { |d| d.adjacent_to_symbol?(symbols) ? d.digit : 0 } # 546312

result = []
gear_symbols.each do |gear_symbol|
  contact_digit = flatten_digits.select { |d| d.adjacent_to_symbol?(Set.new([gear_symbol])) }.map { |d| d.digit }
  if contact_digit.size == 2
    result << contact_digit.inject(:*)
  end
end

p result.inject(:+) # 87449461
