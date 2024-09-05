defmodule ExClash.Type.Clan do
  @moduledoc """
  The Clan struct.

  Attributes:

    * `badge_urls` - .
    * `capital_league` - .
    * `clan_builder_base_points` - .
    * `clan_capital` - .
    * `clan_capital_points` - .
    * `clan_level` - .
    * `clan_points` - .
    * `description` - .
    * `is_family_friendly` - .
    * `is_war_log_public` - .
    * `labels` - .
    * `location` - .
    * `members` - .
    * `member_list` - .
    * `name` - .
    * `required_builder_base_trophies` - .
    * `required_townhall_level` - .
    * `required_trophies` - .
    * `tag` - .
    * `type` - .
    * `war_frequency` - .
    * `war_league` - .
    * `war_losses` - .
    * `war_ties` - .
    * `war_win_streak` - .
    * `war_wins` - .
  """

  @behaviour ExClash.Type

  @typedoc """
  This type refers to how open to clan is. Whether they are free to join,
  join by invite only, or not open to be joined.
  """
  @type clan_type() :: :open | :invite_only | :closed

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
    badge_urls: ExClash.Type.Badge.t(),
    capital_league: ExClash.Type.League.t(),
    clan_builder_base_points: integer(),
    clan_capital: ExClash.Type.Capital.t(),
    clan_capital_points: integer(),
    clan_level: integer(),
    clan_points: integer(),
    description: String.t(),
    is_family_friendly: boolean(),
    is_war_log_public: boolean(),
    labels: list(ExClash.Type.Label.t()),
    location: ExClash.Type.Location.t(),
    members: integer(),
    member_list: list(ExClash.Type.ClanMember.t()),
    name: String.t(),
    required_builder_base_trophies: integer(),
    required_townhall_level: integer(),
    required_trophies: integer(),
    tag: String.t(),
    type: clan_type(),
    war_frequency: war_frequency(),
    war_league: ExClash.Type.League.t(),
    war_losses: integer(),
    war_ties: integer(),
    war_win_streak: integer(),
    war_wins: integer(),
  }

  defstruct [
    :badge_urls,
    :capital_league,
    :clan_builder_base_points,
    :clan_capital,
    :clan_capital_points,
    :clan_level,
    :clan_points,
    :description,
    :is_family_friendly,
    :is_war_log_public,
    :labels,
    :location,
    :members,
    :member_list,
    :name,
    :required_builder_base_trophies,
    :required_townhall_level,
    :required_trophies,
    :tag,
    :type,
    :war_frequency,
    :war_league,
    :war_losses,
    :war_ties,
    :war_win_streak,
    :war_wins
  ]

  @spec format(data :: ExClash.Type.cell_input()) :: __MODULE__.t() | list(__MODULE__.t()) | nil
  def format(nil), do: nil
  def format(data) when is_list(data), do: Enum.map(data, &format/1)
  def format(data) do
    {badge_urls, data} = Map.pop(data, "badgeUrls")
    {capital_league, data} = Map.pop(data, "capitalLeague")
    {clan_capital, data} = Map.pop(data, "clanCapital")
    {labels, data} = Map.pop(data, "labels")
    {location, data} = Map.pop(data, "location")
    {member_list, data} = Map.pop(data, "memberList")
    {type, data} = Map.pop(data, "type")
    {war_frequency, data} = Map.pop(data, "warFrequency")
    {war_league, data} = Map.pop(data, "warLeague")

    %__MODULE__{
      ExClash.cell_map_to_struct(data, __MODULE__) |
      badge_urls: ExClash.Type.Badges.format(badge_urls),
      capital_league: ExClash.Type.League.format(capital_league),
      clan_capital: ExClash.Type.Capital.format(clan_capital),
      labels: ExClash.Type.Label.format(labels),
      location: ExClash.Type.Location.format(location),
      member_list: ExClash.Type.ClanMember.format(member_list),
      type: ExClash.camel_to_atom(type),
      war_frequency: ExClash.camel_to_atom(war_frequency),
      war_league: ExClash.Type.League.format(war_league)
    }
  end
end
