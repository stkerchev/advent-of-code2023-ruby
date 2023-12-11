# https://adventofcode.com/2023/day/11
# --- Day 11: Cosmic Expansion ---
require 'matrix'

def dist(galaxies, empty_rows, empty_columns, expansion)
  distances_sum = 0
  galaxies.each_with_index do |galaxy_1, current|
    galaxies[current..].each do |galaxy_2|
      next if galaxy_1 == galaxy_2
      row_exp_coefficient = empty_rows.select { |row| row.between?([galaxy_1[0], galaxy_2[0]].min, [galaxy_1[0], galaxy_2[0]].max) }.size * expansion
      col_exp_coefficient = empty_columns.select { |col| col.between?([galaxy_1[1], galaxy_2[1]].min, [galaxy_1[1], galaxy_2[1]].max) }.size * expansion
      distances_sum += (galaxy_1[0] - galaxy_2[0]).abs + row_exp_coefficient + (galaxy_1[1] - galaxy_2[1]).abs + col_exp_coefficient # manhattan distance
    end
  end
  distances_sum
end

# empty spaces
def find_empty_from(vector) = vector.each_with_index.map { |col, i| i unless col.include?('#') }.compact

input = File.read("#{File.dirname(__FILE__)}/day_11.input").split("\n").map { _1.split('') }
universe = Matrix[*input]

# collect all galaxies
galaxies = []
universe.row_vectors.each_with_index { |row, i| row.each_with_index { |col, j| galaxies << [i, j] if col == '#' } }

p dist(galaxies, find_empty_from(universe.row_vectors), find_empty_from(universe.column_vectors), 1) # 9639160
p dist(galaxies, find_empty_from(universe.row_vectors), find_empty_from(universe.column_vectors), 999_999) # 752936133304
