defmodule EctoRole.Permission do

  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias EctoRole.Schema
  alias EctoRole.Permission
  alias EctoRole.RoleToPermission


  schema "permission" do
    field :name, :string
    field :read, :string
    field :write, :string
    field :create, :boolean
    field :delete, :boolean
    field :key, :string

    belongs_to :schema, Schema

    many_to_many :permissions, Permission, join_through: RoleToPermission

    timestamps()
  end

  @params ~w(name)a
  @required_fields ~w(name)a


  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @params)
    |> validate_required(@required_fields)
  end


end