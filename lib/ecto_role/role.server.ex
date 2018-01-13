defmodule EctoRole.Server do

  use GenServer

  require Logger

  @moduledoc "A Simple Server to Store Your Roles."

  alias EctoRole.Role


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

    GenServer.call(via_tuple(id), :get_entities)
  end

  def get_permissions (id) do

    GenServer.call(via_tuple(id), :get_permissions)
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
               role = Role.get_role(params)
               %__MODULE__{  state | entites: role.entites, permissions: role.permissions }
    end


    {:noreply, updated_state}
  end


end