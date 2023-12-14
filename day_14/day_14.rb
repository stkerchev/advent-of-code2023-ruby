# https://adventofcode.com/2023/day/14
# --- Day 14: Parabolic Reflector Dish ---
require 'matrix'

grids = File.read("#{File.dirname(__FILE__)}/day_14.input")
            .split("\n")
            .map { |chunk| chunk.lines.map { _1.chomp.chars }.flatten }

m = Matrix.rows(grids)
result = 0
m.column_count.times do |i|
  column = m.column(i).to_a
  multiply_index = column.size
  column.chunk_while { |a, _b| a != '#' }.to_a.each do |chunk|
    chunk_multiply_index = multiply_index
    chunk.count('O').times do |j|
      result += chunk_multiply_index
      chunk_multiply_index -= 1
    end
    multiply_index -= chunk.size
  end
end

p result # 108857
