defmodule KV.Bucket do
  @moduledoc """
  For storing state in a map
  """

  @spec start_link :: {:ok, pid}
  def start_link do
    start_link(%{})
  end

  @spec start_link(map) :: {:ok, pid}
  def start_link(map) do
    Agent.start_link fn -> map end
  end

  @spec get(pid, any) :: any | nil
  def get(pid, key) do
    Agent.get(pid, &Map.get(&1, key))
  end

  @spec put(pid, any, any) :: :ok
  def put(pid, key, value) do
    Agent.update(pid, &Map.put(&1, key, value))
  end

  @spec delete(pid, any) :: any | nil
  def delete(pid, key) do
    Agent.get_and_update(pid, &Map.pop(&1, key))
  end
end
