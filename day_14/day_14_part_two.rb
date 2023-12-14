# https://adventofcode.com/2023/day/14
# --- Day 14: Parabolic Reflector Dish ---

# --- Part Two ---
def tilt(line, size)
  correction = 0
  size.times do |i|
    break if i + correction >= size - 1
    if line[i + correction] == '.'
      (1..(size - (i + correction) - 1)).each do |k|
        if line[i + correction + k] == 'O'
          line[i + correction] = 'O'
          line[i + correction + k] = '.'
          break
        end
        if line[i + correction + k] == '#'
          correction += k
          break
        end
      end
    end
  end
  line
end

def spin_cycle(grid)
  columns = grid[0].size
  rows = grid.size
  # north
  columns.times do |c|
    moved_line = tilt(grid.map { _1[c] }, rows)
    rows.times { |r| grid[r][c] = moved_line[r] }
  end
  # west
  rows.times do |r|
    moved_line = tilt(grid[r], columns)
    columns.times { |c| grid[r][c] = moved_line[c] }
  end
  # south
  columns.times do |c|
    moved_line = tilt(grid.map { _1[c] }.reverse, rows)
    rows.times { |r| grid[r][c] = moved_line.reverse[r] }
  end
  # east
  rows.times do |r|
    moved_line = tilt(grid[r].reverse, columns)
    columns.times { |c| grid[r][c] = moved_line.reverse[c] }
  end
end

grid = File.read("#{File.dirname(__FILE__)}/day_14.input")
           .split("\n")
           .map { |chunk| chunk.lines.map { _1.chomp.chars }.flatten }

cache = {}
pattern = first_seen_index = 0
(1..200).each do |i|
  # 200 is enough to find the pattern and the first seen index
  spin_cycle(grid)
  position = grid.flatten.join
  if cache.key? position
    first_seen_index = cache[position][0]
    pattern = i - first_seen_index
    break
  else
    cache[position] = [i, grid.map(&:clone)]
  end
end

index = ((1_000_000_000 - first_seen_index) % pattern) + first_seen_index
cache.each do |_k, v|
  if v[0] == index
    result = 0
    grid = v[1]
    row_index = grid.size
    grid.each do |line|
      rocks = line.count('O')
      result += rocks * row_index
      row_index -= 1
    end
    p result # 95273
  end
end
