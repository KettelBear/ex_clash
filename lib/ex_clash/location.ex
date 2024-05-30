defmodule ExClash.Location do
  @moduledoc """
  The Location struct.

  Attributes:

    * `id` - The location identification number.

    * `name` - The name of the location.

    * `is_country` - Boolean stating if the location is a country.

    * `country_code` - The country code.
  """

  @type t() :: %__MODULE__{
    id: integer(),
    name: String.t(),
    is_country: boolean(),
    country_code: String.t()
  }

  defstruct [:id, :name, :is_country, :country_code]
end
