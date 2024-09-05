defmodule ExClash.Type.ClanMember do
  # TODO: This module-doc
  @moduledoc """
  """

  @behaviour ExClash.Type

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
  @spec format(data :: ExClash.Type.cell_input()) :: __MODULE__.t() | list(__MODULE__.t()) | nil
  def format(nil), do: nil
  def format(data) when is_list(data), do: Enum.map(data, &format/1)
  def format(data) do
    {builder_league, data} = Map.pop(data, "builderBaseLeague")
    {league, data} = Map.pop(data, "league")
    {house, data} = Map.pop(data, "playerHouse")

    %__MODULE__{
      ExClash.cell_map_to_struct(data, __MODULE__) |
      builder_base_league: ExClash.Type.League.format(builder_league),
      league: ExClash.Type.League.format(league),
      player_house: ExClash.Type.PlayerHouse.format(house)
    }
  end
end
