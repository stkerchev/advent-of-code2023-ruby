# https://adventofcode.com/2023/day/7
# --- Day 7: Camel Cards ---

class Hand
  CARTS = %w[2 3 4 5 6 7 8 9 T J Q K A].freeze
  attr_accessor :carts, :bid, :strength

  def initialize(input)
    @carts = input[0..4].split('')
    @strength = calculate_strength count_equal_elements @carts
    @bid = input.scan(/ (\d+)/).map(&:first).map(&:to_i).first
  end

  def carts_index = CARTS

  def <=>(other)
    if other.strength < self.strength
      1
    elsif other.strength == self.strength
      @carts.each_with_index do |cart, index|
        if carts_index.index(cart) > carts_index.index(other.carts[index])
          return 1
        elsif carts_index.index(cart) < carts_index.index(other.carts[index])
          return -1
        end
      end
    else
      -1
    end
  end

  def count_equal_elements(cards) = cards.tally

  def calculate_strength(grouped_cards)
    return 1 if grouped_cards.size == 5 # high card
    return 2 if grouped_cards.size == 4 # One pair
    return 3 if grouped_cards.size == 3 && grouped_cards.none? { |_k, v| v == 3 } # Two pair
    return 4 if grouped_cards.size == 3 && grouped_cards.one? { |_k, v| v == 3 } # Three of a kind
    return 5 if grouped_cards.size == 2 && grouped_cards.none? { |_k, v| v == 4 } # Full house
    return 6 if grouped_cards.size == 2 && grouped_cards.one? { |_k, v| v == 4 } # Four of a kind
    7 if grouped_cards.size == 1 # Five of a kind
  end
end

class HandWithJoker < Hand
  CARTS_WITH_JOKER = %w[J 2 3 4 5 6 7 8 9 T Q K A].freeze

  def carts_index = CARTS_WITH_JOKER

  def count_equal_elements(cards)
    return transform_joker(cards.tally) if cards.include?('J') && !cards.all? { _1 == 'J' }
    cards.tally
  end

  def transform_joker(equal_elements)
    number_of_jokers = equal_elements.delete('J')
    biggest_group_counter = equal_elements.values.max
    groups = equal_elements.filter { |_k, v| v == biggest_group_counter }.to_a
    group_index = groups.size > 1 ? groups.max { |a, b| carts_index.index(a[0]) <=> carts_index.index(b[0]) }[0] : groups[0][0]
    equal_elements[group_index] = biggest_group_counter + number_of_jokers
    equal_elements
  end

end

input = File.read("#{File.dirname(__FILE__)}/day_7.input").split("\n")
part_1_result, part_2_result = 0, 0
input.map { Hand.new(_1) }.sort.each_with_index { |hand, index| part_1_result += (hand.bid * (index + 1)); }
input.map { HandWithJoker.new(_1) }.sort.each_with_index { |hand, index| part_2_result += (hand.bid * (index + 1)); }
p part_1_result # 248453531
p part_2_result # 248781813
