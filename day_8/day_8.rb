# https://adventofcode.com/2023/day/8
# --- Day 8: Haunted Wasteland ---
input = File.read("#{File.dirname(__FILE__)}/day_8.input").split("\n")

instructions = input[0].split('')
nodes = {}
input.drop(2).map { |line| line.scan(/([0-9A-Z]+)/).flatten }.map { |matched| nodes[matched[0]] = [matched[1], matched[2]] }

current = 'AAA'
s = instructions.size
(0...).each do |i|
  current = instructions[i % s] == 'R' ? nodes[current][1] : nodes[current][0]
  if current == 'ZZZ'
    p i + 1 # part 1 -> 22357
    break
  end
end

# --- Part Two ---
r = []
nodes.keys.select { _1 =~ /(\w+A)/ }.each do |node|
  (0...).each do |i|
    node = instructions[i % s] == 'R' ? nodes[node][1] : nodes[node][0]
    if node =~ /(\w+Z)/
      r << i + 1
      break
    end
  end
end

p r.reduce(:lcm) # 10371555451871
