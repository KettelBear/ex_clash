defmodule ExClash.Clan.Player do
  @moduledoc """
  """

  alias ExClash.Clan.Capital.PlayerHouse

  @type t() :: %__MODULE__{
    builder_base_league: ExClash.League.t(),
    builder_base_trophies: integer(),
    clan_rank: integer(),
    donations: integer(),
    donations_received: integer(),
    exp_level: integer(),
    league: ExClash.League.t(),
    name: String.t(),
    player_house: PlayerHouse.t(),
    previous_clan_rank: integer(),
    role: ExClash.Clan.member_role(),
    tag: String.t(),
    town_hall_level: integer(),
    trophies: integer()
  }

  defstruct [
    :builder_base_league,
    :builder_base_trophies,
    :clan_rank,
    :donations,
    :donations_received,
    :exp_level,
    :league,
    :name,
    :player_house,
    :previous_clan_rank,
    :role,
    :tag,
    :town_hall_level,
    :trophies
  ]

  def format(clan_player) do
    {builder_league, clan_player} = Map.pop(clan_player, "builderBaseLeague")
    {league, clan_player} = Map.pop(clan_player, "league")
    {house, clan_player} = Map.pop(clan_player, "playerHouse")

    %__MODULE__{
      ExClash.HTTP.resp_to_struct(clan_player, __MODULE__) |
      builder_base_league: ExClash.League.format(builder_league),
      league: ExClash.League.format(league),
      player_house: PlayerHouse.format(house)
    }
  end
end
