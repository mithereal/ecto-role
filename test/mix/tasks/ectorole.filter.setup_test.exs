defmodule Mix.Tasks.EctoRole.Filter.SetupTest do
  use ExUnit.Case
  # import EctoRole.Test.Support.FileHelpers

  alias EctoRole.Filter.Supervisor, as: FS
  alias EctoRole.Filter, as: FILTER
  alias EctoRole, as: APP

  describe "Filter Server: Valid Filter" do
    test "true" do
      filter = APP.list_filters()

      first = List.first(filter)

      result = FS.start(first.key)

      assert =
        case result do
          {:error, "Unknown Filter"} -> false
          _ -> true
        end

      assert true == assert
    end
  end

  describe "Filter Server: Invalid Filter" do
    test "true" do
      result = FS.start("totally_invalid_filter")

      assert =
        case result do
          {:error, "Unknown Filter"} -> true
          _ -> false
        end

      assert true == assert
    end
  end

  describe "Filter Server: New Filter" do
    test "success" do

      result = FS.new("test filter")

      assert =
        case result do
          {:error, _} -> false
          _ -> true
        end

      assert true == assert
    end
  end

  describe "Filter Server: soft delete Filter" do
    test "success" do
      role = APP.list_filters()

      first = List.first(role)

      FS.start(first.key)

      result = FS.deactivate(first.key)

      assert =
        case result do
          {:error, _} -> false
          _ -> true
        end

      assert true == assert
    end
  end


end
