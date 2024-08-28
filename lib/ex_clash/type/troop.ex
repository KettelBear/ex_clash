defmodule ExClash.Type.Troop do
  @moduledoc """
  The Troop struct.

  Note: The hero pets are considered troops, so they will be included the
  troop array for the player details.

  Attributes:

    * `name` - The name of the troop.
    * `level` - The current level of the troop.
    * `max_level` - The maximum level of the troop.
    * `village` - Which `ExClash.village()` this toop belongs to.
  """

  @behaviour ExClash.Type

  @type t() :: %__MODULE__{
    name: String.t(),
    level: integer(),
    max_level: integer(),
    village: ExClash.village()
  }

  defstruct [:name, :level, :max_level, :village]

  @spec format(cell_troop :: ExClash.cell_map() | nil) :: __MODULE__.t() | nil
  def format(nil), do: nil
  def format(cell_troop), do: ExClash.cell_map_to_struct(cell_troop, __MODULE__)
end
