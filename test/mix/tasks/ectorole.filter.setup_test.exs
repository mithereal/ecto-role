defmodule Mix.Tasks.EctoFilter.Filter.SetupTest do
  use ExUnit.Case
  # import EctoFilter.Test.Support.FileHelpers

  alias EctoFilter.Filter.Supervisor, as: FS
  alias EctoFilter.Filter.Server, as: SERVER
  alias EctoFilter.Filter, as: FILTER

  describe "Filter server startup succeeds with valid filter" do
    test "is a valid filter" do
      filter = FILTER.all()

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

  describe "Filter server startup fails with invalid filter" do
    test "is an invalid filter" do
      result = FS.start("totally_invalid_filter")

      assert =
        case result do
          {:error, "Unknown Filter"} -> false
          _ -> true
        end

      assert false == assert
    end
  end

  describe "Filter server create a new filter" do
    test "create an filter" do
      filter = FILTER.all()

      first = List.first(filter)

      FS.start(first.key)

      result = FS.new(first.key)

      assert =
        case result do
          {:error, _} -> false
          _ -> true
        end

      assert true == assert
    end
  end
  

  describe "Filter server soft delete an filter" do
    test "soft delete an filter" do
      filter = FILTER.all()

      first = List.first(filter)

      FS.start(first.key)

      result = FS.remove(first.key)

      assert =
        case result do
          {:error, _} -> false
          _ -> true
        end

      assert true == assert
    end
  end

  describe "Filter server delete an filter" do
    test "delete an filter" do
      filter = FILTER.all()

      first = List.first(filter)

      FS.start(first.key)

      result = FS.delete(first.key)

      assert =
        case result do
          {:error, _} -> false
          _ -> true
        end

      assert true == assert
    end
  end
end
