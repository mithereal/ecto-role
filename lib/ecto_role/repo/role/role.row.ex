defmodule EctoRole.Role.Row do
  @moduledoc """
    Row: Represents a Row and associated Fields
    name is the name of the table
  """

  use Ecto.Schema

  import Ecto
  import Ecto.Changeset
  import Ecto.Query

  alias EctoRole.Schema, as: SCHEMA
  alias EctoRole.Role, as: ROLE

  alias EctoRole.Repo, as: Repo

  schema "er_role_to_row" do
    field(:row_id, :integer)

    belongs_to(:schema, SCHEMA)
    belongs_to(:role, ROLE, [foreign_key: :role_key, references: :key, type: :string])


    timestamps()
  end

  @params ~w()a

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @params)
  end


end
