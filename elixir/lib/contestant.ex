defmodule Montyhall.Contestant do
  use GenServer

  def start_link(opts \\ [switches: false]) do
    GenServer.start_link(__MODULE__, {:ok, opts}, opts)
  end

  def init({:ok, opts}) do
    {:ok, %{ wins: 0, losses: 0, plays: 0, switches: opts[:switches], choice: nil }}
  end

  # public API
  def record_outcome(pid, win), do: GenServer.call(pid, {:record_outcome, win})
  def play(pid, doors \\ []), do: GenServer.call(pid, {:play, doors})

  def get_state(pid), do: GenServer.call(pid, :get_state)

  def choose(pid, keys \\ 3), do: GenServer.call(pid, {:choose, keys})

  def final(pid, doors \\ []), do: GenServer.call(pid, {:final, doors})

  # server callbacks
  def handle_call({:final, doors}, _from, state) do
    new_choice = if(state.switches, do: switch_choice(doors, state.choice), else: state.choice)
    {:reply, {:ok, new_choice}, Map.replace(state, :choice, new_choice)}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:choose, keys}, _from, state) do
    choice = Enum.random(keys)
    new_state = Map.replace(state, :choice, choice)

    {:reply, {:ok, choice}, new_state}
  end

  def handle_call({:record_outcome, win}, _from, state) do
    key = if(win, do: :wins, else: :losses)
    new_state = Map.replace(state, key, state[key] + 1)
    new_state = Map.replace(new_state, :plays, state[:plays] + 1)
    {:reply, :ok, new_state}
  end

  # helper functions
  defp switch_choice(doors, original) do
    Map.delete(doors, original) |>
      Map.keys |>
      List.first
  end
end
