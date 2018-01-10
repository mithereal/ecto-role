defmodule EctoRole.Mixfile do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :ecto_role,
      version: @version,
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      build_embedded: Mix.env == :prod,
      description: description(),
      package: package(),
      name: "Ecto Role",
      source_url: "https://github.com/mithereal/ecto-role"
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
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
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp description() do
    """
    Implement Table, Row and Column Locking via OTP
    """
  end

  defp package() do
    [maintainers: ["Jason Clark"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/mithereal/ecto-role"}]
  end

  defp aliases do
    [c: "compile"]
  end


end
