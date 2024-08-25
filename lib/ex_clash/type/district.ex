defmodule ExClash.Type.District do
  @moduledoc """
  The Clan Capital District struct.

  Attributes:

    * `id` - The integer ID of the district.
    * `name` - The name of the district.
    * `district_hall_level` - The level of the district.
  """

  @behaviour ExClash.Type

  @type t() :: %__MODULE__{
    id: integer(),
    name: String.t(),
    district_hall_level: integer()
  }

  defstruct [:id, :name, :district_hall_level]

  @spec format(cell_district :: ExClash.cell_map() | nil) :: __MODULE__.t() | nil
  def format(nil), do: nil
  def format(cell_district), do: ExClash.cell_map_to_struct(cell_district, __MODULE__)
end
