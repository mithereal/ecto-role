defmodule Mix.Tasks.EctoRole.Entity.SetupTest do
    use ExUnit.Case
    #import EctoRole.Test.Support.FileHelpers

    alias EctoRole.Entity.Supervisor, as: ES
    alias EctoRole.Entity, as: ENTITY

    describe "Entity server startup succeeds with valid entity" do

    test "is a valid entity" do

      entity = ENTITY.all()

      first = List.first( entity )

      server = ES.start( first.key )

      assert = case server do
        {:error, "Unknown Entity"} -> false
        _ -> true
      end

      assert true == assert
    end
    end

    describe "Entity server startup fails with invalid entity" do
    test "is an invalid entity" do

      server = ES.start( "totally_invalid_entity" )

      assert = case server do
        {:error, "Unknown Entity"} -> false
        _ -> true
      end

      assert false == assert

    end
  end
  end