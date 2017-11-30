require './contestant'
require './monty'

class Game
  attr_reader :monty, :keeper, :switcher
  def initialize
    @monty = Monty.new
    @keeper = Contestant.new(switches: false)
    @switcher = Contestant.new(switches: true)
  end

  def new_game(games = 1_000_000)
    [keeper, switcher].each do |player|
      games.times { play(player) }
    end

    puts "Keeps: #{ keeper.record }"
    puts "Switches: #{ switcher.record }"
  end

  private
  def play(player)
    doors     = monty.new_doors
    choice    = player.first_choice(doors)
    new_doors = monty.reveal_goat(doors, choice)
    final     = player.final_choice(new_doors)

    player.record_outcome(monty.win? new_doors, final)
  end
end

Game.new.new_game
