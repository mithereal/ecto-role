defmodule EctoRole.Filter.Server do
  use GenServer

  require Logger

  @moduledoc false

  alias EctoRole.Filter, as: FILTER

  @registry_name :ecto_role_filter_registry
  @name __MODULE__

  defstruct key: nil,
            schema: nil,
            filters: []

  def start_link(id) do
    name = via_tuple(id)

    GenServer.start_link(__MODULE__, [id], name: name)
  end

  defp via_tuple(id) do
    {:via, Registry, {@registry_name, id}}
  end

  def get_filters(id) do
    try do
      GenServer.call(via_tuple(id), :get_filters)
    catch
      :exit, _ -> {:error, 'invalid_filter'}
    end
  end

  def init([id]) do
    send(self(), {:setup, id})

    state = %__MODULE__{}
    {:ok, state}
  end

  def handle_info({:setup, id}, state) do
    updated_state =
      case is_nil(id) do
        true ->
          state

        false ->
          params = %{key: id}
          record = FILTER.get_filters(params)
          %__MODULE__{state | key: id, schema: record.schema.name, filters: record}
      end

    {:noreply, updated_state}
  end

  @doc "queries the server for filters"
  def handle_call(:get_filters, _from, state) do
    {:reply, state, state}
  end

  @doc "save the filter"
  def handle_call({:save}, _from, %__MODULE__{schema: schema, filters: filters} = state) do
    Enum.each(filters, fn p ->
      FILTER.delete(p)
    end)

    Enum.each(filters, fn p ->
      FILTER.new(p)
    end)

    {:reply, state, state}
  end
end
