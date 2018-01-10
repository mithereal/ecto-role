defmodule EctoRole.Entity do

  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query


  alias EctoRole.Role
  alias EctoRole.Permissions
  alias EctoRole.RoleToEntity
  alias EctoRole.RoleToPermission


  schema "entity" do
    field :name, :string
    field :value, :string
    field :key, :string

    many_to_many :roles, Role, join_through: RoleToEntity
    many_to_many :permissions, Permissions, join_through: RoleToPermission
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

end