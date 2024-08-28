  defmodule ExClash.Type.Season do
    @moduledoc """
    The Season struct.

    These seasons that the player achieves.

    Attributes:

      * `id` - The string value as an ID, usually MMMM-DD.
      * `rank` - The rank number the player achieved.
      * `trophies` - The number of trophies the player earned.
    """

    @behaviour ExClash.Type

    @type t() :: %__MODULE__{
      id: String.t(),
      rank: integer(),
      trophies: integer()
    }

    defstruct [:id, :rank, :trophies]

    @spec format(cell_season :: ExClash.cell_map() | nil) :: __MODULE__.t() | nil
    def format(nil), do: nil
    def format(cell_season), do: ExClash.cell_map_to_struct(cell_season, __MODULE__)
  end
