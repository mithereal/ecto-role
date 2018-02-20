defmodule Mix.Tasks.EctoRole.Schema.SetupTest do
  use ExUnit.Case
  # import EctoRole.Test.Support.FileHelpers

  alias EctoRole.Schema.Supervisor, as: SS
  alias EctoRole.Schema, as: SCHEMA

  describe "Schema Server: Valid Schema" do
    test "Success" do
      schema = SCHEMA.all()

      first = List.first(schema)

      result = SS.start(first)

      assert =
        case result do
          {:error, "Unknown Schema"} -> false
          _ -> true
        end

      assert true == assert
    end
  end

  describe "Schema Server: Invalid Schema" do
    test "Success" do
      result = SS.start("totally_invalid_schema")

      assert =
        case result do
          {:error, "Unknown Schema"} -> false
          _ -> true
        end

      assert false == assert
    end
  end
#
#  describe "Schema Server: New Schema" do
#    test "Success" do
#      schema = SCHEMA.all()
#
#
#      first = List.first(schema)
#
#      SS.start(first)
#
#      result = SS.new(first)
#
#      assert =
#        case result do
#          {:error, _} -> false
#          _ -> true
#        end
#
#      assert true == assert
#    end
#  end
#
#
#  describe "Schema Server: Delete Schema" do
#    test "Success" do
#      schema = SCHEMA.all()
#
#      first = List.first(schema)
#
#      SS.start(first)
#
#      result = SS.remove(first)
#
#      assert =
#        case result do
#          {:error, _} -> false
#          _ -> true
#        end
#
#      assert true == assert
#    end
#  end
end
