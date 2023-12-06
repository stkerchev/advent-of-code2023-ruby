# https://adventofcode.com/2023/day/6
# --- Day 6: Wait For It ---
input = File.read("#{File.dirname(__FILE__)}/day_6.input").split("\n")

def check(seconds, time, distance) = (seconds * (time - seconds)) > distance

races = input.map { |line| line.scan(/\d+/).map(&:to_i) }
race_counter = []
races[0].each_with_index do |time, i|
  counter = 0
  race_counter << (0..time).map { counter += 1 if check(_1, time, races[1][i]) }.compact.max
end
p race_counter.reduce(:*) # 1660968

# --- Part Two ---
big_race = input.map { |line| line.scan(/\d+/).join('').to_i }
begin_limit, end_limit = 0, 0
big_race[0].times.each { begin_limit = _1 - 1; break if check(_1, big_race[0], big_race[1]) }
big_race[0].downto(0) { end_limit = _1; break if check(_1, big_race[0], big_race[1]) }
p end_limit - begin_limit # 26499773
