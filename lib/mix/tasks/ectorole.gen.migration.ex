defmodule Mix.Tasks.EctoRole.Gen.Migration do
  @shortdoc "Generates EctoRole's migration"

  @moduledoc """
  Generates the required EctoRole's database migration
  """
  use Mix.Task

  import Mix.Ecto
  import Mix.Generator
  import EctoRole.Test.Support.FileHelpers

  @doc false
  def run(args) do

    destroy_tmp_dir("priv/repo/migrations")

    no_umbrella!("ecto.gen.migration")

    repos = parse_repo(args)

    Enum.each(repos, fn repo ->
      ensure_repo(repo, args)
      path = migrations_path(repo)

      source_path =
        :ecto_role
        |> Application.app_dir()
        |> Path.join("priv/templates/migration.exs.eex")

      generated_file = EEx.eval_file(source_path, module_prefix: app_module())
      target_file = Path.join(path, "#{timestamp()}_ectorole.exs")
      create_directory(path)
      create_file(target_file, generated_file)
    end)
  end

  defp app_module do
    Mix.Project.config()
    |> Keyword.fetch!(:app)
    |> to_string()
    |> Macro.camelize()
  end

  defp timestamp do
    {{y, m, d}, {hh, mm, ss}} = :calendar.universal_time()
    "#{y}#{pad(m)}#{pad(d)}#{pad(hh)}#{pad(mm)}#{pad(ss)}"
  end

  defp pad(i) when i < 10, do: <<?0, ?0 + i>>
  defp pad(i), do: to_string(i)
end
