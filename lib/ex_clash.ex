defmodule ExClash do
  @moduledoc false

  @base_url "https://api.clashofclans.com/v1"

  @doc """
  Will return the base url for requests.
  """
  @spec base_url() :: String.t()
  def base_url, do: @base_url

  @doc """
  Will append the path to the end of the base URL.
  """
  @spec url(path :: String.t()) :: String.t()
  def url(path), do: "#{@base_url}#{path}" |> encode_octo()

  @doc """
  Fetches the token from the environment. Will raise if the environment
  value is not set.
  """
  @spec token!() :: String.t()
  def token!, do: Application.fetch_env!(:ex_clash, :token)

  @doc """
  Returns the authorization tuple that `Req` uses for the auth header.
  """
  @spec auth!() :: {:bearer, String.t()}
  def auth!(), do: {:bearer, token!()}

  @doc """
  Translates any existing octothorpe into its URL encoded equivalent.

  ## Examples

      iex> ExClash.encode_octo("www.example.com/player?tag=#ABCD")
      "www.example.com/player?tag=%23ABCD"
  """
  @spec encode_octo(url :: String.t()) :: String.t()
  def encode_octo(url), do: String.replace(url, "#", "%23")

  @doc """
  Translates the camelCase from an API JSON response body into an atom that is
  snake case to follow Elixir convention. Generally, these occur for the keys
  of the response body, and any values that are enums.

  ## Examples

      iex> ExClash.camel_to_atom("camelCase")
      :camel_case
  """
  @spec camel_to_atom(camel :: String.t()) :: atom()
  def camel_to_atom(camel), do: camel |> Macro.underscore() |> String.to_existing_atom()

  @doc """
  """
  # TODO: This function will need to be severly updated to handle other responses.
  @spec get!(path :: String.t(), query_params :: Keyword.t()) :: map()
  def get!(path, query_params \\ []) do
    [auth: auth!(), params: query_params]
    |> Req.new()
    |> Req.get!(url: url(path))
    |> case do
      %Req.Response{status: 200, body: body} -> body
      _ -> {:error, :server_error}
    end
  end

  @doc """
  The response body from the HTTP request is JSON. This will handle converting
  the keys into snake case atoms, then put them in the `clash_struct`. Since
  the struct needs to be passed in, it is not recursive.

  ## Examples

      iex> ExClash.get!("/clans/#9RPU22RU/warlog", limit: 1)
      %{
        "items" => [
          %{
            "attacksPerMember" => 2,
            "endTime" => "20240419T031544.000Z",
            "clan" => %{
              "attacks" => 50,
              "badgeUrls" => %{
                "large" => "https://api-assets.clashofclans.com/badges/512/KBtwIToS85C-c3ROYqXdkB7DkmMY4zUP3BjJ8IDK1Qw.png",
                "medium" => "https://api-assets.clashofclans.com/badges/200/KBtwIToS85C-c3ROYqXdkB7DkmMY4zUP3BjJ8IDK1Qw.png",
                "small" => "https://api-assets.clashofclans.com/badges/70/KBtwIToS85C-c3ROYqXdkB7DkmMY4zUP3BjJ8IDK1Qw.png"
              },
              "clanLevel" => 24,
              "destructionPercentage" => 91.166664,
              "expEarned" => 384,
              "name" => "Reddit Frost",
              "stars" => 73,
              "tag" => "#9RPU22RU"
            },
            "opponent" => %{
              "badgeUrls" => %{
                "large" => "https://api-assets.clashofclans.com/badges/512/2Msa5ORBekyNP5IV9k-N-L2bfehNIuY1zwdIv-E08Mk.png",
                "medium" => "https://api-assets.clashofclans.com/badges/200/2Msa5ORBekyNP5IV9k-N-L2bfehNIuY1zwdIv-E08Mk.png",
                "small" => "https://api-assets.clashofclans.com/badges/70/2Msa5ORBekyNP5IV9k-N-L2bfehNIuY1zwdIv-E08Mk.png"
              },
              "clanLevel" => 20,
              "destructionPercentage" => 100.0,
              "name" => "Reckless R&R",
              "stars" => 90,
              "tag" => "#202QPPRU2"
            },
            "result" => "lose",
            "teamSize" => 30
          }
        ],
        "paging" => %{"cursors" => %{"after" => "eyJwb3MiOjF9"}}
      }
  """
  @spec resp_to_struct(api_response :: map(), clash_struct :: atom()) :: struct()
  def resp_to_struct(api_response, clash_struct) do
    Enum.map(api_response, fn {key, value} ->
      {camel_to_atom(key), maybe_datetime(value)}
    end)
    |> Map.new()
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
end
