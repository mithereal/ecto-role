defmodule EctoRole.Role.Supervisor do
  use Supervisor

  require Logger

  alias EctoRole.Server, as: RS
  alias EctoRole.Role, as: ROLE
  alias EctoRole.Repo, as: Repo

  @moduledoc """
  A Supervisor to Start and Manage your EctoRoles.
  """

  @registry_name :ecto_role_registry

  def start_link do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @doc """
  Start a EctoRole server.
  ## Examples
      iex> EctoRole.Supervisor.start("management_role")
      "%{}"
  """
  def start(id) do

    r = Repo.get_by(ROLE, key: id)

    case r do
      %{} -> Supervisor.start_child(__MODULE__, [id])
      _ -> {:error, "Unknown Role"}
    end

  end

  @doc """
  Stop the EctoRole server.
  ## Examples
      iex> EctoRole.Supervisor.stop("management_role")
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
    children = [worker(RS, [], restart: :transient)]
    supervise(children, strategy: :simple_one_for_one)
  end

  @doc """
  Create a new process if it doesnt exist else return the process.
  ## Examples
      iex> EctoRole.Supervisor.find_or_create_process("management_role")
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
      iex> EctoRole.Supervisor.process_exists("management_role")
      "true"
  """
  def process_exists?(id) do
    IO.inspect id

    case Registry.lookup(@registry_name, id) do
      [] -> false
      _ -> true
    end
  end

  @doc """
  Get the ids of all processes in the registry.
  ## Examples
      iex> EctoRole.Supervisor.key_ids("management_role")
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
  Save a role
  ## Examples
      iex> EctoRole.Role.Supervisor.save("xxx")
      "%{}"
  """
  def save(id) do
    case process_exists?(id) do
      false ->
        {:error, "Role does not exist"}

      true ->
        result = RS.save(id)

        case result do
          :ok -> {:ok, "role was saved"}
          _ -> {:error, "could not save the role"}
        end
    end
  end

  @doc """
  Soft Delete a role from the db
  ## Examples
      iex> EctoRole.Role.Supervisor.deactivate("xxx")
      "%{}"
  """
  def deactivate(id) do
    case process_exists?(id) do
      false ->
        {:error, "Role does not exist"}

      true ->
        result = RS.deactivate(id)

        case result do
          :ok -> {:ok, "role was deactivated"}
          _ -> {:error, "could not deactivate the role"}
        end
    end
  end

  @doc """
  Activate role from the db
  ## Examples
      iex> EctoRole.Role.Supervisor.remove("xxx")
      "%{}"
  """
  def activate(id) do
    case process_exists?(id) do
      false ->
        {:error, "Role does not exist"}

      true ->
        result = RS.activate(id)

        case result do
          :ok -> {:ok, "role was removed"}
          _ -> {:error, "could not remove the role"}
        end
    end
  end


  @doc """
  Create a new role and save it to the db
  ## Examples
      iex> EctoRole.Role.Supervisor.new()
      "%{}"
  """
  def new(name) do
    id = Ecto.UUID.generate()
    Supervisor.start_child(__MODULE__, [id])
    RS.name(id, name)
    result = RS.save(id)

    case result do
      :ok -> {:ok, "new role was created"}
      _ -> {:error, "could not create a new role"}
    end
  end


  @doc """
  Delete a role from the db
  ## Examples
      iex> EctoRole.Role.Supervisor.delete("xxx")
      "%{}"
  """
  def delete(id) do
    case process_exists?(id) do
      false ->
        {:error, "Role does not exist"}

      true ->
        result = RS.delete(id)

        case result do
          :ok -> {:ok, "role was deleted"}
          _ -> {:error, "could not delete the role"}
        end
    end
  end
end
