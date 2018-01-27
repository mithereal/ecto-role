use Mix.Config

config :ecto_role, EctoRole, repo: EctoRole.Repo

config :ecto_role, ecto_repos: [EctoRole.Repo]

config :ecto_role, EctoRole.Repo,
       adapter: Ecto.Adapters.Postgres,
       database: "ecto_role_test",
       pool: Ecto.Adapters.SQL.Sandbox,
       priv: "priv/temp/ecto_role_test"