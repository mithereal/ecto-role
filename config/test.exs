use Mix.Config

config :ecto_role, EctoRole, repo: EctoRole.Repo

config :ecto_role, ecto_repos: [EctoRole.Repo]

config :ecto_role, EctoRole.Repo,
       adapter: Ecto.Adapters.Postgres,
       database: "ecto_role_test",
       username: "mithereal",
       password: "***REMOVED***",
       hostname: "localhost",
       port: "5432"