defmodule EctoRole.Schema.Supervisor do
  use Supervisor

  require Logger

  alias EctoRole.Schema.Server, as: SS
  alias EctoRole.Schema, as: SCHEMA

  @moduledoc """
  A Supervisor to Start and Manage your Schemas.
  """

  @registry_name :ecto_role_schema_registry

  def start_link do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @doc """
  Start a EctoRole server.
  ## Examples
      iex> EctoRole.Supervisor.start("google")
      "%{}"
  """
  def start(id) do
    ## check if is actually an entity
    s = SCHEMA.exists? id

    case s do
      true -> Supervisor.start_child(__MODULE__, [id])
      _ -> {:error, "Unknown Schema"}
    end

  end

  @doc """
  Stop the EctoRole server.
  ## Examples
      iex> EctoRole.Supervisor.stop("google")
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
    children = [worker(SS, [], restart: :transient)]
    supervise(children, strategy: :simple_one_for_one)
  end

  def save(id) do
    case process_exists?(id) do
      false ->
        {:error, "Schema does not exist"}

      true ->
        result = SS.save(id)

        case result do
          :ok -> {:ok, "schema was saved"}
          _ -> {:error, "could not save the schema"}
        end
    end
  end

  @doc """
  Create a new process if it doesnt exist else return the process.
  ## Examples
      iex> EctoRole.Supervisor.find_or_create_process("google")
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
      iex> EctoRole.Supervisor.process_exists("google")
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
      iex> EctoRole.Supervisor.key_ids("google")
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
    result = SS.save(id)

    case result do
      :ok -> {:ok, "new entity was created"}
      _ -> {:error, "could not create a new entity"}
    end
  end


  @doc """

  """
  def remove(id) do
    case process_exists?(id) do
      false ->
        {:error, "Schema does not exist"}

      true ->
        result = SS.delete(id)

        case result do
          :ok -> {:ok, "schema was removed"}
          _ -> {:error, "could not remove the schema"}
        end
    end
  end
end
