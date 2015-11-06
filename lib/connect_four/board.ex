defmodule ConnectFour.Board do
  use Supervisor

  alias ConnectFour.Space, as: Space

  @registered_name ConnectFourBoard
  @last_row 6
  @last_column 7

  def start_link do
    Supervisor.start_link(__MODULE__, :ok, [name: @registered_name])
  end

  def init(:ok) do
    for space <- spaces do
      worker(Space, [space], id: space)
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
    for column <- 1..@last_column, do: print(row, column)
    IO.write "\n"
  end

  def print(row, column) do
    Space.to_string(row, column)
    |> IO.write
  end

  def place_token(player, column) do
    if full?(column) do
      :column_full
    else
      Space.update(first_empty_row(column), column, fn _ -> player end)
      :move_accepted
    end
  end

  def full?(column), do: Space.state(@last_row, column) != :empty

  def first_empty_row(column), do: _first_empty_row(1, column)

  defp _first_empty_row(row, column) do
    if Space.empty?(row, column) do
      row
    else
      _first_empty_row(row + 1, column)
    end
  end
end
