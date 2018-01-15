defmodule EctoRole.Test.DataCase do
  use ExUnit.CaseTemplate
  alias EctoRole.Test.Repo
  import EctoRole.Test.Support.FileHelpers

  using _opts do
    quote do
      import EctoRole.Test.DataCase
      alias EctoRole.Test.Repo
    end
  end

  setup_all do
    on_exit(fn -> destroy_tmp_dir("priv/temp/ecto_role_test") end)
    :ok
  end

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Repo, {:shared, self()})
    :ok
  end


end