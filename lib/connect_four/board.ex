defmodule ConnectFour.Board do
  use Supervisor

  @registered_name ConnectFourBoard
  @last_row 6
  @last_column 7

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
    for row <- 1..@last_row, column <- 1..@last_column, do: {row, column}
  end

  def print do
    for row <- @last_row..1, do: print(row)
  end

  def print(row) do
    for column <- @last_column..1, do: print(row, column)
    IO.write "\n"
  end

  def print(row, column) do
    ConnectFour.Space.agent_name(row, column)
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

  def place_token(player, column) do
    :move_accepted
  end
end
