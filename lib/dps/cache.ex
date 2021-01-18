defmodule Dps.Cache do
  use GenServer

  @cache_table :dps_cache

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: DpsCache)
  end

  def init(state) do
    :ets.new(@cache_table, [:set, :public, :named_table])
    {:ok, state}
  end

  def get(key) do
    GenServer.call(DpsCache, {:get, key})
  end

  def put(key, data) do
    GenServer.cast(DpsCache, {:put, key, data})
    data
  end

  def delete(key) do
    GenServer.cast(DpsCache, {:delete, key})
  end

  def clear do
    GenServer.cast(DpsCache, :clear)
  end

  ### internal API
  def handle_call({:get, key}, _from, state) do
    reply =
      case :ets.lookup(@cache_table, key) do
        [] -> nil
        [{_key, poem}] -> poem
      end

    {:reply, reply, state}
  end

  def handle_cast({:put, key, data}, state) do
    :ets.insert(@cache_table, {key, data})
    {:noreply, state}
  end

  def handle_cast({:delete, key}, state) do
    :ets.delete(@cache_table, key)
    {:noreply, state}
  end

  def handle_cast(:clear, state) do
    :ets.delete_all_objects(@cache_table)
    {:noreply, state}
  end
end
