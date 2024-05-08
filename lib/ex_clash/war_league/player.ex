defmodule ExClash.WarLeague.Player do
  @moduledoc """
  The War League Player struct.
  """

  @type t() :: %__MODULE__{
    name: String.t(),
    tag: String.t(),
    town_hall_level: integer()
  }

  defstruct [:tag, :name, :town_hall_level]
end
