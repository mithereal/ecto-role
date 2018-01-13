defmodule EctoEntity.Server do

  use GenServer

  require Logger

  @moduledoc "A Simple Server to Store Your Entitys."

  alias EctoEntity.Entity


  @registry_name :ecto_entity_registry
  @name __MODULE__


  defstruct name: nil,
            value: nil,
            key: nil,
            uuid: nil,
            roles: [ ]


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
               record = Entity.get_entity(params)
               %__MODULE__{  state | name: record.name, value: record.value, key: record.key, uuid: record.uuid, roles: record.roles }
    end


    {:noreply, updated_state}
  end


end