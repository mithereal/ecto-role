defmodule Mix.Tasks.EctoRole.Role.SetupTest do
  use ExUnit.Case
  # import EctoRole.Test.Support.FileHelpers

  alias EctoRole.Role.Supervisor, as: RS
  alias EctoRole.Role.Server, as: SERVER
  alias EctoRole.Role, as: ROLE

  describe "Role server startup succeeds with valid role" do
    test "is a valid role" do
      role = ROLE.all()

      first = List.first(role)

      result = RS.start(first.key)

      assert =
        case result do
          {:error, "Unknown Role"} -> false
          _ -> true
        end

      assert true == assert
    end
  end

  describe "Role server startup fails with invalid role" do
    test "is an invalid role" do
      result = RS.start("totally_invalid_role")

      assert =
        case result do
          {:error, "Unknown Role"} -> false
          _ -> true
        end

      assert false == assert
    end
  end

  describe "Role server create a new role" do
    test "create an role" do
      role = ROLE.all()

      first = List.first(role)

      RS.start(first.key)

      result = RS.new(first.key)

      assert =
        case result do
          {:error, _} -> false
          _ -> true
        end

      assert true == assert
    end
  end
  

  describe "Role server soft delete an role" do
    test "soft delete an role" do
      role = ROLE.all()

      first = List.first(role)

      RS.start(first.key)

      result = RS.remove(first.key)

      assert =
        case result do
          {:error, _} -> false
          _ -> true
        end

      assert true == assert
    end
  end

  describe "Role server delete an role" do
    test "delete an role" do
      role = ROLE.all()

      first = List.first(role)

      RS.start(first.key)

      result = RS.delete(first.key)

      assert =
        case result do
          {:error, _} -> false
          _ -> true
        end

      assert true == assert
    end
  end
end
