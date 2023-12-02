# https://adventofcode.com/2023/day/2
# --- Day 2: Cube Conundrum ---

class Game
  def initialize(input)
    @game_id = input.scan(/\d+/).first.to_i
    @attempts = input[8..].split('; ')
    @patterns = { red: '(\d+) red', green: '(\d+) green', blue: '(\d+) blue' }
  end

  def possible
    test_game = ->(a) {
      return false if a =~ /#{@patterns[:red]}/ && $1.to_i > 12
      return false if a =~ /#{@patterns[:green]}/ && $1.to_i > 13
      return false if a =~ /#{@patterns[:blue]}/ && $1.to_i > 14
      true
    }
    @attempts.all?(&test_game) ? @game_id : 0
  end

  def fewest_number_of_cubes
    fewest = { red: 0, green: 0, blue: 0 }
    @attempts.each do |a|
      fewest[:red] = $1.to_i if a =~ /#{@patterns[:red]}/ && fewest[:red] < $1.to_i
      fewest[:green] = $1.to_i if a =~ /#{@patterns[:green]}/ && fewest[:green] < $1.to_i
      fewest[:blue] = $1.to_i if a =~ /#{@patterns[:blue]}/ && fewest[:blue] < $1.to_i
    end
    fewest.values.reduce(:*)
  end
end

input = File.read("#{File.dirname(__FILE__)}/day_2.input").split("\n")
games = input.map { |game_input| Game.new(game_input) }
p games.sum { |game| game.possible } # 2449
p games.sum { |game| game.fewest_number_of_cubes } # 63981
