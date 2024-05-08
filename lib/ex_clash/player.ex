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

    # TODO:
    # clan: ,
    # league: ,
    # builder_base_league: ,
    # legend_statistics: ,
    # achievements: ,
    # player_house: ,
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

    # Structs
    :clan,
    :league,
    :builder_base_league,
    :legend_statistics,
    :achievements,
    :player_house,
    :labels,
    :troops,
    :heroes,
    :hero_equipment,
    :spells
  ]
end
