defmodule ConnectFour.Space do
  def start_link({row, column}) do
    Agent.start_link(fn -> :empty end, [name: agent_name(row, column)])
  end

  def agent_name(row, column) do
    String.to_atom("R#{row}C#{column}")
  end

  def get_pid(row, column) do
    Process.whereis(agent_name(row, column))
  end

  def state(row, column) do
    get_pid(row, column) |> Agent.get(&(&1))
  end

  def empty?(row, column) do
    state(row, column) == :empty
  end

  def to_string(row, column) do
    case state(row, column) do
      :empty -> "."
      :red   -> "R"
      :black -> "B"
      _      -> "?"
    end
  end
end
