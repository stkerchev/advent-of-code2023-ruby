# https://adventofcode.com/2023/day/5
# --- Day 5: If You Give A Seed A Fertilizer ---

def between?(input, start_r, end_r) = start_r <= input && input < end_r

def process(input, mappings)
  res = mappings.map { |m| input - (m[1] - m[0]) if between?(input, m[1], m[1] + m[2]) }
  res.compact.first ? res.compact.first : input
end

def calculate(seed, operation)
  soil = process(seed, operation[:to_soil])
  fertilizer = process(soil, operation[:to_fertilizer])
  water = process(fertilizer, operation[:to_water])
  light = process(water, operation[:to_light])
  temperature = process(light, operation[:to_temperature])
  humidity = process(temperature, operation[:to_humidity])
  process(humidity, operation[:to_location])
end

def parse_mapping(input_group) = input_group.split("\n")[1..].map { _1.split(" ").map(&:to_i) }.sort_by { |arr| arr[1] }

input = File.read("#{File.dirname(__FILE__)}/day_5.input").split("\n\n")
seeds = input[0].scan(/\d+/).map { _1.to_i }
operation = { :to_soil => parse_mapping(input[1]),
              :to_fertilizer => parse_mapping(input[2]),
              :to_water => parse_mapping(input[3]),
              :to_light => parse_mapping(input[4]),
              :to_temperature => parse_mapping(input[5]),
              :to_humidity => parse_mapping(input[6]),
              :to_location => parse_mapping(input[7]) }
p seeds.map { |seed| calculate(seed, operation) }.min # 51580674

# --- Part Two ---
def revert_process(input, mappings)
  res = mappings.map { |m| input + (m[1] - m[0]) if between?(input, m[0], m[0] + m[2]) }
  res.compact.first ? res.compact.first : input
end

def revert_calculate(location, operation)
  humidity = revert_process(location, operation[:to_location])
  temperature = revert_process(humidity, operation[:to_humidity])
  light = revert_process(temperature, operation[:to_temperature])
  water = revert_process(light, operation[:to_light])
  fertilizer = revert_process(water, operation[:to_water])
  soil = revert_process(fertilizer, operation[:to_fertilizer])
  revert_process(soil, operation[:to_soil])
end

# The first attempt starts with 0, the value 99750000 is for a quick test
(99750000...).each do |i|
  possible_seed = revert_calculate(i, operation)
  if seeds.each_slice(2).to_a.any? { |range| between?(possible_seed, range[0], range[0] + range[1]) }
    p "location #{i} => #{possible_seed}" # 99751240
    break
  end
end
