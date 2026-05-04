# frozen_string_literal: true

# Logic for completing the current turn, incuding tied rounds
# tracks players involved and the cards they've played
class ResolveWar
  def initialize(players:, cards_played:)
    @players = players
    @cards_played = cards_played
  end

  def call
    winners = highest_cards(@cards_played, @players)

    while winners.size > 1
      puts "\n************ WAR! ************"

      war_cards = play_war_round(winners)
      @cards_played.concat(war_cards)
      winners = highest_cards(war_cards, winners)
    end

    [@cards_played, winners]
  end

  private

  def highest_cards(cards, players)
    highest = cards.map { |c| c[:card] }.max
    winning_cards = cards.select { |c| c[:card] == highest }
    winning_players = winning_cards.map { |c| c[:player] }

    players.select { |p| winning_players.include?(p.name) }
  end

  def play_war_round(players)
    war_cards = []

    players.each do |player|
      cards = play_war_cards(player)

      war_cards.concat(cards)
    end

    war_cards
  end

  def play_face_up_card(player)
    return nil if player.empty_hand?

    card = player.play_card

    puts "#{player.name} goes to WAR with a #{card.display_name}!"

    build_card_hash(card, player)
  end

  def play_war_cards(player)
    war_cards = []

    num_face_down = player.can_war? ? 3 : player.hand_size - 1

    num_face_down.times do
      card = player.play_card
      war_cards << build_card_hash(card, player) if card
    end

    face_up_card = play_face_up_card(player)

    war_cards << face_up_card if face_up_card

    unless face_up_card
      puts "#{player.name} has no resources to bring to WAR, and drew their last breath on the battlefield."
    end

    war_cards
  end

  def build_card_hash(card, player)
    {
      card: card,
      player: player.name
    }
  end
end
