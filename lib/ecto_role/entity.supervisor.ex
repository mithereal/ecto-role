defmodule EctoRole.Entity.Supervisor do
  use Supervisor

  require Logger

  @moduledoc false

  @registry_name :ecto_role_entity_registry

  alias EctoRole.Entity, as: ENTITY
  alias EctoRole.Repo, as: Repo
  alias EctoRole.Entity.Server, as: ES

  def start_link do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @doc """
  Start a Entity server.
  ## Examples
      iex> EctoRole.Entity.Supervisor.start("xxx")
      "%{}"
  """
  def start(id) do
    ## check if is actually an entity
    e = Repo.get_by(ENTITY, key: id)
    # IO.inspect(e)

    case e do
      %{} -> Supervisor.start_child(__MODULE__, [id])
      _ -> {:error, "Unknown Entity"}
    end
  end

  @doc """
  Stop the EctoRole server.
  ## Examples
      iex> EctoRole.Entity.Supervisor.stop("xxx")
      ":ok"
  """
  def stop(id) do
    case Registry.lookup(@registry_name, id) do
      [] ->
        :ok

      [{pid, _}] ->
        Process.exit(pid, :shutdown)
        :ok
    end
  end

  def init(_) do
    children = [worker(ES, [], restart: :transient)]
    supervise(children, strategy: :simple_one_for_one)
  end

  @doc """
  Create a new process if it doesnt exist else return the process.
  ## Examples
      iex> EctoRole.Entity.Supervisor.find_or_create_process("xxx")
      "{}"
  """
  def find_or_create_process(id) do
    if process_exists?(id) do
      {:ok, id}
    else
      id |> start
    end
  end

  @doc """
  Check if process exists.
  ## Examples
      iex> EctoRole.Entity.Supervisor.process_exists("xxx")
      "true"
  """
  def process_exists?(id) do
    case Registry.lookup(@registry_name, id) do
      [] -> false
      _ -> true
    end
  end

  @doc """
  Get the ids of all processes in the registry.
  ## Examples
      iex> EctoRole.Entity.Supervisor.key_ids("xxx")
      "[]"
  """
  def key_ids do
    Supervisor.which_children(__MODULE__)
    |> Enum.map(fn {_, account_proc_pid, _, _} ->
      Registry.keys(@registry_name, account_proc_pid)
      |> List.first()
    end)
    |> Enum.sort()
  end

  @doc """
  Create a new entity and save it to the db
  ## Examples
      iex> EctoRole.Entity.Supervisor.new("xxx")
      "%{}"
  """
  def new(id) do
    Supervisor.start_child(__MODULE__, [id])
    result = ES.save(id)

    case result do
      :ok -> {:ok, "new entity was created"}
      _ -> {:error, "could not create a new entity"}
    end
  end

  @doc """
  Save a entity
  ## Examples
      iex> EctoRole.Entity.Supervisor.save("xxx")
      "%{}"
  """
  def save(id) do
    case process_exists?(id) do
      false ->
        {:error, "Entity does not exist"}

      true ->
        result = ES.save(id)

        case result do
          :ok -> {:ok, "entity was saved"}
          _ -> {:error, "could not save the entity"}
        end
    end
  end

  @doc """
  Soft Delete a entity from the db
  ## Examples
      iex> EctoRole.Entity.Supervisor.remove("xxx")
      "%{}"
  """
  def deactivate(id) do
    case process_exists?(id) do
      false ->
        {:error, "Entity does not exist"}

      true ->
        result = ES.deactivate(id)

        case result do
          :ok -> {:ok, "entity was removed"}
          _ -> {:error, "could not remove the entity"}
        end
    end
  end
  @doc """
  Activate entity from the db
  ## Examples
      iex> EctoRole.Entity.Supervisor.remove("xxx")
      "%{}"
  """
  def activate(id) do
    case process_exists?(id) do
      false ->
        {:error, "Entity does not exist"}

      true ->
        result = ES.activate(id)

        case result do
          :ok -> {:ok, "entity was removed"}
          _ -> {:error, "could not remove the entity"}
        end
    end
  end

  @doc """
  Delete a entity from the db
  ## Examples
      iex> EctoRole.Entity.Supervisor.delete("xxx")
      "%{}"
  """
  def delete(id) do
    case process_exists?(id) do
      false ->
        {:error, "Entity does not exist"}

      true ->
        result = ES.delete(id)

        case result do
          :ok -> {:ok, "entity was deleted"}
          _ -> {:error, "could not delete the entity"}
        end
    end
  end
end
