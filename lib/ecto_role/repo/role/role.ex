defmodule EctoRole.Role do

  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias EctoRole.Role
  alias EctoRole.Entity
  alias EctoRole.Entity.Role, as ER

  schema "role" do
    field :name, :string
    field :value, :string
    field :key, :string

    many_to_many :entites, Entity, join_through: ER
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