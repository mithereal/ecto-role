defmodule EctoRole.Permission do

  @moduledoc """
  Permission: Represents the permissions on a schema
"""

  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias EctoRole.Permission
  alias EctoRole.Role
  alias EctoRole.Schema, as: Schema
  alias EctoRole.Permission.Role, as: PR


  schema "permission" do
    field :name, :string
    field :read, :string
    field :write, :string
    field :create, :boolean
    field :delete, :boolean
    field :key, :string

    belongs_to :schema, Schema

    many_to_many :roles, Role, join_through: PR

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