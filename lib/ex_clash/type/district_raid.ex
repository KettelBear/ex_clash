defmodule ExClash.Type.DistrictRaid do
  @moduledoc """
  The District Raid module.

  This module represents the raid for the specific district within a capital
  raid.
  """

  @behaviour ExClash.Type

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

  @spec format(cell_raid :: ExClash.cell_map() | list(ExClash.cell_map()) | nil) :: __MODULE__.t() | list(__MODULE__.t()) | nil
  def format(nil), do: nil
  def format(cell_raids) when is_list(cell_raids), do: Enum.map(cell_raids, &format/1)
  def format(cell_raid) do
    {attacks, cell_raid} = Map.pop(cell_raid, "attacks")

    %__MODULE__{
      ExClash.cell_map_to_struct(cell_raid, __MODULE__) |
      attacks: ExClash.Type.DistrictAttack.format(attacks)
    }
  end
end
