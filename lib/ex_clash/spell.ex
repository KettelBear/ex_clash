defmodule ExClash.Spell do
  @moduledoc """
  The Spell struct.

  Attributes:

    * `name` -  The name of the spell.

    * `level` - The current level of the spell.

    * `max_level` - The maximum level for the spell for the given town hall.

    * `village` - Which village the spell belongs to.
  """

  @type t() :: %__MODULE__{
    name: String.t(),
    level: integer(),
    max_level: integer(),
    village: ExClash.village()
  }

  defstruct [:name, :level, :max_level, :village]
end
