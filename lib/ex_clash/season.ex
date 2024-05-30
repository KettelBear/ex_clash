  defmodule ExClash.Season do
    @moduledoc """
    The Season struct.

    These seasons that the player achieves.

    Attributes:

      * `id` - The string value as an ID, usually MMMM-DD.

      * `rank` - The rank number the player achieved.

      * `trophies` - The number of trophies the player earned.
    """

    @type t() :: %__MODULE__{
      id: String.t(),
      rank: integer(),
      trophies: integer()
    }

    defstruct [:id, :rank, :trophies]
  end
