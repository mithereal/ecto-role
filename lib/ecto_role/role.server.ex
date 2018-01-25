defmodule EctoRole.Server do

  use GenServer

  require Logger

  @moduledoc "A Simple Server to Store Your Roles."

  alias EctoRole.Role.Role


  @registry_name :ecto_role_registry
  @name __MODULE__

  defstruct entites: [ ],
            permissions: [ ]


  def start_link(id) do

    name = via_tuple(id)

    GenServer.start_link(__MODULE__, [id], name: name)
  end

  defp via_tuple(id) do

    {:via, Registry, {@registry_name, id}}
  end

  def get_entities (id) do

    try do
      GenServer.call(via_tuple(id), :get_entities)
    catch
      :exit, _ -> {:error, "role_doesnt_exist"}
    end
  end

  def get_permissions (id) do

    try do
      GenServer.call(via_tuple(id), :get_permissions)
    catch
      :exit, _ -> {:error, "role_doesnt_exist"}
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
               record = Role.get_role(params)

               Enum.each(record.entities, fn(x) ->

                 EctoRole.Entity.Supervisor.start(x.uuid)
               end)


               Enum.each(record.permissions, fn(x) ->

                 EctoRole.Permission.Supervisor.start(x.key)
               end)

               %__MODULE__{  state | entites: record.entites, permissions: record.permissions }
    end


    {:noreply, updated_state}
  end


end