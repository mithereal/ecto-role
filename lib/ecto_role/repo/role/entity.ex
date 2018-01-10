defmodule EctoRole.Entity do

  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query


  alias EctoRole.Role, as: Role
  alias EctoRole.Permissions, as: Permissions
  alias EctoRole.Entity.Role, as: ER
  alias EctoRole.RoleToPermission, as PR


  schema "entity" do
    field :name, :string
    field :value, :string
    field :key, :string

    many_to_many :roles, Role, join_through: ER
    many_to_many :permissions, Permissions, join_through: PR
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