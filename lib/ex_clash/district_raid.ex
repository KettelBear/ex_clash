defmodule ExClash.DistrictRaid do
  @moduledoc """
  The District Raid module.

  This module represents the raid for the specific district within a capital
  raid.
  """

  @type t :: %__MODULE__{
    attack_count: integer(),
    attacks: ExClash.DistrictAttack.t(),
    destruction_percent: integer(),
    district_hall_level: integer(),
    id: integer(),
    name: String.t(),
    stars: integer(),
    total_looted: integer()
  }

  defstruct [
    :attack_count,
    :attacks,
    :destruction_percent,
    :district_hall_level,
    :id,
    :name,
    :stars,
    :total_looted,
  ]

  @spec format(api_district_raid :: ExClash.cell_map()) :: __MODULE__.t()
  def format(raids) when is_list(raids), do: Enum.map(raids, &format/1)

  def format(api_district_raid) do
    {attacks, api_district_raid} = Map.pop(api_district_raid, "attacks")

    %__MODULE__{
      ExClash.HTTP.resp_to_struct(api_district_raid, __MODULE__) |
      attacks: ExClash.DistrictAttack.format(attacks)
    }
  end
end
