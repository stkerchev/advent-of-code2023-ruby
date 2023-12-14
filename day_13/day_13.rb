# https://adventofcode.com/2023/day/13
# --- Day 13: Point of Incidence ---

def mirror_index(lines, need)
  index = 1.upto(lines.size - 1).find do |i|
    filtered = lines[...i].reverse.zip(lines.drop(i)).filter { |_first, second| second }
    result = filtered.sum { |first, second| first.zip(second).count { |x, y| x != y } }
    result == need
  end
  index || 0
end

def calculate(grid, target)
  mirror_index(grid, target) * 100 + mirror_index(grid.transpose, target)
end

grids = File.read("#{File.dirname(__FILE__)}/day_13.input")
            .split("\n\n")
            .map { _1.split("\n").map { |line| line.split('') } }

p grids.sum { |grid| calculate(grid, 0) } # 40006
p grids.sum { |grid| calculate(grid, 1) } # 28627