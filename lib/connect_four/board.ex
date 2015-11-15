defmodule ConnectFour.Board do
  use Supervisor

  alias ConnectFour.Space, as: Space

  @registered_name ConnectFourBoard
  @last_row 6
  @last_column 7
  @match_length 4

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
      row = first_empty_row(column)
      Space.update(row, column, fn _ -> player end)

      if winner?(row, column) do
        :winner
      else
        :move_accepted
      end
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

  def winner?(row, column) do
    cond do
      vertical_winner?(row, column) -> true
      # horizontal_winner?(row, column) -> true
      # diagonal_winner?(row, column) -> true
      :else -> false
    end
  end

  def vertical_winner?(row, _column) when row < @match_length, do: false
  def vertical_winner?(row, column) do
    starting_row = row - @match_length + 1

    Enum.to_list(row .. starting_row)
    |> Enum.map(&(Space.state(&1, column)))
    |> all_equal?
  end

  def all_equal?([head|tail]) do
    tail |> Enum.all?(&(&1 == head))
  end
end
