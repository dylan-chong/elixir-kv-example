defmodule KV.BucketTest do
  @moduledoc """
  """

  use ExUnit.Case, async: true

  setup do
    {:ok, bucket} = KV.Bucket.start_link
    [bucket: bucket]
  end

  test "get/2 should retrieve an existing value" do
    key = "key"
    value = 5
    {:ok, bucket} = KV.Bucket.start_link(%{key => value})
    assert KV.Bucket.get(bucket, key) == value
  end

  test "get/2 should return nil for a non-existent key", %{bucket: bucket} do
    assert KV.Bucket.get(bucket, "non-existent") == nil
  end

  test "put/3 should save the value", %{bucket: bucket} do
    key = "key"
    value = 5
    KV.Bucket.put(bucket, key, value)
    assert KV.Bucket.get(bucket, key) == value
  end

  test "delete/2 should delete from map", %{bucket: bucket} do
    KV.Bucket.put(bucket, :k, :v)
    KV.Bucket.delete(bucket, :k)
    assert KV.Bucket.get(bucket, :k) == nil
  end

  test "delete/2 should return nil if key/value pair didn't exist",
  %{bucket: bucket} do
    assert KV.Bucket.delete(bucket, :k) == nil
  end

  test "delete/2 should return deleted value if it exists",
  %{bucket: bucket} do
    KV.Bucket.put(bucket, :k, :v)
    assert KV.Bucket.delete(bucket, :k) == :v
  end

end
