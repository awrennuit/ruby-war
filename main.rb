require_relative 'game'

def main
  # this feels a bit clunky, but i do like having a "sorry - try again" message
  # the whole loop could be omitted if we are not concerned with that for this challenge
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
