defmodule KV.RegistryTest do
  @moduledoc """
  """
  use ExUnit.Case, async: true
  require IEx

  setup do
    {:ok, registry} = KV.Registry.start_link()
    {:ok, registry: registry}
  end

  test "lookup/2 should return `:error` for non-existent bucket ",
  %{registry: registry} do
    assert KV.Registry.lookup(registry, "shopping") == :error
  end

  test "create/2 should create a KV.Bucket", %{registry: registry} do
    KV.Registry.create(registry, "shopping")
    assert {:ok, _bucket} = KV.Registry.lookup(registry, "shopping")
  end

  test "lookup/2 should return {:ok, pid} for an existing bucket" do
    created_bucket = KV.Bucket.start_link()

    {:ok, registry} = KV.Registry.start_link(%{"shopping" => created_bucket})

    {:ok, looked_up_bucket} = KV.Registry.lookup(registry, "shopping")
    assert created_bucket == looked_up_bucket
  end

end
