defmodule ExClash.HTTP do
  @moduledoc """
  The HTTP module. Takes care of sending the request via HTTP and will parse the
  response, placing the keys of the JSON decoded response into the struct
  provided. While this module is available, it is not recommended for use.
  Instead, the calls to the API have been defined in the modules that contain
  the struct for the expected data. For example, use `ExClash.Clan` to retrieve
  information about a clan, and `%ExClash.Clan{}` will be returned. Which keys
  are populated depends on which API call was made.
  """

  require Logger

  @base_url "https://api.clashofclans.com/v1"

  @typedoc """
  The body of a response.
  """
  @type body() :: binary() | term()

  @typedoc """
  The response that comes back from `ExClash.HTTP.get/2`. The map will have
  string keys and be camel case, having gone through Jason.decode/2 after
  getting the response from the HTTP request to Supercell.

  ## Examples

      {:ok, %{"items" => [%{"value" => 1}, %{"value" => 4}]}}

      {:error, :not_found}
  """
  @type response() :: {:ok, body()} | {:error, atom()}

  @doc """
  Will return the base url for requests.
  """
  @spec base_url() :: String.t()
  def base_url, do: @base_url

  @doc """
  Will append the path to the end of the base URL. The octothorp is not encoded
  by default in URI.encode/2, so there is a specific call to handle it.
  """
  @spec url(path :: String.t()) :: String.t()
  def url(path), do: "#{base_url()}#{path}" |> encode_octo()

  @doc """
  Fetches the token from the environment. Will raise if the environment value
  is not set.
  """
  @spec token!() :: String.t()
  def token!, do: Application.fetch_env!(:ex_clash, :token)

  @doc """
  Returns the authorization tuple that `Req` uses for the auth header.
  """
  @spec auth!() :: {:bearer, String.t()}
  def auth!(), do: {:bearer, token!()}

  @doc """
  The meat and potatoes. Will send a request to the `base_url` with the `path`
  appended. It will handle the authorization, ensure the octothorpes have been
  encoded, and add any query_params that were passed in. Any query params that
  do not apply will be ignored by Supercell.

  ## Examples

      iex> ExClash.get("/clans")
      {:ok, %{"items" => [%{...}, %{...}], "paging" => %{...}}}

      iex> ExClash.get("/locations", limit: 1)
      {:ok, %{"items" => [%{...}], "paging" => %{...}}}

      # Assuming the following clan does not have a public war log
      iex> ExClash.get("/clans/#ABCD1234/warlog", limit: 2, after: "eJwysdSDF")
      {:error, :not_authorized}
  """
  @spec get(path :: String.t(), query_params :: Keyword.t()) :: response()
  def get(path, query_params \\ []) do
    Req.new(auth: auth!(), url: url(path), params: query_params)
    |> Req.get()
    |> case do
      {:ok, %Req.Response{} = response} -> parse_response(response)
      error -> log_error(path, query_params, error)
    end
  end

  @doc """
  The response body from the HTTP request is JSON. This will handle converting
  the keys into snake case atoms, then put them in the `clash_struct`. Since
  the struct needs to be passed in, it is not recursive.

  ## Examples

      iex> ExClash.HTTP.resp_to_struct(%{"myHTTPKey" => "Some value"}, ExampleStruct)
      %ExampleStruct{my_api_key: "Some value"}
  """
  @spec resp_to_struct(api_response :: map(), clash_struct :: atom()) :: struct()
  def resp_to_struct(api_response, clash_struct) do
    Map.new(api_response, fn {key, value} ->
      {ExClash.camel_to_atom(key), maybe_datetime(value)}
    end)
    |> then(&struct(clash_struct, &1))
  end

  defp maybe_datetime(string) when is_binary(string) do
    if String.ends_with?(string, ".000Z"), do: convert_time(string), else: string
  end
  defp maybe_datetime(not_string), do: not_string

  defp convert_time(time_string) do
    time_string
    |> DateTime.from_iso8601(:basic)
    |> case do
      {:ok, datetime, _} -> datetime
      _ -> {:error, :invalid_datetime}
    end
  end

  defp encode_octo(unencoded), do: String.replace(unencoded, "#", "%23")

  defp parse_response(%{status: 200, body: body}), do: {:ok, body}
  defp parse_response(%{status: 400}), do: {:error, :bad_request}
  defp parse_response(%{status: 403}), do: {:error, :access_denied}
  defp parse_response(%{status: 404}), do: {:error, :not_found}
  defp parse_response(%{status: 429}), do: {:error, :throttled}
  defp parse_response(%{status: 500}), do: {:error, :internal}
  defp parse_response(%{status: 503}), do: {:error, :unavailable}

  defp log_error(path, params, error) do
    Logger.warning("""
    Response that may not have been accounted for:
    \tPath: #{path}
    \tQuery Params: #{inspect(params)}
    \tResponse:\n#{inspect(error)}\n
    """)
    {:error, :server_error}
  end
end