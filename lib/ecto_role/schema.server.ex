defmodule EctoRole.Schema.Server do
  use GenServer

  require Logger

  @moduledoc "A Simple Server to Store Your Schemas."

  alias EctoRole.Schema, as: SCHEMA

  alias EctoRole.Repo, as: Repo

  @registry_name :ecto_role_schema_registry
  @name __MODULE__

  defstruct schema: nil,
            fields: [],
            relations: []

  def start_link(id) do
    name = via_tuple(id)

    GenServer.start_link(__MODULE__, [id], name: name)
  end

  defp via_tuple(id) do
    {:via, Registry, {@registry_name, id}}
  end

  def init([id]) do
    send(self(), {:setup, id})

    state = %__MODULE__{}
    {:ok, state}
  end

  def handle_info(:shutdown, state) do
    Process.sleep(5000)
    {:stop, :normal, state}
  end

  def get_fields(id) do
    try do
      GenServer.call(via_tuple(id), :get_schema)
    catch
      :exit, msg -> {:error, 'invalid_schema'}
    end
  end
  def get_relations(id) do
    try do
      GenServer.call(via_tuple(id), :get_relations)
    catch
      :exit, msg -> {:error, 'invalid_schema'}
    end
  end

  def delete(id) do
    try do
      GenServer.call(via_tuple(id), :delete)
    catch
      :exit, msg -> {:error, 'invalid_schema'}
    end
  end


  def save(key) do
    try do
      GenServer.call(via_tuple(key), :save)
    catch
      :exit, _ -> {:error, 'invalid_schema'}
    end
  end

  def handle_info({:setup, id}, state) do
    updated_state =
      case is_nil(id) do
        true ->
          state

        false ->
          record = SCHEMA.get_schema(id)

          %__MODULE__{state | schema: id, fields: record}
      end

    {:noreply, updated_state}
  end

  def handle_info(:save, %__MODULE__{schema: schema} = state) do
    params = %{name: schema}
    changeset = SCHEMA.changeset(%SCHEMA{}, params)
    {result, _} = Repo.insert_or_update(changeset)

    reply =
      case result do
        nil ->
          :error

        _ ->
          send(self(), {:setup, schema})
          result
      end

    {:noreply, state}
  end

  def handle_call(
        :save,
        _from,
        %__MODULE__{schema: schema} = state
      ) do
    params = %{name: schema}
    changeset = SCHEMA.changeset(%SCHEMA{}, params)
    {result, _} = Repo.insert_or_update(changeset)

    reply =
      case result do
        nil ->
          :error

        _ ->
          send(self(), {:setup, schema})
          :ok
      end

    {:reply, reply, state}
  end

  @doc "queries the server for fields"
  def handle_call(:get_fields, _from, %__MODULE__{fields: fields} = state) do
    {:reply, fields, state}
  end
  @doc "queries the server for relations"
  def handle_call(:get_relations, _from, %__MODULE__{relations: relations} = state) do
    {:reply, relations, state}
  end

  @doc "remove the schema from the db and sup tree"
  def handle_call(:delete, _from, %__MODULE__{schema: schema} = state) do

    schema = SCHEMA.get!(%{name: schema})
    Repo.delete(schema)

    send(self(), :shutdown)
    {:reply, schema, state}
  end
end
