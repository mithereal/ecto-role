defmodule EctoRole.Entity.Server do
  use GenServer

  require Logger

  @moduledoc false

  alias EctoRole.Entity, as: ENTITY
  alias EctoRole.Filter, as: FILTER

  @registry_name :ecto_role_entity_registry

  defstruct key: nil,
            roles: [],
            permissions: [],
            status: nil

  def start_link(id) do
    name = via_tuple(id)

    GenServer.start_link(__MODULE__, [id], name: name)
  end

  defp via_tuple(id) do
    {:via, Registry, {@registry_name, id}}
  end

  ### Server
  def init([id]) do
    send(self(), {:setup, id})

    state = %__MODULE__{}
    {:ok, state}
  end

  def handle_info(:shutdown, state) do
    Process.sleep(5000)
    {:stop, :normal, state}
  end

  def handle_info({:setup, id}, state) do
    updated_state =
      case is_nil(id) do
        true ->
          state

        false ->
          params = %{key: id}
          record = ENTITY.get_entity(params)

          permissions =
            Enum.map(record.roles, fn x ->
              Enum.map(x.filters, fn y ->
                y
              end)
            end)

          permissions = calculate_permissions(permissions)

          %__MODULE__{state | key: id, roles: record.roles, permissions: permissions}
      end

    {:noreply, updated_state}
  end

  def handle_info(:save, %__MODULE__{key: key} = state) do
    params = %{key: key}
    changeset = ENTITY.changeset(%ENTITY{}, params)
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
        {:has_permission, permission_key},
        _from,
        %__MODULE__{permissions: permissions} = state
      ) do
    result =
      Enum.find(permissions, fn element ->
        match?(%{name: _, read: _, write: _, create: _, delete: _, key: ^permission_key}, element)
      end)

    reply =
      case result do
        nil -> false
        _ -> true
      end

    {:reply, reply, state}
  end

  def handle_call(
        :save,
        _from,
        %__MODULE__{key: key} = state
      ) do
    params = %{key: key}
    changeset = ENTITY.changeset(%ENTITY{}, params)
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

  @doc "queries the server for permissions"
  def handle_call(:get_permissions, _from, %__MODULE__{permissions: permissions} = state) do
    {:reply, permissions, state}
  end

  @doc "queries the server for roles"
  def handle_call(:get_roles, _from, %__MODULE__{roles: roles} = state) do
    {:reply, roles, state}
  end

  @doc "builds the entitys active permission set based on the filters in use"
  def handle_call(:init_permission, _from, %__MODULE__{permissions: permissions} = state) do
    permissions = [{'user', %FILTER{}}]
    updated_state = %__MODULE__{state | permissions: permissions}
    {:reply, permissions, state}
  end

  @doc "remove the entity"
  def handle_call(:remove, _from, %__MODULE__{status: status, key: key} = state) do
    updated_state = %__MODULE__{state | status: status}

    send(self(), :save)

    {:reply, :ok, updated_state}
  end

  @doc "delete the entity, then shutdown"
  def handle_call(:delete, _from, %__MODULE__{status: status, key: key} = state) do
    entity = %ENTITY{status: status, key: key}
    Repo.delete(entity)

    send(self(), :shutdown)

    updated_state = %__MODULE__{state | status: status}
    {:reply, :ok, updated_state}
  end

  ### Client

  def get_roles(id) do
    try do
      GenServer.call(via_tuple(id), :get_roles)
    catch
      :exit, _ -> {:error, 'invalid_entity'}
    end
  end

  def get_permissions(id) do
    try do
      GenServer.call(via_tuple(id), :get_permissions)
    catch
      :exit, _ -> {:error, 'invalid_entity'}
    end
  end

  def has_permission(key, params) do
    try do
      GenServer.call(via_tuple(key), {:has_permission, params})
    catch
      :exit, _ -> {:error, 'invalid_entity'}
    end
  end

  def save(key) do
    try do
      GenServer.call(via_tuple(key), :save)
    catch
      :exit, _ -> {:error, 'invalid_entity'}
    end
  end

  def remove(key) do
    try do
      GenServer.call(via_tuple(key), :remove)
    catch
      :exit, _ -> {:error, 'invalid_entity'}
    end
  end

  def delete(key) do
    try do
      GenServer.call(via_tuple(key), :delete)
    catch
      :exit, _ -> {:error, 'invalid_entity'}
    end
  end

  @doc "calculates the active permissions based on a list of permissions"
  defp calculate_permissions(permissions) do
    ## sort by schema name
    ## calculate an int value for each sorted permission
    ## sort by int
    ## pop the highest
    [{'user', %FILTER{}}]
  end
end
