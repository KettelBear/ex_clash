defmodule ExClash.Type.Capital do
  @moduledoc """
  The Capital struct.

  Attributes:

    * `capital_hall_level` - The integer level of the capital hall for the clan.
    * `districts` - See `ExClash.District` for more information.
  """

  @behaviour ExClash.Type

  @type t() :: %__MODULE__{
    capital_hall_level: integer(),
    districts: list(District.t())
  }

  defstruct [:capital_hall_level, :districts]

  @spec format(cell_capital :: ExClash.cell_map() | nil) :: __MODULE__.t() | nil
  def format(nil), do: nil
  def format(cell_capital), do: ExClash.cell_map_to_struct(cell_capital, __MODULE__)
end
