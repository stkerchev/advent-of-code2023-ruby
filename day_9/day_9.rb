# https://adventofcode.com/2023/day/9
# --- Day 9: Mirage Maintenance ---

class Sensor
  def initialize(history)
    @difference = [history.split(' ').map(&:to_i)]
    calculate_difference
  end

  def prediction = @difference.sum(&:last)

  def backwards_prediction
    first = @difference.map(&:first) << 0
    calculated = []
    first.reverse!.each_with_index { |element, index| calculated << element - (calculated[index - 1] || 0) }
    calculated.last
  end

  private

  def calculate_difference
    new_steps = calculate @difference[0]
    until new_steps.all? { |e| e == 0 }
      @difference << new_steps
      new_steps = calculate new_steps
    end
  end

  def calculate(steps)
    calculated = []
    steps.each_cons(2) { |a, b| calculated << b - a }
    calculated
  end

end

input = File.read("#{File.dirname(__FILE__)}/day_9.input").split("\n")
sensors = input.map { |line| Sensor.new(line) }
p sensors.map(&:prediction).sum # 1834108701
p sensors.map(&:backwards_prediction).sum # 993

