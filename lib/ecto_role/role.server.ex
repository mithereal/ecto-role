defmodule EctoRole.Server do
  use GenServer

  require Logger

  @moduledoc "A Simple Server to Store Your Roles."

  alias EctoRole.Role, as: ROLE
  alias EctoRole.Filter.Supervisor, as: FS
  alias EctoRole.Role.Supervisor, as: RS

  alias EctoRole.Repo, as: Repo

  @registry_name :ecto_role_registry
  @name __MODULE__

  defstruct key: nil,
            name: nil,
            entities: [],
            filters: [],
          status: nil

  def start_link(id) do
    name = via_tuple(id)

    GenServer.start_link(__MODULE__, [id], name: name)
  end

  defp via_tuple(id) do
    {:via, Registry, {@registry_name, id}}
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
          record = ROLE.get(params)

          case record do
            nil ->
              %__MODULE__{state | key: id}

            %{} ->
              #              Enum.each(record.filters, fn x ->
              #                FS.start(x.key)
              #              end)

              #              Enum.each(record.entities, fn x ->
              #                EctoRole.Entity.Supervisor.start(x.key)
              #              end)

              %__MODULE__{
                state
                | key: id,
                  name: record.name,
                  entities: [],
                  filters: [],
              status: "active"
              }

            _ ->
              %__MODULE__{state | key: id, status: "active"}
          end
      end

    {:noreply, updated_state}
  end

  def handle_info(:shutdown, state) do
    Process.sleep(5000)
    {:stop, :normal, state}
  end

  def handle_info(:save, %__MODULE__{key: key} = state) do
    params = %{key: key}
    changeset = ROLE.changeset(%ROLE{}, params)
    {result, _} = Repo.insert_or_update(changeset)

    reply =
      case result do
        nil ->
          :error

        _ ->
          send(self(), {:setup, key})
          result
      end

    {:noreply, state}
  end


  def handle_call(
        :save,
        _from,
        %__MODULE__{key: key} = state
      ) do
    params = %{key: key}
    changeset = ROLE.changeset(%ROLE{}, params)
    {result, _} = Repo.insert_or_update(changeset)

    reply =
      case result do
        nil ->
          :error

        _ ->
          send(self(), {:setup, key})
          result
      end

    {:reply, reply, state}
  end

  @doc "queries the server for filters"
  def handle_call(:get_filters, _from, %__MODULE__{filters: filters} = state) do
    {:reply, filters, state}
  end

  @doc "queries the server for entities"
  def handle_call(:get_entities, _from, %__MODULE__{entities: entities} = state) do
    {:reply, entities, state}
  end

  @doc "deactivate the role"

  def handle_call(:deactivate, _from, %__MODULE__{status: status} = state) do
    new_status = 'inactive'
    updated_state = %__MODULE__{state | status: new_status}

    send(self(), :save)

    {:reply, :ok, updated_state}
  end

  @doc "activate the entity"
  def handle_call(:activate, _from, %__MODULE__{status: status} = state) do
    new_status = 'active'
    updated_state = %__MODULE__{state | status: new_status}

    send(self(), :save)

    {:reply, :ok, updated_state}
  end

  @doc "delete the role, then shutdown"
  def handle_call(:delete, _from, %__MODULE__{status: status, key: key} = state) do
    entity = ROLE.get(%{key: key})
    Repo.delete(entity)

    send(self(), :shutdown)

    updated_state = %__MODULE__{state | status: status}
    {:reply, :ok, updated_state}
  end

  ## client

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

  def save(key) do
    try do
      GenServer.call(via_tuple(key), :save)
    catch
      :exit, _ -> {:error, 'invalid_role'}
    end
    end

  def deactivate(key) do
    try do
      GenServer.call(via_tuple(key), :deactivate)
    catch
      :exit, _ -> {:error, 'invalid_role'}
    end
  end

  def activate(key) do
    try do
      GenServer.call(via_tuple(key), :activate)
    catch
      :exit, _ -> {:error, 'invalid_role'}
    end
  end

  def delete(key) do
    try do
      GenServer.call(via_tuple(key), :delete)
    catch
      :exit, _ -> {:error, 'invalid_role'}
    end
  end
end
