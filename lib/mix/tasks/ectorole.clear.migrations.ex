defmodule Mix.Tasks.EctoRole.Clear.Migrations do
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
  end
end
