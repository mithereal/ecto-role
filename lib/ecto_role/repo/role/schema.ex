defmodule EctoRole.Schema do

  @moduledoc """
  Schema: Represents a Schema and associated Fields
"""

  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias EctoRole.Repo, as: Repo

  alias EctoRole.Permission


  schema "er.schema" do
    field :name, :string
    field :fields, :string

    has_many :permissions, Permission

    timestamps()
  end

  @params ~w(name fields)a
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
  Fetch the entire schema from the db
  """
  def all() do
  []
  end

  def get_schema(name) do
    []
  end


end