# frozen_string_literal: true

# Creates a comparable card
class Card
  include Comparable

  attr_reader :rank, :suit, :value

  VALUES = {
    '2' => 2,
    '3' => 3,
    '4' => 4,
    '5' => 5,
    '6' => 6,
    '7' => 7,
    '8' => 8,
    '9' => 9,
    '10' => 10,
    'J' => 11,
    'Q' => 12,
    'K' => 13,
    'A' => 14
  }.freeze

  def initialize(rank:, suit:)
    @rank = rank
    @suit = suit
    @value = VALUES[rank]
  end

  def display_name
    "#{rank} of #{suit}"
  end

  def <=>(other)
    value <=> other.value
  end
end
