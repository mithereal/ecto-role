defmodule EctoRole.Server do
  use GenServer

  require Logger

  @moduledoc "A Simple Server to Store Your Roles."

  alias EctoRole.Role, as: ROLE
  alias EctoRole.Filter.Supervisor, as: FS

  @registry_name :ecto_role_registry
  @name __MODULE__

  defstruct key: nil,
            entities: [],
            filters: []

  def start_link(id) do
    name = via_tuple(id)

    GenServer.start_link(__MODULE__, [id], name: name)
  end

  defp via_tuple(id) do
    {:via, Registry, {@registry_name, id}}
  end

  def get_entities(id) do
    try do
      GenServer.call(via_tuple(id), :get_entities)
    catch
      :exit, _ -> {:error, "invalid_role"}
    end
  end

  def get_filters(id) do
    try do
      GenServer.call(via_tuple(id), :get_filters)
    catch
      :exit, _ -> {:error, "invalid_role"}
    end
  end

  def get_entities(id) do
    try do
      GenServer.call(via_tuple(id), :get_entities)
    catch
      :exit, _ -> {:error, "invalid_role"}
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
          record = ROLE.get_role(params)

          case record do
            nil ->
              %__MODULE__{state | key: id}

            %{} ->
              Enum.each(record.filters, fn x ->
                FS.start(x.key)
              end)

              #              Enum.each(record.entities, fn x ->
              #                EctoRole.Entity.Supervisor.start(x.key)
              #              end)

              %__MODULE__{
                state
                | key: id,
                  entities: record.entities,
                  filters: record.filters
              }

            _ ->
              %__MODULE__{state | key: id}
          end
      end

    {:noreply, updated_state}
  end

  @doc "queries the server for filters"
  def handle_call(:get_filters, _from, %__MODULE__{filters: filters} = state) do
    {:reply, filters, state}
  end

  @doc "queries the server for entities"
  def handle_call(:get_entities, _from, %__MODULE__{entities: entities} = state) do
    {:reply, entities, state}
  end
end
