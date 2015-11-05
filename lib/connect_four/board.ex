defmodule ConnectFour.Board do
  use Supervisor

  @registered_name ConnectFourBoard
  @last_row 6
  @last_col 7

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, [name: @registered_name])
  end

  def init(:ok) do
    for space <- spaces do
      worker(ConnectFour.Space, [space], id: space)
    end
    |> supervise(strategy: :one_for_one)
  end

  def spaces do
    for row <- 1..@last_row, col <- 1..@last_col, do: {row, col}
  end

  def print do
    for row <- @last_row..1, do: print_row(row)
  end

  def print_row(row) do
    for col <- @last_col..1, do: print_space(row, col)
    IO.write "\n"
  end

  def print_space(row, col) do
    ConnectFour.Space.agent_name(row, col)
    |> Process.whereis
    |> Agent.get(fn state -> state end)
    |> convert_for_display
    |> IO.write
  end

  def convert_for_display(state) do
    case state do
      :empty -> "."
      :red   -> "R"
      :black -> "B"
      _      -> "?"
    end
  end
end
