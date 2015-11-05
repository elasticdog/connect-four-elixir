defmodule ConnectFour.Space do
  def start_link({row, column}) do
    Agent.start_link(fn -> :empty end, [name: agent_name(row, column)])
  end

  def agent_name(row, column) do
    String.to_atom("R#{row}C#{column}")
  end
end
