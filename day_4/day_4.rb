# https://adventofcode.com/2023/day/4
# --- Day 4: Scratchcards ---

def calculate_score(matched)
  return 0 if matched.size == 0
  return 1 if matched.size == 1
  2 ** (matched.size - 1) if matched.size > 1
end

input = File.read("#{File.dirname(__FILE__)}/day_4.input").split("\n")
cards = input.map { |card| card.gsub(/(\d+):/, "").split(' | ').map { _1.scan(/(\d+)|\|/).flatten.map(&:to_i) } }
p cards.sum { |card| calculate_score(card[0] & card[1]) } # 23847

# --- Part Two ---
cads_score = { 1 => 0 }
cards.each_with_index do |card, current_card|
  cads_score[current_card] = (cads_score[current_card] ||= 0) + 1
  current_card_times = cads_score[current_card]
  if current_card_times
    current_card_times.times do |_attempt|
      score = (card[0] & card[1]).size
      score.times do |i|
        processed_card = current_card + i + 1
        cads_score[processed_card] = (cads_score[processed_card] ||= 0) + 1
      end
    end
  end
end

p cads_score.sum { |_k, v| v } # 8570000
