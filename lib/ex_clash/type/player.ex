defmodule ExClash.Type.Player do
  @moduledoc """
  The Player struct.

  Attributes:

    * `tag` - The `ExClash.tag()` for the player.
    * `name` - The of the player.
    * `town_hall_level` - The town hall level the player is currently at.
    * `town_hall_weapon_level` - The weapon level of the town hall.
    * `exp_level` - The current level the player has earned with experience.
    * `trophies` - The current number of trophies the player has.
    * `best_trophies` - The highest trophies the player has reached.
    * `war_stars` - The total war stars earned by the player.
    * `attack_wins` - The total number of multiplayer wins when attacking.
    * `defense_wins` - The total number of multiplayer wins when defending.
    * `builder_hall_level` - The current builder hall level.
    * `builder_base_trophies` - The current number of trophies in builder base.
    * `best_builder_base_trophies` - The highest trophies the player has earned
    in the builder base.
    * `role` - The current role the clan.
    * `war_preference` - `true` if the player opted into war, `false` otherwise.
    * `donations` - The current number of donations for the season.
    * `donations_received` - The current number of donations received for the
    season.
    * `clan_capital_contributions` - Lifetime Clan Capital Gold contribution.
    * `clan_name` - The name of the player's current clan.
    * `clan_tag` - The tag of the clan.
    * `clan_badges` - The badges of the clan.
    * `league` - The league that the player is currently in.
    * `builder_base_league` - The current Builder Base League.
    * `player_house` - The identifiers for the 4 pieces of the player house.
    * `legend_statistics` - The players lifetime legend stats.
    * `achievements` - A list of achievements earned by the player.
    * `labels` - The 1 to 3 labels the player can select for their profile.
    * `troops` - The list of troops and their levels.
    * `heroes` - The list of heroes and their levels.
    * `hero_equipment` - The list of hero equipment and their levels.
    * `spells` - The list of spells and their levels.
  """

  @behaviour ExClash.Type

  @typedoc """
  The available clan memeber roles.
  """
  @type clan_role() :: :member | :elder | :co_leader | :leader

  @type t() :: %__MODULE__{
    tag: String.t(),
    name: String.t(),
    town_hall_level: integer(),
    town_hall_weapon_level: integer(),
    exp_level: integer(),
    trophies: integer(),
    best_trophies: integer(),
    war_stars: integer(),
    attack_wins: integer(),
    defense_wins: integer(),
    builder_hall_level: integer(),
    builder_base_trophies: integer(),
    best_builder_base_trophies: integer(),
    role: clan_role(),
    war_preference: boolean(),
    donations: integer(),
    donations_received: integer(),
    clan_capital_contributions: integer(),
    clan: %{tag: ExClash.tag(), name: String.t(), badges: ExClash.Type.Badges.t()},
    league: ExClash.Type.League.t(),
    builder_base_league: ExClash.Type.League.t(),
    player_house: ExClash.Type.PlayerHouse.t(),
    legend_statistics: ExClash.Type.LegendStats.t(),
    achievements: list(ExClash.Type.Achievements.t()),
    labels: list(ExClash.Type.Label.t()),
    troops: list(ExClash.Type.Troop.t()),
    heroes: list(ExClash.Type.Hero.t()),
    hero_equipment: list(ExClash.Type.Equipment.t()),
    spells: list(ExClash.Type.Spell.t())
  }

  defstruct [
    # Simple data types
    :tag,
    :name,
    :town_hall_level,
    :town_hall_weapon_level,
    :exp_level,
    :trophies,
    :best_trophies,
    :war_stars,
    :attack_wins,
    :defense_wins,
    :builder_hall_level,
    :builder_base_trophies,
    :best_builder_base_trophies,
    :role,
    :war_preference,
    :donations,
    :donations_received,
    :clan_capital_contributions,

    # Structs
    :clan,
    :league,
    :builder_base_league,
    :player_house,

    :legend_statistics,

    :achievements,
    :labels,
    :troops,
    :heroes,
    :hero_equipment,
    :spells
  ]

  @doc """
  
  """
  @spec format(data :: ExClash.Type.cell_input()) :: __MODULE__.t() | list(__MODULE__.t()) | nil
  def format(nil), do: nil
  def format(data) when is_list(data), do: Enum.map(data, &format/1)
  def format(data) do
    {clan, data} = Map.pop(data, "clan")
    {league, data} = Map.pop(data, "league")
    {bb_league, data} = Map.pop(data, "builderBaseLeague")
    {player_house, data} = Map.pop(data, "playerHouse")
    {legend_statistics, data} = Map.pop(data, "legendStatistics")
    {achievements, data} = Map.pop(data, "achievements")
    {labels, data} = Map.pop(data, "labels")
    {troops, data} = Map.pop(data, "troops")
    {heroes, data} = Map.pop(data, "heroes")
    {hero_equipment, data} = Map.pop(data, "heroEquipment")
    {spells, data} = Map.pop(data, "spells")

    %__MODULE__{
      ExClash.cell_map_to_struct(data, __MODULE__) |
      league: ExClash.Type.League.format(league),
      player_house: ExClash.Type.PlayerHouse.format(player_house),
      clan: format_clan(clan),
      builder_base_league: ExClash.Type.League.format(bb_league),
      legend_statistics: ExClash.Type.LegendStats.format(legend_statistics),
      achievements: ExClash.Type.Achievements.format(achievements),
      labels: ExClash.Type.Label.format(labels),
      troops: ExClash.Type.Troop.format(troops),
      heroes: ExClash.Type.Hero.format(heroes),
      hero_equipment: ExClash.Type.Equipment.format(hero_equipment),
      spells: ExClash.Type.Spell.format(spells)
    }
  end

  defp format_clan(clan) do
    %{
      tag: Map.get(clan, "tag"),
      name: Map.get(clan, "name"),
      badges: clan |> Map.get("badgeUrls") |> ExClash.Type.Badges.format()
    }
  end
end
