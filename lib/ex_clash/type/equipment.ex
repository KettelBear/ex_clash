defmodule ExClash.Type.Equipment do
  @moduledoc """
  The Equipment struct.

  Attributes:

    * `name` - The name of the piece of equipment.

    * `level` - The current level.

    * `max_level` - The max level it can reach.

    * `village` - Which village the equipment belongs to.
  """

  @behaviour ExClash.Type

  @type t() :: %__MODULE__{
    name: String.t(),
    level: integer(),
    max_level: integer(),
    village: ExClash.village()
  }

  defstruct [:name, :level, :max_level, :village]

  @spec format(cell_equipment :: ExClash.cell_map() | list(ExClash.cell_map()) | nil) :: __MODULE__.t() | list(__MODULE__.t()) | nil
  def format(nil), do: nil
  def format(cell_equipment) when is_list(cell_equipment), do: Enum.map(cell_equipment, &format/1)
  def format(cell_equipment), do: ExClash.cell_map_to_struct(cell_equipment, __MODULE__)
end
