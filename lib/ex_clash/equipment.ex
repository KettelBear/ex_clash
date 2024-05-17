defmodule ExClash.Equipment do
  @moduledoc """
  The Equipment struct.

  Attributes:

    * `name` - The name of the piece of equipment.

    * `level` - The current level.

    * `max_level` - The max level it can reach.

    * `village` - Which village the equipment belongs to.
  """

  @type t() :: %__MODULE__{
    name: String.t(),
    level: integer(),
    max_level: integer(),
    village: ExClash.village()
  }

  defstruct [:name, :level, :max_level, :village]
end
