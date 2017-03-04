defmodule KV.Registry do
  @moduledoc """
  For registering processes with strings instead of atoms
  """

  use GenServer

  @type registry :: GenServer.server

  ## Client methods

  @spec start_link(any) :: {:ok, registry}
  def start_link(name) do
    GenServer.start_link(__MODULE__, :ok, name: name)
  end

  @spec start_link(:with, map) :: {:ok, registry}
  def start_link(:with, name_to_bucket_map) do
    GenServer.start_link(__MODULE__, name_to_bucket_map)
  end

  @doc """
  Looks up the bucket pid for `name` stored in `server`
  Can return `:error`
  """
  @spec lookup(registry, String.t) :: {:ok, KV.Bucket.bucket} | :error
  def lookup(server, name) do
    GenServer.call(server, {:lookup, name})
  end

  @doc """
  Ensures there is a bucket associated to the given `name` in `server`
  """
  @spec create(registry, String.t) :: any
  def create(server, name) do
    GenServer.cast(server, {:create, name})
  end

  ## Server callbacks

  @spec init(:ok) :: {:ok, %{}}
  def init(:ok) do
    {:ok, %{}} # map of names
  end

  @spec init(map) :: {:ok, map}
  def init(name_to_bucket_map) do
    {:ok, name_to_bucket_map}
  end

  @spec handle_call({:lookup, String.t}, GenServer.from, map)
  :: {:reply, any, map}
  def handle_call({:lookup, name}, _from, name_to_bucket_map) do
    {:reply, Map.fetch(name_to_bucket_map, name), name_to_bucket_map}
  end

  @spec handle_cast({:create, String.t}, map) :: {:noreply, map}
  def handle_cast({:create, name}, name_to_bucket_map) do
    if Map.has_key?(name_to_bucket_map, name) do
      {:noreply, name_to_bucket_map}
    end

    {:ok, bucket} = KV.Bucket.start_link
    {:noreply, Map.put(name_to_bucket_map, name, bucket)}
  end
end
