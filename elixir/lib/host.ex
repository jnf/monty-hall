defmodule Montyhall.Host do
  use GenServer

  @doors [:prize, :goat, :goat]

  def start_link(opts \\ [contestants: %{}]) do
    GenServer.start_link(__MODULE__, {:ok, opts}, opts)
  end

  def init({:ok, opts}) do
    {:ok, %{ contestants: opts[:contestants] }}
  end

  # public API
  def outcome(pid, choice, doors) do
    GenServer.call pid, {:outcome, choice, doors}
  end

  def new_doors(pid) do
    GenServer.call pid, :new_doors
  end

  def contestants(pid) do
    GenServer.call pid, :contestants
  end

  def reveal_goat(pid, choice, doors) do
    GenServer.call pid, {:reveal_goat, choice, doors}
  end

  # server callbacks
  def handle_call({:outcome, choice, doors}, _from, state) do
    {:reply, {:ok, doors[choice] == :prize}, state}
  end

  def handle_call({:reveal_goat, choice, doors}, _from, state) do
    {index, _} = doors |>
      Enum.find(fn({index, contents}) ->
        contents == :goat && index != choice
      end)

    {:reply, {:ok, Map.delete(doors, index)}, state}
  end

  def handle_call(:new_doors, _from, state) do
    doors = @doors |>
      Enum.shuffle |>
      Enum.with_index |>
      Enum.reduce(%{}, fn({v, i}, m) -> Map.put(m, i, v) end)
    {:reply, doors, state}
  end

  def handle_call(:contestants, _from, state) do
    {:reply, state.contestants, state}
  end
end
