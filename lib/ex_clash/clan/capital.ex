defmodule ExClash.Clan.Capital do
  @moduledoc """
  /capitalleagues
  /capitalleagues/{leagueId}
  /clans/{clanTag}/capitalraidseasons
  """
  alias ExClash.Paging
  alias ExClash.League
  alias ExClash.Clan.Capital.District

  @type t() :: %__MODULE__{
    capital_hall_level: integer(),
    districts: list(District.t())
  }

  defstruct [:capital_hall_level, :districts]

  @doc """
  Get the names and IDs of the capital leagues.

  ## Param Options

    * `limit` - Limit the number of items returned in the response.

    * `after` - Return only items that occur after this marker.

    * `before` - Return only items that occur before this marker.

  ## Examples
      TODO - HERE
  """
  @spec leagues(params :: Keyword.t()) :: {list(League.t()), Paging.t()}
  def leagues(params \\ []) do
    case ExClash.HTTP.get("/capitalleagues", params) do
      {:ok, %{"items" => items, "paging" => paging}} ->
        {Enum.map(items, &League.format/1), Paging.format(paging)}

      err ->
        err
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
