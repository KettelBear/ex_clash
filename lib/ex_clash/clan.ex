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
    represented by the `ExClash.Clan.Player` struct.

    * `labels` - Which labels the clan currently has set. There will be a
    maximum of 3. Please refer to `ExClash.Label` for more information.

    * `required_builder_base_trophies` - The minimum required builder trophies
    to join the clan.

    * `required_townhall_level` - The minimum required town hall to join the clan.

    * `clan_capital` - The details of the clan's capital. Please refer to the
    `ExClash.Clan.Capital` module for more information.

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

    * `war_frequency` - Filter by clan war frequency.

    * `location_id` - Filter by clan location identifier. For list of available
    locations, refer to `ExClash.Locations.get/0` operation.

    * `min_memebers` - Filter by minimum number of clan members.

    * `max_members` - Filter by maximum number of clan members.

    * `min_clan_points` - Filter by minimum amount of clan points.

    * `min_clan_level` - Filter by minimum clan level.

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
  @spec search(filters :: Keyword.t())
      :: {list(__MODULE__.t()), ExClash.Paging.t()} | {:error, atom()}
  def search(filters \\ []) do
    case ExClash.get("/clans", Enum.map(filters, &convert_filters/1)) do
      {:ok, %{"items" => clans, "paging" => paging}} ->
        {Enum.map(clans, &format/1), ExClash.Paging.format(paging)}

      error ->
        error
    end
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
  @spec details(tag :: String.t()) :: __MODULE__.t() | {:error, atom()}
  def details(tag) do
    case ExClash.get("/clans/#{tag}") do
      {:ok, clan} -> format(clan)
      error -> error
    end
  end

  @doc """
  Get the list of members for the provided `tag`.

  ## Param Options

    * `limit` - Limit the number of items returned in the response.

    * `after` - Return only items that occur after this marker.

    * `before` - Return only items that occur before this marker.

  ## Examples

      iex> ExClash.Clan.members("#G0RY89LU", limit: 3)
      {
        [
          %ExClash.Clan.Player{...},
          %ExClash.Clan.Player{...},
          %ExClash.Clan.Player{...}
        ],
        %ExClash.Paging{after: "eyJwb3MiOjN9", before: nil}
      }
  """
  @spec members(tag :: String.t(), params :: Keyword.t())
      :: {list(ExClash.Clan.Player.t()), ExClash.Paging.t()} | {:error, atom()}
  def members(tag, params \\ []) do
    case ExClash.get("/clans/#{tag}/members", params) do
      {:ok, %{"items" => members, "paging" => paging}} ->
        {Enum.map(members, &ExClash.Clan.Player.format/1), ExClash.Paging.format(paging)}

      error ->
        error
    end
  end

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
  @spec war_log(tag :: String.t(), params :: Keyword.t())
      :: ExClash.War.war_log() | {:error, atom()}
  def war_log(tag, params \\ []) do
    case ExClash.get("/clans/#{tag}/warlog", params) do
      {:ok, %{"items" => wars, "paging" => paging}} ->
        {Enum.map(wars, &ExClash.War.format/1), ExClash.Paging.format(paging)}

      error ->
        error
    end
  end

  @doc """
  Return the current war that the clan is in, or the most recent war that ended
  for the clan.

  ## Examples

      iex> ExClash.Clan.current_war("#ABCDEFGH")
      %ExClash.Clan.War{...}
  """
  @spec current_war(tag :: String.t()) :: ExClash.War.t() | {:error, atom()}
  def current_war(tag) do
    case ExClash.get("/clans/#{tag}/currentwar") do
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
      ExClash.resp_to_struct(api_clan, __MODULE__) |
      badge_urls: ExClash.resp_to_struct(badges, ExClash.Badges),
      capital_league: ExClash.League.format(capital_league),
      chat_language: format_chat_lang(chat_language),
      clan_capital: ExClash.Clan.Capital.format(capital),
      labels: Enum.map(labels, &ExClash.Label.format/1),
      location: ExClash.resp_to_struct(location, ExClash.Location),
      member_list: format_member_list(member_list),
      type: format_type(type),
      war_frequency: format_frequency(war_freq),
      war_league: ExClash.League.format(war_league)
    }
  end

  defp format_chat_lang(nil), do: nil
  defp format_chat_lang(lang), do: ExClash.resp_to_struct(lang, ExClash.ChatLanguage)

  defp format_member_list(nil), do: nil
  defp format_member_list(members), do: Enum.map(members, &ExClash.Clan.Player.format/1)

  defp format_type(nil), do: nil
  defp format_type(type), do: ExClash.camel_to_atom(type)

  defp format_frequency(nil), do: nil
  defp format_frequency(freq), do: ExClash.camel_to_atom(freq)

  defp convert_filters({key, value}), do: {Map.get(@search_filters, key, key), value}
end
