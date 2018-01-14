defmodule EctoRole.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  use Supervisor

  alias EctoRole.Role
  alias EctoRole.Repo

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      supervisor(EctoRole.Repo, []),
      supervisor(Registry, [:unique, :ecto_role_permission_registry], id: :ecto_role_permission_registry),
      supervisor(Registry, [:unique, :ecto_role_registry], id: :ecto_role_registry),
      supervisor(EctoRole.Permission.Supervisor, []),
      supervisor(EctoRole.Role.Supervisor, []),
      supervisor(EctoRole.Schema.Supervisor, []),

      worker(Task, [&init/0], restart: :transient),

      # Starts a worker by calling: EctoRole.Worker.start_link(arg)
      # {EctoRole.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EctoRole.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # load the available roles
  defp load_roles do

    roles = EctoRole.Repo.all(Role)

    Enum.each(roles, fn(x) ->
      EctoRole.Role.Supervisor.start x.key
    end)

  end

  # load the schema
  defp load_schemas do

    schemas = EctoRole.Schema.fetch()

    Enum.each(schemas, fn(x) ->
      EctoRole.Schema.Supervisor.start x
    end)

  end

  # init the initial state of the otp app
  defp init do

    load_schemas
    load_roles
  end

end
