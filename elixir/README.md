# Montyhall -- Elixir

Load the project with `iex -S mix`, then play the game using `Montyhall.new_game n` where `n` is the number of games you'd like the simulator to play.

1. Host sets up three _doors_. Two have `:goats`. One has `:prize`.
1. Contestant chooses door at random, unaware of what's behind them.
1. Host eliminates one `:goat` that Contestant didn't select.
1. Contestant _may_ switch their choice to the other door.
1. Open the door. `:goat` is a loss. `:prize` is a win.
1. Collect stats on wins, losses, and plays for Contestants.
