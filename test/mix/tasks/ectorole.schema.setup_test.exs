defmodule Mix.Tasks.EctoRole.Schema.SetupTest do
  use ExUnit.Case
  # import EctoRole.Test.Support.FileHelpers

  alias EctoRole.Schema.Supervisor, as: SS
  alias EctoRole.Schema.Server, as: SERVER
  alias EctoRole.Schema, as: SCHEMA

  describe "Schema server startup succeeds with valid schema" do
    test "is a valid schema" do
      schema = SCHEMA.all()

      first = List.first(schema)

      result = SS.start(first.key)

      assert =
        case result do
          {:error, "Unknown Schema"} -> false
          _ -> true
        end

      assert true == assert
    end
  end

  describe "Schema server startup fails with invalid schema" do
    test "is an invalid schema" do
      result = SS.start("totally_invalid_schema")

      assert =
        case result do
          {:error, "Unknown Schema"} -> false
          _ -> true
        end

      assert false == assert
    end
  end

  describe "Schema server create a new schema" do
    test "create an schema" do
      schema = SCHEMA.all()

      first = List.first(schema)

      SS.start(first.key)

      result = SS.new(first.key)

      assert =
        case result do
          {:error, _} -> false
          _ -> true
        end

      assert true == assert
    end
  end


  describe "Schema server soft delete an schema" do
    test "soft delete an schema" do
      schema = SCHEMA.all()

      first = List.first(schema)

      SS.start(first.key)

      result = SS.remove(first.key)

      assert =
        case result do
          {:error, _} -> false
          _ -> true
        end

      assert true == assert
    end
  end

  describe "Schema server delete an schema" do
    test "delete an schema" do
      schema = SCHEMA.all()

      first = List.first(schema)

      SS.start(first.key)

      result = SS.delete(first.key)

      assert =
        case result do
          {:error, _} -> false
          _ -> true
        end

      assert true == assert
    end
  end
end
