# https://adventofcode.com/2023/day/10
# --- Day 10: Pipe Maze ---
require 'matrix'

def find_first_move(start_p, m)
  possible_first_moves = []
  possible_first_moves << [start_p[0], start_p[1] + 1] if %w[J 7 -].include? m[start_p[0], start_p[1] + 1] # check in right
  possible_first_moves << [start_p[0], start_p[1] - 1] if %w[L F -].include? m[start_p[0], start_p[1] - 1] # check in left
  possible_first_moves << [start_p[0] - 1, start_p[1]] if %w[| F &].include? m[start_p[0] - 1, start_p[1] + 1] # check in up
  possible_first_moves << [start_p[0] + 1, start_p[1]] # down
end

input = File.read("#{File.dirname(__FILE__)}/day_10.input").split("\n").map { _1.split('') }
m = Matrix[*input]
start_p = m.index('S')
visited = Set.new
visited << start_p.to_s
first_moves = find_first_move(start_p, m)
tile = first_moves[0] # one of two possible first moves

(1...).each do |i|
  visited << tile.to_s
  visited.delete(start_p.to_s) if i == 2
  current_value = m[tile[0], tile[1]]

  possible = []
  case current_value
  when '|' # | is a vertical pipe connecting north and south.
    possible = [tile[0] + 1, tile[1]] unless visited.include?([tile[0] + 1, tile[1]].to_s)
    possible = [tile[0] - 1, tile[1]] unless visited.include?([tile[0] - 1, tile[1]].to_s)
  when '-' # - is a horizontal pipe connecting east and west.
    possible = [tile[0], tile[1] + 1] unless visited.include?([tile[0], tile[1] + 1].to_s)
    possible = [tile[0], tile[1] - 1] unless visited.include?([tile[0], tile[1] - 1].to_s)
  when 'L' # L is a 90-degree bend connecting north and east.
    possible = [tile[0] - 1, tile[1]] unless visited.include?([tile[0] - 1, tile[1]].to_s)
    possible = [tile[0], tile[1] + 1] unless visited.include?([tile[0], tile[1] + 1].to_s)
  when 'J' # J is a 90-degree bend connecting north and west.
    possible = [tile[0] - 1, tile[1]] unless visited.include?([tile[0] - 1, tile[1]].to_s)
    possible = [tile[0], tile[1] - 1] unless visited.include?([tile[0], tile[1] - 1].to_s)
  when '7' # 7 is a 90-degree bend connecting south and west.
    possible = [tile[0] + 1, tile[1]] unless visited.include?([tile[0] + 1, tile[1]].to_s)
    possible = [tile[0], tile[1] - 1] unless visited.include?([tile[0], tile[1] - 1].to_s)
  else
    # F is a 90-degree bend connecting south and east.
    possible = [tile[0] + 1, tile[1]] unless visited.include?([tile[0] + 1, tile[1]].to_s)
    possible = [tile[0], tile[1] + 1] unless visited.include?([tile[0], tile[1] + 1].to_s)
  end

  if m[possible[0], possible[1]] == 'S'
    m[possible[0], possible[1]] = '-' # hardcoded to simplify the calculation
    visited << possible.to_s
    p "Found S at #{possible} and index 'i' #{i}  and farthest #{ (i + 1) / 2}" # 6823
    break
  end
  tile = possible
end

# Part 2
# all not visited are marked as 'O' and collected in an array
not_visited = []
m.to_a.each_with_index do |row, x|
  row.each_with_index do |_col, y|
    unless visited.include? [x, y].to_s
      m[x, y] = 'O'
      not_visited << [x, y]
    end
  end
end

# for each not visited count the number of borders
# odd number of borders is 'in' even number of borders is 'out'
result = not_visited.select do |pear|
  counted = m.row(pear[0]).to_a[(pear[1] + 1)..].tally
  element_f = counted['F'] ||= 0
  element_7 = counted['7'] ||= 0
  element_l = counted['L'] ||= 0
  element_j = counted['J'] ||= 0
  borders = [(element_f - element_7).abs, (element_l - element_j).abs].max + counted['|'] ||= 0
  borders > 0 && borders % 2 != 0
end

p result.size # 415
