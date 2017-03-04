defmodule KV.RegistryTest do
  @moduledoc """
  """
  use ExUnit.Case, async: true
  require IEx

  setup context do
    {:ok, registry} = KV.Registry.start_link(context.test)
    {:ok, registry: registry}
  end

  # Unit Tests

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

    {:ok, registry} = KV.Registry.start_link(:with,
                                             %{"shopping" => created_bucket})

    {:ok, looked_up_bucket} = KV.Registry.lookup(registry, "shopping")
    assert created_bucket == looked_up_bucket
  end

  # Behavioural Tests

  test "Feature: Spawns buckets", %{registry: registry} do
    # Given a registry that
    assert KV.Registry.lookup(registry, "shopping") == :error

    # When
    KV.Registry.create(registry, "shopping")
    # And
    {:ok, bucket} = KV.Registry.lookup(registry, "shopping")
    # Then
    assert is_pid(bucket)

    # When
    KV.Bucket.put(bucket, "milk", 1)
    # Then
    assert KV.Bucket.get(bucket, "milk") == 1
  end

  test "Feature: Removes buckets when they stop", %{registry: registry} do
    # Given a registry
    # And a bucket
    KV.Registry.create(registry, "shopping")
    {:ok, bucket} = KV.Registry.lookup(registry, "shopping")

    # When
    Agent.stop(bucket)
    # Then
    assert KV.Registry.lookup(registry, "shopping") == :error
  end
end

