defmodule ExClash.Type.ClanMember do
  # TODO: This module-doc
  @moduledoc """
  """

  @behaviour ExClash.Type

  @type member_data :: ExClash.cell_map() | list(ExClash.cell_map()) | nil

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

  # TODO: This doc-block
  @doc """
  """
  @spec format(data :: member_data()) :: __MODULE__.t() | list(__MODULE__.t()) | nil
  def format(nil), do: nil
  def format(data) when is_list(data), do: Enum.map(data, &format/1)
  def format(clan_player) do
    {builder_league, clan_player} = Map.pop(clan_player, "builderBaseLeague")
    {league, clan_player} = Map.pop(clan_player, "league")
    {house, clan_player} = Map.pop(clan_player, "playerHouse")

    %__MODULE__{
      ExClash.cell_map_to_struct(clan_player, __MODULE__) |
      builder_base_league: ExClash.Type.League.format(builder_league),
      league: ExClash.Type.League.format(league),
      player_house: ExClash.PlayerHouse.format(house)
    }
  end
end
