defmodule EctoRole.Role do

  @moduledoc """
  Role: Represents a Role and Permissions for an associated Entity.
"""

  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias EctoRole.Role
  alias EctoRole.Permission
  alias EctoRole.Entity
  alias EctoRole.Permission.Role, as: PR
  alias EctoRole.Entity.Role, as: ER

  schema "er.role" do
    field :name, :string
    field :value, :string
    field :key, :string

    many_to_many :entites, Entity, join_through: ER
    many_to_many :permissions, Permission, join_through: PR
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
  end

  @doc """
  Fetch the Entitys belonging to the Role by key
  """
  def get_entities(%{key: value}) do
    record = Repo.get_by(Role, key: value) |> Repo.preload(:entites)
    record.entities
  end

  @doc """
  Fetch the Entitys belonging to the Role by name
  """
  def get_entities(%{name: value}) do
    record = Repo.get_by(Role, name: value) |> Repo.preload(:entites)
    record.entities
  end

  @doc """
  Fetch the Permissions belonging to the Role by key
  """
  def get_permissions(%{key: value}) do
    record = Repo.get_by(Role, key: value) |> Repo.preload(:permissions)
    record.permissions
  end

  @doc """
  Fetch the Permissions belonging to the Role by name
  """
  def get_permissions(%{name: value}) do
    record = Repo.get_by(Role, name: value) |> Repo.preload(:permissions)
    record.permissions
  end

  @doc """
  Fetch the Complete Role by key
  """
  def get_role(%{key: value}) do
    record = Repo.get_by(Role, key: value) |> Repo.preload(:entites) |> Repo.preload(permissions: :schema)
    record
  end

  @doc """
  Fetch the Complete Role by name
  """
  def get_role(%{name: value}) do
    record = Repo.get_by(Role, name: value) |> Repo.preload(:entites) |> Repo.preload(permissions: :schema)
    record
  end

  @doc """
  Fetch the Complete Role by key
  """
  def get_role(%{key: value}) do
    record = Repo.get_by(Role, key: value) |> Repo.preload(:entites) |> Repo.preload(permissions: :schema)
    record
  end

 @doc """
  check if uuid has permission
  """
  def has_permission(id, permission) do
    ##lookup uuid
    ## get roles
    ##check for permission
    false
  end

end