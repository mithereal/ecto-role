defmodule EctoRole.Permission.Supervisor do

  use Supervisor

  require Logger

  @moduledoc """
  A Supervisor to Start and Manage your Permissions.
  """

  @registry_name :ecto_role_permission_registry

  def start_link do

    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @doc """
  Start a Permission server.
  ## Examples
      iex> EctoRole.Permission.Supervisor.start("xxx")
      "%{}"
  """
  def start(id) do

    Supervisor.start_child(__MODULE__, [ id ])
  end

  @doc """
  Stop the EctoRole server.
  ## Examples
      iex> EctoRole.Permission.Supervisor.stop("xxx")
      ":ok"
  """
  def stop(id) do

    case Registry.lookup(@registry_name,  id) do

      [] -> :ok
      [{pid, _}] ->
        Process.exit(pid, :shutdown)
        :ok
    end
  end

  def init(_) do

    children = [worker(EctoRole.Permission.Server, [], restart: :transient)]
    supervise(children, [strategy: :simple_one_for_one])
  end

  @doc """
  Create a new process if it doesnt exist else return the process.
  ## Examples
      iex> EctoRole.Permission.Supervisor.find_or_create_process("xxx")
      "{}"
  """
  def find_or_create_process(id)  do

    if process_exists?(id) do

      {:ok, id}
    else
      id |> start
    end
  end

  @doc """
  Check if process exists.
  ## Examples
      iex> EctoRole.Permission.Supervisor.process_exists("xxx")
      "true"
  """
  def process_exists?(id)  do

    case Registry.lookup(@registry_name, id) do
      [] -> false
      _ -> true
    end
  end

  @doc """
  Get the ids of all processes in the registry.
  ## Examples
      iex> EctoRole.Permission.Supervisor.key_ids("xxx")
      "[]"
  """
  def key_ids do

    Supervisor.which_children(__MODULE__)
    |> Enum.map(fn {_, account_proc_pid, _, _} ->
      Registry.keys(@registry_name, account_proc_pid)
      |> List.first
    end)
    |> Enum.sort
  end


end