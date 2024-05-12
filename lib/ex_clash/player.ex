defmodule ExClash.Player do
  @moduledoc """
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
    role: ExClash.Clan.Player.clan_role(),
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

    # TODO:
    # legend_statistics: ,
    # achievements: ,
    # labels: ,
    # troops: ,
    # heroes: ,
    # hero_equipment: ,
    # spells: 
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

  @spec details(tag :: ExClash.tag()) :: __MODULE__.t() | {:error, atom()}
  def details(tag) do
    case ExClash.HTTP.get("/players/#{tag}") do
      {:ok, player} -> format(player)
      err -> err
    end
  end

  defp format(api_player) do
    # TODO: If it isn't obvious by the warnings, this is where I need to pick back up.

    {clan, api_player} = Map.pop(api_player, "clan")
    {league, api_player} = Map.pop(api_player, "league")
    {bb_league, api_player} = Map.pop(api_player, "builderBaseLeague")
    {player_house, api_player} = Map.pop(api_player, "playerHouse")

    {legend_statistics, api_player} = Map.pop(api_player, "legendStatistics")

    # {achievements, api_player} = Map.pop(api_player, "achievements")
    # {labels, api_player} = Map.pop(api_player, "labels")
    # {troops, api_player} = Map.pop(api_player, "troops")
    # {heroes, api_player} = Map.pop(api_player, "heroes")
    # {hero_equipment, api_player} = Map.pop(api_player, "heroEquipment")
    # {spells, api_player} = Map.pop(api_player, "spells")

    %__MODULE__{
      ExClash.HTTP.resp_to_struct(api_player, __MODULE__) |
      league: ExClash.League.format(league),
      player_house: ExClash.Clan.Capital.PlayerHouse.format(player_house),
      clan_name: Map.get(clan, "name"),
      clan_tag: Map.get(clan, "tag"),
      clan_badges: clan_badges(clan),
      builder_base_league: ExClash.HTTP.resp_to_struct(bb_league, ExClash.League),
      legend_statistics: ExClash.Player.LegendStats.format(legend_statistics),
    }
  end

  defp clan_badges(clan) do
    clan |> Map.get("badgeUrls") |> ExClash.HTTP.resp_to_struct(ExClash.Badges)
  end
end
