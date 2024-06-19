defmodule ExClash.District do
  @moduledoc """
  The Clan Capital District struct.

  Attributes:

    * `id` - The integer ID of the district.
    * `name` - The name of the district.
    * `district_hall_level` - The level of the district.
  """

  @type t() :: %__MODULE__{
    id: integer(),
    name: String.t(),
    district_hall_level: integer()
  }

  defstruct [:id, :name, :district_hall_level]
end
