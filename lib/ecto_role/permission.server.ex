defmodule EctoRole.Permission.Server do

  use GenServer

  require Logger

  @moduledoc false


  alias EctoRole.Permission

  @registry_name :ecto_role_registry
  @name __MODULE__

  defstruct key: nil,
            schema: nil,
            permissions: []


  def start_link(id) do

    name = via_tuple(id)

    GenServer.start_link(__MODULE__, [id], name: name)
  end

  defp via_tuple(id) do

    {:via, Registry, {@registry_name, id}}
  end


  def get_permissions(id) do

    try do
      GenServer.call(via_tuple(id), :get_permissions)
    catch
      :exit, _ -> {:error, 'invalid_permission'}
    end

  end

  def init([id]) do

    send(self(), { :setup, id })

    state = %__MODULE__{}
    {:ok, state }
  end

  def handle_info( { :setup, id }, state) do

    updated_state = case is_nil id do
      true -> state
      false -> params = %{key: id}
               record = Permission.get_permissions(params)
               %__MODULE__{  state | key: id, schema: record.name, permissions: record.value }
    end


    {:noreply, updated_state}
  end


  @doc "queries the server for permissions"
  def handle_call(:get_permissions, _from,  state) do

    {:reply, state, state}
  end


  @doc "save the permission"
  def handle_call({:save}, _from,  %__MODULE__{ schema: schema , permissions: permissions } = state) do

    Enum.each(permissions, fn(p)->
      Permission.delete(p)
    end)

    Enum.each(permissions, fn(p)->
      Permission.new(p)
    end)


    {:reply, state, state}
  end

end