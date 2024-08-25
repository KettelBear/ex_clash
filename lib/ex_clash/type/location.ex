defmodule ExClash.Type.Location do
  @moduledoc """
  The Location struct.

  Attributes:
    * `id` - The location identification number.
    * `name` - The name of the location.
    * `is_country` - Boolean stating if the location is a country.
    * `country_code` - The country code.
  """

  @behaviour ExClash.Type

  @type t() :: %__MODULE__{
    id: integer(),
    name: String.t(),
    is_country: boolean(),
    country_code: String.t()
  }

  defstruct [:id, :name, :is_country, :country_code]

  @spec format(cell_location :: ExClash.cell_map() | nil) :: __MODULE__.t() | nil
  def format(nil), do: nil
  def format(cell_location), do: ExClash.cell_map_to_struct(cell_location, __MODULE__)
end
