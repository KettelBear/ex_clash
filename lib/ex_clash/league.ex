defmodule ExClash.League do
  @moduledoc """
  The League struct.

  This simply represents a league in Clash of Clans.

  Attributes:

    * `id` - The league id number.

    * `name` - The name of the league.

    * `icon_urls` - See `ExClash.IconUrls` for more details.

  Endpoints:
  * `/leagues/{leagueId}`
  * `/leagues/{leagueId}/seasons`
  * `/leagues/{leagueId}/seasons/{seasonId}`
  """

  @type t() :: %__MODULE__{
    id: integer(),
    name: String.t(),
    icon_urls: list(ExClash.IconUrls.t())
  }

  defstruct [:id, :name, :icon_urls]

  @doc """
  Get the league information from Supercell.

  Note: This does not include Capital Leagues or Builder Base Leagues. Those
  have their own API calls.

  ## Parameters

    * `opts` - Paging and additonal `Req` options.
      * `limit` - Limit the number of items returned in the response.
      * `after` - Return only items that occur after this marker.
      * `before` - Return only items that occur before this marker.

  ## Examples

      iex> ExClash.League.list(limit: 2, after: "eyJwb3MiOjJ9")
      {
        [
          %ExClash.League{id: 29000002, name: "Bronze League II", icon_urls: %ExClash.IconUrls{...}},
          %ExClash.League{id: 29000003, name: "Bronze League I", icon_urls: %ExClash.IconUrls{...}},
        ],
        %ExClash.Paging{after: "eyJwb3MiOjR9", before: "eyJwb3MiOjJ9"}
      }
  """
  @spec list(opts :: Keyword.t()) :: list(__MODULE__.t()) | {:error, atom()}
  def list(opts \\ []) do
    case ExClash.HTTP.get("/leagues", opts) do
      {:ok, %{"items" => leagues, "paging" => paging}} ->
        {format(leagues), ExClash.Paging.format(paging)}

      err ->
        err
    end
  end

  @doc """
  Format the Supercell league into an `ExClash.League`.

  There are many entities that can be part of leagues. These include;
  Clans, Players, Capitals. This will take the JSON object and return this
  struct.
  """
  @spec format(api_league :: ExClash.cell_map() | list(ExClash.cell_map()) | nil)
      :: __MODULE__.t() | list(__MODULE__.t()) | nil
  def format(nil), do: nil

  def format(api_league) when is_list(api_league), do: Enum.map(api_league, &format/1)

  def format(api_league) do
    icons = Map.get(api_league, "iconUrls")

    %__MODULE__{
      id: Map.get(api_league, "id"),
      name: Map.get(api_league, "name"),
      icon_urls: format_icon_urls(icons)
    }
  end

  defp format_icon_urls(nil), do: nil
  defp format_icon_urls(icon_urls) do
    ExClash.HTTP.resp_to_struct(icon_urls, ExClash.IconUrls)
  end
end
