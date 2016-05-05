defmodule Nexmo.Webhook do
  require Logger
  use ExActor.GenServer
  @doc """
    When you start your app, you should start link this or put in application, thus it can mount to application automatically with route /nexmo/callback

  """

  @httpoison_opts [{:hackney, [{:pool, __MODULE__}]}]
  defstart start_link() do
    :hackney_pool.start_pool(__MODULE__, timeout: 60000, max_connections: 30000)
    initial_state(0)
  end

  def terminate(reason, state) do
    :hackney_pool.stop_pool __MODULE__
  end

  defcall receive_call(opts), state: state do
    noreply
  end
end
