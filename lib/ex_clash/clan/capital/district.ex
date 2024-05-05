defmodule ExClash.Clan.Capital.District do
  @moduledoc """
  """

  @type t() :: %__MODULE__{
    id: integer(),
    name: String.t(),
    district_hall_level: integer()
  }

  defstruct [:id, :name, :district_hall_level]
end
