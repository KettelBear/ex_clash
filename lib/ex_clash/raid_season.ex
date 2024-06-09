defmodule ExClash.RaidSeason do
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

  @spec format(api_season :: ExClash.cell_map()) :: __MODULE__.t()
  def format(seasons) when is_list(seasons), do: Enum.map(seasons, &format/1)

  def format(api_season) do
    {attack_log, api_season} = Map.pop(api_season, "attackLog")
    {defense_log, api_season} = Map.pop(api_season, "defenseLog")
    {members, api_season} = Map.pop(api_season, "members")

    %__MODULE__{
      ExClash.HTTP.resp_to_struct(api_season, __MODULE__) |
      attack_log: ExClash.CapitalRaid.format(attack_log),
      defense_log: ExClash.CapitalRaid.format(defense_log),
      members: ExClash.RaidMember.format(members)
    }
  end
end
