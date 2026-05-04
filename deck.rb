# frozen_string_literal: true

require_relative 'card'

# Sets up, shuffles, and deals the deck
class Deck
  RANKS = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze
  SUITS = %w[clubs diamonds hearts spades].freeze

  def initialize
    @cards = RANKS.product(SUITS).map { |r, s| Card.new(rank: r, suit: s) }
    shuffle!
  end

  def deal_card
    @cards.pop
  end

  def empty?
    @cards.empty?
  end

  def shuffle!
    @cards.shuffle!
  end
end
