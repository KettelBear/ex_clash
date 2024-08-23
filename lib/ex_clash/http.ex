defmodule ExClash.HTTP do
  @moduledoc false

  # This module should not be documented, as it is not intended for use
  # outside of this project. This wraps `Req` for the requests going
  # specifically to Supercell. Since `Req` is included in this project,
  # just use that for additional requests.

  require Logger

  @base_url "https://api.clashofclans.com/v1"

  @typedoc false
  @type body() :: binary() | term()

  @typedoc false
  @type response() :: {:ok, body()} | {:error, atom()}

  @doc false
  @spec get(path :: String.t(), query_params :: Keyword.t()) :: response()
  def get(path, query_params \\ []) do
    case Keyword.pop(query_params, :plug) do
      {nil, params} -> send(url: url(path), params: params)
      {plug, params} -> send(url: url(path), params: params, plug: plug)
    end
  end

  defp encode_octo(unencoded), do: String.replace(unencoded, "#", "%23")

  defp send(options) do
    [{:auth, {:bearer, token()}} | options]
    |> Req.new()
    |> Req.get()
    |> case do
      {:ok, %Req.Response{} = response} -> parse_response(response)
      error -> log_error(options, error)
    end
  end

  defp parse_response(%Req.Response{status: 200, body: body}), do: {:ok, body}
  defp parse_response(%Req.Response{status: 400}), do: {:error, :bad_request}
  defp parse_response(%Req.Response{status: 403}), do: {:error, :access_denied}
  defp parse_response(%Req.Response{status: 404}), do: {:error, :not_found}
  defp parse_response(%Req.Response{status: 429}), do: {:error, :throttled}
  defp parse_response(%Req.Response{status: 500}), do: {:error, :internal}
  defp parse_response(%Req.Response{status: 503}), do: {:error, :unavailable}

  defp log_error(options, error) do
    Logger.warning("""
      Response that may not have been accounted for:
      \tPath: #{inspect(options)}
      \tResponse:\n\t#{inspect(error)}\n
    """)

    {:error, :server_error}
  end

  defp token(), do: Application.fetch_env!(:ex_clash, :token)

  defp url(path), do: "#{@base_url}#{path}" |> encode_octo()
end
