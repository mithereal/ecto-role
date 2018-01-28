defmodule Mix.Tasks.EctoRole.Gen.MigrationTest do
  use ExUnit.Case, async: true
  import Mix.Tasks.EctoRole.Gen.Migration, only: [run: 1]
  import EctoRole.Test.Support.FileHelpers

  @tmp_path Path.join(tmp_path(), inspect(EctoRole.Gen.Migration))
  @migrations_path Path.join(@tmp_path, "migrations")

  defmodule Setup.Repo do
    def __adapter__ do
      true
    end

    def config do

      [priv: Path.join("priv/temp", inspect(EctoRole.Gen.Migration)), otp_app: :ecto_role]
    end
  end

  setup do

    create_dir(@migrations_path)

    on_exit(fn ->
      destroy_tmp_dir("priv/temp/EctoRole.Gen.Migration")
    end)

    :ok
  end

  test "generates a new migration" do
    run(["-r", to_string(Setup.Repo)])
    assert [name] = File.ls!(@migrations_path)
    assert String.match?(name, ~r/^\d{14}_ectorole\.exs$/)
  end
end
