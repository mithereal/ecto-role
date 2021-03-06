defmodule EctoRole do
  alias EctoRole.Role, as: ROLE
  alias EctoRole.Filter, as: FILTER
  alias EctoRole.Entity, as: ENTITY
  alias EctoRole.Schema, as: SCHEMA
  alias EctoRole.Filter.Role, as: FR
  alias EctoRole.Entity.Role, as: ER

  alias EctoRole.Repo, as: Repo

  config = Application.get_env(:ecto_role, EctoRole, [])
  @repo Keyword.get(config, :repo)

  if config == [], do: raise("EctoRole configuration is required")
  if is_nil(@repo), do: raise("EctoRole requires a repo")

  @moduledoc """
  Ecto-Role: Implement Table, Row and Column Locking(ish) via OTP
  """

  @doc """
  ** is?: checks if username is role **

  ## Examples

      iex> EctoRole.is? "username", "super"
      :false

  """
  def is?(key, role) do
    false
  end

  @doc """
  ** filter: filters struct based on role/struct **

  ## Examples

      iex> EctoRole.filter "key", %{}
      %{}

  """
  def filter(key, struct) do
    struct
  end

  def repo do
    :ecto_role
    |> Application.fetch_env!(EctoRole)
  end

  @doc """
  Gets a single entity.

  Raises `Ecto.NoResultsError` if the Entity does not exist.

  ## Examples


  """
  # @spec get_entity!(String.t()) :: Map.t()
  def get_entity!(id), do: Repo.get!(ENTITY, id)

  @doc """
  Creates a entity.

  ## Examples



  """
  # @spec create_entity(Map.t()) :: Tuple.t()
  def create_entity(attrs \\ %{}) do
    %ENTITY{}
    |> ENTITY.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns the list of entity.

  ## Examples


  """
  def list_entities do
    Repo.all(ENTITY)
  end

  @doc """
  Updates a entity.

  ## Examples

  """
  # @spec update_entity(Map.t()) :: Tuple.t()
  def update_entity(%ENTITY{} = entity, attrs) do
    entity
    |> ENTITY.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Entity.

  ## Examples


  """
  # @spec delete_entity(Map.t()) :: Tuple.t()
  def delete_entity(%ENTITY{} = entity) do
    Repo.delete(entity)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking entity changes.

  ## Examples


  """
  # @spec change_entity(Map.t()) :: Map.t()
  def change_entity(%ENTITY{} = entity) do
    ENTITY.changeset(entity, %{})
  end

  @doc """
  Returns the list of filter.

  ## Examples

  """
  def list_filters do
    Repo.all(FILTER)
  end

  @doc """
  Gets a single filter.

  Raises `Ecto.NoResultsError` if the Filter does not exist.

  ## Examples

  """
  # @spec get_filter!(String.t()) :: Map.t()
  def get_filter!(id), do: Repo.get!(FILTER, id)

  @doc """
  Creates a filter.

  ## Examples


  """
  # @spec create_filter(Map.t()) :: Tuple.t()
  def create_filter(attrs \\ %{}) do
    %FILTER{}
    |> FILTER.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a filter.

  ## Examples


  """
  # @spec update_filter(Map.t()) :: Tuple.t()
  def update_filter(%FILTER{} = filter, attrs) do
    filter
    |> FILTER.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Filter.

  ## Examples



  """
  # @spec delete_filter(Map.t()) :: Tuple.t()
  def delete_filter(%FILTER{} = filter) do
    Repo.delete(filter)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking filter changes.

  ## Examples



  """
  # @spec change_filter(Map.t()) :: Map.t()
  def change_filter(%FILTER{} = filter) do
    FILTER.changeset(filter, %{})
  end

  @doc """
  Returns the list of er_role.

  ## Examples

  """
  def list_roles do
    Repo.all(ROLE)
  end

  @doc """
  Gets a single role.

  Raises `Ecto.NoResultsError` if the Role does not exist.

  ## Examples


  """
  # @spec get_role!(String.t()) :: Map.t()

  def get_role!(id), do: Repo.get!(ROLE, id)

  @doc """
  Creates a role.

  ## Examples



  """
  # @spec create_role(Map.t()) :: Tuple.t()

  def create_role(attrs \\ %{}) do
    %ROLE{}
    |> ROLE.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a role.

  ## Examples


  """
  # @spec update_role(Map.t()) :: Tuple.t()

  def update_role(%ROLE{} = role, attrs) do
    role
    |> ROLE.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Role.

  ## Examples


  """
  # @spec delete_role(Map.t()) :: Tuple.t()

  def delete_role(%ROLE{} = role) do
    Repo.delete(role)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking role changes.

  ## Examples


  """
  # @spec change_role(Map.t()) :: Map.t()

  def change_role(%ROLE{} = role) do
    ROLE.changeset(role, %{})
  end

  @doc """
  Returns the list of er_schema.

  ## Examples


  """

  def list_schemas do
    Repo.all(SCHEMA)
  end

  @doc """
  Gets a single schema.

  Raises `Ecto.NoResultsError` if the Schema does not exist.

  ## Examples



  """
  # @spec get_schema!(String.t()) :: Map.t()

  def get_schema!(id), do: Repo.get!(SCHEMA, id)

  @doc """
  Creates a schema.

  ## Examples



  """
  # @spec create_schema(Map.t()) :: Tuple.t()

  def create_schema(attrs \\ %{}) do
    %SCHEMA{}
    |> SCHEMA.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a schema.

  ## Examples



  """
  # @spec update_schema(Map.t()) :: Tuple.t()

  def update_schema(%SCHEMA{} = schema, attrs) do
    schema
    |> SCHEMA.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Schema.

  ## Examples



  """
  # @spec delete_schema(Map.t()) :: Tuple.t()

  def delete_schema(%SCHEMA{} = schema) do
    Repo.delete(schema)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking schema changes.

  ## Examples



  """
  # @spec change_schema(Map.t()) :: Map.t()

  def change_schema(%SCHEMA{} = schema) do
    SCHEMA.changeset(schema, %{})
  end

  def fetch_schemas() do
    SCHEMA.all()
  end
end
