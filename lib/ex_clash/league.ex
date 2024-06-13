defmodule ExClash.League do
  @moduledoc """
  The League struct.

  This simply represents a league in Clash of Clans.

  Attributes:

    * `id` - The league id number.

    * `name` - The name of the league.

    * `icon_urls` - See `ExClash.IconUrls` for more details.
  """

  @typedoc """
  `YYYY-MM` as a String, representing the season.

  Although just a string, Supercell's "season" takes a very specific format
  of `YYYY-MM`. That should be the expected format of `cell_season`.

  ## Examples

      "2024-01"
  """
  @type cell_season() :: String.t()

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
  Get league information for the provided league `id`.

  ## Examples

      iex> ExClash.League.one(29000002)
      %ExClash.League{id: 29000002, name: "Bronze League II", icon_urls: %ExClash.IconUrls{...}},
  """
  @spec one(id :: integer(), opts :: Keyword.t()) :: __MODULE__.t() | {:error, atom()}
  def one(id, opts \\ []) do
    case ExClash.HTTP.get("/leagues/#{id}", opts) do
      {:ok, league} -> format(league)
      err -> err
    end
  end

  @doc """
  Get the list of seasons for the provided league `id`.

  ## Parameters

    * `opts` - Paging and additonal `Req` options.
      * `limit` - Limit the number of items returned in the response.
      * `after` - Return only items that occur after this marker.
      * `before` - Return only items that occur before this marker.

  ## Examples

      iex> ExClash.League.seasons(29000022, limit: 5)
      {
        ["2015-07", "2015-08", "2015-09", "2015-10", "2015-11"],
        %ExClash.Paging{after: "eyJwb3MiOjV9", before: nil}
      }
  """
  @spec seasons(id :: integer(), opts :: Keyword.t()) :: {list(cell_season()), ExClash.Paging.t()} | {:error, atom()}
  def seasons(id, opts \\ []) do
    case ExClash.HTTP.get("/leagues/#{id}/seasons", opts) do
      {:ok, %{"items" => seasons, "paging" => paging}} ->
        {Enum.map(seasons, fn %{"id" => season} -> season end), ExClash.Paging.format(paging)}

      err ->
        err
    end
  end

  @doc """
  Get the list of top ranked `SeasonPlayer`s for the provided league `id` and
  season `id`.

  It will return an empty list if the league has not completed yet, or if the
  season ID is in a correct format, but no season existed (before 2015-07).

  ## Parameters

    * `opts` - Paging and additonal `Req` options.
      * `limit` - Limit the number of items returned in the response.
      * `after` - Return only items that occur after this marker.
      * `before` - Return only items that occur before this marker.

  ## Examples

      iex> ExClash.League.top_players(29000022, "2024-01", limit: 1, after: "eyJwb3MiOjJ9")
      {
        [
          %ExClash.SeasonPlayer{
            attack_wins: 279,
            clan_name: "⭐TEAM♻️ SHAKIL⭐",
            clan_tag: "#2Y0RJYC00",
            defense_wins: 2,
            exp_level: 203,
            name: "Rula❤️ Vet",
            rank: 3,
            tag: "#LUJJQCJ0C",
            trophies: 6736
          }
       ],
       %ExClash.Paging{after: "eyJwb3MiOjN9", before: "eyJwb3MiOjJ9"}}
  """
  @spec top_players(league_id :: integer(), season_id :: cell_season(), opts :: Keyword.t())
      :: {list(ExClash.SeasonPlayer.t()), ExClash.Paging.t()} | {:error, atom()}
  def top_players(league_id, season_id, opts \\ []) do
    case ExClash.HTTP.get("/leagues/#{league_id}/seasons/#{season_id}", opts) do
      {:ok, %{"items" => top_players, "paging" => paging}} ->
        {ExClash.SeasonPlayer.format(top_players), ExClash.Paging.format(paging)}

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
