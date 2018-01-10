defmodule EctoRole.Permission.Server do

  use GenServer

  require Logger

  @moduledoc """
A Simple Server to Store Your Permissions.
"""


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

end