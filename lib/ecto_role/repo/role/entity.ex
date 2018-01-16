defmodule EctoRole.Entity do

  @moduledoc """
  Entity: Represents a schema where the name is the name of the schema, the key is the column to select on and
the value is the expected value, the uuid is the generated key representing this entity/schema combination
  """

  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias EctoRole.Repo, as: Repo

  alias EctoRole.Entity.Role, as: ER


  schema "er.entity" do
    field :name, :string ## ex. users
    field :value, :string  ## ex. mithereal
    field :key, :string ## ex. username

    field :uuid, :string ## this will represent the uniq user

    many_to_many :roles, Role, join_through: ER
  end

  @params ~w(name value key)a
  @required_fields ~w(name value)a


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
    |> put_change(:uuid, uuid)

  end


  @doc """
  Fetch the Complete Entity by name
  """
  def get_entity(%{name: value}) do
    record = EctoRole.repo().get_by(Entity, name: value) |> EctoRole.repo().preload(:roles)
    record
  end

  @doc """
  Fetch the Complete Entity by key
  """
  def get_entity(%{key: value}) do
    record = EctoRole.repo().get_by(Entity, name: value) |> EctoRole.repo().preload(:roles)
    record
  end


end