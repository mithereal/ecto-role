defmodule EctoRole.Mixfile do
  use Mix.Project

  @version "0.1.0"
  @source_url "https://github.com/mithereal/ecto-role"


  def project do
    [
      app: :ecto_role,
      version: @version,
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      docs: docs(),
      build_embedded: Mix.env == :prod,
      description: description(),
      package: package(),
      name: "Ecto Role",
      source_url: @source_url
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [applications: applications(Mix.env)]
  end

  defp applications(:test), do: [:logger, :postgrex]

  defp applications(_) do
     [
     extra_applications: [:logger],
     mod: {EctoRole.Application, []}
     ]
  end


  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      {:ecto, "~> 2.1"},
      {:postgrex, "~> 0.13", optional: true},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:inch_ex, ">= 0.0.0", only: :docs}
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
      links:  %{GitHub: @source_url },
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
    [c: "compile", test: ["ecto.drop --quiet", "ecto.create --quiet", "ecto_role.gen.migration", "ecto.migrate", "test"]]
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
