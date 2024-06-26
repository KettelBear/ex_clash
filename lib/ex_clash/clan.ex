defmodule ExClash.Clan do
  @moduledoc """
  The Clan struct.

  Attributes:

    * `tag` - The clan tag.
    * `name` - The name of the clan.
    * `type` - If the clan is open or closed, refer to the type `clan_type`.
    * `description` - The clan's self-set description.
    * `location` - The `ExClash.Location` of the clan. Refer to that module for
    more details.
    * `is_family_friendly` - A boolean.
    * `badge_urls` - The urls for the different sized badges for the clan. Refer
    to `ExClash.Badges` for more details.
    * `chat_language` - The clan-set language, in `ExClash.ChatLanguage`.
    * `clan_level` - The level of the clan.
    * `clan_points` - How many points the clan has.
    * `clan_builder_base_points` - How many builder base points the clan has.
    * `clan_capital_points` - How many clan capital points the clan has.
    * `capital_league` - The capital league the clan is in. Refer to
    `ExClash.League` for more information.
    * `required_trophies` - The minimum required trophies to join the clan.
    * `war_frequency` - How often the clan particiaptes in clan wars. Please
    refer to the type `war_frequency`.
    * `war_win_streak` - The number of war wins in a row.
    * `war_wins` - The total number of war wins for the clan.
    * `war_ties` - The total number of war ties for the clan.
    * `war_losses` - The total number of war losses for the clan.
    * `is_war_log_public` - A boolean, whether the war log is public or not.
    * `war_league` - The war league the clan is in. Refer to `ExClash.League`
    for more information.
    * `members` - Total number of members in the clan. This is just a count.
    * `member_list` - The details of the members in the clan. They are
    represented by the `ExClash.ClanMember` struct.
    * `labels` - Which labels the clan currently has set. There will be a
    maximum of 3. Please refer to `ExClash.Label` for more information.
    * `required_builder_base_trophies` - The minimum required builder trophies
    to join the clan.
    * `required_townhall_level` - The minimum required town hall to join the clan.
    * `clan_capital` - The details of the clan's capital. Please refer to the
    `ExClash.Capital` module for more information.
  """

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

  @typedoc """
  This type refers to how open to clan is. Whether they are free to join,
  join by invite only, or not open to be joined.
  """
  @type clan_type() :: :open | :invite_only | :closed

  @typedoc """
  The available memeber roles.
  """
  @type member_role() :: :member | :elder | :co_leader | :leader

  @typedoc """
  Represents the setting the clan has set for themselves representing how often
  they sign up for clan wars.

  Note: This is a setting that is set by the leader or co-leaders of the clan
  and clan wars may be declared more often, or less often, than the currently
  selected `war_frequency`.
  """
  @type war_frequency() ::
    :unknown
    | :always
    | :more_than_once_per_week
    | :once_per_week
    | :less_than_once_per_week
    | :never
    | :any

  @type t() :: %__MODULE__{
    badge_urls: ExClash.Badges.t(),
    capital_league: ExClash.League.t(),
    chat_language: ExClash.ChatLanguage.t(),
    clan_builder_base_points: integer(),
    clan_capital: ExClash.Capital.t(),
    clan_capital_points: integer(),
    clan_level: integer(),
    clan_points: integer(),
    description: String.t(),
    is_family_friendly: boolean(),
    is_war_log_public: boolean(),
    labels: [ExClash.Label.t()],
    location: ExClash.Location.t(),
    members: integer(),
    member_list: [ClanMember.t()],
    name: String.t(),
    required_builder_base_trophies: integer(),
    required_townhall_level: integer(),
    required_trophies: integer(),
    tag: String.t(),
    type: clan_type(),
    war_frequency: war_frequency(),
    war_league: ExClash.League.t(),
    war_losses: integer(),
    war_ties: integer(),
    war_win_streak: integer(),
    war_wins: integer()
  }

  defstruct [
    :tag,
    :name,
    :type,
    :description,
    :location,
    :is_family_friendly,
    :badge_urls,
    :chat_language,
    :clan_level,
    :clan_points,
    :clan_builder_base_points,
    :clan_capital_points,
    :capital_league,
    :required_trophies,
    :war_frequency,
    :war_win_streak,
    :war_wins,
    :war_ties,
    :war_losses,
    :is_war_log_public,
    :war_league,
    :members,
    :member_list,
    :labels,
    :required_builder_base_trophies,
    :required_townhall_level,
    :clan_capital,
  ]

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
  @spec search(filters :: Keyword.t()) :: {list(__MODULE__.t()), Paging.t()} | {:error, atom()}
  def search(filters \\ []) do
    case ExClash.HTTP.get("/clans", Enum.map(filters, &convert_filters/1)) do
      {:ok, %{"items" => clans, "paging" => paging}} ->
        {Enum.map(clans, &format/1), Paging.format(paging)}

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
        member_list: nil,
        labels: nil,
        required_builder_base_trophies: 0,
        required_townhall_level: 15,
        clan_capital: nil
      }
  """
  @spec details(tag :: String.t(), opts :: Keyword.t()) :: __MODULE__.t() | {:error, atom()}
  def details(tag, opts \\ []) do
    case ExClash.HTTP.get("/clans/#{tag}", opts) do
      {:ok, clan} -> format(clan)
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

  defp format(api_clan) do
    {badges, api_clan} = Map.pop(api_clan, "badgeUrls")
    {capital, api_clan} = Map.pop(api_clan, "clanCapital")
    {capital_league, api_clan} = Map.pop(api_clan, "capitalLeague")
    {chat_language, api_clan} = Map.pop(api_clan, "chatLanguage")
    {labels, api_clan} = Map.pop(api_clan, "labels")
    {location, api_clan} = Map.pop(api_clan, "location")
    {member_list, api_clan} = Map.pop(api_clan, "memberList")
    {type, api_clan} = Map.pop(api_clan, "type")
    {war_freq, api_clan} = Map.pop(api_clan, "warFrequency")
    {war_league, api_clan} = Map.pop(api_clan, "warLeague")

    %__MODULE__{
      ExClash.HTTP.resp_to_struct(api_clan, __MODULE__) |
      badge_urls: ExClash.HTTP.resp_to_struct(badges, ExClash.Badges),
      capital_league: ExClash.League.format(capital_league),
      chat_language: ExClash.HTTP.resp_to_struct(chat_language, ExClash.ChatLanguage),
      clan_capital: ExClash.Capital.format(capital),
      labels: ExClash.Label.format(labels),
      location: ExClash.HTTP.resp_to_struct(location, ExClash.Location),
      member_list: ExClash.ClanMember.format(member_list),
      type: ExClash.camel_to_atom(type),
      war_frequency: ExClash.camel_to_atom(war_freq),
      war_league: ExClash.League.format(war_league)
    }
  end

  defp convert_filters({key, value}), do: {Map.get(@search_filters, key, key), value}
end
