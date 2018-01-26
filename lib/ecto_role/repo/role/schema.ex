defmodule EctoRole.Schema do

  @moduledoc """
  Schema: Represents a Schema and associated Fields
"""

  use Ecto.Schema

  import Ecto
  import Ecto.Changeset
  import Ecto.Query

  alias EctoRole.Permission, as: PERMISSION

  alias EctoRole.Repo, as: Repo


  schema "er.schema" do
    field :name, :string
    field :fields, :string

    has_many :permissions, PERMISSION

    timestamps()
  end

  @params ~w(name fields)a
  @required_fields ~w(name)a
  @ignored_schemas ~w(er.entity er.role_to_entity er.permission er.role_to_permission er.role er.schema)a


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
  query = """
    SELECT table_name
    FROM information_schema.tables
    where table_schema = $1
    ORDER BY table_name;
  """

  Ecto.Adapters.SQL.query!(Repo, query, ["public"])
  end

  @doc """
  Fetch the entire schema for specified table from the public db
  """
  @spec get_schema(String.t) :: Map.t
  def get_schema(name) when is_binary(name), do: get_schema(name)
  def get_schema(name) do
    query = """
        SELECT *
        FROM information_schema.columns
        WHERE table_schema = $1
        AND table_name   = $2
      """

      Ecto.Adapters.SQL.query!(Repo, query, ["public", name])
  end

  @doc """
  Fetch the entire schema from specified db
  """
  @spec get_schema(String.t,String.t) :: Map.t
  def get_schema(schema, name) when is_binary(name) and is_binary(schema), do: get_schema(schema, name)
  def get_schema(schema, name) do
    query = """
        SELECT *
        FROM information_schema.columns
        WHERE table_schema = $1
        AND table_name   = $2
      """

       Ecto.Adapters.SQL.query!(Repo, query, [schema,  name])
  end

  def filter_schema(schema) do

  end

end