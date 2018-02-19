defmodule Mix.Tasks.EctoRole.Role.SetupTest do
  use ExUnit.Case
  # import EctoRole.Test.Support.FileHelpers

  alias EctoRole.Role.Supervisor, as: RS

  alias EctoRole, as: APP


  describe "Role Server:  Valid Role" do
    test "success" do
      role = APP.list_roles()

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

  describe "Role Server: Invalid Role" do
    test "success" do
      result = RS.start("totally_invalid_role")

      assert =
        case result do
          {:error, "Unknown Role"} -> false
          _ -> true
        end

      assert false == assert
    end
  end

  describe "Role Server: New Role" do
    test "success" do

      result = RS.new("test role")

      assert =
        case result do
          {:error, _} -> false
          _ -> true
        end

      assert true == assert
    end
  end

  describe "Role Server: soft delete Role" do
    test "success" do
      role = APP.list_roles()

      first = List.first(role)

      RS.start(first.key)

      result = RS.deactivate(first.key)

      assert =
        case result do
          {:error, _} -> false
          _ -> true
        end

      assert true == assert
    end
  end

  describe "Role Server: Delete Role" do
    test "failure" do
      role = APP.list_roles()

      first = List.first(role)

      RS.start(first.key)

      result = RS.delete(first.key)

      assert =
        case result do
          {:error, _} -> false
          _ -> true
        end

      assert false == assert
    end
  end
end
