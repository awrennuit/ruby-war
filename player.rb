class Player
  attr_reader :name

  def initialize(name)
    @name = name
    @hand = []
  end
  
  def add_cards(cards)
    @hand.unshift(*Array(cards))
  end

  def can_war?
    @hand.size >= 4
  end

  def empty_hand?
    @hand.empty?
  end

  def hand_size
    @hand.size
  end

  def play_card
    @hand.pop
  end
end
