defmodule ExClash.WarLeague.Player do
  @moduledoc """
  The War League Player struct.

  Attributes:

    * `name` - The name of the player participant.

    * `tag` - The player's tag.

    * `town_hall_level` - It is in the name.
  """

  @type t() :: %__MODULE__{
    name: String.t(),
    tag: String.t(),
    town_hall_level: integer()
  }

  defstruct [:tag, :name, :town_hall_level]
end
