defmodule EctoRole.Schema.Supervisor do
  use Supervisor

  require Logger

  @moduledoc """
  A Supervisor to Start and Manage your Schemas.
  """

  @registry_name :ecto_schema_registry

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
    Supervisor.start_child(__MODULE__, [id])
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
    children = [worker(EctoRole.Server, [], restart: :transient)]
    supervise(children, strategy: :simple_one_for_one)
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
end
