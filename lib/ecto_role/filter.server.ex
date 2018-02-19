defmodule EctoRole.Filter.Server do
  use GenServer

  require Logger

  @moduledoc false

  alias EctoRole.Filter, as: FILTER
  alias EctoRole.Enitiy, as: ENTITY


  @registry_name :ecto_role_filter_registry
  @name __MODULE__

  defstruct key: nil,
            schema: nil,
            filters: [],
            status: "active",
            name: nil

  def start_link(id) do
    name = via_tuple(id)

    GenServer.start_link(__MODULE__, [id], name: name)
  end

  defp via_tuple(id) do
    {:via, Registry, {@registry_name, id}}
  end

  def get_filters(id) do
    try do
      GenServer.call(via_tuple(id), :get_filters)
    catch
      :exit, _ -> {:error, 'invalid_filter'}
    end
  end

  def init([id]) do
    send(self(), {:setup, id})

    state = %__MODULE__{ key: id}
    {:ok, state}
  end

  def handle_info({:setup, id}, state) do
    updated_state =
      case is_nil(id) do
        true ->
          state

        false ->
          params = %{key: id}
          record = FILTER.get(params)

          filters = case record do
            %{} -> [record]
            _-> []
          end

          schema = case record do
            %{} -> record.schema
            _-> nil
          end


          name = case schema do
            nil -> nil
            _-> schema.name
          end

          %__MODULE__{state | key: id, schema: name, filters: filters}
      end

    {:noreply, updated_state}
  end

  @doc "queries the server for filters"
  def handle_call(:get_filters, _from, state) do
    {:reply, state, state}
  end

  @doc "save the filter"
  def handle_call(
        :save,
        _from,
        %__MODULE__{key: key, schema: schema, filters: filters} = state
      ) do
    Enum.each(filters, fn f ->
      FILTER.delete(%{key: f.key})
    end)

    Enum.each(filters, fn p ->

    f = %{name: p.name, key: p.key, status: p.status, create: p.create, delete: p.delete}
      FILTER.create(f)
    end)

    send(self(), {:setup, key})

    {:reply, :ok, state}
  end



  def handle_info(:save, %__MODULE__{key: key, schema: schema, filters: filters} = state) do
    Enum.each(filters, fn p ->
      FILTER.delete(p)
    end)

    Enum.each(filters, fn p ->

      f = %{name: p.name, key: p.key, status: p.status,  create: p.create, delete: p.delete}
      #FILTER.create(f)
    end)

    send(self(), {:setup, key})

    {:noreply, state}
  end

  @doc "deactivate the filter"
  def handle_call(:deactivate, _from, %__MODULE__{status: status} = state) do
    new_status = 'inactive'
    updated_state = %__MODULE__{state | status: new_status}

    send(self(), :save)

    {:reply, :ok, updated_state}
  end

  @doc "activate the filter"
  def handle_call(:activate, _from, %__MODULE__{status: status} = state) do
    new_status = 'active'
    updated_state = %__MODULE__{state | status: new_status}

    send(self(), :save)

    {:reply, :ok, updated_state}
  end

  @doc "delete the filter, then shutdown"
  def handle_call(:delete, _from, %__MODULE__{status: status, key: key} = state) do
    FILTER.delete(%{key: key})


    send(self(), :shutdown)

    updated_state = %__MODULE__{state | status: status}
    {:reply, :ok, updated_state}
  end


  def handle_call({:name, name} , _from, %__MODULE__{status: status} = state) do

    updated_state = %__MODULE__{state | name: name}

    {:reply, :ok, updated_state}
  end

  @doc "status the role"

  def handle_call({:status, status} , _from, %__MODULE__{status: status} = state) do

    updated_state = %__MODULE__{state | status: status}

    {:reply, :ok, updated_state}
  end

  ### Client

  def save(key) do
    try do
      GenServer.call(via_tuple(key), :save)
    catch
      :exit, _ -> {:error, 'invalid_filter'}
    end
  end

  def deactivate(key) do
    try do
      GenServer.call(via_tuple(key), :deactivate)
    catch
      :exit, _ -> {:error, 'invalid_filter'}
    end
  end

  def activate(key) do
    try do
      GenServer.call(via_tuple(key), :activate)
    catch
      :exit, _ -> {:error, 'invalid_filter'}
    end
  end

  def delete(key) do
    try do
      GenServer.call(via_tuple(key), :delete)
    catch
      :exit, _ -> {:error, 'invalid_filter'}
    end
  end


  def name(key, name) do
    try do
      GenServer.call(via_tuple(key), {:name, name})
    catch
      :exit, _ -> {:error, 'invalid_role'}
    end
  end

  def status(key, status) do
    try do
      GenServer.call(via_tuple(key), {:status, status})
    catch
      :exit, _ -> {:error, 'invalid_role'}
    end
  end

end
