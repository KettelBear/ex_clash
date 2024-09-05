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

  @doc """
  
  """
  @spec format(data :: ExClash.Type.cell_input()) :: __MODULE__.t() | list(__MODULE__.t()) | nil
  def format(nil), do: nil
  def format(data) when is_list(data), do: Enum.map(data, &format/1)
  def format(data) do
    {attack_log, data} = Map.pop(data, "attackLog")
    {defense_log, data} = Map.pop(data, "defenseLog")
    {members, data} = Map.pop(data, "members")

    %__MODULE__{
      ExClash.cell_map_to_struct(data, __MODULE__) |
      attack_log: CapitalRaid.format(attack_log),
      defense_log: CapitalRaid.format(defense_log),
      members: RaidMember.format(members)
    }
  end
end
