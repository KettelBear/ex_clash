  defmodule ExClash.Season do
    @moduledoc """
    The Season struct.
    """

    @typedoc """
    Note: The `id` is a string of "[YEAR]-[MONTH]"
    """
    @type t() :: %__MODULE__{
      id: String.t(),
      rank: integer(),
      trophies: integer()
    }

    defstruct [:id, :rank, :trophies]
  end
