defmodule ExClash.Clan.Capital do
  @moduledoc """
  /clans/{clanTag}/capitalraidseasons
  """
  alias ExClash.Clan.Capital.District

  @type t() :: %__MODULE__{
    capital_hall_level: integer(),
    districts: list(ExClash.Clan.Capital.District.t())
  }

  defstruct [:capital_hall_level, :districts]

  def format(nil), do: nil
  def format(api_capital) do
    districts = Map.get(api_capital, "districts", [])

    %__MODULE__{
      capital_hall_level: Map.get(api_capital, "capitalHallLevel"),
      districts: Enum.map(districts, &ExClash.HTTP.resp_to_struct(&1, District))
    }
  end
end
