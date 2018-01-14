defmodule Mix.Tasks.EctoRole.Gen.Migration do
  @shortdoc "Generates a migration for role based db locking"

  @moduledoc """
    Run mix EctoRole.install to generates a `setup_ecto_role_tables` migration,
    which creates your accounts, entries, and amounts tables, as well as
    required indexes.
  """

  def run(_args) do
    source = Path.join(Application.app_dir(:ecto_role, "/priv/templates/ectorole.install/"), "setup_ectorole_tables.exs")
    target = Path.join(File.cwd!, "/priv/repo/migrations/#{timestamp}_setup_ectorole_tables.exs")

    if !File.dir?(target) do
      File.mkdir_p("priv/repo/migrations/")
    end

    Mix.Generator.create_file(target, EEx.eval_file(source))
  end

  defp timestamp do
    {{y, m, d}, {hh, mm, ss}} = :calendar.universal_time()
    "#{y}#{pad(m)}#{pad(d)}#{pad(hh)}#{pad(mm)}#{pad(ss)}"
  end

  defp pad(i) when i < 10, do: << ?0, ?0 + i >>
  defp pad(i), do: to_string(i)
end