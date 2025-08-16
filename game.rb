require_relative 'deck'
require_relative 'player'

class Game
  CARD_VALUES = {
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
    "10" => 10,
    "J" => 11,
    "Q" => 12,
    "K" => 13,
    "A" => 14
  }.freeze

  def initialize(num_players)
    @players = num_players.times.map { |i| Player.new("Player #{i + 1}") }
    @cur_round = 0
  end

  def start
    deal_cards

    # set a hard limit in case the cards line up in such a way that the game goes on indefinitely
    while !game_over? && @cur_round < 25000 do
      @cur_round += 1
      play_round
    end

    return puts "The battle draws rages on for centuries until all contenders turn to dust. There are no winners." if @cur_round == 25000
    return puts "#{@players.first.name} wins in #{@cur_round} rounds!" if @players.any?
  end

  private

  def deal_cards
    deck = Deck.new

    until deck.empty?
      @players.each { |p| p.add_cards(deck.deal_card) }
    end
  end

  def game_over?
    @players.size == 1
  end

  def play_round
    cards_played = []

    puts "\n\n:::::::::::::::: Round #{@cur_round} ::::::::::::::::"

    # `compact` since `nil` can be return if the player cannot play a card for some reason
    cards_played = @players.map do |p|
      play_card(p)
    end.compact

    resolve_round(cards_played)
  end

  def play_card(player)
    card = player.play_card

    # Ruby returns `nil` by default, but writing here it makes it clearer and obviously intentional
    return nil unless card

    value = CARD_VALUES[card[0..-2]]

    puts "#{player.name} attacks with a #{card}! (hand size: #{player.hand_size})"

    # personal preference of listing everything out rather than shorthand { card:, player: player.name, value: }
    { card: card, player: player.name, value: value}
  end

  def resolve_round(cards_played)
    winners = highest_cards(cards_played)

    while winners.size > 1
      puts "\n************ WAR! ************"

      war_cards_played = winners.flat_map { |p| play_war_cards(p) }
      winners = highest_cards(war_cards_played) 
      cards_played.concat(war_cards_played)
    end

    if winners.size == 1
      winner = winners.first
      winner.add_cards(cards_played.map { |c| c[:card] })

      remove_players

      puts "#{winner.name} wins the skirmish and takes #{cards_played.size} cards!\n\n"
    else
      # in the super rare event of both players playing their final card and having a tie
      puts "WAR is brutal, and all combatants perished in battle. There are no winners."
    end
  end

  def highest_cards(cards)
    highest = cards.map { |c| c[:value] }.max
    winning_cards = cards.select { |c| c[:value] == highest }
    winning_players = winning_cards.map { |c| c[:player] }

    @players.select { |p| winning_players.include?(p.name) }
  end

  def play_war_cards(player)
    war_cards_played = []
    num_cards_to_play = player.can_war? ? 3 : player.hand_size - 1

    num_cards_to_play.times do
      card = player.play_card
      # war cards are facedown, thus having no value
      war_cards_played << { card: card, player: player.name, value: 0 } if card
    end

    # thought about doing the inverse here to avoid a double negative, but it's more likely that the player will have at least 1 card than have no cards
    if !player.empty_hand?
      war_card = player.play_card
      value = CARD_VALUES[war_card[0..-2]]
      war_cards_played << { card: war_card, player: player.name, value: value }

      puts "#{player.name} goes to WAR with a #{war_card}!"
    else
      puts "#{player.name} has no resources to bring to WAR, and drew their last breath on the battlefield."

      @players.delete(player)
    end

    war_cards_played
  end

  def remove_players
    # could do `delete_if`, but that didn't seem as easy to read as this setup
    @players.each do |p|
      next unless p.empty_hand?

      puts "#{p.name} has departed this mortal realm during WAR."

      @players.delete(p)
    end
  end
end
