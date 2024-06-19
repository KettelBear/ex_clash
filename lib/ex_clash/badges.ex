defmodule ExClash.Badges do
  @moduledoc """
  The Badges struct.

  These are the badges that are associated with `ExClash.Clan`s.

  Attrbiutes:

    * `small` - The smallest size in terms of pixels.
    * `medium` - The medium size.
    * `large` - The largest size.
  """

  @type t() :: %__MODULE__{
    small: String.t(),
    medium: String.t(),
    large: String.t(),
  }

  defstruct [:small, :medium, :large]
end
