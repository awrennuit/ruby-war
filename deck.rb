class Deck
  CARD_RANKS = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze
  SUITS = %w[C D H S].freeze

  def initialize
    @cards = CARD_RANKS.product(SUITS).map { |c, s| "#{c}#{s}" }
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
