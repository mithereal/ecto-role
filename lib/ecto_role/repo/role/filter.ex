defmodule EctoRole.Filter do
  @moduledoc """
    filter: Represents the filters on a schema
  """

  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query

  alias EctoRole.Filter, as: FILTER
  alias EctoRole.Role, as: ROLE
  alias EctoRole.Schema, as: SCHEMA
  alias EctoRole.Filter.Role, as: FR
  alias EctoRole.Filter.Read, as: READ
  alias EctoRole.Filter.Write, as: WRITE

  alias EctoRole.Repo, as: Repo

  schema "er_filter" do
    field(:name, :string)
    field(:status, :string, default: "active")
    field(:create, :boolean)
    field(:delete, :boolean)
    field(:key, :string)

    belongs_to(:schema, SCHEMA)

    embeds_one :read, READ
    embeds_one :write, WRITE

    many_to_many(
      :roles,
      ROLE,
      [join_through: FR, join_keys: [filter_key: :key, role_key: :key], on_delete: :delete_all]
    )
    timestamps()
  end

  @params ~w(name create delete key status schema_id)a
  @required_fields ~w(name)a

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @params)
    |> validate_required(@required_fields)
    |> generate_uuid()
  end

  @doc """
  Fetch the Complete Permsission set by schema
  """
  #@spec get(Map.t()) :: Map.t()
  def get(%{key: value}) do
    record = Repo.get_by(FILTER, key: value) |> Repo.preload(:schema)
    record
  end

  @doc """
  Fetch the Complete Permsission set by schema
  """
 # @spec get(Map.t()) :: Map.t()
  def get(%{name: value}) do
    record = Repo.get_by(FILTER, name: value) |> Repo.preload(:schema)
    record
  end

  @doc """
  delete single filter
  """
  #def delete(filter) when is_map(filter), do: delete(filter)

  def delete(filter) do
    record = Repo.delete(filter)
    record
  end

  @doc """
  delete all from the list of filters
  """
  def delete_all(filters) when is_list(filters), do: delete_all(filters)

  def delete_all(filters) do
    Enum.each(filters, fn f ->
      from(x in FILTER, where: x.key == ^f.key) |> Repo.delete_all()
    end)
  end

  @doc """
  create a new filter ## destructure attrs
  """
  def create(attrs \\ %{}) do

    IO.inspect(attrs, label: "attrs")
    FILTER
    |> FILTER.changeset(attrs)
    |> Repo.insert()
  end

  defp generate_uuid(changeset) do
    uuid = Ecto.UUID.generate()

    case get_change(changeset, :key) do
      nil ->
        changeset
        |> put_change(:key, uuid)

      _ ->
        changeset

    end
  end
end
