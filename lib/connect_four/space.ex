defmodule ConnectFour.Space do
  def start_link({row, col}) do
    Agent.start_link(fn -> :empty end, [name: agent_name(row, col)])
  end

  def agent_name(row, col) do
    String.to_atom("R#{row}C#{col}")
  end
end
