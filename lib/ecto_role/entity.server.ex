defmodule EctoRole.Entity.Server do
  use GenServer

  require Logger

  @moduledoc false

  alias EctoRole.Entity, as: ENTITY
  alias EctoRole.Filter, as: FILTER

  alias EctoRole.Repo

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

          %__MODULE__{state | key: id, roles: record.roles, permissions: permissions, status: 'active'}
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

  @doc "deactivate the entity"
  def handle_call(:deactivate, _from, %__MODULE__{status: status, key: key} = state) do
    new_status  = 'inactive'
    updated_state = %__MODULE__{state | status: new_status}

    send(self(), :save)

    {:reply, :ok, updated_state}
  end

  @doc "activate the entity"
  def handle_call(:activate, _from, %__MODULE__{status: status, key: key} = state) do
    new_status  = 'active'
    updated_state = %__MODULE__{state | status: new_status}

    send(self(), :save)

    {:reply, :ok, updated_state}
  end

  @doc "delete the entity, then shutdown"
  def handle_call(:delete, _from, %__MODULE__{status: status, key: key} = state) do
    entity = ENTITY.get(%{key: key})
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

  def deactivate(key) do
    try do
      GenServer.call(via_tuple(key), :deactivate)
    catch
      :exit, _ -> {:error, 'invalid_entity'}
    end
  end

  def activate(key) do
    try do
      GenServer.call(via_tuple(key), :activate)
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
    calculated_permissions =
      Map.merge(permissions, fn x ->
        {_, filter} = x
        read_count = case Enum.count(filter.read) > 0 do
          true -> Enum.count(filter.read)
          false -> 9999
        end
        write_count = case Enum.count(filter.write) > 0 do
          true -> Enum.count(filter.read)
          false -> 9999
        end

        create_perm =
          case filter.create do
            true -> 1
            false -> 0
          end

        delete_perm =
          case filter.delete do
            true -> 1
            false -> 0
          end

        value = read_count + write_count + create_perm + delete_perm
        filter = x

        Map.put(x, :permission_value, value)
      end)

    sorted_by_key =
      Enum.reduce(calculated_permissions, %{}, fn m, acc ->
        Map.merge(acc, m, fn
          _k, e when is_map(e) ->
            [e]

          _k, e ->
            [e]
        end)
      end)

    IO.inspect(calculated_permissions, label: "calculated_permissions")
    IO.inspect(sorted_by_key, label: "sorted_by_key")

    ## sort by int
    ## pop the highest
    [{'user', %FILTER{}}]
  end
end
