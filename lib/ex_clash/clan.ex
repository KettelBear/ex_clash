defmodule ExClash.Clan do
  alias ExClash.ClanMember
  alias ExClash.Paging

  @search_filters %{
    war_frequency: "warFrequency",
    location_id: "locationId",
    min_members: "minMembers",
    max_members: "maxMembers",
    min_clan_points: "minClanPoints",
    min_clan_level: "minClanLevel",
    label_ids: "labelIds"
  }

  @doc """
  Search for clans using the various `filters`.

  The `page` options can go right into the `filters` list.

  ## Parameters

    * Filter Options
      * `name` - Search clans by name. If name is used as part of search query, it
      needs to be at least three characters long. Name search parameter
      is interpreted as wild card search, so it may appear anywhere in
      the clan name.
      * `war_frequency` - Filter by clan war frequency.
      * `location_id` - Filter by clan location identifier. For list of available
      locations, refer to `ExClash.Locations.get/0` operation.
      * `min_memebers` - Filter by minimum number of clan members.
      * `max_members` - Filter by maximum number of clan members.
      * `min_clan_points` - Filter by minimum amount of clan points.
      * `min_clan_level` - Filter by minimum clan level.
      * `label_ids` - List of label IDs to use for filtering results.
    * Paging Options
      * `limit` - Limit the number of items returned in the response.
      * `after` - Return only items that occur after this marker.
      * `before` - Return only items that occur before this marker.

  ## Examples

      iex> ExClash.Clan.search(name: "My Clan", min_clan_level: 10, limit: 5)
      {
        [
          %ExClash.Clan{tag: "#JU2QJCLG", name: "MY CLAN", clan_level: 15, ...},
          %ExClash.Clan{tag: "#VCP2CVC8", name: "My clan", clan_level: 18, ...},
          %ExClash.Clan{tag: "#2YJ0L2VY9", name: "my clan", clan_level: 13, ...},
          %ExClash.Clan{tag: "#G0RY89LU", name: "MY CLAN", clan_level: 19, ...},
          %ExClash.Clan{tag: "#2PYGGVYQC", name: "my clan", clan_level: 17, ...}
        ],
        %ExClash.Paging{after: "eyJwb3MiOjV9", before: nil}
      }
  """
  @spec search(filters :: Keyword.t()) :: {list(ExClash.Type.Clan.t()), Paging.t()} | {:error, atom()}
  def search(filters \\ []) do
    case ExClash.HTTP.get("/clans", Enum.map(filters, &convert_filters/1)) do
      {:ok, %{"items" => clans, "paging" => paging}} ->
        {Enum.map(clans, &ExClash.Type.Clan.format/1), Paging.format(paging)}

      error ->
        error
    end
  end

  @doc """
  Retrieve the clan details for the provided clan `tag`.

  ## Parameters

    * `tag` - The clan tag.
    * `opts` - Additonal `Req` options.

  ## Examples

      iex> ExClash.Clan.details("#G0RY89LU")
      %ExClash.Clan{
        tag: "#G0RY89LU",
        name: "MY CLAN",
        type: :invite_only,
        description: "",
        location: nil,
        is_family_friendly: false,
        badge_urls: %ExClash.Badges{...},
        clan_level: 19,
        clan_points: 47181,
        clan_builder_base_points: 41464,
        clan_capital_points: 3159,
        capital_league: nil,
        required_trophies: 2200,
        war_frequency: :always,
        war_win_streak: 0,
        war_wins: 272,
        war_ties: nil,
        war_losses: nil,
        is_war_log_public: false,
        war_league: nil,
        members: 45,
        member_list: [...],
        labels: nil,
        required_builder_base_trophies: 0,
        required_townhall_level: 15,
        clan_capital: nil
      }
  """
  @spec details(tag :: String.t(), opts :: Keyword.t()) :: ExClash.Type.Clan.t() | {:error, atom()}
  def details(tag, opts \\ []) do
    case ExClash.HTTP.get("/clans/#{tag}", opts) do
      {:ok, clan} -> ExClash.Type.Clan.format(clan)
      error -> error
    end
  end

  @doc """
  Retrieve information about clan's current clan war league group.

  ## Parameters

    * `tag` - The clan tag.
    * `opts` - Additional `Req` options.

  ## Examples

      iex> ExClash.Clan.cwl_group("#JU2QJCLG")
      %ExClash.WarLeague{
        state: :in_war,
        season: "2024-05",
        clans: [%ExClash.WarLeagueClan{...}],
        rounds: %ExClash.WarLeague.Rounds{}
      }
  """
  @spec cwl_group(tag :: String.t(), opts :: Keyword.t()) :: ExClash.WarLeague.t() | {:error, atom()}
  def cwl_group(tag, opts \\ []) do
    case ExClash.HTTP.get("/clans/#{tag}/currentwar/leaguegroup", opts) do
      {:ok, body} -> ExClash.WarLeague.format(body)
      error -> error
    end
  end

  @doc """
  Get the list of members for the provided clan `tag`.

  ## Parameters

    * `tag` - The clan tag.
    * `opts` - Paging and additional `Req` options.
      * `limit` - Limit the number of items returned in the response.
      * `after` - Return only items that occur after this marker.
      * `before` - Return only items that occur before this marker.

  ## Examples

      iex> ExClash.Clan.members("#G0RY89LU", limit: 3)
      {
        [
          %ExClash.ClanMember{...},
          %ExClash.ClanMember{...},
          %ExClash.ClanMember{...}
        ],
        %ExClash.Paging{after: "eyJwb3MiOjN9", before: nil}
      }
  """
  @spec members(tag :: String.t(), opts :: Keyword.t()) :: {list(ClanMember.t()), Paging.t()} | {:error, atom()}
  def members(tag, opts \\ []) do
    case ExClash.HTTP.get("/clans/#{tag}/members", opts) do
      {:ok, %{"items" => members, "paging" => paging}} ->
        {Enum.map(members, &ClanMember.format/1), Paging.format(paging)}

      error ->
        error
    end
  end

  @doc """
  Return the war log for the provided clan `tag`.

  Will fetch the most recent war going back in time, unless the after tag is
  provided. If `after` is provided it will exclude all recent wars up to and
  including that marker.

  ## Parameters

    * `tag` - The clan tag.
    * `opts` - Paging and additonal `Req` options.
      * `limit` - Limit the number of items returned in the response.
      * `after` - Return only items that occur after this marker.
      * `before` - Return only items that occur before this marker.

  ## Examples

      iex> ExClash.Clan.war_log("#ABCDEFGH")
      {[%ExClash.Clan.War{...}, ...], %ExClash.Paging{...}}

      iex> ExClash.Clan.war_log("#ABCDEFGH", limit: 2)
      {[%ExClash.Clan.War{...}, %ExClash.Clan.War{...}], %ExClash.Paging{...}}
  """
  @spec war_log(tag :: String.t(), opts :: Keyword.t()) :: ExClash.War.war_log() | {:error, atom()}
  def war_log(tag, opts \\ []) do
    case ExClash.HTTP.get("/clans/#{tag}/warlog", opts) do
      {:ok, %{"items" => wars, "paging" => paging}} ->
        {Enum.map(wars, &ExClash.War.format/1), Paging.format(paging)}

      error ->
        error
    end
  end

  @doc """
  Return the current/most recent war for the clan `tag`.

  ## Parameters

    * `tag` - The clan tag.
    * `opts` - Additional `Req` options.

  ## Examples

      iex> ExClash.Clan.current_war("#ABCDEFGH")
      %ExClash.Clan.War{...}
  """
  @spec current_war(tag :: String.t(), opts :: Keyword.t()) :: ExClash.War.t() | {:error, atom()}
  def current_war(tag, opts \\ []) do
    case ExClash.HTTP.get("/clans/#{tag}/currentwar", opts) do
      {:ok, war} -> ExClash.War.format(war)
      error -> error
    end
  end

  defp convert_filters({key, value}), do: {Map.get(@search_filters, key, key), value}
end
