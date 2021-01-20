defmodule Dps.CacheTest do
  use ExUnit.Case
  alias Dps.Cache

  # Clear Cache after each test
  setup do
    on_exit(&Cache.clear/0)
  end

  test "get/1 nx key returns nil" do
    assert Cache.get(:nx) == nil
  end

  test "put/2 saves a key" do
    assert Cache.get(:some_key) == nil
    assert Cache.put(:some_key, :some_data) == :some_data
    assert Cache.get(:some_key) == :some_data
  end

  test "delete/1 deletes a single key" do
    assert Cache.put(:some_key, :some_data) == :some_data
    Cache.delete(:some_key)
    assert Cache.get(:some_key) == nil
  end

  test "clear/0 deletes all keys" do
    assert Cache.put(:key1, :a) == :a
    assert Cache.put(:key2, :b) == :b
    Cache.clear()
    assert Cache.get(:key1) == nil
    assert Cache.get(:key2) == nil
  end
end
