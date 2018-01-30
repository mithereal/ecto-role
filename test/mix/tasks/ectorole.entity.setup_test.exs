defmodule Mix.Tasks.EctoRole.Entity.SetupTest do
  use ExUnit.Case
  # import EctoRole.Test.Support.FileHelpers

  alias EctoRole.Entity.Supervisor, as: ES
  alias EctoRole.Entity, as: ENTITY

  alias EctoRole, as: APP

  describe "Entity Server: Valid Entity " do
    test "Success" do
      entity = APP.list_entities()

      first = List.first(entity)

      result = ES.start(first.key)

      assert =
        case result do
          {:error, "Unknown Entity"} -> false
          _ -> true
        end

      assert true == assert
    end
  end

  describe "Entity Server: Invalid Entity" do
    test "Success" do
      result = ES.start("totally_invalid_entity")

      assert =
        case result do
          {:error, "Unknown Entity"} -> false
          _ -> true
        end

      assert false == assert
    end
  end

  describe "Entity Server: Create" do
    test "Create an Entity with Storage" do

      result = ES.new()

      assert =
        case result do
          {:error, _} -> false
          _ -> true
        end

      assert true == assert
    end
  end

  describe "Entity Server: Deactivate" do
    test "Deactivate" do
      entity = APP.list_entities()

      first = List.first(entity)

      ES.start(first.key)

      result = ES.deactivate(first.key)

      assert =
        case result do
          {:error, _} -> false
          _ -> true
        end

      assert true == assert
    end
  end

  describe "Entity Server: Activate" do
    test "Activate" do
      entity = APP.list_entities()

      first = List.first(entity)

      ES.start(first.key)

      result = ES.activate(first.key)

      assert =
        case result do
          {:error, _} -> false
          _ -> true
        end

      assert true == assert
    end
  end

  describe "Entity Server: Delete" do
    test "Delete an Entity from Storage" do
      entity = APP.list_entities()

      first = List.first(entity)

      ES.start(first.key)

      result = ES.delete(first.key)

      assert =
        case result do
          {:error, _} -> false
          _ -> true
        end

      assert true == assert
    end
  end
end
