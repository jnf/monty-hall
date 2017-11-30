defmodule Montyhall do
  alias Montyhall.Host, as: Monty
  alias Montyhall.Contestant, as: Contestant

  def new_game(plays \\ 1_000_000) do
    {:ok, switches_pid} = Contestant.start_link(switches: true)
    {:ok, keeps_pid} = Contestant.start_link(switches: false)

    {:ok, monty_pid} = Monty.start_link(
      contestants: %{
        switches: switches_pid,
        keeps: keeps_pid
      }
    )

    {:ok, results} = play(monty_pid, plays)

    GenServer.stop(monty_pid)
    GenServer.stop(keeps_pid)
    GenServer.stop(switches_pid)

    IO.puts(inspect {:ok, results })
  end

  defp play(pid, plays_remaining \\ 100)
  defp play(pid, 0) do
    # return the player stats
    {:ok, Monty.contestants(pid) |>
      Map.values |>
      Enum.map(&Contestant.get_state/1) }
  end
  defp play(pid, plays_remaining) do
    Monty.contestants(pid) |> Enum.each(fn ({_key, contestant_pid}) ->
      # generate doors
      doors =  Monty.new_doors(pid)

      # let the contestant choose a door at random
      {:ok, first_choice} = Contestant.choose(contestant_pid, doors |> Map.keys)

      # eliminate a :goat
      {:ok, new_doors} = Monty.reveal_goat(pid, first_choice, doors)

      # contestant gives final selection
      {:ok, final_door} = Contestant.final(contestant_pid, new_doors)

      # the host tells us if they won
      {:ok, win} = Monty.outcome(pid, final_door, doors)

      # record the outcome in the appropriate player's stats
      :ok = Contestant.record_outcome(contestant_pid, win)
    end)

    play(pid, plays_remaining - 1)
  end
end
