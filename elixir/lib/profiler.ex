defmodule Profiler do
  import ExProf.Macro

  @doc "analyze with profile macro"
  def analyze do
    profile do
      {:ok, results} = Montyhall.new_game(10_000)
      IO.puts(inspect results)
    end
  end

  @doc "get analysis records and sum them up"
  def run do
    percent = Enum.reduce(analyze(), 0.0, &(&1.percent + &2))
    IO.inspect "total = #{percent}"
  end
end
