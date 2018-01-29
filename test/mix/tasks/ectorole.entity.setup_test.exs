defmodule Mix.Tasks.EctoRole.Entity.SetupTest do
  use ExUnit.Case
  # import EctoRole.Test.Support.FileHelpers

  alias EctoRole.Entity.Supervisor, as: ES
  alias EctoRole.Entity.Server, as: SERVER
  alias EctoRole.Entity, as: ENTITY

  describe "Entity server startup succeeds with valid entity" do
    test "is a valid entity" do
      entity = ENTITY.all()

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

  describe "Entity server startup fails with invalid entity" do
    test "is an invalid entity" do
      result = ES.start("totally_invalid_entity")

      assert =
        case result do
          {:error, "Unknown Entity"} -> false
          _ -> true
        end

      assert false == assert
    end
  end

  describe "Entity server create a new entity" do
    test "create an entity with storage" do
      entity = ENTITY.all()

      first = List.first(entity)

      ES.start(first.key)

      result = ES.new(first.key)

      assert =
        case result do
          {:error, _} -> false
          _ -> true
        end

      assert true == assert
    end
  end

  describe "Deactivate Entity server" do
    test "soft delete an entity from storage" do
      entity = ENTITY.all()

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

  describe "Activate Entity server" do
    test "activate an entity from storage" do
      entity = ENTITY.all()

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

  describe "Delete the Entity server" do
    test "delete an entity from storage" do
      entity = ENTITY.all()

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
