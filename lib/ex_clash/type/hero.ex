defmodule ExClash.Type.Hero do
  @moduledoc """
  The Hero struct.

  Attributes:

    * `name` - The hero name.

    * `level` - The hero's current level.

    * `max_level` - The hero's max level possible for the town hall level.

    * `village` - The village that the hero belongs to.

    * `equipment` - See `ExClash.Equipment` for more details.
  """

  @behaviour ExClash.Type

  alias ExClash.Type.Equipment

  @type t() :: %__MODULE__{
    name: String.t(),
    level: integer(),
    max_level: integer(),
    village: ExClash.village(),
    equipment: list(Equipment.t())
  }

  defstruct [:name, :level, :max_level, :village, :equipment]

  @doc """
  When player details are fetched, this will handle the embedded JSON object
  that are the heroes that the player has.
  """
  @spec format(api_hero :: ExClash.cell_map()) :: __MODULE__.t()
  def format(api_hero) do
    {equipment, api_hero} = Map.pop(api_hero, "equipment")

    %__MODULE__{
      ExClash.cell_map_to_struct(api_hero, __MODULE__) |
      equipment: Equipment.format(equipment)
    }
  end
end
