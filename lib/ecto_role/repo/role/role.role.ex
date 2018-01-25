defmodule EctoRole.Role.Role do

  @moduledoc """
  Role: Represents a Role and Permissions for an associated Entity.
"""

  use Ecto.Schema

  import Ecto.Changeset


  alias EctoRole.Role.Role, as: ROLE
  alias EctoRole.Permission, as: PERMISSION
  alias EctoRole.Entity, as: ENTITY
  alias EctoRole.Permission.Role, as: PR
  alias EctoRole.Entity.Role, as: ER

  alias EctoRole.Repo, as: Repo

  schema "er.role" do
    field :name, :string
    field :value, :string
    field :key, :string

    many_to_many :entites, ENTITY, join_through: ER
    many_to_many :permissions, PERMISSION, join_through: PR
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
  @spec get_entities(Map.t) :: Map.t
  def get_entities(%{key: value}) do
    record = Repo.get_by(ROLE, key: value) |> Repo.preload(:entites)
    record.entities
  end

  @doc """
  Fetch the Entitys belonging to the Role by name
  """
  @spec get_entities(Map.t) :: Map.t
  def get_entities(%{name: value}) do
    record = Repo.get_by(ROLE, name: value) |> Repo.preload(:entites)
    record.entities
  end

  @doc """
  Fetch the Permissions belonging to the Role by key
  """
  @spec get_permissions(Map.t) :: Map.t
  def get_permissions(%{key: value}) do
    record = Repo.get_by(ROLE, key: value) |> Repo.preload(:permissions)
    record.permissions
  end

  @doc """
  Fetch the Permissions belonging to the Role by name
  """
  @spec get_permissions(Map.t) :: Map.t
  def get_permissions(%{name: value}) do
    record = Repo.get_by(ROLE, name: value) |> Repo.preload(:permissions)
    record.permissions
  end

  @doc """
  Fetch the Complete Role by key
  """
  @spec get_role(Map.t) :: Map.t
  def get_role(%{key: value}) do
    record = Repo.get_by(ROLE, key: value) |> Repo.preload(:entites) |> Repo.preload(permissions: :schema)
    record
  end

  @doc """
  Fetch the Complete Role by name
  """
  @spec get_role(Map.t) :: Map.t
  def get_role(%{name: value}) do
    record = Repo.get_by(ROLE, name: value) |> Repo.preload(:entites) |> Repo.preload(permissions: :schema)
    record
  end

 @doc """
  check if uuid has permission
  """
  @spec has_permission(String.t, String.t) :: Map.t
  def has_permission(id, permission) when is_binary(id) and is_binary(permission), do: has_permission(id, permission)
  def has_permission(id, permission) do

    status = EctoRole.Entity.Supervisor.start(id)

    case status do
    {:error, message} -> %{error: message}
    _ ->  EctoRole.Entity.Server.has_permission(id, permission)

    end

  end

end