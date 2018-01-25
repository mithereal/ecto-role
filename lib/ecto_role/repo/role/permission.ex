defmodule EctoRole.Permission do

  @moduledoc """
  Permission: Represents the permissions on a schema
"""

  use Ecto.Schema

  import Ecto.Changeset



  alias EctoRole.Permission, as: PERMISSION
  alias EctoRole.Role.Role, as: ROLE
  alias EctoRole.Schema, as: SCHEMA
  alias EctoRole.Permission.Role, as: PR

  alias EctoRole.Repo, as: Repo


  schema "er.permission" do
    field :name, :string
    field :read, :string
    field :write, :string
    field :create, :boolean
    field :delete, :boolean
    field :key, :string

    belongs_to :schema, SCHEMA

    many_to_many :roles, ROLE, join_through: PR

    timestamps()
  end

  @params ~w(name read write create delete key)a
  @required_fields ~w(name)a


  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @params)
    |> validate_required(@required_fields)
  end

  @doc """
  Fetch the Complete Permsission set by schema
  """
  @spec get_permissions(Map.t) :: Map.t
  def get_permissions(%{key: value}) do
    record = Repo.get_by(PERMISSION, key: value) |> Repo.preload(:schema)
    record
  end

  @doc """
  Fetch the Complete Permsission set by schema
  """
  @spec get_permissions(Map.t) :: Map.t
  def get_permissions(%{name: value}) do
    record = Repo.get_by(PERMISSION, name: value) |> Repo.preload(:schema)
    record
  end

end