defmodule EctoRole.Schema do
  @moduledoc """
    Schema: Represents a Schema and associated Fields
    name is the name of the table
  """

  use Ecto.Schema

  import Ecto
  import Ecto.Changeset
  import Ecto.Query

  alias EctoRole.Filter, as: FILTER
  alias EctoRole.Schema, as: SCHEMA
  alias EctoRole.Schema.Fields, as: FIELDS
  alias EctoRole.Schema.Relation, as: RELATIONS

  alias EctoRole.Repo, as: Repo

  schema "er_schema" do
    field(:name, :string)

    embeds_one :fields, FIELDS
    embeds_many :relations, RELATIONS

    has_many(:filters, FILTER)

    timestamps()
  end



  @params ~w(name)a
  @required_fields ~w(name)a
  @ignored_schemas ~w(er_entity er_role_to_entity er_permission er_role_to_permission er_filter er_role_to_filter er_role er_schema schema_migrations)

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

    result = Ecto.Adapters.SQL.query!(Repo, query, ["public"])

    List.flatten(result.rows)
    |> filter_ignored_schemas
  end

  @doc """
  Fetch the entire schema for specified table from the public db
  """
  @spec get_schema(String.t()) :: Map.t()
  # def get_schema(name) when is_binary(name), do: get_schema(name)

  def get_schema(name) do
    query = """
      SELECT column_name
      FROM information_schema.columns
      WHERE table_schema = $1
      AND table_name   = $2
    """

    result = Ecto.Adapters.SQL.query!(Repo, query, ["public", name])

    List.flatten(result.rows)
  end

  @doc """
  Fetch the entire schema from specified db
  """
  @spec get_schema(String.t(), String.t()) :: Map.t()
  def get_schema(schema, name) when is_binary(name) and is_binary(schema),
    do: get_schema(schema, name)

  def get_schema(schema, name) do
    query = """
      SELECT *
      FROM information_schema.columns
      WHERE table_schema = $1
      AND table_name   = $2
    """

    result = Ecto.Adapters.SQL.query!(Repo, query, [schema, name])

    List.flatten(result.rows)
  end

  @doc """
  Fetch the  schema from schemas table
  """
   def get!(%{key: value}) do
   record =
  Repo.get_by(SCHEMA, ROLE, key: value)

  record
  end


  def filter_ignored_schemas(schema) do
    ignored_schemas = @ignored_schemas


    schema
    |> Enum.filter(fn el -> !Enum.member?(@ignored_schemas, el) end)
  end

  def exists?(name) do
    schema = get_schema(name)

    case Enum.count(schema) > 0 do
      true -> true
      false -> false
    end

  end

  @doc """
  delete single SCHEMA
  """
  #def delete(SCHEMA) when is_map(filter), do: delete(filter)

  def delete(%{key: key}) do
    record = Repo.delete(SCHEMA, key: key)
    record
  end

end
