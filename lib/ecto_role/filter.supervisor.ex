defmodule EctoRole.Filter.Supervisor do
  use Supervisor

  require Logger

  alias EctoRole.Filter.Server, as: FS
  alias EctoRole.Filter, as: FILTER
  alias EctoRole.Repo, as: Repo

  @moduledoc false

  @registry_name :ecto_role_filter_registry

  def start_link do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @doc """
  Start a filter server.
  ## Examples
      iex> EctoRole.filter.Supervisor.start("xxx")
      "%{}"
  """
  def start(id) do

    ## check if is actually an entity
    e = Repo.get_by(FILTER, key: id)
    # IO.inspect(e)

    case e do
      %{} -> Supervisor.start_child(__MODULE__, [id])
      _ -> {:error, "Unknown Filter"}
    end

  end

  @doc """
  Stop the EctoRole server.
  ## Examples
      iex> EctoRole.filter.Supervisor.stop("xxx")
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
    children = [worker(FS, [], restart: :transient)]
    supervise(children, strategy: :simple_one_for_one)
  end

  @doc """
  Create a new process if it doesnt exist else return the process.
  ## Examples
      iex> EctoRole.filter.Supervisor.find_or_create_process("xxx")
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
      iex> EctoRole.filter.Supervisor.process_exists("xxx")
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
      iex> EctoRole.filter.Supervisor.key_ids("xxx")
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
  Create a new filter and save it to the db
  ## Examples
      iex> EctoRole.Filter.Supervisor.new()
      "%{}"
  """
  def new(name) do
    id = Ecto.UUID.generate()
    Supervisor.start_child(__MODULE__, [id])
    FS.name(id, name)
    result = FS.save(id)

    case result do
      :ok -> {:ok, "new filter was created"}
      _ -> {:error, "could not create a filter"}
    end
  end

  @doc """
  Save a Filter
  ## Examples
      iex> EctoRole.Filter.Supervisor.save("xxx")
      "%{}"
  """
  def save(id) do
    case process_exists?(id) do
      false ->
        {:error, "Filter does not exist"}

      true ->
        result = FS.save(id)

        case result do
          :ok -> {:ok, "filter was saved"}
          _ -> {:error, "could not save the filter"}
        end
    end
  end

  @doc """
  Soft Delete a filter from the db
  ## Examples
      iex> EctoRole.Filter.Supervisor.remove("xxx")
      "%{}"
  """
  def deactivate(id) do
    case process_exists?(id) do
      false ->
        {:error, "Filter does not exist"}

      true ->
        result = FS.deactivate(id)

        case result do
          :ok -> {:ok, "filter was deactivated"}
          _ -> {:error, "could not deactivate the filter"}
        end
    end
  end

  @doc """
  Activate filter from the db
  ## Examples
      iex> EctoRole.Filter.Supervisor.remove("xxx")
      "%{}"
  """
  def activate(id) do
    case process_exists?(id) do
      false ->
        {:error, "Filter does not exist"}

      true ->
        result = FS.activate(id)

        case result do
          :ok -> {:ok, "filter was activated"}
          _ -> {:error, "could not activate the filter"}
        end
    end
  end
end
