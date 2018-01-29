defmodule EctoRole.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias EctoRole, as: APP

  alias EctoRole.Supervisor, as: SUP
  alias EctoRole.Role.Supervisor, as: RS
  alias EctoRole.Filter.Supervisor, as: FS
  alias EctoRole.Entity.Supervisor, as: ES
  alias EctoRole.Schema.Supervisor, as: SS

  alias EctoRole.Repo

  def start(_type, _args) do
    import Supervisor.Spec
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Repo, []),
      supervisor(Registry, [:unique, :ecto_role_schema_registry], id: :ecto_role_schema_registry),
      supervisor(Registry, [:unique, :ecto_role_entity_registry], id: :ecto_role_entity_registry),
      supervisor(
        Registry,
        [:unique, :ecto_role_filter_registry],
        id: :ecto_role_filter_registry
      ),
      supervisor(Registry, [:unique, :ecto_role_registry], id: :ecto_role_registry),
      supervisor(ES, []),
      supervisor(FS, []),
      supervisor(RS, []),
      supervisor(SS, []),
      worker(Task, [&init/0], restart: :transient)

      # worker(Task, [&init/0], restart: :transient),

      # Starts a worker by calling: EctoRole.Worker.start_link(arg)
      # {EctoRole.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SUP]
    Supervisor.start_link(children, opts)
  end

  # init the initial state of the otp app
  defp init() do
    load_schemas()
   # load_roles()
    load_entities()
  end

  defp load_schemas do
    schemas = APP.fetch_schemas()

    Enum.each(schemas, fn x ->
      SS.start(x)
    end)
  end

  defp load_roles do
    roles = APP.list_roles()

    Enum.each(roles, fn x ->
      RS.start(x.key)
    end)
  end

  defp load_entities do
    entities = APP.list_entities()


    Enum.each(entities, fn x ->
      ES.start(x.key)
    end)
  end
end
