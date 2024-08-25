defmodule ExClash.Type.Badges do
  @moduledoc """
  The Badges struct.

  These are the badges that are associated with `ExClash.Type.Clan`s.

  Attrbiutes:

    * `small` - The smallest size in terms of pixels.
    * `medium` - The medium size.
    * `large` - The largest size.
  """

  @behaviour ExClash.Type

  @type t() :: %__MODULE__{
    small: String.t(),
    medium: String.t(),
    large: String.t(),
  }

  defstruct [:small, :medium, :large]

  @spec format(cell_badges :: ExClash.cell_map() | nil) :: __MODULE__.t() | nil
  def format(nil), do: nil
  def format(cell_badges), do: ExClash.cell_map_to_struct(cell_badges, __MODULE__)
end
