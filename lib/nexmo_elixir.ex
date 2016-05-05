defmodule NexmoElixir do
  require Logger
  use ExActor.GenServer

  @httpoison_opts [{:hackney, [{:pool, __MODULE__}]}]
  defstart start_link() do
    :hackney_pool.start_pool(__MODULE__, timeout: 60000, max_connections: 30000)
    initial_state(0)
  end

  def terminate(reason, state) do
    :hackney_pool.stop_pool __MODULE__
  end

  @doc """
    Base of nexmo
  """

  defcall http(method, url, body, opts // {}), state: state do
    reply(state)
  end

  defcast http(method, url, body, opts // {}) do
    noreply
  end

  defp perform do
    if is_blank(opts[:content_type]) do
      opts=Map.put(opts, :content_type, "application/json")
    end
    if url && body do
      case HTTPoison.post(url, data, [{"Content-Type", opts[:content_type]}], @httpoison_opts) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}}-> nil
        {:ok, %HTTPoison.Response{status_code: 204, body: body}}-> nil
        {:ok, %HTTPoison.Response{status_code: 404, body: body}}-> nil
        {:ok, %HTTPoison.Response{status_code: status_code, body: body}}-> nil
        _-> nil
      end
    else

    end
  end

  defp is_blank(obj) do
    is_nil(obj) || obj == "undefined" || obj == :undefined || (is_binary(obj) && String.length(String.strip(obj)) == 0)
  end
end
