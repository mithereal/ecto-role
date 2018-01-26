defmodule EctoRole.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

 # config = Application.get_env(:ecto_role, EctoRole, [])
 # @repo Keyword.get(config, :repo)

  use Application
  use Supervisor

  alias EctoRole.Role, as: APP
  alias EctoRole.Role.Role, as: ROLE
  alias EctoRole.Schema, as: SCHEMA

  alias EctoRole.Supervisor, as: SUP
  alias EctoRole.Role.Supervisor, as: RS
  alias EctoRole.Permission.Supervisor, as: PS
  alias EctoRole.Entity.Supervisor, as: ES
  alias EctoRole.Schema.Supervisor, as: SS

  alias EctoRole.Repo

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Repo, []),
      supervisor(Registry, [:unique, :ecto_role_entity_registry], id: :ecto_role_entity_registry),
      supervisor(Registry, [:unique, :ecto_role_permission_registry], id: :ecto_role_permission_registry),
      supervisor(Registry, [:unique, :ecto_role_registry], id: :ecto_role_registry),
      supervisor(ES, []),
      supervisor(PS, []),
      supervisor(RS, []),
      supervisor(SS, []),

      #worker(Task, [&init/0], restart: :transient),

      # Starts a worker by calling: EctoRole.Worker.start_link(arg)
      # {EctoRole.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SUP]
    Supervisor.start_link(children, opts)
  end

  # load the available roles
  defp load_roles do

    roles = ROLE.all

    Enum.each(roles, fn(x) ->
      RS.start x.key
    end)

  end

  # load the schema
  defp load_schemas do

    schemas = SCHEMA.all

    Enum.each(schemas, fn(x) ->
      SS.start x
    end)

  end

  # init the initial state of the otp app
  defp init do

    load_schemas()
    load_roles()
  end

end
