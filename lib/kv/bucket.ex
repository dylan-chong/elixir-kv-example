defmodule KV.Bucket do
  def start_link do
    start_link(%{})
  end

  def start_link(map) do
    Agent.start_link fn -> map end
  end

  def get(pid, key) do
    Agent.get(pid, &Map.get(&1, key))
  end

  @doc """
  Returns :ok
  """
  def put(pid, key, value) do
    Agent.update(pid, &Map.put(&1, key, value))
  end

  def delete(pid, key) do
    Agent.get_and_update(pid, &Map.pop(&1, key))
  end
end
