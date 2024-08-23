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

  # TODO: Move this to the player structs named `clan_role`
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

  @impl ExClash.Type
  @spec format(api_clan :: ExClash.cell_map()) :: __MODULE__.t()
  def format(api_clan) do
    {_badge_urls, api_clan} = Map.pop(api_clan, "badgeUrls")
    {_capital_league, api_clan} = Map.pop(api_clan, "capitalLeague")
    {_clan_capital, api_clan} = Map.pop(api_clan, "clanCapital")
    {_labels, api_clan} = Map.pop(api_clan, "labels")
    {_location, api_clan} = Map.pop(api_clan, "location")
    {_member_list, api_clan} = Map.pop(api_clan, "memberList")
    {_type, api_clan} = Map.pop(api_clan, "type")
    {_war_frequency, api_clan} = Map.pop(api_clan, "warFrequency")
    {_war_league, api_clan} = Map.pop(api_clan, "warLeague")

    ExClash.cell_map_to_struct(api_clan, __MODULE__)
  end
end
