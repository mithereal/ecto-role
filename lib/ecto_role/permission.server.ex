defmodule EctoRole.Permission.Server do

  use GenServer

  require Logger

  @moduledoc false


  alias EctoRole.Permission

  @registry_name :ecto_role_registry
  @name __MODULE__

  defstruct schema: nil,
            permissions: []


  def start_link(id) do

    name = via_tuple(id)

    GenServer.start_link(__MODULE__, [id], name: name)
  end

  defp via_tuple(id) do

    {:via, Registry, {@registry_name, id}}
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
               %__MODULE__{  state | schema: record.name, permissions: record.value }
    end


    {:noreply, updated_state}
  end

end