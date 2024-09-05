defmodule ExClash.League do
  # TODO: Module documentation
  @moduledoc """
  
  """

  alias ExClash.HTTP.Paging
  alias ExClash.Type.League, as: LeagueType

  @type top_return() :: {list(ExClash.Type.SeasonPlayer.t()), Paging.t()} | {:error, atom()}

  @doc """
  Get the details of the Builder Base league.

  Note this does not get `:icon_urls`, as Supercell does not provide those
  in the response to this call.

  ## Parameters

    * `id` - The integer ID of the Builder Base League.

  ## Examples

      iex(27)> ExClash.League.builder_league(44000038)
      %ExClash.Type.League{id: 44000038, name: "Ruby League III", icon_urls: nil}
  """
  @spec builder_league(id :: integer(), opts :: Keyword.t()) :: LeagueType.t() | {:error, atom()}
  def builder_league(id, opts \\ []) do
    case ExClash.HTTP.get("/builderbaseleagues/#{id}", opts) do
      {:ok, league} -> LeagueType.format(league)
      err -> err
    end
  end

  @doc """
  Get the list of Builder Base Leagues.

  While this does return this struct, Supercell currently does not return the
  icon URLs in this response like it works in the `/leagues` endpoint. So all
  `:icon_urls` will be `nil` for these leagues.

  ## Parameters

    * `opts` - Paging and additonal `Req` options.
      * `limit` - Limit the number of items returned in the response.
      * `after` - Return only items that occur after this marker.
      * `before` - Return only items that occur before this marker.

  ## Examples

      iex(25)> ExClash.League.builder_leagues(limit: 6, after: "eyJwb3MiOjMzfQ")
      {
        [
          %ExClash.Type.League{id: 44000033, name: "Platinum League II", icon_urls: nil},
          %ExClash.Type.League{id: 44000034, name: "Platinum League I", icon_urls: nil},
          %ExClash.Type.League{id: 44000035, name: "Emerald League III", icon_urls: nil},
          %ExClash.Type.League{id: 44000036, name: "Emerald League II", icon_urls: nil},
          %ExClash.Type.League{id: 44000037, name: "Emerald League I", icon_urls: nil},
          %ExClash.Type.League{id: 44000038, name: "Ruby League III", icon_urls: nil}
        ],
        %ExClash.HTTP.Paging{after: "eyJwb3MiOjM5fQ", before: "eyJwb3MiOjMzfQ"}
      }
  """
  @spec builder_leagues(opts :: Keyword.t()) :: list(LeagueType.t()) | {:error, atom()}
  def builder_leagues(opts \\ []) do
    case ExClash.HTTP.get("/builderbaseleagues", opts) do
      {:ok, %{"items" => leagues, "paging" => paging}} ->
        {LeagueType.format(leagues), Paging.format(paging)}

      err ->
        err
    end
  end

  @doc """
  Get specific details for the Clan Capital league by ID.

  ## Param Options

    * `id` - The integer ID of the league. If provided, it will attempt to hit
      the endpoint for that specific Capital League.

  ## Examples

      iex> ExClash.League.captial_league(id: 85000021)
      %ExClash.Type.League{id: 85000021, name: "Titan League I", icon_urls: nil}
  """
  @spec capital_league(id :: integer(), opts :: Keyword.t()) :: ExClash.Type.League.t() | {:error, atom()}
  def capital_league(id, opts \\ []) do
    case ExClash.HTTP.get("/capitalleagues/#{id}", opts) do
      {:ok, league} -> ExClash.Type.League.format(league)
      err -> err
    end
  end

  @doc """
  Get the names and IDs of the Capital leagues.

  ## Param Options

    * `opts` - Paging and additional `Req` options.
      * `limit` - Limit the number of items returned in the response.
      * `after` - Return only items that occur after this marker.
      * `before` - Return only items that occur before this marker.

  ## Examples

      iex> ExClash.League.capital_leagues(limit: 3, after: "eyJwb3MiOjN9")
      {
        [
          %ExClash.Type.League{id: 85000003, name: "Bronze League I"},
          %ExClash.Type.League{id: 85000004, name: "Silver League III"},
          %ExClash.Type.League{id: 85000005, name: "Silver League II"}
        ],
        %ExClash.HTTP.Paging{after: "eyJwb3MiOjZ9", before: "eyJwb3MiOjN9"}
      }
  """
  @spec capital_leagues(opts :: Keyword.t()) :: League.t() | {list(League.t()), Paging.t()} | {:error, atom()}
  def capital_leagues(opts) do
    case ExClash.HTTP.get("/capitalleagues", opts) do
      {:ok, %{"items" => items, "paging" => paging}} ->
        {Enum.map(items, &ExClash.Type.League.format/1), Paging.format(paging)}

      err ->
        err
    end
  end

  @doc """
  
  """
  @spec cwl_war(war_tag :: ExClash.tag()) :: ExClash.War.t() | {:error, atom()}
  def cwl_war(war_tag) do
    case ExClash.HTTP.get("/clanwarleagues/wars/#{war_tag}") do
      {:ok, war} ->
        war
        # This is a duplicate value.
        |> Map.delete("warStartTime")
        |> ExClash.Type.War.format()

      err ->
        err
    end
  end

  @doc """
  Get league information for the home league `id`.

  ## Examples

      iex> ExClash.League.home_league(29000002)
      %ExClash.Type.League{id: 29000002, name: "Bronze League II", icon_urls: %ExClash.IconUrls{...}},
  """
  @spec home_league(id :: integer(), opts :: Keyword.t()) :: LeagueType.t() | {:error, atom()}
  def home_league(id, opts \\ []) do
    case ExClash.HTTP.get("/leagues/#{id}", opts) do
      {:ok, league} -> LeagueType.format(league)
      err -> err
    end
  end

  @doc """
  Get the home league information from Supercell.

  Note: This does not include Capital Leagues or Builder Base Leagues. Those
  have their own API calls.

  ## Parameters

    * `opts` - Paging and additonal `Req` options.
      * `limit` - Limit the number of items returned in the response.
      * `after` - Return only items that occur after this marker.
      * `before` - Return only items that occur before this marker.

  ## Examples

      iex> ExClash.League.home_leagues(limit: 2, after: "eyJwb3MiOjJ9")
      {
        [
          %ExClash.Type.League{id: 29000002, name: "Bronze League II", icon_urls: %ExClash.IconUrls{...}},
          %ExClash.Type.League{id: 29000003, name: "Bronze League I", icon_urls: %ExClash.IconUrls{...}},
        ],
        %ExClash.HTTP.Paging{after: "eyJwb3MiOjR9", before: "eyJwb3MiOjJ9"}
      }
  """
  @spec home_leagues(opts :: Keyword.t()) :: list(LeagueType.t()) | {:error, atom()}
  def home_leagues(opts \\ []) do
    case ExClash.HTTP.get("/leagues", opts) do
      {:ok, %{"items" => leagues, "paging" => paging}} ->
        {LeagueType.format(leagues), Paging.format(paging)}

      err ->
        err
    end
  end

  @doc """
  Get the list of seasons for the provided home league `id`.

  ## Parameters

    * `opts` - Paging and additonal `Req` options.
      * `limit` - Limit the number of items returned in the response.
      * `after` - Return only items that occur after this marker.
      * `before` - Return only items that occur before this marker.

  ## Examples

      iex> ExClash.League.seasons(29000022, limit: 5)
      {
        ["2015-07", "2015-08", "2015-09", "2015-10", "2015-11"],
        %ExClash.HTTP.Paging{after: "eyJwb3MiOjV9", before: nil}
      }
  """
  @spec seasons(id :: integer(), opts :: Keyword.t()) :: {list(LeagueType.cell_season()), Paging.t()} | {:error, atom()}
  def seasons(id, opts \\ []) do
    case ExClash.HTTP.get("/leagues/#{id}/seasons", opts) do
      {:ok, %{"items" => seasons, "paging" => paging}} ->
        {Enum.map(seasons, fn %{"id" => season} -> season end), Paging.format(paging)}

      err ->
        err
    end
  end

  @doc """
  Get the list of top ranked `ExClash.Type.SeasonPlayer`s for the provided
  league `id` and season `id` combination.

  It will return an empty list if the league has not completed yet, or if the
  season ID is in a correct format but no season existed (before 2015-07).

  ## Parameters

    * `opts` - Paging and additonal `Req` options.
      * `limit` - Limit the number of items returned in the response.
      * `after` - Return only items that occur after this marker.
      * `before` - Return only items that occur before this marker.

  ## Examples

      iex> ExClash.League.top_players(29000022, "2024-01", limit: 1, after: "eyJwb3MiOjJ9")
      {
        [
          %ExClash.Type.SeasonPlayer{
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
       %ExClash.Type.Paging{after: "eyJwb3MiOjN9", before: "eyJwb3MiOjJ9"}}
  """
  @spec top_players(league_id :: integer(), season_id :: LeagueType.cell_season(), opts :: Keyword.t()) :: top_return()
  def top_players(league_id, season_id, opts \\ []) do
    case ExClash.HTTP.get("/leagues/#{league_id}/seasons/#{season_id}", opts) do
      {:ok, %{"items" => top_players, "paging" => paging}} ->
        {ExClash.Type.SeasonPlayer.format(top_players), Paging.format(paging)}

      err ->
        err
    end
  end

  @doc """
  Get the details of the war league for the provided `id`.

  ## Parameters

    * `id` - The integer ID of the war league.

  ## Examples

      iex(34)> ExClash.League.war_league(48000018)
      %ExClash.Type.League{id: 48000018, name: "Champion League I", icon_urls: nil}
  """
  @spec war_league(id :: integer(), opts :: Keyword.t()) :: ExClash.Type.League.t() | {:error, atom()}
  def war_league(id, opts \\ []) do
    case ExClash.HTTP.get("/warleagues/#{id}", opts) do
      {:ok, league} -> ExClash.Type.League.format(league)
      err -> err
    end
  end

  @doc """
  Get the details of the war leagues.

  ## Parameters

    * `opts` - The available pagination options.
      * `limit` - Limit the number of items returned in the response.
      * `after` - Return only items that occur after this marker.
      * `before` - Return only items that occur before this marker.

  ## Examples

      iex(34)> ExClash.League.war_leagues(48000018)
      %ExClash.Type.League{id: 48000018, name: "Champion League I", icon_urls: nil}
  """
  @spec war_leagues(opts :: Keyword.t()) :: list(ExClash.Type.League.t()) | {:error, atom()}
  def war_leagues(opts \\ []) do
    case ExClash.HTTP.get("/warleagues", opts) do
      {:ok, %{"items" => leagues, "paging" => paging}} ->
        {ExClash.Type.League.format(leagues), Paging.format(paging)}

      err ->
        err
    end
  end
end
