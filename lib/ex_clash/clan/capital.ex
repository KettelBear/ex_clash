defmodule ExClash.Clan.Capital do
  @moduledoc """
  /capitalleagues
  /capitalleagues/{leagueId}
  /clans/{clanTag}/capitalraidseasons
  """
  alias ExClash.Clan.Capital.District

  @type t() :: %__MODULE__{
    capital_hall_level: integer(),
    districts: list(ExClash.Clan.Capital.District.t())
  }

  defstruct [:capital_hall_level, :districts]

  def leagues(params \\ []) do
    case ExClash.HTTP.get("/leagues", params) do
      {:ok, body} -> body
      err -> err
    end
  end

  @doc """
  Format Supercell's for the Clan Capital.
  """
  @spec format(api_capital :: ExClash.cell_map()) :: __MODULE__.t()
  def format(nil), do: nil
  def format(api_capital) do
    districts = Map.get(api_capital, "districts", [])

    %__MODULE__{
      capital_hall_level: Map.get(api_capital, "capitalHallLevel"),
      districts: Enum.map(districts, &ExClash.HTTP.resp_to_struct(&1, District))
    }
  end
end
