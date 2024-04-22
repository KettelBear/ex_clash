defmodule ExClash.Clan do
  @moduledoc """
  """

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
    tag: String.t(),
    name: String.t(),
    type: clan_type(),
    description: String.t(),
    location: ExClash.Location.t(),
    is_family_friendly: boolean(),
    badge_urls: ExClash.Badges.t(),
    clan_level: integer(),
    clan_points: integer(),
    clan_builder_base_points: integer(),
    clan_capital_points: integer(),
    capital_league: ExClash.League.t(),
    required_trophies: integer(),
    war_frequency: war_frequency(),
    war_win_streak: integer(),
    war_wins: integer(),
    war_ties: integer(),
    war_losses: integer(),
    is_war_log_public: boolean(),
    war_league: ExClash.League.t(),
    members: integer(),
    member_list: [ExClash.Clan.Player.t()],
    labels: [ExClash.Label.t()],
    required_builder_base_trophies: integer(),
    required_townhall_level: integer(),
    clan_capital: ExClash.Clan.Capital.t(),
  }

  defstruct [
    :tag,
    :name,
    :type,
    :description,
    :location,
    :is_family_friendly,
    :badge_urls,
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

  def search do
    """
    /clans
    """
  end

  # TODO:
  @doc """
  """
  @spec details(tag :: String.t()) :: __MODULE__.t()
  def details(tag) do
    "/clans/#{tag}"
    |> ExClash.get!()
    |> format()
  end

  def memebers(_tag) do
    """
    /clans/{clanTag}/members
    """
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
    # TODO:
    {_api_location, api_clan} = Map.pop(api_clan, "location")
    {_cap_league, api_clan} = Map.pop(api_clan, "capitalLeague")
    {_war_league, api_clan} = Map.pop(api_clan, "warLeague")
    {_member_list, api_clan} = Map.pop(api_clan, "memberList")
    {_labels, api_clan} = Map.pop(api_clan, "labels")
    {_capital, api_clan} = Map.pop(api_clan, "clanCapital")

    {badges, api_clan} = Map.pop(api_clan, "badgeUrls")
    {type, api_clan} = Map.pop(api_clan, "type")
    {war_freq, api_clan} = Map.pop(api_clan, "warFrequency")

    %__MODULE__{
      ExClash.resp_to_struct(api_clan, __MODULE__) |
      badge_urls: ExClash.resp_to_struct(badges, ExClash.Badges),
      type: format_type(type),
      war_frequency: format_frequency(war_freq)
    }
  end

  defp format_type(nil), do: nil
  defp format_type(type), do: ExClash.camel_to_atom(type)

  defp format_frequency(nil), do: nil
  defp format_frequency(freq), do: ExClash.camel_to_atom(freq)
end
