defmodule ExClash.Player do
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
    role: ExClash.Clan.member_role(),
    war_preference: boolean(),
    donations: integer(),
    donations_received: integer(),
    clan_capital_contributions: integer(),
    clan_name: String.t(),
    clan_tag: ExClash.tag(),
    clan_badges: ExClash.Badges.t(),
    league: ExClash.League.t(),
    builder_base_league: ExClash.League.t(),
    player_house: ExClash.Clan.Capital.PlayerHouse.t(),
    legend_statistics: ExClash.Player.LegendStats.t(),
    achievements: list(ExClash.Achievements.t()),
    labels: list(ExClash.Label.t()),
    troops: list(ExClash.Troop.t()),
    heroes: list(ExClash.Hero.t()),
    hero_equipment: list(ExClash.Equipment.t()),
    spells: list(ExClash.Spell.t())
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
    :clan_name,
    :clan_tag,

    # Structs
    :clan_badges,
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
  Retrieve the player details for the provided clan `tag`.

  ## Examples

      iex> ExClash.Player.details("#QVRVCY28")
      %ExClash.Player{
        tag: "#QVRVCY28",
        name: "Sean",
        town_hall_level: 16,
        town_hall_weapon_level: 1,
        exp_level: 241,
        trophies: 6120,
        best_trophies: 6330,
        war_stars: 1706,
        attack_wins: 143,
        defense_wins: 0,
        builder_hall_level: 10,
        builder_base_trophies: 3875,
        best_builder_base_trophies: 5709,
        role: :elder,
        war_preference: "in",
        donations: 501,
        donations_received: 348,
        clan_capital_contributions: 2405921,
        # ...
      }

      iex> ExClash.Player.details("#000000")
      {:error, :not_found}
  """
  @spec details(tag :: ExClash.tag()) :: __MODULE__.t() | {:error, atom()}
  def details(tag) do
    case ExClash.HTTP.get("/players/#{tag}") do
      {:ok, player} -> format(player)
      err -> err
    end
  end

  defp format(api_player) do
    {clan, api_player} = Map.pop(api_player, "clan")
    {league, api_player} = Map.pop(api_player, "league")
    {bb_league, api_player} = Map.pop(api_player, "builderBaseLeague")
    {player_house, api_player} = Map.pop(api_player, "playerHouse")
    {legend_statistics, api_player} = Map.pop(api_player, "legendStatistics")
    {achievements, api_player} = Map.pop(api_player, "achievements")
    {labels, api_player} = Map.pop(api_player, "labels")
    {troops, api_player} = Map.pop(api_player, "troops")
    {heroes, api_player} = Map.pop(api_player, "heroes")
    {hero_equipment, api_player} = Map.pop(api_player, "heroEquipment")
    {spells, api_player} = Map.pop(api_player, "spells")

    %__MODULE__{
      ExClash.HTTP.resp_to_struct(api_player, __MODULE__) |
      league: ExClash.League.format(league),
      player_house: ExClash.Clan.Capital.PlayerHouse.format(player_house),
      clan_name: Map.get(clan, "name"),
      clan_tag: Map.get(clan, "tag"),
      clan_badges: clan_badges(clan),
      builder_base_league: ExClash.HTTP.resp_to_struct(bb_league, ExClash.League),
      legend_statistics: ExClash.Player.LegendStats.format(legend_statistics),
      achievements: Enum.map(achievements, &ExClash.Achievements.format/1),
      labels: Enum.map(labels, &ExClash.Label.format/1),
      troops: Enum.map(troops, &ExClash.HTTP.resp_to_struct(&1, ExClash.Troop)),
      heroes: Enum.map(heroes, &ExClash.Hero.format/1),
      hero_equipment: Enum.map(hero_equipment, &ExClash.HTTP.resp_to_struct(&1, ExClash.Equipment)),
      spells: Enum.map(spells, &ExClash.HTTP.resp_to_struct(&1, ExClash.Spell))
    }
  end

  defp clan_badges(clan) do
    clan |> Map.get("badgeUrls") |> ExClash.HTTP.resp_to_struct(ExClash.Badges)
  end
end
