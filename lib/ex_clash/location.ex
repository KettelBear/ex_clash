defmodule ExClash.Location do
  @moduledoc false

  @type t() :: %__MODULE__{
    id: integer(),
    name: String.t(),
    is_country: boolean(),
    country_code: String.t()
  }

  defstruct [:id, :name, :is_country, :country_code]
end
