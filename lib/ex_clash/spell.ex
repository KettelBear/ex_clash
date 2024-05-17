defmodule ExClash.Spell do
  @moduledoc """
  The Spell struct.
  """

  @type t() :: %__MODULE__{
    name: String.t(),
    level: integer(),
    max_level: integer(),
    village: ExClash.village()
  }

  defstruct [:name, :level, :max_level, :village]
end
