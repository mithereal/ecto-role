defmodule EctoRole.Entity do
  @moduledoc """
  Entity: Represents a Object That has a Role.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias EctoRole.Role, as: ROLE
  alias EctoRole.Entity, as: ENTITY
  alias EctoRole.Entity.Role, as: ER
  alias EctoRole.Repo, as: Repo

  schema "er_entity" do
    field(:key, :string, default: nil)
    field(:status, :string, default: nil)

    many_to_many(:roles, ROLE, join_through: ER, join_keys: [entity_key: :key, role_key: :key])
  end

  @params ~w(key status)a
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

  defp generate_uuid(changeset) do
    uuid = Ecto.UUID.generate()

    case get_change(changeset, :key) do
      nil ->
        changeset
        |> put_change(:key, uuid)

      _ ->
        changeset
        |> put_change(:key, uuid)

    end
  end

  @doc """
  Fetch the Complete Entity by key
  """
  @spec get(Map.t()) :: Map.t()

  def get(%{key: key}) do
    record = Repo.get_by(ENTITY, key: key) |> Repo.preload(roles: :filters)
    record
  end
end
