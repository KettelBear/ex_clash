defmodule ExClash.Type.RaidSeason do
  # TODO:
  @moduledoc """
  
  """

  @behaviour ExClash.Type

  alias ExClash.Type.{CapitalRaid, RaidMember}

  # TODO:
  @typedoc """
  
  """
  @type response :: {list(__MODULE__.t()), ExClash.Paging.t()}

  @type t :: %__MODULE__{
    capital_total_loot: integer(),
    defensive_reward: integer(),
    start_time: DateTime.t(),
    end_time: DateTime.t(),
    enemy_districts_destroyed: integer(),
    offensive_reward: integer(),
    state: String.t(), # Find out the states maybe and create type?
    total_attacks: integer(),
    attack_log: list(ExClash.CapitalRaid.t()),
    defense_log: list(ExClash.CapitalRaid.t()),
    members: list(ExClash.RaidMember.t()),
  }

  defstruct [
    :capital_total_loot,
    :defensive_reward,
    :start_time,
    :end_time,
    :enemy_districts_destroyed,
    :offensive_reward,
    :state,
    :total_attacks,
    :attack_log,
    :defense_log,
    :members,
  ]

  @spec format(cell_raid_season :: ExClash.cell_map() | list(ExClash.cell_map()) | nil) :: __MODULE__.t() | list(__MODULE__.t()) | nil
  def format(nil), do: nil
  def format(cell_raid_season) when is_list(cell_raid_season), do: Enum.map(cell_raid_season, &format/1)
  def format(cell_raid_season) do
    {attack_log, cell_raid_season} = Map.pop(cell_raid_season, "attackLog")
    {defense_log, cell_raid_season} = Map.pop(cell_raid_season, "defenseLog")
    {members, cell_raid_season} = Map.pop(cell_raid_season, "members")

    %__MODULE__{
      ExClash.cell_map_to_struct(cell_raid_season, __MODULE__) |
      attack_log: CapitalRaid.format(attack_log),
      defense_log: CapitalRaid.format(defense_log),
      members: RaidMember.format(members)
    }
  end
end
