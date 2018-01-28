defmodule EctoRole.Role do
  @moduledoc """
    Role: Represents a Role and filters for an associated Entity.
  """

  use Ecto.Schema

  import Ecto.Changeset

  alias EctoRole.Role, as: ROLE
  alias EctoRole.Filter, as: FILTER
  alias EctoRole.Entity, as: ENTITY
  alias EctoRole.Schema, as: SCHEMA
  alias EctoRole.Filter.Role, as: FR
  alias EctoRole.Entity.Role, as: ER

  alias EctoRole.Repo, as: Repo

  schema "er_role" do
    field(:name, :string)
    field(:key, :string)

    many_to_many(
      :entities,
      ENTITY,
      join_through: ER,
      join_keys: [entity_key: :key, role_key: :key]
    )

    many_to_many(
      :filters,
      FILTER,
      join_through: FR,
      join_keys: [filter_key: :key, role_key: :key]
    )
  end

  @params ~w(name key)a
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
  Fetch the Entitys belonging to the Role by key
  """
  @spec get_entities(Map.t()) :: Map.t()
  def get_entities(%{key: value}) do
    record = Repo.get_by(ROLE, key: value) |> Repo.preload(:entities)
    record.entities
  end

  @doc """
  Fetch the Entitys belonging to the Role by name
  """
  @spec get_entities(Map.t()) :: Map.t()
  def get_entities(%{name: value}) do
    record = Repo.get_by(ROLE, name: value) |> Repo.preload(:entities)
    record.entities
  end

  @doc """
  Fetch the filters belonging to the Role by key
  """
  @spec get_filters(Map.t()) :: Map.t()
  def get_filters(%{key: value}) do
    record = Repo.get_by(ROLE, key: value) |> Repo.preload(:filters)
    record.filters
  end

  @doc """
  Fetch the filters belonging to the Role by name
  """
  @spec get_filters(Map.t()) :: Map.t()
  def get_filters(%{name: value}) do
    record = Repo.get_by(ROLE, name: value) |> Repo.preload(:filters)
    record.filters
  end

  @doc """
  Fetch the Complete Role by key
  """
  @spec get(Map.t()) :: Map.t()
  def get(%{key: value}) do
    record =
      Repo.get_by!(ROLE, key: value) |> Repo.preload(:entities)
      |> Repo.preload(filters: :schema)

    record
  end

  @doc """
  Fetch the Complete Role by name
  """
  @spec get(Map.t()) :: Map.t()
  def get(%{name: value}) do
    record =
      Repo.get_by(ROLE, name: value) |> Repo.preload(:entities)
      |> Repo.preload(filters: :schema)

    record
  end

  @doc """
  check if key has filter
  """
  @spec has_filter?(String.t(), String.t()) :: Map.t()
  def has_filter?(id, filter) when is_binary(id) and is_binary(filter), do: has_filter(id, filter)

  def has_filter?(id, filter) do
    status = EctoRole.Entity.Supervisor.start(id)

    case status do
      {:error, message} -> %{error: message}
      _ -> EctoRole.Entity.Server.has_filter(id, filter)
    end
  end

  defp generate_uuid(changeset) do
    uuid = Ecto.UUID.generate()
    case get_change(changeset, :key) do
      nil  ->  changeset
      _->
        changeset
        |> put_change(:key, uuid)
  end

end
