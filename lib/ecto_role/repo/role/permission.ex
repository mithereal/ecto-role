defmodule EctoRole.Permission do

  @moduledoc false

  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query


  schema "permission" do
    field :name, :string
    field :read, :string
    field :write, :string
    field :create, :boolean
    field :delete, :boolean
    field :key, :string

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