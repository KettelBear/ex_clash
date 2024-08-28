defmodule ExClash.Type.Spell do
  @moduledoc """
  The Spell struct.

  Attributes:

    * `name` -  The name of the spell.
    * `level` - The current level of the spell.
    * `max_level` - The maximum level for the spell for the given town hall.
    * `village` - Which village the spell belongs to.
  """

  @behaviour ExClash.Type

  @type t() :: %__MODULE__{
    name: String.t(),
    level: integer(),
    max_level: integer(),
    village: ExClash.village()
  }

  defstruct [:name, :level, :max_level, :village]

  @spec format(cell_spell :: ExClash.cell_map() | nil) :: __MODULE__.t() | nil
  def format(nil), do: nil
  def format(cell_spell), do: ExClash.cell_map_to_struct(cell_spell, __MODULE__)
end
