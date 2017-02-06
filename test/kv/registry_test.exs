defmodule KV.RegistryTest do
  @moduledoc """
  """

  use ExUnit.Case, async: true

  test "start_link/0 returns {:ok, pid}" do
    assert {:ok, pid} = KV.Registry.start_link()
  end

end
