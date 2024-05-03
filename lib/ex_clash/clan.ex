defmodule ExClash.Clan do
  # TODO: Fill out the `moduledoc` for this module.
  @moduledoc """
  """

  @search_filters %{
    war_frequency: "warFrequency",
    location_id: "locationId",
    min_members: "minMembers",
    max_members: "maxMembers",
    min_clan_points: "minClanPoints",
    min_clan_level: "minClanLevel",
    label_ids: "labelIds"
  }

  @type clan_type() :: :open | :invite_only | :closed

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
    clan_capital: ExClash.Clan.Capital.t(),
    clan_capital_points: integer(),
    clan_level: integer(),
    clan_points: integer(),
    description: String.t(),
    is_family_friendly: boolean(),
    is_war_log_public: boolean(),
    labels: [ExClash.Label.t()],
    location: ExClash.Location.t(),
    members: integer(),
    member_list: [ExClash.Clan.Player.t()],
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
  Search for clans using the various `filters`. The `page` options can go right
  into the `filters` list.

  ## Param Options

    ### Filter Options

    * `name` - Search clans by name. If name is used as part of search query, it
               needs to be at least three characters long. Name search parameter
               is interpreted as wild card search, so it may appear anywhere in
               the clan name.

    TODO: Find the values for War Frequency, as I'm pretty sure they're part of an Enum.
          Add those values to the documentation.
    * `war_frequency` - Filter by clan war frequency.

    TODO: Check if I have the right documentation for the get locations.
    * `location_id` - Filter by clan location identifier. For list of available
                      locations, refer to `ExClash.Locations.get/0` operation.

    * `min_memebers` - Filter by minimum number of clan members.

    * `max_members` - Filter by maximum number of clan members.

    * `min_clan_points` - Filter by minimum amount of clan points.

    * `min_clan_level` - Filter by minimum clan level.

    TODO: Verify the label IDs, if they need any verification, or anything.
    * `label_ids` - List of label IDs to use for filtering results.

    ### Paging Options

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
  @spec search() :: {list(__MODULE__.t()), ExClash.Paging.t()}
  def search(filters \\ []) do
    %{"items" => clans, "paging" => paging} = ExClash.get!("/clans", Enum.map(filters, &convert_filters/1))

    {Enum.map(clans, &format/1), ExClash.Paging.format(paging)}
  end

  @doc """
  Retrieve the details for the provided `tag`.

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
  @spec details(tag :: String.t()) :: __MODULE__.t()
  def details(tag), do: ExClash.get!("/clans/#{tag}") |> format()

  # TODO: Implementation, spec, and doc
  def memebers(_tag) do
    """
    /clans/{clanTag}/members
    """
  end

  # TODO: Both WAR_LOG and CURRENT_WAR; if the clan's warlog is not public,
  # then a 403 will be returned. I definitely need to handle that far more
  # gracefully than error over the fact that Map cannot pop a tuple.
  @doc """
  Return the war log for the provided clan tag. Will fetch the most recent war
  going back in time, unless the after tag is provided. If `after` is provided
  it will exclude all recent wars up to and including that marker.

  ## Param Options

    * `limit` - Limit the number of items returned in the response.

    * `after` - Return only items that occur after this marker.

    * `before` - Return only items that occur before this marker.

  ## Examples

    iex> ExClash.Clan.war_log("#ABCDEFGH")
    {[%ExClash.Clan.War{...}, ...], %ExClash.Paging{...}}

    iex> ExClash.Clan.war_log("#ABCDEFGH", limit: 2)
    {[%ExClash.Clan.War{...}, %ExClash.Clan.War{...}], %ExClash.Paging{...}}
  """
  @spec war_log(tag :: String.t(), params :: Keyword.t()) :: ExClash.War.war_log()
  def war_log(tag, params \\ []) do
    %{"items" => wars, "paging" => paging} = ExClash.get!("/clans/#{tag}/warlog", params)

    {Enum.map(wars, &ExClash.War.format/1), ExClash.Paging.format(paging)}
  end

  @doc """
  Return the current war that the clan is in, or the most recent war that ended
  for the clan.

  ## Examples

      iex> ExClash.Clan.current_war("#ABCDEFGH")
      %ExClash.Clan.War{...}
  """
  @spec current_war(tag :: String.t()) :: ExClash.War.t()
  def current_war(tag) do
    "/clans/#{tag}/currentwar"
    |> ExClash.get!()
    |> ExClash.War.format()
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
      ExClash.resp_to_struct(api_clan, __MODULE__) |
      badge_urls: ExClash.resp_to_struct(badges, ExClash.Badges),
      capital_league: ExClash.League.format(capital_league),
      chat_language: format_chat_lang(chat_language),
      clan_capital: ExClash.Clan.Capital.format(capital),
      labels: Enum.map(labels, &ExClash.Label.format/1),
      location: ExClash.resp_to_struct(location, ExClash.Location),
      member_list: Enum.map(member_list, &ExClash.Clan.Player.format/1),
      type: format_type(type),
      war_frequency: format_frequency(war_freq),
      war_league: ExClash.League.format(war_league)
    }
  end

  defp format_chat_lang(nil), do: nil
  defp format_chat_lang(lang), do: ExClash.resp_to_struct(lang, ExClash.ChatLanguage)

  defp format_type(nil), do: nil
  defp format_type(type), do: ExClash.camel_to_atom(type)

  defp format_frequency(nil), do: nil
  defp format_frequency(freq), do: ExClash.camel_to_atom(freq)

  defp convert_filters({key, value}), do: {Map.get(@search_filters, key, key), value}
end
