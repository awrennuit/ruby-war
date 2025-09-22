require_relative 'game'

def main
  invalid_selection = false

  loop do
    puts invalid_selection ? "You must choose 2 or 4." : "How many players will go to WAR? 2 or 4?"
    num_players = gets.chomp.to_i

    if [2, 4].include?(num_players)
      Game.new(num_players).start
      break
    else
      invalid_selection = true
    end
  end
end

main
