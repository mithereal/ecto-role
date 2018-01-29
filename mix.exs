defmodule EctoRole.Mixfile do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/mithereal/ecto-role"

  def project do
    [
      name: "Ecto Role",
      app: :ecto_role,
      version: @version,
      description: description(),
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env()),
      package: package(),
      docs: docs(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      preferred_cli_env: [ecto_role: :test],
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      applications: applications(Mix.env()),
      extra_applications: [:logger, :runtime_tools],
      mod: {EctoRole.Application, []}
    ]
  end

  defp applications(:test), do: [:logger, :postgrex]

  defp applications(_), do: [:logger]

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib", "test/support"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 2.1"},
      {:postgrex, "~> 0.13", optional: true},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:inch_ex, ">= 0.0.0", only: :docs},
      {:dialyxir, "~> 0.5", only: :dev, runtime: false}
    ]
  end

  defp description() do
    """
    Implement Table, Row and Column Locking via OTP
    """
  end

  defp package() do
    [
      maintainers: ["Jason Clark"],
      licenses: ["MIT"],
      links: %{GitHub: @source_url},
      files: [
        "lib",
        "CHANGELOG.md",
        "LICENSE",
        "mix.exs",
        "README.md",
        "priv/templates"
      ]
    ]
  end

  defp aliases do
    [
      c: "compile",
      test: [
        "ecto.drop --quiet",
        "ecto.create --quiet",
        "ecto_role.clear.migrations",
        "ecto_role.gen.migration",
      #  "ecto_role.gen.test.migration",
        "ecto.migrate",
       # "run priv/repo/test_seeds.exs",
        "test"
      ],
      in: [
        "ecto.drop --quiet",
        "ecto.create --quiet",
        "ecto_role.clear.migrations",
        "ecto_role.gen.migration",
        "ecto.migrate",
        "run priv/repo/seeds.exs"
      ]
    ]
  end

  defp docs do
    [
      main: "readme",
      homepage_url: @source_url,
      source_ref: "v#{@version}",
      source_url: @source_url,
      extras: ["README.md"]
    ]
  end
end
