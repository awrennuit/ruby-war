# frozen_string_literal: true

require_relative 'deck'
require_relative 'player'
require_relative 'resolve_war'

# Core game loop
class Game
  def initialize(num_players:)
    @active_players = num_players.times.map { |i| Player.new(name: "Player #{i + 1}") }
    @cur_round = 0
  end

  def start
    deal_cards

    # set a hard limit in case the cards line up in such a way that the game goes on indefinitely
    while !game_over? && @cur_round < 10_000
      @cur_round += 1
      play_round
    end

    if @cur_round == 10_000
      return puts 'The battle draws rages on for centuries until all contenders turn to dust. There are no winners.'
    end

    puts "#{@active_players.first.name} wins in #{@cur_round} rounds!" if @active_players.any?
  end

  private

  def deal_cards
    deck = Deck.new

    @active_players.each { |p| p.add_cards(deck.deal_card) } until deck.empty?
  end

  def game_over?
    @active_players.size == 1
  end

  def play_round
    puts "\n\n:::::::::::::::: Round #{@cur_round} ::::::::::::::::"

    # `compact` since `nil` can be return if the player cannot play a card for some reason
    cards_played = @active_players.map do |p|
      play_card(p)
    end.compact

    resolve_round(cards_played)
  end

  def end_of_turn(all_cards, winners)
    if winners.size == 1
      winner = winners.first
      winner.add_cards(all_cards.map { |c| c[:card] })

      puts "#{winner.name} wins the skirmish and takes #{all_cards.size} cards!\n\n"
    else
      puts 'WAR is brutal, and all combatants perished in battle. There are no winners.'
    end

    @active_players.reject! { |p| p.hand_size.zero? }
  end

  def play_card(player)
    card = player.play_card

    return nil unless card

    puts "#{player.name} attacks with a #{card.display_name}! (hand size: #{player.hand_size})"

    { card: card, player: player.name }
  end

  def resolve_round(cards_played)
    outcome = ResolveWar.new(
      players: @active_players,
      cards_played: cards_played
    )

    all_cards, winners = outcome.call

    end_of_turn(all_cards, winners)
  end
end
