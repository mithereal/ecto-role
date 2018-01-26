defmodule EctoRole.Entity do

  @moduledoc """
  Entity: Represents a Object That has a Role.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias EctoRole.Role.Role, as: ROLE
  alias EctoRole.Entity, as: ENTITY
  alias EctoRole.Entity.Role, as: ER
  alias EctoRole.Repo, as: Repo

  schema "er.entity" do

    field :key, :string

    many_to_many :roles, ROLE, join_through: ER
  end

  @params ~w()a
  @required_fields ~w()a


  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @params)
    |> validate_required(@required_fields)
    |> generate_uuid()
  end

  @doc """
  Builds an update changeset based on the `struct` and `params`.
  """
  def update_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @params)
    |> validate_required(@required_fields)
  end

  defp generate_uuid(changeset) do

    uuid = Ecto.UUID.generate

    changeset
    |> put_change(:key, uuid)

  end


  @doc """
  Fetch the Complete Entity by key
  """
  @spec get_entity(Map.t) :: Map.t

  def get_entity(%{key: key}) do

    record = Repo.get_by(ENTITY, key: key) |> Repo.preload(:roles)
    record
  end


end