defmodule EctoRole.Timer do
  use GenServer
  require Logger
  @name __MODULE__

  defstruct tick_interval: 500, ticker_ref: :none

  def init(args) do
    {:ok, args}
  end


  def start_link(id) do
    GenServer.start_link(__MODULE__, [id], name: @name)
  end

  def handle_cast(:start_timer, %{tick_interval: tick_interval, ticker_ref: ticker_ref} = state)
      when ticker_ref == :none do
    Logger.debug("#{@name} started")

    {:ok, new_ticker_ref} = :timer.send_after(tick_interval, :tick)
    {:noreply, %{state | ticker_ref: new_ticker_ref}}
  end

  def handle_cast(:start_timer, state), do: {:noreply, state}

  def handle_cast(:stop_timer, %{ticker_ref: ticker_ref} = state)
      when ticker_ref == :none do
    {:noreply, state}
  end

  def handle_cast(:stop_timer, %{ticker_ref: ticker_ref} = state) do
    Logger.debug("#{@name} cancelled")

    :timer.cancel(ticker_ref)
    {:noreply, %{state | ticker_ref: :none}}
  end
end
