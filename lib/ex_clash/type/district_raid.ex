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

  @doc """
  
  """
  @spec format(data :: ExClash.Type.cell_input()) :: __MODULE__.t() | list(__MODULE__.t()) | nil
  def format(nil), do: nil
  def format(data) when is_list(data), do: Enum.map(data, &format/1)
  def format(data) do
    {attacks, data} = Map.pop(data, "attacks")

    %__MODULE__{
      ExClash.cell_map_to_struct(data, __MODULE__) |
      attacks: ExClash.Type.DistrictAttack.format(attacks)
    }
  end
end
